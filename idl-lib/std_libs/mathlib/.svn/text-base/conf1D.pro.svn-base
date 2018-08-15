FUNCTION conf1D, L, points, peak=peak

; Returns a vector of the locations of the points where
; the integral of the liklihood is a fraction points[i]
; of it's total integral;

; I assume you have fully sampled the liklihood, and do
; very simple approximations to find the integrals.

; L : liklihood
; points : array of fractions of the total integral of L, about max(L)
; peak : peak location of L

	out = points
	nL = n_elements(L)
	np = n_elements(points)
	tot = total(L)

	peak = (where(L eq max(L)))[0]
	frac = dblarr(nL-peak)
	for i = peak,nL-1 do begin
		w = where(L GE L[i])
		frac[i-peak] = total(L[w])/tot
	endfor

	for p = 0,np-1 do begin
		absdiff = abs(frac - points[p])
		out[p] = (where(absdiff eq min(absdiff)))[0] + peak
	endfor

	return, out
END