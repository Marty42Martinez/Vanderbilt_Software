	function ComputeTQ, lmax,F1l0,TE

    pi = 4.*atan(1.)
 	sum= 0.
 	for  l=2l, lmax-2 do begin
 	   aux = (2.*l+1.)/(4.*pi)
 	   sum = sum + aux*(TE(l)*F1l0(l))
 	endfor
 	return,sum
 	end

