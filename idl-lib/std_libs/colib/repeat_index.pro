function repeat_index, A_, sort=sort

; kind of the inverse of value_locate
; gives the index number of an array
; if unsorted, set the /SORT keyword

sort = keyword_set(sort)
if sort then begin
	s = sort(A_)
	A = A_[s]
endif else A = A_

iter = 0
small = min(A) - 1
nA = n_elements(A)
index = lonarr(nA)
count = 0
repeat begin
	n = n_elements(A)
	if n eq 1 then diff = 1 else diff = [1, A[1:*] - A]
	w0 = where(diff GT 0, n0, comp=wc)
	if n0 GT 0 then begin
		count = count + n0
		if iter GT 0 then index[w[w0]] = iter
	endif
	if wc[0] ne -1 then begin
		A = A[wc]
		if iter eq 0 then w =wc else w = w[wc]
	endif
	iter= iter + 1
endrep until count eq nA or wc[0] eq -1

if count ne nA then print, 'REPEAT_INDEX FAILED FOR SOME REASON!'
if sort then index = index[sort[s]]

return, index

END