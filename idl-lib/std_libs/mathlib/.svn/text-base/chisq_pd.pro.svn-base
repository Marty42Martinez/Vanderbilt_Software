function chisq_pd, cs, dof

; my job is to calculate your p-value

rcs = cs/float(dof)

if dof GT 12 then begin
	P = 1./sqrt(4*!dpi*dof) * rcs^(0.5*dof-1.) * (exp(rcs-1.))^(-dof/2.) * (1.+1./6./dof+1./72./dof^2)^(-1)
endif else begin
	P =  (cs) ^ (0.5 * (dof-2)) * exp(-cs/2.) / ( 2^(dof/2.)*gamma(dof/2.0))
endelse

return, P

end