!--Convert ROD (ROSAT Observation Dataset) from Fits to EXSAS Format-----------------------------------------------------
! For more details:
!	help intape/rdf

intape/rdf disk rs anc,bas,mex

! If broad band exposure map <exposure.bdf> has not created by the above command (unknown reason), then
intape/rdf disk rs*_mex.fits mex
!------------------------------------------------------------------------------------------------------------------------


!--Generate 512 x 512 Binned Images--------------------------------------------------------------------------------------
! Th.Boller et al. 2016: 
!	Broad band (B, image1): 0.1 - 2.4 keV 
!	Soft band (S, image2): 0.1 - 0.4 keV
!	Hard band (H, image3): 0.5 - 2.0 keV
!	Medium band (M, image4): 0.5 - 0.9 keV
!	Very hard band (V, image5): 0.9 - 2.0 keV
!	Wide band (W, image6): 0.1 - 2.0 keV

create/source_detect_image events 11-235,11-41,52-201,52-90,91-201,11-201
!------------------------------------------------------------------------------------------------------------------------


!--Local Source Detection------------------------------------------------------------------------------------------------
! Create Parameter File (Local Detection): 
create/parfile deteloc deteloc rosat,survey

! Modify parameters, ML = 7 (Voges et al. 1999)
write/parfile deteloc min_ml 7.0

! 6 images output
write/parfile deteloc num_images 6

! Create source lists: lslst{X}.bdf with sources ML > 7
detect/local deteloc
!------------------------------------------------------------------------------------------------------------------------


!--Background Source Detection-------------------------------------------------------------------------------------------
! Create Parameter File (Background Detection): 
create/parfile creabg creabg rosat,survey

! Modify parameters, ML = 7 (Voges et al. 1999)
write/parfile creabg min_ml 7.0

! 6 images output
write/parfile creabg num_images 6

write/parfile creabg mask_flag F
write/parfile creabg exposure_flag T

! Referential Exposure Map
write/parfile creabg exposure_image_1 exposure.bdf
write/parfile creabg exposure_image_2 exposure.bdf
write/parfile creabg exposure_image_3 exposure.bdf
write/parfile creabg exposure_image_4 exposure.bdf
write/parfile creabg exposure_image_5 exposure.bdf
write/parfile creabg exposure_image_6 exposure.bdf


! Output spline-fitted background images: bacmpX.bdf
create/bg_image creabg

! Create Parameter File (Map Detection): 
creat/parfile detemap detemap rosat,survey

write/parfile detemap min_ml 7.0
write/parfile detemap num_images 6

detect/map detemap
!------------------------------------------------------------------------------------------------------------------------


!--Merging of the Source Lists-------------------------------------------------------------------------------------------
! Create Parameter File (Merge sources): 
create/parfile mergsou mergsou rosat,survey

! We only merge the sources detected in Hard Band:
write/parfile mergsou num_images 1
write/parfile mergsou ldetect_list_1 lslst3.tbl
write/parfile mergsou mdetect_list_1 mslst3.tbl
write/parfile mergsou merged_list mplst3.tbl
write/parfile mergsou BG_IMAGE_1 bacmp3.bdf

merg/sou mergsou
!------------------------------------------------------------------------------------------------------------------------
