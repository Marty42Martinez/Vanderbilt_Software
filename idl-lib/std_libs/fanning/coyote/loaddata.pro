;+
; NAME:
;       SMOOTH2
; PURPOSE:
;       Do multiple smoothing. Gives near Gaussian smoothing.
; CATEGORY:
; CALLING SEQUENCE:
;       b = smooth2(a, w)
; INPUTS:
;       a = array to smooth (1,2, or 3-d).  in
;       w = smoothing window size.          in
; KEYWORD PARAMETERS:
; OUTPUTS:
;       b = smoothed array.                 out
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner.  8 Jan, 1987.
;       Johns Hopkins University Applied Physics Laboratory.
;       RES  14 Jan, 1987 --- made both 2-d and 1-d.
;       RES 30 Aug, 1989 --- converted to SUN.
;       R. Sterner, 1994 Feb 22 --- cleaned up some.
;
; Copyright (C) 1987, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------

    function smooth2, i, w, help=hlp

    if (n_params(0) lt 2) or keyword_set(hlp)  then begin
      print,' Do multiple smoothing. Gives near Gaussian smoothing.'
      print,' b = smooth2(a, w)'
      print,'   a = array to smooth (1,2, or 3-d).  in'
      print,'   w = smoothing window size.          in'
      print,'   b = smoothed array.                 out'
      return, -1
    endif

    w1 = w > 2
    w2 = w/2 > 2

    i2 = smooth(i, w1)
    i2 = smooth(i2, w1)
    i2 = smooth(i2, w2)
    i2 = smooth(i2, w2)

    return, i2
    end


;-------------------------------------------------------------
;+
; NAME:
;       MAKEZ
; PURPOSE:
;       Make simulated 2-d data.  Useful for software development.
; CATEGORY:
; CALLING SEQUENCE:
;       data = makez( nx, ny, w)
; INPUTS:
;       nx, ny = size of 2-d array to make.                   in
;       w = smoothing window size (def = 5% of sqrt(nx*ny)).  in
; KEYWORD PARAMETERS:
;       Keywords:
;         /PERIODIC   forces data to match at ends.  Will not work
;           for smoothing windows much more than about 30% of n.
;         SEED=s      Set random seed for repeatable results.
;         LASTSEED=s  returns last random seed used.
; OUTPUTS:
;       data = resulting data array (def = undef).            out
; COMMON BLOCKS:
;       makez_com
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner,  29 Nov, 1986.
;       R. Sterner,  1994 Feb 22 --- Rewrote from new makey.
;
; Copyright (C) 1986, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------

    function makez, nx, ny, w, seed=seed0, lastseed=lseed, $
      periodic=per, help=hlp

        common makez_com, seed
    ;-----------------------------------------------------------------
    ;   Must store seed in common otherwise it is undefined
    ;   on entry each time and gets set by the clock but only
    ;   to a one second resolution (same random data for a whole sec).
    ;-----------------------------------------------------------------

    if keyword_set(hlp) then begin
      print,' Make simulated 2-d data.  Useful for software development.'
      print,' data = makez( nx, ny, w)'
      print,'   nx, ny = size of 2-d array to make.                   in'
      print,'   w = smoothing window size (def = 5% of sqrt(nx*ny)).  in'
      print,'   data = resulting data array (def = undef).            out'
      print,' Keywords:'
      print,'   /PERIODIC   forces data to match at ends.  Will not work'
      print,'     for smoothing windows much more than about 30% of n.'
      print,'   SEED=s      Set random seed for repeatable results.'
      print,'   LASTSEED=s  returns last random seed used.'
      return, -1
    endif

    ;-----  Return last random seed or set new  -----
    if n_elements(seed) ne 0 then lseed=seed else lseed=-1
    if n_elements(nx) eq 0 then return,0            ; That was all.
        if n_elements(seed0) ne 0 then seed = seed0

    ;-----  Default smoothing window size  ---------
    if n_elements(w) eq 0 then w = .05*sqrt(long(nx)*ny) > 5

    ;-----  Compute size of edge effect  --------
    lo = fix(w)/2 + fix(w)  ; First index after edge effects.
    ntx = nx + 2*lo     ; X size extended to include edge effects.
    nty = ny + 2*lo     ; Y size extended to include edge effects.
    hix = ntx - 1 - lo  ; Last X index before edge effects.
    hiy = nty - 1 - lo  ; Last Y index before edge effects.

    ;-----  Make data  ---------------------------
    r = randomu(seed, ntx, nty) ; Random starting data.
    seed0 = seed            ; Return new seed.
    if keyword_set(per) then begin  ; Want periodic data.
      r(ntx-2*lo,0) = r(0:2*lo-1,*) ; Copy part of random data.
      r(0,nty-2*lo) = r(*,0:2*lo-1)
    endif
    s = smooth2(r,w)        ; Smooth.
    s = s(lo:hix, lo:hiy)       ; Trim edge effects.
    s = s - min(s)          ; Normalize.
    s = s/max(s)

    lseed = seed            ; Return last seed.

    return, s
    end
;-------------------------------------------------------------
;+
; NAME:
;       MAKEY
; PURPOSE:
;       Make simulated data.  Useful for software development.
; CATEGORY:
; CALLING SEQUENCE:
;       data = makey( n, w)
; INPUTS:
;       n = number of data values to make.                in
;       w = smoothing window size (def = 5% of n).        in
; KEYWORD PARAMETERS:
;       Keywords:
;         /PERIODIC   forces data to match at ends.  Will not work
;           for smoothing windows much more than about 30% of n.
;         SEED=s      Set random seed for repeatable results.
;         LASTSEED=s  returns last random seed used.
; OUTPUTS:
;       data = resulting data array (def = undef).        out
; COMMON BLOCKS:
;       makey_com
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner,  2 Apr, 1986.
;       Johns Hopkins University Applied Physics Laboratory.
;       RES 21 Nov, 1988 --- added SEED.
;       R. Sterner, 2 Feb, 1990 --- added periodic.
;       R. Sterner, 29 Jan, 1991 --- renamed from makedata.pro.
;       R. Sterner, 24 Sep, 1992 --- Added /NORMALIZE.
;       R. Sterner, 1994 Feb 22 --- Greatly simplified.  Always normalize.
;
; Copyright (C) 1986, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------


    function makey, n, w, seed=seed0, lastseed=lseed, $
      periodic=per, help=hlp

        common makey_com, seed
    ;-----------------------------------------------------------------
    ;   Must store seed in common otherwise it is undefined
    ;   on entry each time and gets set by the clock but only
    ;   to a one second resolution (same random data for a whole sec).
    ;-----------------------------------------------------------------

    if keyword_set(hlp) then begin
      print,' Make simulated data.  Useful for software development.'
      print,' data = makey( n, w)'
      print,'   n = number of data values to make.                in'
      print,'   w = smoothing window size (def = 5% of n).        in'
      print,'   data = resulting data array (def = undef).        out'
      print,' Keywords:'
      print,'   /PERIODIC   forces data to match at ends.  Will not work'
      print,'     for smoothing windows much more than about 30% of n.'
      print,'   SEED=s      Set random seed for repeatable results.'
      print,'   LASTSEED=s  returns last random seed used.'
      return, -1
    endif

    ;-----  Return last random seed or set new  -----
    if n_elements(seed) ne 0 then lseed=seed else lseed=-1
    if n_elements(n) eq 0 then return,0 ; That was all.
        if n_elements(seed0) ne 0 then seed = seed0

    ;-----  Default smoothing window size  ---------
    if n_elements(w) eq 0 then w = .05*n > 5

    ;-----  Compute size of edge effect  --------
    lo = long(w)/2L + long(w)   ; First index after edge effects.
    nt = n + 2*lo           ; Size extended to include edge effects.
    hi = nt - 1 - lo        ; Last index before edge effects.

    ;-----  Make data  ---------------------------
    r = randomu(seed, nt)       ; Random starting data.
    seed0 = seed            ; Return new seed.
    if keyword_set(per) then begin  ; Want periodic data.
      r(nt-2*lo) = r(0:2*lo-1)  ; Copy part of random data.
    endif
    s = smooth2(r,w)        ; Smooth.
    s = s(lo:hi)            ; Trim edge effects.
    s = s - min(s)          ; Normalize.
    s = s/max(s)

    lseed = seed            ; Return last seed.

    return, s
    end

FUNCTION COYOTE

   ; The purpose of this function is to find the
   ; "coyote" directory and return its path. If no
   ; directory is found, the function returns a null string.

ON_ERROR, 1

   ; Check this directory first.

CD, Current=thisDir
IF STRPOS(STRUPCASE(thisDir), 'COYOTE') GT 0 THEN RETURN, thisDir

   ; Look in !Path directories.

pathDir = EXPAND_PATH(!Path, /Array)
s = SIZE(pathDir)
IF s(1) LT 1 THEN RETURN, ''
FOR j=0,s(1)-1 DO BEGIN
   check = STRPOS(STRUPCASE(pathDir(j)), 'COYOTE')
   IF check GT 0 THEN RETURN, pathDir(j)
ENDFOR
RETURN, ''
END



PRO LOADDATA_CANCEL, event
WIDGET_CONTROL, event.top, /Destroy
END


PRO LOADDATA_EVENT, event
WIDGET_CONTROL, event.top, GET_UVALUE=ptr

CATCH, error
IF error NE 0 THEN BEGIN
   ok = WIDGET_MESSAGE(!ERR_STRING)
   RETURN
ENDIF

coyoteDir = COYOTE()
IF coyoteDir EQ '' THEN CD, CURRENT=coyoteDir

CATCH, error
IF error NE 0 THEN BEGIN
   Message, 'Trouble reading "' + file + '"', /Informational
   Message, 'Please check the data directory location.', /Informational
   Widget_Control, event.top, /Destroy
   RETURN
ENDIF


CASE event.index OF
   0: BEGIN
      data = MAKEY(101, 5, Seed=1L) * 30.0
      END
   1: BEGIN
      data = MAKEZ(41, 41, 8, Seed=-2L)  * 1550
      END
   2: BEGIN
      data = MAKEZ(41, 41, 10, Seed=-5L)
      data = BYTSCL(data, Top=!D.N_Colors-1)
      END
   3: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'galaxy.dat')
      data = BYTARR(256, 256)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   4: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'ctscan.dat')
      data = BYTARR(256, 256)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   5: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'abnorm.dat')
      data = BYTARR(64, 64, 15)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   6: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'worldelv.dat')
      data = BYTARR(360,360)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   7: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'head.dat')
      data = BYTARR(80, 100, 57)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   8: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'cereb.dat')
      data = BYTARR(512, 512)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   9: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'people.dat')
      data = BYTARR(192, 192, 2)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
  10: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'convec.dat')
      data = BYTARR(248, 248)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
  11: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'm51.dat')
      data = BYTARR(340, 440)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
  12: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'hurric.dat')
      data = BYTARR(440, 340)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END

  13: BEGIN

        ; Create randomly-distributed (xyz) data.

      seed = -1L
      x = RANDOMU(seed, 41)
      y = RANDOMU(seed, 41)
      distribution = SHIFT(DIST(41,41), 25, 15)
      distribution = EXP(-(distribution/15)^2)

      lat = x * (24./1.0) + 24
      lon = y * 50.0/1.0 - 122
      temp = distribution(x*41, y*41) * 273
      data = FLTARR(3, 41)
      data(0,*) = lon
      data(1,*) = lat
      data(2,*) = temp
      END

 14: BEGIN

        ; Create randomly-distributed (xyz) data.

      seed = -1L
      x = RANDOMU(seed, 41)
      y = RANDOMU(seed, 41)
      distribution = SHIFT(DIST(41,41), 25, 15)
      distribution = EXP(-(distribution/15)^2)

      lat = x * (24./1.0) + 24
      lon = y * 50.0/1.0 - 122
      temp = distribution(x*41, y*41) * 273
      data = {lat:lat, lon:lon, temp:temp}
      END

 15: BEGIN
     file = FILEPATH(ROOT_DIR=coyoteDir, 'image24.dat')
     data = BYTARR(3, 360, 360)
     OPENR, lun, file, /GET_LUN
     READU, lun, data
     FREE_LUN, lun
     END

ENDCASE

WIDGET_CONTROL, event.top, /DESTROY
HANDLE_VALUE, ptr, data, /SET
END

FUNCTION LOADDATA, CANCEL=cancel, number

   ; Function to read and return training data sets.

coyoteDir = COYOTE()
IF coyoteDir EQ '' THEN CD, CURRENT=coyoteDir

CATCH, error
IF error NE 0 THEN BEGIN
   Message, 'Trouble reading "' + file + '"', /Informational
   RETURN, -1
ENDIF

   ; If a parameter is passed in, read that data set and return.

IF N_PARAMS() EQ 1 THEN BEGIN
   minnumber = 1
   maxnumber = 15
   number = minnumber > number < maxnumber
   number = number-1
   CASE number OF
   0: BEGIN
      data = MAKEY(101, 5, Seed=1L) * 30.0
      END
   1: BEGIN
      data = MAKEZ(41, 41, 8, Seed=-2L)  * 1550
      END
   2: BEGIN
      data = MAKEZ(41, 41, 10, Seed=-5L)
      data = BYTSCL(data, Top=!D.N_Colors-1)
      END
   3: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'galaxy.dat')
      data = BYTARR(256, 256)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   4: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'ctscan.dat')
      data = BYTARR(256, 256)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   5: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'abnorm.dat')
      data = BYTARR(64, 64, 15)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   6: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'worldelv.dat')
      data = BYTARR(360,360)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   7: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'head.dat')
      data = BYTARR(80, 100, 57)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   8: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'cereb.dat')
      data = BYTARR(512, 512)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
   9: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'people.dat')
      data = BYTARR(192, 192, 2)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
  10: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'convec.dat')
      data = BYTARR(248, 248)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
  11: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'm51.dat')
      data = BYTARR(340, 440)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END
  12: BEGIN
      file = FILEPATH(ROOT_DIR=coyoteDir, 'hurric.dat')
      data = BYTARR(440, 340)
      OPENR, lun, file, /GET_LUN
      READU, lun, data
      FREE_LUN, lun
      END

 13: BEGIN

        ; Create randomly-distributed (xyz) data.

      seed = -1L
      x = RANDOMU(seed, 41)
      y = RANDOMU(seed, 41)
      distribution = SHIFT(DIST(41,41), 25, 15)
      distribution = EXP(-(distribution/15)^2)

      lat = x * (24./1.0) + 24
      lon = y * 50.0/1.0 - 122
      temp = distribution(x*41, y*41) * 273
      data = FLTARR(3, 41)
      data(0,*) = lon
      data(1,*) = lat
      data(2,*) = temp
      END

 14: BEGIN

        ; Create randomly-distributed (xyz) data.

      seed = -1L
      x = RANDOMU(seed, 41)
      y = RANDOMU(seed, 41)
      distribution = SHIFT(DIST(41,41), 25, 15)
      distribution = EXP(-(distribution/15)^2)

      lat = x * (24./1.0) + 24
      lon = y * 50.0/1.0 - 122
      temp = distribution(x*41, y*41) * 273
      data = {lat:lat, lon:lon, temp:temp}
      END

 15: BEGIN
     file = FILEPATH(ROOT_DIR=coyoteDir, 'image24.dat')
     data = BYTARR(3, 360, 360)
     OPENR, lun, file, /GET_LUN
     READU, lun, data
     FREE_LUN, lun
     END

ENDCASE

   RETURN, data
ENDIF

   ; Put up widget if there is no parameter.

tlb = WIDGET_BASE(TITLE='Select Data Set...', COLUMN=1)

   ; The data sets.

value = ['1. Time Series Data (FLOAT 101 vector)', $
         '2. Elevation Data (FLOAT 41-by-41 array)', $
         '3. Snow Pack Data (FLOAT 41-by-41 array)', $
         '4. Galaxy (BYTE 256-by-256 array)', $
         '5. CT Scan Thoracic Cavity (BYTE 256-by-256 array)', $
         '6. Heart Gated Blood Pool Study (BYTE 64-by-64-by-15 array)', $
         '7. World Elevation Data (BYTE 360-by-360 array)', $
         '8. MRI Head Data (BYTE 80-by-100-by-57 array)', $
         '9. Brain X-Ray (BYTE 512-by-512 array)', $
         '10. Ali and Dave (192-by-192-by-2 array)', $
         '11. Earth Mantle Convection (BYTE 248-by-248 array)', $
         '12. M51 Whirlpool Galaxy (BYTE 340-by-440 array)', $
         '13. Hurricane Gilbert (BYTE 440-by-340 array)', $
         '14. Randomly Distributed (XYZ) Data (FLOAT 3-by-41 array)', $
         '15. Lat/Lon/Temperature Data Set (Structure)', $
         '16. Pixel Interleaved 24-Bit Image (BYTE 3-by-360-by-360 array)']

list = WIDGET_LIST(tlb, VALUE=value, SCR_XSIZE=500, YSIZE=16)
button = WIDGET_BUTTON(tlb, VALUE='Cancel', EVENT_PRO='LOADDATA_CANCEL')
WIDGET_CONTROL, tlb, /REALIZE

   ; Create a pointer to store the data.

ptr = HANDLE_CREATE()
WIDGET_CONTROL, tlb, SET_UVALUE=ptr

thisRelease = STRMID(!Version.Release, 0, 1)
IF thisRelease EQ '5' THEN $
   XMANAGER, 'loaddata', tlb ELSE $
   XMANAGER, 'loaddata', tlb, /MODAL

   ; Get the data if it is there. If it is not there,
   ; user canceled or error occured.

HANDLE_VALUE, ptr, data
IF N_ELEMENTS(data) EQ 0 THEN BEGIN
   cancel = 1
   HANDLE_FREE, ptr
   RETURN, -1
ENDIF ELSE BEGIN
   HANDLE_VALUE, ptr, data, /NO_COPY
   HANDLE_FREE, ptr
   RETURN, data
ENDELSE
END