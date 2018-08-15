function unique, x, d, sort=sort, index=index

; returns a shortened list of the unique elements of x
; optional variable d: the # of digits to be the same to.

if n_params() eq 2 then xp = roundigit(x,d) else xp = x

Nx = n_elements(xp)

out = xp[0]
if keyword_set(index) then ind = 0
for i=1,Nx-1 do begin
	if not elt(xp[i],out) then begin
		out = [out,xp[i]]
		if keyword_set(index) then ind = [ind, i]
	endif
endfor

if keyword_set(sort) then begin
	s = sort(out)
	out = out[s]
	if keyword_set(index) then ind = ind[s]
endif

if keyword_set(index) then return, ind else return, out

END