;FUNCTION flake_measurements, i
FUNCTION flake_measurements, st
  ;calculate Rmax.Rmin,EH,EZ for all cameras and add to the structure
  ;break this into two separate functions, one function accepts an image and returns a structure with above params
  ;second function adds new structure to the snowflake structure
  ;need to account for tags that already exist in the structure
  ;set of if statements (if tagexists **FIND THIS FUNCTION** then check the next tag)
  
;  img4c = i
  img4c = st.flake_img
;  img = img_cent(i)
  texture_st = {$
  mean_entropy:0.,$
  mean_homogenity:0.,$
  mean_energy:0.,$
  mean_asm:0.,$
  mean_sigma:0.,$
  stddv_entropy:0.,$
  stddv_homogenity:0.,$
  stddv_energy:0.,$
  stddv_asm:0.,$
  stddv_sigma:0.,$
  raw_mean:0.,$
  raw_stddv:0.$
  }
  out = {$
    ;flake_img:intarr(800,800),$
	flake_img: make_array(800,800,/byte),$
	;ellipse_img: make_array(800,800,/byte),$
    x_width:0,$
    y_width:0,$
    Rmax:0,$
    Rmin:0,$
    AsR:0.,$
    ArR:0.,$
    angle:0,$
    x_off:0,$
    y_off:0,$
    max_bright:0.,$
	texparams: replicate(texture_st,1),$
	;texparams_px_gt_ten: replicate(texture_st,1),$
	;texparams_ell: replicate(texture_st,1),$
	;meanB:0.,$
	;stdB:0.,$
	;meanB_in_ell:0.,$
	;stdB_in_ell:0.,$
	sharpness:0.,$
	fname:''$
    }
  
  maxarr=intarr(180)
  minarr=intarr(180)
    ;pix_count:0,$
  out.flake_img = img4c
    
;  This is code for finding the center of the snowflake in the image
;  cannot use for loop because img is a centered image which gives skewed values  
  ;tester = total(img4c,2)
  ;testmax = max(where(tester gt 0))
  ;testmin = min(where(tester gt 0))
  ;cent_x = testmin + (testmax-testmin)/2
  
  ;tester = total(img4c,1)
  ;testmax = max(where(tester gt 0))
  ;testmin = min(where(tester gt 0))
  ;cent_y = testmin + (testmax-testmin)/2
  
  for j = 0,179 do begin
    img2 = rot(img4c,j)
    
    tester = total(img2,2)
    ;tester is an array that sums all brightness values for each column
    ;its length = xdim of image
    ;use this to determine where we have useable data in the x direction
    testmax = max(where(tester gt 0))
    testmin = min(where(tester gt 0))
    ;since where returns positions this gives the max and min positions in the x direction where a snowflake exists
    maxarr[j] = testmax-testmin

    tester = total(img2,1)
    ;same idea but in y direction
    testmax = max(where(tester gt 0))
    testmin = min(where(tester gt 0))
    minarr[j] = testmax - testmin
    ;here we don't want the minimum width, we want the maximum width that is perpendicular to the max direction
    
  endfor
    
    ind = where(maxarr eq max(maxarr))
    ;ind will be an array (ideally of size 1) of angles
    ind2 = where(minarr[ind] eq min(minarr[ind]))
    ;written this way to account for ind having more than one element
    ;ind2 will be the position in IND **IMPORTANT** of minimum width in ydir associated with the position of max width in xdir
    out.Rmax = maxarr[ind[ind2[0]]]
    ;use ind2[0] to account for multiple min values; we assume they are adjacent at this point
    out.Rmin = minarr[ind[ind2[0]]]
    angle = ind[ind2[0]]
    
    out.x_width = maxarr[0]
    out.y_width = minarr[0]
    out.angle = angle
    out.x_off = st.xcent
    out.y_off = st.ycent
    out.AsR = out.Rmin/float(out.Rmax)
    rad = out.Rmax/2.
    out.ArR = st.pix_count/(!pi*rad^2)
    out.max_bright = max(img4c)
    b_vals = where(img4c > 10)
    ;out.meanB = total(img4c[b_vals])/st.pix_count
    ;out.pix_count = st.pix_count
	
	
    edge = sobel(img4c)
	e_ind = where(edge gt 20 )
	img_ind = where(img4c gt 20)
	out.sharpness = mean(edge[e_ind])/mean(img4c[img_ind])
	
	;x   = FINDGEN(800) # (FLTARR(800)+1) -400
    ;y   = TRANSPOSE(x)
    ;ell   = ROT((2*x/out.Rmax)^2 + (2*y/out.Rmin)^2,-angle)
	;stop
    ;asd = ell

   ;makes an image with a thick ellipse
   ;consider adjusting and adding to structure because it is useful for figures
    ;asd[where(asd gt 1.05)] = 0
	;asd[where(asd lt 1.05 and asd gt 0.95)] = 255
	
	;out.ellipse_img = asd+out.flake_img
	;px_loc = where(out.flake_img gt 10)
	;ell_loc = where(ell le 1,count)
 
	;rect = out.flake_img[400-(0.5*out.x_width):400+(0.5*out.x_width),$
	;400-(0.5*out.y_width):400+(0.5*out.y_width)]
	
	
	;hold = make_array(800,800,/byte)
	;hold[inside] = out.flake_img[inside]
	rect = out.flake_img[400-(0.5*out.x_width):400+(0.5*out.x_width),$
	400-(0.5*out.y_width):400+(0.5*out.y_width)]
	sz = size(rect)
	
	a = LABEL_REGION(rect GT 3) 
    b = SMOOTH(FLOAT(a),5)
    c = b GT 0.999
	inside = where(c eq 1, cnt)
	inside2 = WHERE(out.flake_img gt 3)
	raw_mn = mean(out.flake_img[inside2])
	raw_std = stddev(out.flake_img[inside2])
	norm_rect = (float(rect)/raw_mn*120.<255)
	;norm_rect = (rect -raw_mn)/raw_std
	;norm_rect = norm_rect + abs(min(norm_rect))
	
	
	if cnt gt 10 then begin
	  tex1 = texture_new2(norm_rect)
	  for i = 1,5 do begin  
	    out.texparams.(i-1) = mean(tex1.(i)[inside])
	    out.texparams.(i+4) = stddev(tex1.(i)[inside])
	  endfor
	  out.texparams.(10) = raw_mn
	  out.texparams.(11) = raw_std
	endif
	;stop
	
	
	;out.meanB_in_ell = mean(out.flake_img[loc])
	;out.stdB_in_ell = stddev(out.flake_img[loc])
	
	
    
    return, out

end
