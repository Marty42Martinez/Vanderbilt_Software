FUNCTION multi_flake, i, cam_num
;1/13/14: manipulated flake accepting parameters
;***xcent[600:1800], avg_br of pixels in flake reg > 30 (changed from max_br > 50)
;1/19/14: manipulated flake acceptance region (line 92 and very end)
;***Want to isolate flake that triggered camera
  img = i
;  if cam_num eq 1 then begin
;    img = img[300:*,*]
;  endif
;  if cam_num eq 3 then begin
;    img = img[0:2150,*]
;  endif
  s = size(img)
  img_mask = intarr(s[1],s[2])
  ;  Gets rid of IR sensor spots in the image
  ;  Not sure how necessary this is...
  ;if cam_num EQ 1 then begin
  ;  if (total(where(img[65:230,1020] gt 30)) EQ -1) then begin
  ;    img[65:230,960:1015] = 0 ;only removes the IR dots if the snowflake is not near them
  ;  endif
  ;endif else begin

  ;  if (total(where(img[2180:2447,1020] gt 30)) EQ -1) then begin
  ;    img[2180:2447,950:1005] = 0
  ;  endif
  ;endelse

  
  mask = where(img gt 10)
  img_mask[mask] = 255
  
  
  flake_reg = label_region(img_mask,/ULONG)
  n = max(flake_reg) ;number of regions
  
  flake = {$
    ycent:0,$
    ydim:0,$
    xcent:0,$
    pix_count:0L,$
	flake_img: make_array(800,800,/byte)$
    ;flake_img:intarr(800,800)$
    }
  
;  tags = strarr(n)
  ;for i=0,n-1 do begin
  ;  tags[i]= ftag+'_'+str(i)
  ;endfor
  
  
  ;Need to only go through regions that have one dimension > 30 pixels
  check = 0
  for j=1,n do begin
    pix_loc = where(flake_reg eq j,count)
    ;if count gt 70 and max(img[pix_loc]) gt 50 then begin
	avg_br = total(img[pix_loc])/count
	if count gt 70 and avg_br gt 30 then begin
      
      x = pix_loc mod s[1]
      y = pix_loc/s[1]
      
  ;    xnew = findgen(max(x)-min(x))
      
      
      ycent = fix(y[-1] - y[0]) + y[0]
      xcent = fix(x[-1] - x[0]) +x[0]
      
      flakenew = flake
  ;    flakenew = create_struct(flakenew,'flake_img',flake_img)
      xlen = max(x) - min(x)
      x_blank = (800-xlen)/2
      xnew = x-min(x)
      xtest = xnew + x_blank
      
      ylen = max(y) - min(y)
      y_blank = (800-ylen)/2
      ynew = y-min(y)
      ytest = ynew + y_blank
      
;;      xtest = (800.-xnew[-1])/2 + xnew
;      ;    ynew = findgen(max(y)-min(y))
;      ynew = y-min(y)
;      ytest = (800.-ynew[-1])/2 +ynew
;      stest = max([xnew[-1]+1,ynew[-1]+1])
;      ;    flake_img = intarr(xnew[-1]+1,ynew[-1]+1)
      flakenew.ycent = ycent
;      flakenew.ydim = ynew[-1]+1
      flakenew.xcent = xcent
	  
      flakenew.flake_img[xtest,ytest] = img[x,y]
      flakenew.pix_count = count ; changed from float(count)
	  
	  if flakenew.xcent gt 400 and flakenew.xcent lt 2000 and $
	  flakenew.ycent gt 850 and flakenew.ycent lt 1200 then begin
	  ;old ycent lims [700,1350]
	  ;if flakenew.xcent gt 0 then begin
        meas2D = flake_measurements(flakenew)
        if check eq 0 then begin
          flake_arr = [meas2D,meas2D]
          check = 1
        endif else begin
          flake_arr = [flake_arr,meas2D]
		  check += 1
        endelse
	  endif
    endif
    
  endfor
  sreturn, flake_arr
;  if check = 0 then begin
;    
;  endif
  if check eq 0 then begin
    flake_arr = []
	;stop
  endif else begin
    flake_arr = flake_arr[1:*]  
  endelse
  
  if check gt 1 then begin
    flake = trigger_flake(flake_arr,check)
	return, flake
  endif
  
  
  return, flake_arr
end
