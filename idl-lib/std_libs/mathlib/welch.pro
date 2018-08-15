Function welch, tod

; applies a Welch window to a data segment
	N = n_elements(tod)
	w=findgen(N)
	w=1-((w-0.5*N)/(0.5*N))^2
return, tod*w

end