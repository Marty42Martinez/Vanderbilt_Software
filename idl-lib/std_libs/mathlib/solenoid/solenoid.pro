Function Solenoid, r, z, a1, a2, L, J, _extra = _extra

; Calculates the magnetic field due to a finite solenoid

; INPUTS
; r : evaluation point (radius) [cm] -- Can be array
; z : evaluation point (z-distance) -- Can be array

;   Inner radius:  a1 [cm]  -- must be scalar
;   Outer radius:  a2 [cm]  -- must be scalar
;   Length      :  L [cm]   -- must be scalar
;   Current Density: J [A/cm^2]  -- must be scalar

; OUTPUTS
;    B: array [2,1] with radial and axial components (r and z, respectively)
; 			[Gauss]
;	    may be array of structs if more than one evaluation point requested
;       will be of form [2,Nr,Nz]

; KEYWORDS
;   some stuff about integral convergence

Nr = n_elements(r)
Nz = n_elements(z)
mu = 4*!dpi * 1E-1
B = dblarr(2,Nr,Nz)

COMMON Solenoid_Share, a1_, J_, mu_ ;share definition
a1_ = a1
J_ = J
mu_ = mu

for i = 0,Nr-1 do begin
	print, i
	for j = 0,Nz-1 do begin
		B[0,i,j] = Fr(r[i],z[j]+L/2,a2,_extra=_extra) - Fr(r[i],z[j]-L/2,a2,_extra=_extra) $
			- Fr(r[i],z[j]+L/2,a1,_extra=_extra) + Fr(r[i],z[j]-L/2,a1,_extra=_extra)
		B[1,i,j] = Fz(r[i],z[j]+L/2,a2,_extra=_extra) - Fz(r[i],z[j]-L/2,a2,_extra=_extra) $
			- Fz(r[i],z[j]+L/2,a1,_extra=_extra) + Fz(r[i],z[j]-L/2,a1,_extra=_extra)
	endfor
endfor

return, B
End

function Fz, r, d, a, _extra = _extra
Common Solenoid_share_z, r_, d_, a_ ; share definition
r_ = r
d_ = d
a_ = a
x = findgen(101)/100. * !dpi
COMMON Solenoid_Share, a1, J, mu               ; share reference
Fz_value = mu*J/(2*!dpi)*d_*Int_tabulated(x,Fz_int(x),_extra=_extra)
return, Fz_value
end


function Fr, r, d, a, _extra = _extra
Common Solenoid_share_r, r_, d_, a_  ; share definition
x = findgen(101)/100. * !dpi
r_ = r
d_ = d
a_ = a
;Fr_value =  Qromb('Fr_int',0,!dpi, _extra=_extra)
Fr_value = Int_tabulated(x,Fr_int(x),_extra=_extra)
return, Fr_value
end

function Fz_int, x

COMMON Solenoid_Share_z     ; share reference
COMMON Solenoid_Share, a1, J, mu 		; share reference

athing = a_^2 + r_^2 -2*a_*r_*cos(x)
sthing = sqrt(d_^2 + athing)

return, alog(a_/a1-r_/a1*cos(x) + 1/a1*sthing) - $
		a_* r_^2*sin(x)^2/(athing * sthing) - $
		r_*sin(x)/abs(d_)*atan((a_-r_*cos(x))*abs(d_)/(r_*sin(x)*sthing))

end

function Fr_int, x

COMMON Solenoid_Share_r  ;share reference
COMMON Solenoid_Share, a1, J, mu    ;share reference

athing = a_^2 + r_^2 -2*a_*r_*cos(x)
sthing = sqrt(d_^2 + athing)

return, cos(x)*sthing+r_*cos(x)^2*alog(a_/a1-r_/a1*cos(x) + 1/a1*sthing)

end
