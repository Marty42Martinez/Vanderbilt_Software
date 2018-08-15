pro Snowflakes

;######################;
;####BEFORE RUNNING####;
;##CHANGE PATHS IN...##;
     ;get_tags.pro;
    ;multi_flake.pro;
   ;MASC_dataInfo.pro;
;######################;
;######################;

  tag_st = get_tags()
  tags = tag_st.tags
  tagdates = tag_st.dates

  
  last_stop = 0 ;Mon Jan 12
  ;last_stop = 252 ; Mon Jan 12

  prev_hr = 0
  curr_hr = 0
  flake_ct = 0
  flakes=[]
  dates = tagdates[uniq(tagdates)]

  for i =last_stop,n_elements(tags)-1 do begin
    flake = threeimages(tags[i],tagdates[i])
	;stop
	;flakes = [flakes,flake]
	if flake.fallspeed ne 1000 then begin
	  fname = flake.cameras[0].fname
	  flake.fallspeed = MASC_dataInfo(fname,tags[i])
	  
	  curr_hr = flake.date_time.hh
	  ;stop
	  if prev_hr ne curr_hr and flake_ct ne 0 then begin
	    last_fl = flakes[-1]
	    newD = '/Users/Marty/Desktop/MASC/BoulderA/MASC/MascImages/BoulderSaveFiles/'
		out1 = newD + last_fl.date_fn +'.sav'
		;stop
		save, file=out1, flakes
		flakes = [flake]
	  endif else begin
	    flakes = [flakes,flake]
	  endelse
	  prev_hr = curr_hr
	  
	  
	 flake_ct += 1
	endif

  endfor
end  
  
  ;last_fl = flakes[-1]
;  newD = '/Users/Marty/Desktop/MASC/MQT/MQTSaveFiles/'
  ;newD = '/Users/Marty/Desktop/MASC/BoulderA/MASC/MascImages/BoulderSaveFiles/' 
  ;out1 = newD + last_fl.date_fn +'test.sav'
		;stop
  ;save, file=out1, flakes
  ;out1='/Users/Marty/Desktop/Research_Data/Droplets/2_4_droplets2ml.sav'
  ;save, file=out1,flakes
  ;calib_struct.max0 = R_max0
  ;calib_struct.min0 = R_min0
  
  ;calib_struct.max1 = R_max1
  ;calib_struct.min1 = R_min1
  
  ;calib_struct.max2 = R_max2
  ;calib_struct.min2 = R_min2 
  
  ;out1='/Users/Marty/Desktop/Research_Data/Calib_sphere_save/cal_struct.sav'
  ;SAVE,file=out1,calib_struct
  ;cal = calibration(calib_struct)
  ;stop
  ;plot, ArR1,AsR1 
  ;test1 = scatterplot(ArR1,AsR1)
  ;out1='Desktop/Imaging/12_10_ASARvals/AsR1.sav'
  ;SAVE,file=out1,AsR1
  ;out2='Desktop/Imaging/12_10_ASARvals/ArR1.sav'
  ;SAVE,file=out2,ArR1
  
  ;out3='Desktop/Imaging/12_10_ASARvals/AsR2.sav'
  ;SAVE,file=out3,AsR2
  ;out4='Desktop/Imaging/12_10_ASARvals/ArR2.sav'
  ;SAVE,file=out4,ArR2
 
  ;out5='Desktop/Imaging/12_10_ASARvals/AsR3.sav'
  ;SAVE,file=out5,AsR3
  ;out6='Desktop/Imaging/12_10_ASARvals/ArR3.sav'
  ;SAVE,file=out6,ArR3

;    stop
;    
;;    all_flakes = threeimages(tags[2])
;    camera1 = all_flakes[0:599,*]
;    camera2 = all_flakes[600:1199,*]
;    camera3 = all_flakes[1200:1799,*]
;    snowflake = snow_struct(camera1,camera2,camera3,tags[i])
;;    checksize = float(n_elements(all_flakes))
;;    stop
;;    Need to see the size of this array to see which part to use
;;    camera1 = all_flakes[0:checksize/3-1]
;;    camera2 = allflakes[checksize/3:2*checksize/3-1]
;;    camera3 = allflakes[2*checksize/3:checksize]
;    
;;    for j =0,n_elements(camera1) do begin
;;      snowflake = snow_struct(camera1[j],camera2[j], camera3[j], tag[i])
;;      
;;      new = flake_measurements(snowflake.cam1)
;;      snowflake = struct_append(snowflake,new)
;;      new = flake_measurements(snowflake.cam2)
;;      snowflake = struct_append(snowflake,new)
;;      new = flake_measurements(snowflake.cam3)
;;      snowflake = struct_append(snowflake,new)
;;      
;;      
;;;      outfile='STRUCTURES/flake_'+snowflake.tag+'_'+str(j)+'.sav'
;;      ;  SAVE,file=outfile,snowflake
;;      ;  stop
;;    endfor
;    
;  
;    new = flake_measurements(snowflake.cam1)
;    snowflake = struct_append(snowflake,new)
;    new = flake_measurements(snowflake.cam2)
;    snowflake = struct_append(snowflake,new)
;    new = flake_measurements(snowflake.cam3)
;    snowflake = struct_append(snowflake,new)
;    
;    
;;    ellipses = ellipse_2D(snowflake)
;;    snowflake = struct_append(snowflake, ellipses)
;;    if i eq 24 or 42 then begin
;;      stop
;;    endif
;    
;    
;;    outfile='Desktop/Imaging/STRUCTURES/flake_'+snowflake.tag+'.sav'
;;    SAVE,file=outfile,snowflake
;;    EZ1s[i] = snowflake.EZ1_f
;;    EZ2s[i] = snowflake.EZ2
;;    EZ3s[i] = snowflake.EZ3_f
;;This is to feed into the volume statistics function to test water drop images
;    snowflake = pixels2mmeters(snowflake)
;
;    R_max1[i] = snowflake.Rmax1
;    R_min1[i] = snowflake.Rmin1
;;    
;    R_max2[i] = snowflake.Rmax2
;    R_min2[i] = snowflake.Rmin2
;;    
;    R_max3[i] = snowflake.Rmax3
;    R_min3[i] = snowflake.Rmin3 
;    
;    
;    
;    
;    
;;  endfor
;;  calib_struct.max1 = R_max1
;;  calib_struct.min1 = R_min1
;;  
;;  calib_struct.max2 = R_max2
;;  calib_struct.min2 = R_min2
;;  
;;  calib_struct.max3 = R_max3
;;  calib_struct.min3 = R_min3
;  
;;  cal = calibration(calib_struct)
;;   window, 1
;;   plot, EZ2s, EZ1s, psym=1, title = 'EZ2 values vs EZ1 values'
;;   window, 2
;;   plot, EZ2s, EZ3s, psym=1, title = 'EZ2 values vs EZ3 values'
;;   window, 3
;;   plot, EZ1s, EZ3s, psym=1, title = 'EZ1 values vs EZ3 values'  
;
;
;;  outfile='STRUCTURES/flake_'+snowflake.tag+'.sav'
;;  SAVE,file=outfile,snowflake
;;  stop
;  volume_data1 = proxy_vol_2D(R_max1,R_min1)
;  volume_data2 = proxy_vol_2D(R_max2,R_min2)
;  volume_data3 = proxy_vol_2D(R_max3,R_min3)
;  stop
;
;end
