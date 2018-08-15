Function Hann, tod

; applies a Hanning window to a data segment
	N = n_elements(tod)
	w=findgen(N)
	w=(1-cos(2*!pi*w/N))
return, tod*w

end