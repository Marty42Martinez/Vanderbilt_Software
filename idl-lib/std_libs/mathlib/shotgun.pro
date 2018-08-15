function shotgun, x, index=index

; returns x with elements in a random order

	n = n_elements(x)
	r = randomu(seed, n)
	s = sort(r)
	if ~keyword_set(index) then s = x[s]
	return, s

end
