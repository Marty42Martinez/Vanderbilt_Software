Function Bartlett, tod

; applies a Bartlett window to a data segment
	N = n_elements(tod)
	w=findgen(N)
	w=1-((w-0.5*Nb)/(0.5*Nb))^2
return, 2*tod*w

end