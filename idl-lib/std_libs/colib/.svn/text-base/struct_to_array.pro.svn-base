FUNCTION struct_to_array, s, names= names

	n = n_elements(s) ; # of data points
	ntag = n_tags(s)
	names= tag_names(s)

	data = bytarr(n, ntag) + s[0].(0)

	for t = 0, ntag-1 do data[*,t] = s.(t)

	return, data

END
