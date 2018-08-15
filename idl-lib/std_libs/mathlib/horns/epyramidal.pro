; programs to calculate pyramidal horn beam patterns

function Epyramidal, phorn, lambda, r, theta_, phi_, $
	eplane=eplane, hplane=hplane, double=double

; INPUTS
; phorn: a struct containing geometrical data for a pyramidal horn
;	Re : dist angle side to aperature in e-plane [in]
;   Rh : dist angle side to aperature in h-plane [in]
;	a : short length of aperature [in]
;	b : long length of aperature [in]
;
; lambda = wavelength [cm]
; r = distance to horn [cm]
; theta_ = angle(s) from central axis (-180 to 180)
; phi = angle of plane.  Eplane: phi= 90 deg ; Hplane: phi=0

; KEYWORDS
;  eplane : force phi = 90.
;  hplane : force phi = 0.
;  double : use double precision arithmetic

; RETURN VALUES:  E_theta : Main E-field, E_phi : Cross E-field
; both fields are relative to aperature field E0.


; PREDEFINED VALUES
d2r = !pi/180.
; K_a band waveguide parameters
a = 0.28 * 2.54  ; long side of wvgd
b = 0.14 * 2.54  ; short side

if keyword_set(eplane) then phi_ = 90.
if keyword_set(hplane) then phi_ = 0.
if n_elements(phi_) eq 0 then phi_ = 90. ; default is eplane

phi = phi_ * d2r

theta = theta_ * d2r
j = complex(0,-1)
k = 2 * !pi / lambda

if keyword_set(double) then begin
	theta = double(theta)
	phi = double(phi)
	j = dcomplex(j)
	k = double(k)
endif

; geometrical stuff
; givens
a1 = phorn.a * 2.54 ; convert [in] to [cm]
b1 = phorn.b * 2.54
Re = phorn.Re * 2.54
Rh = phorn.Rh * 2.54
; calculate more geometry stuff
pE = sqrt(Re^2 - 0.25*(b1-b)^2)
pH = sqrt(Rh^2 - 0.25*(a1-a)^2)
rho1 = 1./(1-b/b1) * pE
rho2 = 1./(1-a/a1) * pH

; calculate all the little crappy things:
; t1p,t2p,kxp,t1pp,t2pp,kxpp, t1, t2, and ky.

ky = k * sin(theta) * sin(phi)
t1 = (!pi * k * rho1)^(-0.5) * (-0.5*k*b1 - ky*rho1)
t2 = (!pi * k * rho1)^(-0.5) * (0.5*k*b1 - ky*rho1)

kxp = k*sin(theta)*cos(phi) + !pi/a1
t1p = sqrt(1./(!pi*k*rho2))*(-1*k*a1/2 - kxp*rho2)
t2p = sqrt(1./(!pi*k*rho2))*(k*a1/2 - kxp*rho2)

kxpp = k * sin(theta) * cos(phi) - !pi/a1
t1pp = sqrt(1./(!pi*k*rho2))*(-1*k*a1/2 - kxpp*rho2)
t2pp = sqrt(1./(!pi*k*rho2))*(k*a1/2 - kxpp*rho2)

; Now evaluate those huge I functions

I1 = 0.5 * sqrt(!pi*rho2/k)* ( expi(kxp^2*rho2/(2*k))* $
	((Ci(t2p)-Ci(t1p)) - j*(Si(t2p)-Si(t1p))) + expi(kxpp^2*rho2/(2*k)) * $
	((Ci(t2pp)-Ci(t1pp)) - j*(Si(t2p)-Si(t1p))))

I2 = sqrt(!pi*rho1/k)*expi(ky^2*rho1/(2*k)) * $
		((Ci(t2)-Ci(t1))-j*(Si(t2)-Si(t1)))

I1I2 = I1 * I2

; Now evaluate fields

Etheta = j * k * expi(-1*k*r)/(4*!pi*r) * sin(phi)*(1+cos(theta))*I1I2
Ephi = j * k * expi(-1*k*r)/(4*!pi*r) * cos(phi)*(1+cos(theta))*I1I2

return, {Etheta:Etheta, Ephi:Ephi}

END