;+
; NAME:
;       geopotential
;
; PURPOSE:
;       This function calculates the geopotential or geopotential
;       heights using the hypsometric equation.
;
; CATEGORY:
;       Meteorology, atmospheric physics
;
; CALLING SEQUENCE:
;       geopot = geopotential( pressure, $
;                                    temperature, $
;                                    mixing_ratio, $
;                                    surface_altitude
;                                    height=height)
;
; EXAMPLE:
;       Given arrays of pressure, temperature, and mixing ratio:
;
;         IDL> PRINT, p, t, mr
;               1015.42      958.240
;               297.180      291.060
;               7.83         5.71
;
;       the geopotential can be found by typing:
;
;         IDL> print,geopotential( p, t, mr, 0.0 )
; INPUTS:
;       pressure:        1D or 3D Array of pressure in mb
;       temperature:     1D or 3D Array of temperature in K
;       mixing_ratio:    1D or 3D Array of water vapor mixing ratio in
;                        g/kg. Note that mixing_ratio=Q/(1-Q), where Q
;                        is the specific humidity in g/kg.
;       surface_height:  0D or 2D Array of height of surface in m. 
;
; KEYWORD PARAMETERS:
;       height:     Set /height to return geopotential heights (m)
;                   instead of the geopotential (m**2/s**2).
;
; OUTPUTS:
;       The function returns the 1D geopotential array for a single column
;       or a 3D array for a 3D field in the same order as the input
;       data.
;       Relation between geopotential (GP in units of m**2/s**2) and 
;       geopotential height (Z in units of m):
;       
;       Z = g * GP, with g = 9.80616 m/s**2
;
; CALLS:
;       None.
;
; COMMON BLOCKS:
;       None
;
; SIDE EFFECTS:
;       None
;
; RESTRICTIONS:
;       - Input pressure, temperature and mixing_ratio MUST be arrays with at
;         LEAST two elements where the element with the highest pressure corresponds
;         to the surface altitude passed.
;       - Input surface height must be > or = to 0.0km and a SCALAR.
;       - No allowance is made for the change in the acceleration due to 
;         gravity with altitude.
;
; PROCEDURE:
;       Geopotential height is calculated using the hypsometric equation:
;
;                         -
;                    Rd * Tv    [  p1  ]
;         z2 - z1 = --------- ln[ ---- ]
;                       g       [  p2  ]
;
;       where Rd    = gas constant for dry air (286.9968933 J/K/kg),
;             g     = acceleration due to gravity (9.80616m/s^2),
;             Tv    = mean virtual temperature for an atmospheric layer,
;             p1,p2 = layer boundary pressures, and
;             z1,z2 = layer boundary heights.
;
;       The virtual temperature, the temperature that dry air must have in
;       order to have the same density as moist air at the same pressure, is
;       calculated using:
;
;                  [      1 - eps      ]
;         Tv = T * [ 1 + --------- * w ]
;                  [        eps        ]
;
;       where T   = temperature,
;             w   = water vapor mixing ratio, and
;             eps = ratio of the molecular weights of water and dry air (0.621970585).
;
;
; MODIFICATION HISTORY:
;       Dominik Brunner, LAPETH ETH Zurich, 02 Aug, 2000
;                        Adapted from geopotential_height by Paul van
;                        Delst and rewritten to support 3D input
;
;-

FUNCTION geopotential,pressure, $          ; Input
                      temperature, $       ; Input
                      mixing_ratio, $      ; Input
                      surface_altitude,$   ; Input
                      height=height        ; Keyword Input
   print,'aha'
;------------------------------------------------------------------------------
;                    -- Determine floating-point precision --
;------------------------------------------------------------------------------
   tolerance = ( MACHAR() ).EPS

;------------------------------------------------------------------------------
;                             -- Check input --
;------------------------------------------------------------------------------
  n_arguments = 4
  IF ( N_PARAMS() NE n_arguments ) THEN BEGIN
     MESSAGE, 'Invalid number of arguments', /INFO
     RETURN, -1
  ENDIF

; ---------------------------------------------------
; Check that required arguments are defined correctly
; ---------------------------------------------------
  IF ( N_ELEMENTS( pressure ) EQ 0 ) THEN BEGIN
    MESSAGE, 'Input PRESSURE argument not defined!', /INFO
    RETURN, -1
  ENDIF
  
  s=size(reform(pressure))
  ; 1D or 3D input?
  ndim=s[0]
  nrealdim=size(pressure,/n_dim) ; number of dimensions including degenerated dimensions
  n=s[ndim+2]
  CASE ndim OF
     1: BEGIN 
        n_levels=s[1] & n_lats=1 & n_lons=1
     END
     3: BEGIN 
        n_lons=s[1] & n_lats=s[2] & n_levels=s[3]
     END
     ELSE: BEGIN
        MESSAGE, 'Input PRESSURE must be 1D (levels) or 3D (lons,lats,levels)!', /INFO
        RETURN, -1
     END
  ENDCASE
    
  IF ( n_levels LE 1 ) THEN BEGIN
     MESSAGE, 'Must specify AT LEAST two levels; surface and one other level.', /INFO
     RETURN, -1
  ENDIF
  
  IF n_elements(temperature) NE n THEN BEGIN
     MESSAGE, 'Input TEMPERATURE must have same number of elements as PRESSURE!', /INFO
     RETURN, -1
  ENDIF
  
  IF n_elements(mixing_ratio) NE n THEN BEGIN
     MESSAGE, 'Input MIXING RATIO must have same number of elements as PRESSURE!', /INFO
     RETURN, -1
  ENDIF
  
  IF n_elements(surface_altitude) NE (n_lons*n_lats) THEN BEGIN
     MESSAGE, 'Input SURFACE ALTITUDE must have same number of elements as PRESSURE!', /INFO
     RETURN, -1
  ENDIF
  
; ----------------
; Check dimensions
; ----------------
  
  IF (size(temperature,/n_dim) NE nrealdim) OR $
     (size(mixing_ratio,/n_dim) NE nrealdim) THEN BEGIN
     MESSAGE, 'TEMPERATURE and MIXING RATIO must have same dimensions as PRESSURE', /INFO
     RETURN, -1
  ENDIF
  
  IF size(surface_altitude,/n_dim) NE (nrealdim-1) THEN BEGIN
     MESSAGE, 'SURFACE ALTITUDE must have one dimension less than PRESSURE', /INFO
     RETURN, -1
  ENDIF

; ----------------------------------
; Check for pressures < or = zero
; ----------------------------------
  index = WHERE( pressure LT tolerance, count )
  
  IF ( count GT 0 ) THEN BEGIN
     MESSAGE, 'Input pressures < or = 0.0 found. Input units must be in hPa.', /INFO
     RETURN, -1
  ENDIF
  
; ----------------------------------
; Check for temperatures < or = zero
; ----------------------------------
  index = WHERE( temperature LT tolerance, count )
  
  IF ( count GT 0 ) THEN BEGIN
     MESSAGE, 'Input temperatures < or = 0.0 found. Input units must be in Kelvin.', /INFO
     RETURN, -1
  ENDIF

; ------------------------------
; Check for mixing ratios < zero
; ------------------------------

  index = WHERE( mixing_ratio LT 0.0, count )

  IF ( count GT 0 ) THEN BEGIN
    MESSAGE, 'Input mixing ratios < 0.0 found. Input units must be in g/kg.', /INFO
    RETURN, -1
  ENDIF

; --------------------------------
; Check for surface altitude < 0.0
; --------------------------------
  index = WHERE(surface_altitude LT 0.0,count)
  IF count GT 0 THEN BEGIN
     surface_altitude[index]=0.
     MESSAGE,'Surface altitudes < 0.0 put to zero!!', /INFO
  ENDIF
  
;---------------------------------
; Reform arrays if necessary
;--------------------------------
  IF nrealdim GT ndim THEN BEGIN
     pressure=reform(pressure,/over)
     temperature=reform(temperature,/over)
     mixing_ratio=reform(mixing_ratio,/over)
     surface_altitude=reform(surface_altitude,/over)
  ENDIF
  
;------------------------------------------------------------------------------
;                      -- Declare some constants --
;
;  Parameter         Description                 Units
;  ---------   ---------------------------     -----------
;     Rd       Gas constant for dry air        J/degree/kg
;
;     g        Acceleration due to gravity       m/s^2
;
;    eps       Ratio of the molec. weights        None
;              of water and dry air
;              
;------------------------------------------------------------------------------
  Rd  = 286.9968933
  g   = 9.80616
  eps = 0.621970585
  ratio  = ( 1.0 - eps ) / eps / 1000. ; DB: factor 1000. to account for units g/kg
  
;------------------------------------------------------------------------------
;            -- Check if levels start at top or bottom of atmosphere  --
;------------------------------------------------------------------------------

  IF ndim EQ 3 THEN BEGIN
     IF pressure[0,0,0]-pressure[0,0,1] GT 0 THEN ascending=1 ELSE ascending=-1
     gph=FltArr(n_lons,n_lats,n_levels) ; 3D output array
     gph[*,*,(n_levels-1)*(ascending EQ -1)]=surface_altitude
  ENDIF ELSE BEGIN
     IF pressure[0]-pressure[1] GT 0 THEN ascending=1 ELSE ascending=-1
     gph=FltArr(n_levels) ; 1D output array
     gph[(n_levels-1)*(ascending EQ -1)]=surface_altitude
  ENDELSE

  
;------------------------------------------------------------------------------
;             -- Loop over levels and calculate geopot --
;------------------------------------------------------------------------------
  IF ndim EQ 1 THEN BEGIN ; geopotentials for a column
     FOR i=(ascending EQ 1)+(n_levels-2)*(ascending EQ -1),$
        (ascending EQ 1)*(n_levels-1),ascending DO BEGIN
        ; Calculate average layer temperatures
        t_average = 0.5 * ( temperature[i] + temperature[i-ascending] )
        ; Calculate average mixing ratio (in g/kg)
        mr_average = 0.5 * ( mixing_ratio[i] + mixing_ratio[i-ascending] )
	; Calculate virtual temperature
        t_virtual = t_average * ( 1.0 + ratio * mr_average  )
        ; Calculate the geopotential
        IF FINITE(pressure[i]) THEN gph[i]=gph[i-ascending] + ( Rd / g ) * t_virtual * $
           ALOG( pressure[i-ascending] / pressure[i] ) $
        ELSE gph[i]=gph[i-ascending]
     ENDFOR
  ENDIF ELSE BEGIN ; geopotentials for a 3D field
     FOR i=(ascending EQ 1)+(n_levels-2)*(ascending EQ -1),$
        (ascending EQ 1)*(n_levels-1),ascending DO BEGIN
        ; Calculate average layer temperatures
        t_average = 0.5 * ( temperature[*,*,i] + temperature[*,*,i-ascending] )
        ; Calculate average mixing ratio (in g/kg)
        mr_average = 0.5 * ( mixing_ratio[*,*,i] + mixing_ratio[*,*,i-ascending] )
        ; Calculate virtual temperature
        t_virtual = t_average * ( 1.0 + ratio * mr_average  )
        ; Calculate the geopotential
        gph[*,*,i]=gph[*,*,i-ascending] + ( Rd / g ) * t_virtual * $
           ALOG( pressure[*,*,i-ascending] / pressure[*,*,i] )
     ENDFOR
  ENDELSE
  
  IF keyword_set(height) THEN RETURN,gph ELSE RETURN,gph/g

END


