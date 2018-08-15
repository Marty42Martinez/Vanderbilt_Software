PRO make_lidar_image_elena,ovp,COLOR=color
; Color option has not been implemented yet
; COLOR implements the color bar
; Get the color info
  lidar_colors_erik,rgb,colors_532,color_bar,color_bar_labels,/MODIFY
  
; The following code was inserted here to show how the colors are assigned to 
; each pixel (data elements within the attenuated backscatter profiles).

; ist and iend are the selected start and end locations along the orbit track
  
  	startup				; Start AVACS
	o=OBJ_NEW('atrain')
	o->set_overpass,ovp
	
	; Import CALIOP data:	
	data = o->get_Data(Sen='CALIOP',pro='TAB_1064',/DATA,/NEAR)
	hgt = o->get_Data(Sen='CALIOP',pro='HGT',/DATA,/NEAR)
	hgt = hgt[*,0]
	lat = o->get_Data(Sen='CPR',pro='LAT',/DATA)
  
  dim = size(data,/DIMENSIONS)
; From MATLAB, data - (MxN)= row X col = alt X prof, matrix of attenueted 
; backscatter values

  nAlt = fltarr(dim[1])
  nProf = fltarr(dim[0])
  
; From MATLAB code:
; For some reason adding the color bar messes up the colormap for the image.  I
; spent a bunch of time trying to figure out why and was unable to determine the
; exact cause.  So, when adding a colorbar draw the image as MxNx3.
IF N_ELEMENTS(color) EQ 1 THEN BEGIN
  out_img = uintarr(dim[0],dim[1],3)
ENDIF ELSE BEGIN
  out = uintarr(dim[0],dim[1])
ENDELSE

FOR ic=1,dim[0]-1 DO BEGIN
; The_profile_mfs contains the attenuated backscatter values in units of /km/sr.
; Division by 1.0e-4 converts the attenuated backscatter values to an integer 
; value.  Each integer value is associated to a color within colors_532.
  tmp = floor(data[ic,*]/1.0e-4)
; Filter out the negative data
  neg_mask = (data[ic,*] GT 1.0e-4)
  tmp = neg_mask*tmp + (~neg_mask)*1
; Filter out the data that exceeds 0.1
  over_mask = (data[ic,*] LT 0.1)
  tmp = over_mask*tmp + (~over_mask)*1001
  
; Convert the out value (which is an index) to a color.
  IF N_ELEMENTS(color) EQ 1 THEN BEGIN
    tmp = colors_532[tmp]
	out_img[0,ic,*] = uint(rgb(0,tmp)/255*65535)
	out_img[1,ic,*] = uint(rgb(1,tmp)/255*65535)
	out_img[2,ic,*] = uint(rgb(2,tmp)/255*65535)
  ENDIF ELSE BEGIN
    out[ic,*] = colors_532[tmp]; - 1 ; Required for uint8 image indexing
  ENDELSE
ENDFOR

IF N_ELEMENTS(color) EQ 1 THEN BEGIN
  tv,rotate(out_img,3)
; Default is vertical
  lidar_colorbar,rgb,color_bar,color_bar_labels;/HORIZ
ENDIF ELSE BEGIN
  tvlct,rgb[0,*],rgb[1,*],rgb[2,*]
  
;  x2ps,'test.ps',bits=8
;  !P.FONT=0
;  !P.CHARSIZE=0.8
;  IF !D.NAME NE 'X' THEN DEVICE, SET_FONT='HELVETICA'
 
  mask = hgt LE 5100 AND hgt GE 0
  index = where(mask EQ 1)
  alt_new = hgt[index]
  dim1 = size(index,/DIMENSIONS)
  dim2 = size(lat,/DIMENSIONS)
  out_new = fltarr(dim1[0],dim2[0])
  FOR i=0,dim[1]-1 DO BEGIN
    out_new[*,i] = out[index,i]
  ENDFOR
  
  cgImage,rotate(out_new,3),Margin=0.1,/Axes, $
    XRange=[min(lat),max(lat)], $
    YRange=[min(alt_new),max(alt_new)]/1e3,Color='black', $
	AxKeywords={XTicklen:-0.015,YTicklen:-0.015, $
	Title:'Total Attenuated Backscatter',XTitle:'Latitude [deg]', $
	YTitle:'Altitude [km]'}

;  ps2x,/CONV
ENDELSE
END
