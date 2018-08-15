PRO richards, x, A, y, pder

; The Richardson Growth Curve!
; the formula is:
;
; y = y0 + y1/ (1 + T*exp(-B*(x-xc)))^(gamma)
; where
; y0 = lower asymptote
; y1 = upper asymptote
; B = the growth rate
; xc = the place of max growth
; T = near which asymptote max growth occurs
;
; INPUTS
; x : the dependent variable
; A : the parameters:
;	y0 = A[0]
;   y1 = A[1]
; 	xc  = A[2]
;   B = A[3]
;   T = A[4]
;   gamma = A[5]

term1 = 1 + A[4] * exp(-A[3]*(x-A[2]))
term2 = (term1-1)/A[4] / term1
y = A[0] + A[1]/term1^(A[5])
if n_params() GE 4 then begin
	d0 = x*0 + 1
	d1 = term1^(-1.0/A[4])
	d2 = -y*A[3]*A[4]*A[5]*term2
	d3 = y*(x-A[2]) * term2 * A[4] * A[5]
	d4 = -y * A[5]*term2
	d5 = -y * alog(term1)
	pder = [[d0],[d1],[d2],[d3],[d4],[d5]] ; the partial deriv matrix
endif

END
