FUNCTION flakestruct_concat,cam0,cam1,cam2,f,tag
  date = {$
    d:0,$
	m:0,$
	y:0,$
	hh:0,$
	mm:0,$
	ss:0,$
	jul_day:0D$
	}
	
  fname = file_basename(f[0])
  fn = strsplit(fname,'_',/extract)
  daten = fn[0]
  time = fn[1]
  reads,daten,FORMAT='(I4,1X,I2,1X,I2)',yr,mo,da
  reads,time,FORMAT='(I2,1X,I2,1X,I2)',hr,mi,se
  date.y = yr
  date.m = mo
  date.d = da
  date.hh = hr
  date.mm = mi
  date.ss = se
  date.jul_day = julday(date.m,date.d,date.y,date.hh,date.mm,date.ss)
  
  out = {$
    date_time:replicate(date,1),$
	date_fn:'',$
	fallspeed:0.,$
	tag:'',$
	cameras:replicate(cam0,3)$
  }
  ;NEED TO INCLUDE THE CODE FOR EXTRACTING FALLSPEED!;
  ;Maybe write a function (called in snowflakes) that returns an array of speeds
  ;use counter variable in for loop to determine which speed to assign
  
  ;file_basename()
  
  
  out.date_time = date
  out.date_fn = strcompress(daten+'_'+string(date.hh),/remove_all)
  out.tag = tag
  
  out.cameras[0] = cam0
  out.cameras[1] = cam1
  out.cameras[2] = cam2
  
  out.cameras[0].fname = file_basename(f[0])
  out.cameras[1].fname = file_basename(f[1])
  out.cameras[2].fname = file_basename(f[2])
  
  ;out.cameras[0].flake_img = byte(out.cameras[0].flake_img)
  ;out.cameras[1].flake_img = byte(out.cameras[1].flake_img)
  ;out.cameras[2].flake_img = byte(out.cameras[2].flake_img)
  
  return, out
end
