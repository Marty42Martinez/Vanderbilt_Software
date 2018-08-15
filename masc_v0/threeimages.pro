FUNCTION ThreeImages, tag,tagdate
  ;Accepts a tag for a specific snowflake and returns a structure that contains all needed info for a snowflake
  
;  f = file_search('/Users/Marty/Desktop/TRIPLETS','*'+tag+'*')
;  f = file_search('/Users/Marty/Desktop/MASC/Water_drops/1_30_2014/1cc_1_30/','*'+tag+'*')
;f = file_search('/Users/Marty/Desktop/MASC/BoulderA/MASC/OldMascImages/LightSpheres_Nashville_03.11.2014/','*flake_'+tag+'*')
;  f = file_search('/Users/Marty/Desktop/MASC/BoulderFlakes','*flake_'+tag+'*')
  f = file_search('/Users/Marty/Desktop/MASC/BoulderA/MASC/MascImages','*'+tagdate+'*'+'*flake_'+tag+'*')
  ;f = file_search('/Users/Marty/Desktop/MASC/AGU','*flake_'+tag+'*')
  ;f = file_search('/Users/Marty/Desktop/MASC/MultiFlakes','*flake_'+tag+'*')
  ;f = file_search('/Users/Marty/Desktop/MASC/MQT/Event5','*'+tagdate+'*'+'*flake_'+tag+'_*')
  ;f = file_search('/Users/Marty/Desktop/MASC/drops_Nashville_1.30.2014/2cc','*'+tagdate+'*'+'*flake_'+tag+'*')
  ;stop
  if n_elements(f) ne 3 then begin
    st = {fallspeed:1000}
    return, st
  endif

  i0 = fix(Read_Image(f[0]))
  i1 = fix(Read_Image(f[1]))
  i2 = fix(Read_Image(f[2]))
  
  img0 = multi_flake(i0,1)
  img1 = multi_flake(i1,2)
  img2 = multi_flake(i2,3)
  ;stop
  
  ;need to test if img1-3 actually have something
  if img0 eq !null or img1 eq !null or img2 eq !null then begin
    st = {fallspeed:1000}
    return, st
  endif 
  ;else begin
   ; together = match_test(img0,img1,img2,tag,date, hour)
  ;endelse
  ;return, img1
  flake = flakestruct_concat(img0,img1,img2,f,tag)
  return, flake
  
  

  ;****NEED TO UPDATE BELOW TO FOLLOW cam0..1..2 nomenclature***;
  s1 = size(img1)
  s2 = size(img2)
  s3 = size(img3)
  
  
  
  
  if s1[1] eq 0 or s2[1] eq 0 or s3[1] eq 0 then begin
    out = {$
      AsR1:0,$
      AsR2:0,$
      AsR3:0,$
      ArR1:0,$
      ArR2:0,$
      ArR3:0$
    }
    
    out.AsR1 = 0
    out.AsR2 = 0
    out.AsR3 = 0
    
    out.ArR1 = 0
    out.ArR2 = 0
    out.ArR3 = 0  
	num = 0  
  endif else begin
    out = {$
      AsR1:fltarr(s1[1]),$
      AsR2:fltarr(s2[1]),$
      AsR3:fltarr(s3[1]),$
      ArR1:fltarr(s1[1]),$
      ArR2:fltarr(s2[1]),$
      ArR3:fltarr(s3[1])$
    }
    ord_flakes = flake_matching(img1,img2,img3)
    s_ord = size(ord_flakes) 
	num = s_ord[1]/3
	ord1 = ord_flakes[0:num-1]
	ord2 = ord_flakes[num:2*num-1]     
	ord3 = ord_flakes[2*num:3*num-1]
	
    ;out.AsR1 = ord_img1.AsR
    ;out.AsR2 = ord_img2.AsR
    ;out.AsR3 = ord_img3.AsR
    
    ;out.ArR1 = ord_img1.ArR
    ;out.ArR2 = ord_img2.ArR
    ;out.ArR3 = ord_img3 .ArR
  endelse
  
  if num ge 1 then begin
    ;printf, 101, date,'   ',hour,'   ',tag
  ;**PROBLEM**
  ;  Only shows SOME of the snowflakes...not sure why? 
    for i = 0,num-1 do begin        
	    holder = match_test(ord1[i],ord2[i],ord3[i],tag,date, hour)
    endfor
  endif

  
    
  return, out
  
  stop
  images = [img1.flake_img,img2.flake_img,img3.flake_img]
;  img_ is an array of flake structures
;  images = flake_matching(img1,img2,img3)
;  stop
  
;  images = [img1,img2,img3]
  return, images



end
