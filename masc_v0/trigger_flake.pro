FUNCTION trigger_flake, flakearr, s

;avgbrightness does not work 
;**small particles with really bright spot are misjudged
;vert dist from diodes does not work
;**particles directly above main flake tend to be closer to diodes

;Current Solution
;1/20/15
;small flakes have very high sharpness values (>2)
;therefore we discount those values...has led to success


  p2mm = 0.0308252
  psize = flakearr.Rmax
  ycents = flakearr.y_off
  imgs = flakearr.flake_img
  ;px = flakearr.pix_count
  sharpness = flakearr.sharpness
  
  ;stop
  ;sharpness = fltarr(s)
  for i=0,s-1 do begin
	if sharpness[i] gt 1.9 and psize[i] lt 5 then begin
	  sharpness[i] = 0
    endif
  endfor
  
  
  flake = flakearr[where(sharpness eq max(sharpness))]
  if n_elements(flake) gt 1 then flake=flake[where(flake.Rmax) eq max(flake.Rmax)]
  if n_elements(flake) gt 1 then flake = flake[0]
  return, flake
end
