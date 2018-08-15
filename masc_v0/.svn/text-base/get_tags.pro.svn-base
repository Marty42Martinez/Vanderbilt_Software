FUNCTION get_tags
;  f = file_search('/Users/Marty/Desktop/TRIPLETS','*cam_0.png')
;  f = file_search('/Users/Marty/Desktop/MASC/Water_drops/1_30_2014/1cc_1_30/','*cam_0.png')
  ;f = file_search('/Users/Marty/Desktop/MASC/BoulderA/MASC/OldMascImages/LightSpheres_Nashville_03.11.2014/','*cam_0.png')
;  f = file_search('/Users/Marty/Desktop/MASC/BoulderFlakes','*cam_0.png')
  f = file_search('/Users/Marty/Desktop/MASC/BoulderA/MASC/MascImages','*cam_0.png')
  ;f = file_search('/Users/Marty/Desktop/MASC/AGU','*cam_0*')
  ;f = file_search('/Users/Marty/Desktop/MASC/MultiFlakes','*cam_0.png')
  ;f = file_search('/Users/Marty/Desktop/MASC/MQT/Event5','*cam_0.png')
  ;f = file_search('/Users/Marty/Desktop/MASC/drops_Nashville_1.30.2014/2cc','*cam_0.png')
  sf = size(f)
  cont = 0
  tagarr = make_array(sf[1], /string)
  datearr= make_array(sf[1],/string)
  while cont LT sf[1] do begin

    fcam0 = f[cont]
    dir   = FILE_DIRNAME(fcam0) ;saves the directory as a string
    file  = FILE_BASENAME(fcam0) ;saves the filename as a string
    tag  = STRSPLIT(file,'_',/EXTR)
    tagarr[cont] = tag[3]
	datearr[cont] = tag[0]
    cont = cont+1
  endwhile
  ;stop
    st = {tags:tagarr,dates:datearr}
  RETURN, st  

end
