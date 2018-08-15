
pro x2ps,filename,_EXTRA=_EXTRA,xsize=xsize,ysize=ysize

 COMMON x2ps_common_block,x2ps_filename
 
 
KEYWORD_DEFAULT,xsize,17.
KEYWORD_DEFAULT,ysize,17.
 
 x2ps_filename=filename
 
 set_plot,'PS'
 device, file = filename, $
        XOFFSET = 0.5, YOFFSET = 5.,$
        XSIZE = xsize, YSIZE = ysize, $
        /helvetica,/COLOR,_EXTRA=_EXTRA
end



pro x2eps,filename,xsize=xsize,ysize=ysize

 COMMON x2ps_common_block,x2ps_filename


 KEYWORD_DEFAULT,xsize,17.
 KEYWORD_DEFAULT,ysize,17.
 set_plot,'PS'
 device, file = filename, $
        XOFFSET = 0.5, YOFFSET = 5.,$
        XSIZE = xsize, YSIZE = ysize, $
        /helvetica,/ENCAPSUL,/COLOR
end

;pro ps2x
;  device, /close
;  set_plot,'X'
;end    

