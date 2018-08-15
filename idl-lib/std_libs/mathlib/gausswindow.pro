Function gausswindow, tod

; applies a Gauss window to a data segment
	N = n_elements(tod)
	w=findgen(N)-N/2
	w=exp(-w^2/(N^(1.5)))
return, tod*w

end