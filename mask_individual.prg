define/param P1  ? ? "Which Source ? (#Row)"
define/local xm/r/1/1 0.
define/local ym/r/1/1 0.
define/local x1/r/1/1 0.
define/local y1/r/1/1 0.
define/local rad/r/1/1 0.
define/local rsou/r/1/1 0.
define/local Remark/c/1/1 " " all
set/format I6

!--Image shown in the Display Window #0----------------------------------------------------------------
assign/dis 0

!--Select the {P1}^{th} Source to Mask-----------------------------------------------------------------
select/tab solst3 seq.eq.{P1}

!--Load the relevant image for eye-ball checking-------------------------------------------------------
! For example, we mask the Hard-band image
! To have a better visual inspection, using Gaussian Filter on the image is necessary
filter/gaus image3 image3_S 3,3 3,1,3,1
load/image image3_S.bdf cuts=0,2

! Mark the selected point source on the image
draw/source solst3

mask:	
	xm = {solst3.tbl,:X_SKY,@{P1}} 
	ym = {solst3.tbl,:Y_SKY,@{P1}}
	Inquire/keyword rsou "Input Mask Image Size (unit:ima_pix) ?"
	
	!--Compute the radius of image mask of that source---------------------------------------------
	rad =  {rsou}/2. * 90 
	write/out "Mask out region" {xm} {ym} "radius" {rsou} "pixel"
	x1 = xm - rad
	y1 = ym + rad
	
	!--Create the mask frame-----------------------------------------------------------------------
	create/image source_mask_{P1} 2,{rsou},{rsou} {x1},{y1},90,-90 CIRCLE {rad},0,1
	
	!--Masked Image shown in the Display Window #1 for comparison----------------------------------
	assign/dis 1
	$cp mask.bdf mask1.bdf
	ins/ima source_mask_{P1} mask1
	comp/ima mask1 = mask1 * mask
	comp/ima ima3_M = image3 * mask1
	filter/gaus ima3_M.bdf ima3S_M 3,3 3,1,3,1
	load/image ima3S_M cuts=0,2
	draw/source solst3 0 cross
	Inquire/keyword Remark "If this auotmatic mask OK? (y/n)"
	if Remark(1:1) .eq. "y" then
  		$cp mask1.bdf mask.bdf
	else
		goto mask
	endif
