!--Convert ROD (ROSAT Observation Dataset) from fits file to EXSAS format
! For more details:
!	help intape/rdf
 
intape/rdf disk rs anc,bas,mex

! If broad-band exposure map <exposure.bdf> has not created by the above command (unknown reason), then:
intape/rdf disk rs*_mex.fits mex

! 512x512 binned image (Th.Boller et al. 2016): broad-band (image1), soft-band (image2), hard-band (image3), medium-band (image4), very-hard-band (image5), wide-band (image6)
create/source_detect_image events 11-235,11-41,52-201,52-90,91-201,11-201

! Local source detection:
create/parfile deteloc deteloc rosat,survey
! Modify parameters, ML = 7 (Voges et al. 1999)
write/parfile deteloc min_ml 7.0
! 3 images created
write/parfile deteloc num_images 3
! Create source lists: lslstX.bdf with sources ML > 7
detect/local deteloc

! Background source detection:
create/parfile creabg creabg rosat,survey
write/parfile creabg num_images 3
write/parfile creabg min_ml 7.0
write/parfile creabg mask_flag F
write/parfile creabg exposure_flag T
write/parfile creabg exposure_image_1 exposure.bdf
write/parfile creabg exposure_image_2 exposure.bdf
write/parfile creabg exposure_image_3 exposure.bdf
write/parfile creabg exposure_image_4 exposure.bdf
write/parfile creabg exposure_image_5 exposure.bdf
write/parfile creabg exposure_image_6 exposure.bdf
create/bg_image creabg
! Output spline-fitted background images: bacmpX.bdf

creat/parfile detemap detemap rosat,survey
write/parfile detemap min_ml 7.0
write/parfile detemap num_images 6
detect/map detemap

! Merging of source lists: 0.5-2.0 keV
create/parfile mergsou mergsou rosat,survey
write/parfile mergsou num_images 1
write/parfile mergsou ldetect_list_1 lslst3.tbl
write/parfile mergsou mdetect_list_1 mslst3.tbl
write/parfile mergsou merged_list mplst3.tbl
write/parfile mergsou BG_IMAGE_1 bacmp3.bdf
merg/sou mergsou
