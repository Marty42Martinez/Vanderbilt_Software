FUNCTION rprast,point,par,nopd=nopd,SN=SN,nogain=nogain

;makes simulated time-ordered data given a beamsize, using in-flight pointing data.

;SC,11/29/99

;strip out variables from arrays
x=point(*,0)
y=point(*,1)
f_chop=point(*,2)

;***fwhm_xl=par[0]
;***fwhm_el=par[1]
;***tau=par[2]
;***delta_x=par[3]
;***delta_y=par[4]
;***A_c=par[5]
;***A=par[6]
fact=2*sqrt(2*alog(2))

sig_xl0=par[0]/fact	;convert fwhm parameter to sigma
sig_el0=par[1]/fact	;
tau=par[2]		;***
delta_x=par[3]	;***
delta_y=par[4]	;***
A_c=par[5]		;***
sig_grad=par[6]
sig_curv=par[7]
A=par[8]		;***



y=y-delta_y
x=(x+A_c*f_chop)-delta_x

;make time ordered data

sc=(1+sig_grad*f_chop+sig_curv*(f_chop)^2)

sig_xl=sig_xl0*sc
sig_el=sig_el0*sc

r2=(x/(sqrt(2)*sig_xl))^2+(y/(sqrt(2)*sig_el))^2

TOD=A*exp(-r2)

if (n_elements(SN) ne 0) then begin
	noise=(A/SN)*randomn(seed,n_elements(TOD))      
	TOD=TOD+noise
endif

TODf=fft(TOD)

;get transfer function for given tau and convolve.

print,'Generating transfer function and convolving w/ simulated raster data...'

;ask for partial derivative wrt tau as well
pttfptau=1

MSAM2TF,n_elements(TOD)/2.,mag,phi,ttf,f,tau,pttfptau=pttfptau

print,'Transfer function generated. FFTing.'
TODs=float(fft(TODf*ttf,/inverse))

print,'Convolution complete.'

;calculate partial derivatives?

if (keyword_set(nopd) eq 0) then begin
	print,"       Calculating partial derivatives."
	pspfwhm_xl=fft(fft(TOD*(x^2/sig_xl^3))*ttf,/inverse)/fact & print,'.'
	pspfwhm_el=fft(fft(TOD*(y^2/sig_el^3))*ttf,/inverse)/fact & print,'.'
	psptau=fft(pttfptau*TODf,/inverse)                                    & print,'.'
	pspdelta_x=fft(fft(TOD*x/(sig_xl^2))*ttf,/inverse)              & print,'.'
	pspdelta_y=fft(fft(TOD*y/(sig_el^2))*ttf,/inverse)             & print,'.'
	pspA_c=fft(fft(-TOD*x*f_chop/(sig_xl^2))*ttf,/inverse)       & print,'.'

	pspsig_grad=fft(fft((((x/sig_xl)^2+(y/sig_el)^2)*(f_chop))*TOD)*ttf,/inverse)    & print,'.'
	pspsig_curv=fft(fft((((x/sig_xl)^2+(y/sig_el)^2)*((f_chop^2)))*TOD)*ttf,/inverse)  & print,'.'
	
	;pspsig_grad_el=pspfwhm_el*(1/fact)*sig_el0*f_chop
	;pspsig_curv_el=pspfwhm_el*(1/fact)*sig_el0*f_chop^2	

	pspA=TODs/A	& print,'.'

	print,"       Calculation complete."
	return,float([[tods],[pspfwhm_xl],[pspfwhm_el],[psptau],[pspdelta_x],[pspdelta_y],[pspA_c],[pspsig_grad],[pspsig_curv],[pspA]])
endif else begin
	return,float([[tod],[tods]])
endelse

stop

end
