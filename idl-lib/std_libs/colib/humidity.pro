
; Humidity-related programs!!!

; relevant quantities & formulae

; w    : water vapor mixing ratio : mass of water vapor per mass of dry air    : kg/kg
; q    : specific humidity        : mass of water vapor per mass of moist air  : kg/kg
; e    : water vapor pressure     : pressure of water vapor                    : Pascals
; P    : total pressure     : Pa
; Pd   : dry air pressure   : Pa
; rhov : density of water vapor : kg/m^3
; rhod : density of dry air     : kg/m^3
; Tv   : virtual temperature    : temperature that makes the ideal gas law work for total density, using Rd
; Rd   : ideal gas constant of dry air : 287.06 [W/(K kg)]
; Rv   : ideal gas constant of water vapor : Rd/epsilon [W/(K kg)] ~ 461.5
; epsilon : Rd/Rv = ratio of these ideal gas constants

; Fundamental Equations:
;
; 1) ideal gas laws
; Pd  = P-e = rhod * Rd * T
; e   = rhov * Rv * T
; P   = (rhov+rhod) * Rd * Tv
;
; 2) def of mixing ratios
; w = rhov / rhod
; q = rhov / (rhod+rhov)

; 3) hydrostatic formula (for determining elevation changes due to pressure changes)
; dP = g * (rhov+rhod) * dz  (where g is local accel due to gravity)
; this can be turned into the following (for nonzero q):
; rhov * dz = q * dP / g


function w2q, w
; given w, return q
q = w/(1.+w)
return, q
end

function q2w, q
; given q, return w
w = q/(1.-q)
return, w
end

function press2w, p, e
; given the total pressure & partial pressure of water vapor, return, w
epsilon = 0.622
w = epsilon * e/(p-e)
return, w
end

function q2e, q, p
; given q, p
; return, e
epsilon =0.622
e = q * P/(epsilon + q*(1-epsilon))
return, e
end

function w2e, w, p
; given w, p
; return e
epsilon =0.622
e = w*p/(epsilon+w)
return, e
end

function e2rhov, e, t
; given e, t, return rhov
; eqn: e = rhov * Rv * T = rhov*Rd*T/epsilon
Rd = 287.06
epsilon =0.622
rhov = e / (Rd * T) /epsilon
return, rhov
end

function q2rhov, q, p, t
; given q, p, t, return, rhov
e = q2e(q, p)
rhov = e2rhov(e,t)
return, rhov
end

function q2rhod, q, p, t
; given q, p, t return rhod
e = q2e(q,p)
rhod = (p-e)/(Rd*T)
return, rhod
end

function q2Tv, q, t
; given, q, t, return, tv
epsilon = 0.622
tv = T * (1. + q * (1.-epsilon)/epsilon)
return, tv
end

function dP2dz, dP, P, t, q, g=g
; given dP : positive pressure difference between layer boundaries
; and  P, t, q : mean-layer quantities
; return change in altitude [meters]
Rd = 287.06
if n_elements(g) eq 0 then g = 9.81
dz = dP/P * q2Tv(q,t) * Rd/g  ; meters
return, dz
end

function esat, t, ice=ice
; given t: the temperature in K
; return the saturation vapor pressure in Pa

; uses the Goff-Gaff eqn from Goff(1957)

if ~keyword_set(ice) then begin
Log10pw =  10.79574 * (1-273.16/T) $
                    - 5.02800 * aLog10(T/273.16) $
                    + 1.50475e-4 * (1 - 10.^(-8.2969*(T/273.16-1))) $
                    + 0.42873e-3 * (10.^(+4.76955*(1-273.16/T)) - 1) $
                    + 0.78614
e_sat = 100. * (10.^log10pw)
endif else begin
  Log10pi =  -9.09718 * (273.16/T - 1)         $
                   - 3.56654 * aLog10(273.16/ T) $
                   + 0.876793 * (1 - T/ 273.16)
  e_sat = 100. * (10.^log10pi)
endelse
return, e_sat
end

function q2rh, q, p, t
; give q, t, return, rh as a fraction

return, q2e(q,p) / esat(t)

end

function q2td, q, p, t
; given q, p, t, return the dewpoint in K
  rh = q2rh(q,p,t)
  a = 17.27
  b = 237.3
  Tc = T - 273.16
  g = a*Tc/(b+Tc) + alog(rh)
  td = b*g / (a-g)
  return, td + 273.16
end