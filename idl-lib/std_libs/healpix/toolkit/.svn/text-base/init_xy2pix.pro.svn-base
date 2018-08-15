PRO init_xy2pix
;************************************************************************
;
;     sets the array giving the number of the pixel lying in (x,y)
;     x and y are in {1,128}
;     the pixel number is in {0,128**2-1}
;
;     if  i-1 = sum_p=0  b_p * 2^p
;     then ix = sum_p=0  b_p * 4^p
;          iy = 2*ix
;     ix + iy in {0, 128**2 -1}
;-
;************************************************************************

  common xy2pix, x2pix, y2pix

  x2pix = LONARR(128)
  y2pix = LONARR(128)

  for i = 0,127 do begin        ;for converting x,y into
      j  = i                    ;pixel numbers
      k  = 0
      ip = 1
      loop:
      if (j eq 0) then begin
          x2pix(i) = K
      endif else begin
          id = j mod 2
          j  = j/2
          k  = IP*ID+K
          ip = ip*4
          goto, loop
      endelse
  endfor
  y2pix = 2 * x2pix

  return
end

;*****************************************************************************
