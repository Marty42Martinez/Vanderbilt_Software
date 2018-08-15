
pro ps2x,convert=convert,display=display,resolution=resolution
  
  COMMON x2ps_common_block,x2ps_filename
  
  KEYWORD_DEFAULT,resolution,150
  
  resolution= resolution>50<999
  
  asd=STRING(resolution,FORM='(I3)')+'x'+STRING(resolution,FORM='(I3)')
  
  
  device, /close
  set_plot,'X'
;  IF KEYWORD_SET(convert) THEN SPAWN,'convert -density 100x100 -alpha off '+x2ps_filename+' '+x2ps_filename+'.png'
  IF KEYWORD_SET(convert) THEN SPAWN,'convert -density '+asd+' +matte '+x2ps_filename+' '+x2ps_filename+'.png'
  IF KEYWORD_SET(convert) and KEYWORD_SET(display) THEN SPAWN,'display '+x2ps_filename+'.png'
end    

