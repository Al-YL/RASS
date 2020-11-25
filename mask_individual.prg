dafine/PARAM P1 ? ? "which source"
define/local xm/r/1/1 0.
define/local ym/r/1/1 0.
define/local x1/r/1/1 0.
define/local y1/r/1/1 0.
define/local rad/r/1/1 0.
define/local rsou/r/1/1 0.
define/local Remark/c/1/1 " " all

set/format I6	
assign/dis 0
select/tab solst3 seq.eq.{P1}
load/image image3_S.bdf cuts=0,2
draw/source solst3 
xm = {solst3.tbl,:X_SKY,@{P1}} 
ym = {solst3.tbl,:Y_SKY,@{P1}}

mask:	
	Inquire/keyword rsou "input mask radius (unit:ima_pix) ?"
	rad =  {rsou}/2.*90 
	!radius of image mask of individual source
	write/out "Mask out region" {xm} {ym} "radius" {rsou} "pixel"
	x1 = xm - rad
	y1 = ym + rad
	create/image source_mask{P1} 2,{rsou},{rsou} {x1},{y1},90,-90 CIRCLE {rad},0,1
	assign/dis 1 
	$cp mask.bdf mask1.bdf
	ins/ima source_mask{P1} mask1
	comp/ima mask1 = mask1*mask
	comp/ima ima3_M = image3*mask1
	FILTER/GAUS ima3_M.bdf ima3S_M 3,3 3,1,3,1
	load/image ima3S_M cuts=0,2
	draw/source solst3 0 cross
	Inquire/keyword Remark "If this auotmatic mask_expo OK? (y/n)"
	if Remark(1:1) .eq. "y" then
  		$cp mask1.bdf mask.bdf
	else
		goto mask
	endif
