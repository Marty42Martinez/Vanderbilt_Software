;LMMIN.PRO
;perform Levenberg-Marquardt minimization of model wrt data.
;accepts independent variables of any dimension.
;SC, 12/14/99




FUNCTION comp_chisq,S,M,sigma
	chisq=(1/sigma^2)*total((S-M)^2)
return,chisq
end


FUNCTION comp_beta,S,M,pd,sigma
	COMMON LM,npar
	beta=fltarr(npar)
	for k=0,npar-1 do begin
		beta(k)=(1/sigma^2)*total((S-M)*pd(*,k))
	endfor
return,beta
end


FUNCTION comp_alpha,pd,sigma
	COMMON LM,npar
	alpha=fltarr(npar,npar)
	for k=0,npar-1 do begin
		for l=0,npar-1 do begin
			alpha(k,l)=double(total(pd(*,k)*pd(*,l)))
		endfor
	endfor
	alpha=(1/sigma^2)*alpha
return,alpha
end


FUNCTION comp_alpha_p,alpha,lambda
	COMMON LM,npar
	d=findgen(npar)
	alpha(d,d)=double(alpha(d,d)*(1+lambda))
return,alpha
end


FUNCTION get_delta_a,alpha_p,beta,sigma
	svdc,alpha_p,w,u,v,/double
	delta_a=svsol(u,w,v,beta,/double)
	
	;alpha_p=invert(alpha_p,/double)
	;delta_a=alpha_p##beta
return,delta_a
end





PRO lm_fit,point,S,M,pd,funcs,a,sigma,alpha,chisq,lambda,term


alpha=comp_alpha(pd,sigma)
beta=comp_beta(S,M,pd,sigma)
alpha_p=comp_alpha_p(alpha,lambda)
delta_a=get_delta_a(alpha_p,beta,sigma)

trya=a+delta_a

Mn=(call_function(funcs,point,trya))
pdn=Mn(*,1:*)
Mn=Mn(*,0)	

chitry=comp_chisq(S,Mn,sigma)
print,'Chi-squared/DOF for this attempt is: '+numstr(chitry/(n_elements(S)-n_elements(a)),5)
print,'Parameters are : '
for i=0,n_elements(trya)-1 do begin
	print,'	Parameter '+numstr(i,2)+'= '+numstr(trya[i],5)
endfor

if (abs((chitry-chisq)/chisq) le 0.0005) then term=0  ;change in chisq threshold for termination of fit
	
if (chitry lt chisq) then begin
	
	plot,S(63500:63560),charsize=2
	oplot,Mn(63500:63560),color=12000000
	
	plot,S(63500:64000),charsize=2,xtitle=textoidl('\chi^2')+'/DOF= '+numstr(chisq/(n_elements(S)-n_elements(a)),5)
	oplot,m(63500:64000),color=12000000
	
	;STOP	
				
	lambda=lambda/10.
	a=trya
	chisq=chitry
	pd=pdn
	M=Mn
	
endif else begin
	lambda=10*lambda
endelse

return

end








PRO lmmin,point,S,funcs,a,sigma,covar,alpha,chisq


;TEST HACKS IN PLACE:
;	NONE
;




!p.multi=[0,2,3]

;calculate variance/stdev for fits from data at end of raster (off Jupiter)
;look at beginning and end of raster - take minimum variance portion (most glitch free) as noise estimate

stat_begin=moment(S(0:10000))  & sigma_begin=sqrt(stat_begin[1])
stat_end=moment(S((n_elements(S)-10000):*)) & sigma_end=sqrt(stat_end[1])

if (sigma_begin lt sigma_end) then begin
	sigma=sigma_begin
	print,'Using beginning of raster for noise estimate.'
endif else begin
	sigma=sigma_end
	print,'Using end of raster for noise estimate.'
endelse


print,'Std is '+strtrim(string(sigma),2)

;initialize gradient scaling factor
lambda=0.001

;calculate chisq of initial guess

COMMON LM,npar

M=(call_function(funcs,point,a))
pd=M(*,1:*)
M=M(*,0)	
npar=n_elements(a)

chisq=comp_chisq(S,M,sigma)
print,'Initial chi-squared/DOF is '+numstr(chisq/(n_elements(S)-npar),5)

;flag to terminate fit
term=1

while (term gt 0) do begin
	term=term+1
	print,'Iteration '+numstr(term-1,2)+'. Lambda= '+numstr(lambda,10)
	lm_fit,point,S,M,pd,funcs,a,sigma,alpha,chisq,lambda,term
	if (term ge 0) then print,'Best chi-squared/DOF after iteration '+numstr(term-1,2)+' is '+numstr(chisq/(n_elements(S)-npar),5)	
endwhile


print,'Final chi-squared/DOF value is '+numstr(chisq/(n_elements(S)-npar),5)

;now set lambda to zero and get covariance matrix
lambda=0.

alpha=comp_alpha(pd,sigma)

covar=invert(alpha,/double)

plot,S(63000:63500),charsize=2
oplot,m(63000:63500),color=99999

plot,S(63500:64000),charsize=2
oplot,m(63500:64000),color=99999

return
end








	
