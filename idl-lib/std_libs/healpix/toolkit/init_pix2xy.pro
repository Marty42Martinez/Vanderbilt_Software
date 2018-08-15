PRO init_pix2xy
;*********************************************************************
;+
;     INIT_PIX2XY
;
;     constructs the array giving x and y in the face from pixel number
;     for the nested (quad-cube like) ordering of pixels
;
;     the bits corresponding to x and y are interleaved in the pixel number
;     one breaks up the pixel number by even and odd bits
;-
;*********************************************************************

  common pix2xy, pix2x, pix2y
  pix2x = LONARR(1024L)
  pix2y = LONARR(1024L)

  for kpix = 0L, 1023L do begin ; pixel number
      jpix = kpix
      ix = 0L
      iy = 0L
      ip = 1L                   ; bit position (in x and y)
      while (jpix GT 0) do begin ; go through all the bits
          id = jpix MOD 2       ; bit value (in kpix), goes in ix
          jpix = jpix/2
          ix = id*ip+ix

          id = jpix MOD 2       ; bit value (in kpix), goes in iy
          jpix = jpix/2
          iy = id*ip+iy

          ip = 2*ip             ; next bit (in x and y)
       endwhile
       pix2x(kpix) = ix         ; in 0,31
       pix2y(kpix) = iy         ; in 0,31
   endfor

   return
end
