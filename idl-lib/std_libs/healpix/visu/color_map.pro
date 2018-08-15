function color_map, data, mindata, maxdata, Obs, color_bar = color_bar, mode = mode, minset = min_set, maxset = max_set
;+
; color_map
;
; color = color_map( data, mindata, maxdata, Obs=obs, color_bar =
; color_bar, mode = mode)
;
;
; INPUT
;    data : input data
;    mindata : min (can be changed by the routine)
;    maxdata : maxdata (can be changed by the routine)
;-

if undefined (mode) then mode = 0
N_Color = !D.n_colors < 256

sz = size(data)
npix = n_elements(data)
Color = MAKE_ARRAY(/BYTE, npix, Value = 2B)
color_bar = [2B]
if (sz(0) eq 2) then Color = reform(color,/over,sz(1),sz(2))
if undefined (Obs) then Obs = lindgen(npix)
if (Obs(0)) eq -1 then return, color
N_obs = n_elements(Obs)
N_no_Obs = npix - N_obs

; -------------------------------------------------------------
; sets MIN and MAX
; -------------------------------------------------------------
print,'plotted area original MIN and MAX: ',mindata, maxdata
IF DEFINED(min_set) THEN BEGIN
    if (min_set gt mindata) then begin
        IF (N_No_Obs eq 0) THEN data = data > min_set ELSE data(Obs)=data(Obs) > min_set
    endif
    mindata = min_set
    print,'new MIN : ',mindata
ENDIF

IF DEFINED(max_set) THEN BEGIN
    if (max_set lt maxdata) then begin
        IF (N_No_Obs eq 0) THEN data = data < max_set ELSE data(Obs)=data(Obs) < max_set
    endif
    maxdata = max_set
    print,'new MAX : ',maxdata
ENDIF

IF (mode ge 2) THEN BEGIN
    data(Obs) = ALOG10(data(Obs) + (0.0001 -mindata))
    mindata = MIN(data,MAX=maxdata)
ENDIF


col_scl = FINDGEN(N_Color-3)/(N_Color-4)

if ((mode MOD 2) eq 1) then begin
;   histogram equalised scaling
    Tmax = maxdata & Tmin = mindata
    Bs = (Tmax-Tmin)/5000. ;MIN( [(Tmax-Tmin)/5000.,2.] )
    Phist = HISTOGRAM( data(Obs), Min=Tmin, Max=Tmax, Bin = Bs )
    FOR I = 1L,N_ELEMENTS(Phist)-1 DO Phist(i) = Phist(i) + Phist(i-1)
    Phist(0) = 0.
    Junk = INTERPOLATE( FLOAT(Phist), (data(Obs)-Tmin)/Bs )
    Color(Obs) = 3B + BYTSCL( Junk, Top=N_Color-4 )

    junk2= INTERPOLATE( FLOAT(Phist), col_scl*(Tmax-Tmin)/bs )
    color_bar = (3B + BYTSCL( junk2, TOP = N_Color-4 ))

endif else begin
;   linear scaling
    if (ABS((maxdata+mindata)/FLOAT(maxdata-mindata)) lt 5.e-2) then begin
;       if Min and Max are symmetric
;       put data=0 at the center of the color scale
        Tmax = MAX(ABS([mindata,maxdata]))
        Tmin = -Tmax
    endif else begin 
        Tmax = maxdata & Tmin=mindata
    endelse
    if (N_No_Obs eq 0) then begin 
	Obs = 0  ; save space
    	color = 3B + BYTSCL(data, MIN=Tmin, MAX=Tmax, Top=N_Color-4 )
    endif else begin
    	color(Obs) = 3B + BYTSCL(data(Obs), MIN=Tmin, MAX=Tmax, Top=N_Color-4 )
    endelse
    color_bar = (3B + BYTSCL( col_scl, TOP = N_Color-4 ))
endelse

mindata = Tmin
maxdata = Tmax

return, color
end

