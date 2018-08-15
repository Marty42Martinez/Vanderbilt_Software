function E1, x, verbose=verbose, cutoff=cutoff, eps=eps, double=double, cf = cf
; Computes Exponential integral E1(x)
; See Numerical Recipes, pg 222.
; accepts vector input

verbose = keyword_set(verbose)

; x must be gt 0!
if n_elements(cutoff) eq 0 then cutoff = 1.0
EULER = 0.5772156649
if n_elements(eps) eq 0 then eps = 1e-7
tiny = 1e-30
w0 = where(x lt cutoff)
w1 = where(x ge cutoff)

ans = x * 0

m=0
if w0[0] ne -1 then begin
	x0 = x[w0]
	if keyword_set(double) then x0 = double(x0)
	; where x LT 1
	ans0 = -EULER - alog(x0)
	term = 1
	repeat begin
		m = m+1
		term = term * (-x0)/m
		add = term/m
		ans0 = ans0 - add
		err = add/ans0
		wbad = where(abs(err) GT eps)
	endrep until (wbad[0] eq -1)
	ans[w0] = ans0
endif

i=0
if w1[0] ne -1 then begin
	x1 = x[w1]
	if keyword_set(double) then x1=double(x1)
	; Lentz's algorithm
	b = x1 + 1
	c = 1.0/tiny
	d = 1.0/b
	h = d
	repeat begin
		i = i+1
		a = -i^2
		b = b+2
		d = 1./(a*d+b)
		c = b+a/c
		del=c*d
		h = h*del
		wbad = where(abs(del-1) GT eps)
	endrep until wbad[0] eq -1
	if keyword_set(cf) then ans[w1] = h else ans[w1] = h * exp(-x1)
endif

if verbose then print, 'Max Iterations = ', max([i, m])
if n_elements(ans) eq 1 then ans = ans[0]
return, ans

END

