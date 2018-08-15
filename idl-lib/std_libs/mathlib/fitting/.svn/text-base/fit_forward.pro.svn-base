function fit_forward, p, Sp, functname, x, covar=Sy, _extra=_extra, $
	autoderivative = autoderivative, diag_only = diag_only

; p is (n) or (n,npix)
; Sp is (n,n) or (n,n,npix) - corresponding to p
; x : [OPTIONAL]. independent variable passed to forward function (like frequencies)
; return, y : (m) or (m,npix)

; MODEL :
; f(x) = funct_name(p, x, deriv=deriv, _extra=_extra), same space as y.
; OR
; f(x) = funct_name(p, deriv=deriv, _extra=_extra)
; where
;	p = vector of parameters, (n) or (n,npix)
;   x = optional vector of indepedent data (like channel number), (m) or (m,mpix)
;   deriv = output jacobian, (n,m,npix). Function MUST accept this keyword, though it need not
;		do anything with it.  If nothing happens to this keyword, numberical derivatives will be calculated
;   return value: (m, npix)
;   of course, the model must be able to accept 1 or 2-dimensional data
;  (if you use this option)

	sizep = size(p)
	n = sizep[1]
	if sizep[0] eq 2 then npix = sizep[2] else npix=1
	use_x = n_elements(x) GT 0

	if use_x then f = CALL_FUNCTION(functname, p, x, deriv=K, _extra = _extra) $
			 else f = CALL_FUNCTION(functname, p, deriv=K, _extra = _extra)

	m = n_elements(f[*,0])
	if n_elements(K) eq 0 OR keyword_set(autoderivative) then begin
	; must get numerical derivatives!!!
		K = fltarr(n,m,npix)
		dp = fltarr(n,npix)
		for ix = 0, n-1 do begin ; cycle through input variables
			delta = 1e-3 * reform(p[ix,*])
			wbad = where (delta eq 0.)
			if wbad[0] ne -1 then delta[wbad] = 1e-5 ; default perturbation
			dp[ix,*] = delta
			if use_x then f2 = CALL_FUNCTION(functname, p+dp, x, _extra = _extra) $
					 else f2 = CALL_FUNCTION(functname, p+dp, _extra = _extra)
			if m LT npix then for ii=0,m-1 do K[ix,ii,*] = (f2 - f)[ii,*] / delta $
				else for ii=0,npix-1 do K[ix,*,ii] = (f2-f)[*,ii] / delta[ii]
			dp[ix,*] = 0.
		endfor
	endif

; now I have y and K (and Sp and p)

; Calculate Sy = K Sp Kt
	KSp = fltarr(n,m,npix)
	if npix GT (n*m) then begin
		for i=0,m-1 do for j=0,n-1 do KSp[j,i,*] = total(K[*,i,*] * Sp[*,j,*], 1)
	endif else begin
		for i=0, npix-1 do KSp[*,*,i] = K[*,*,i] ## Sp[*,*,i]
	endelse

	if keyword_set(diag_only) then begin
	  Sy = total(ksp * k, 1)
	endif else begin
		Sy = fltarr(m,m,npix)
		if npix GT (m*m) then begin
			for i=0,m-1 do for j=0,m-1 do Sy[j,i,*] = total(KSp[*,i,*] * K[*,j,*], 1)
		endif else begin
			for i=0, npix-1 do Sy[*,*,i] = Ksp[*,*,i] ## transpose(K[*,*,i])
		endelse
	endelse

	return, f

END