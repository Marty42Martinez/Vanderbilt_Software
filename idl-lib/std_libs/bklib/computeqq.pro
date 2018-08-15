	function ComputeQQ, lmax,F1l2,F2l2,E,B

    pi = 4.*atan(1.)
 	sum= 0.
 	for  l=2l, lmax-2 do begin
 	   aux = (2.*l+1.)/(4.*pi)
 	   sum = sum + aux*(E(l)*F1l2(l)-B(l)*F2l2(l))
 	endfor
 	return,sum
 	end

