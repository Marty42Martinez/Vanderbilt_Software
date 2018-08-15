function readcmbfast, filename, correction = correction, GC=GC

; GC: This puts the power spectra into the Grad-Curl convention,
;     meaning TE gets divided by sqrt(2), and EE and BB divided by 2.

readcol, filename, l, TT, EE, TE, skipline = 1

if n_elements(correction) eq 0  then c = 1.0 else c = correction

TT = TT * c
TE = TE * c
EE = EE * c

if keyword_set(GC) then begin
	TE = TE / sqrt(2)
	EE = EE / sqrt(2)
	BB = BB / sqrt(2)
endif
return, {l:l, TT:TT, TE:TE, EE:EE, BB:BB}

end

