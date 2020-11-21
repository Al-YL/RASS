!--Convert ROD (ROSAT Observation Dataset) from fits file to EXSAS format
! For more details:
!	help intape/rdf
 
intape/rdf disk rs anc,bas,mex

! If broad-band exposure map <exposure.bdf> has not created by the above command (unknown reason), then:
intape/rdf disk rs*_mex.fits mex
