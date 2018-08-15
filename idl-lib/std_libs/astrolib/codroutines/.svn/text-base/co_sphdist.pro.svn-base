;-------------------------------------------------------------
;+
; NAME:
;       CO_SPHDIST
; PURPOSE:
;       Angular distance between points on a sphere.
; CALLING SEQUENCE:
;       d = sphdist(long1, lat1, long2, lat2)
; INPUTS:
;       long1 = longitude of point 1, scalar or vector
;       lat1 = latitude of point 1, scalar or vector
;       long2 = longitude of point 2, scalar or vector
;       lat2 = latitude of point 2, scalar or vector
;
; OPTIONAL KEYWORD INPUT PARAMETERS:
;       /DEGREES - means angles are in degrees, else radians.
; OUTPUTS:
;       d = angular distance between points (in radians unless /DEGREES
;           is set.)
; PROCEDURES CALLED:
;       RECPOL, POLREC
; NOTES:
;       (1) The procedure GCIRC is similar to SPHDIST(), but may be more
;           suitable for astronomical applications.
;
;       (2) If long1,lat1 are scalars, and long2,lat2 are vectors, then
;           SPHDIST returns a vector giving the distance of each element of
;           long2,lat2 to long1,lat1.   Similarly, if long1,lat1 are vectors,
;           and long2, lat2 are scalars, then SPHDIST returns a vector giving
;           giving the distance of each element of long1,lat1 to to long2,lat2.
;           If both long1,lat1 and long2,lat2 are vectors then SPHDIST returns
;           vector giving the distance of each element of long1,lat1 to the
;           corresponding element of long2, lat2.   If the input vectors are
;           not of equal length, then excess elements of the longer ones will
;           be ignored.
; MODIFICATION HISTORY:
;       R. Sterner, 5 Feb, 1991
;       R. Sterner, 26 Feb, 1991 --- Renamed from sphere_dist.pro
;
; Copyright (C) 1991, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;	Converted to IDL V5.0   W. Landsman   September 1997
;-
;-------------------------------------------------------------
; Rewritten by Chris O'Dell to be slicker, and do everything in the angular domain.

	function co_sphdist, long1, lat1, long2, lat2, $
	  help=hlp, degrees=degrees, alternate=alternate, $
	  approximate = approximate

	if (n_params(0) lt 4) or keyword_set(hlp) then begin
	  print,' Angular distance between points on a sphere.'
	  print,' d = sphdist(long1, lat1, long2, lat2)'
	  print,'   long1 = longitude of point 1.         in'
	  print,'   lat1 = latitude of point 1.           in'
	  print,'   long2 = longitude of point 2.         in'
	  print,'   lat2 = latitude of point 2.           in'
	  print,'   d = angular distance between points.  out'
	  print,' Keywords:'
	  print,'   /DEGREES means angles are in degrees, else radians.'
	  print,' Notes: points 1 and 2 may be arrays.'
	  return, -1
	endif

	cf = 1.0
	if keyword_set(degrees) then cf = !radeg

	; find the square of the sine of the angle c/2, where c is the angular separation we're after.
	if ~keyword_set(alternate) then begin
	  if keyword_set(approximate) then begin
	    out = sqrt((lat1-lat2)^2 + cos(lat1/cf)*cos(lat2/cf) * longitude_difference(long1-long2)^2)
          endif else begin
   	    sinsqc2 = sin( (lat1-lat2)/2./cf)^2 + cos(lat1/cf)*cos(lat2/cf) * sin( longitude_difference(long1-long2)/2./cf)^2
	    out = 2 * cf * asin(sqrt(sinsqc2))
          endelse	    
        endif else begin
;	  cf = double(cf)
	  cos_c = cos(lat1/cf)*cos(lat2/cf) * (cos(long1/cf)*cos(long2/cf)+sin(long1/cf)*sin(long2/cf))  + sin(lat1/cf) * sin(lat2/cf)
          out = cf * acos(cos_c)
     	endelse 
          
;	print, sinsqc2
	return, out

END
