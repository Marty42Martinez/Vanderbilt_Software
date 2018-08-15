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
sig_grad_xl=par[6]
sig_curv_xl=par[7]
sig_grad_el=par[8]
sig_curv_el=par[9]
A=par[10]		;***

y=y-delta_y
x=(x+A_c*f_chop)-delta_x

;make time ordered data

sc_xl=(1+sig_grad_xl*f_chop+sig_curv_xl*(f_chop)^2)
sc_el=(1+sig_grad_el*f_chop+sig_curv_el*(f_chop)^2)
sig_xl=sig_xl0*sc_xl
sig_el=sig_el0*sc_el

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
	pspfwhm_xl=fft(fft(TOD*(x^2/sig_xl^3))*ttf,/inverse)/fact 
	pspfwhm_el=fft(fft(TOD*(y^2/sig_el^3))*ttf,/inverse)/fact 
	psptau=fft(pttfptau*TODf,/inverse)                                   
	pspdelta_x=fft(fft(TOD*x/(sig_xl^2))*ttf,/inverse)             
	pspdelta_y=fft(fft(TOD*y/(sig_el^2))*ttf,/inverse)             
	pspA_c=fft(fft(-TOD*x*f_chop/(sig_xl^2))*ttf,/inverse)       

	pspsig_grad_xl=pspfwhm_xl*fact*sig_xl0*f_chop
	pspsig_curv_xl=pspfwhm_xl*fact*sig_xl0*f_chop^2

	pspsig_grad_el=pspfwhm_el*fact*sig_el0*f_chop
	pspsig_curv_el=pspfwhm_el*fact*sig_el0*f_chop^2	

	pspA=TODs/A	& print,'.'

	print,"       Calculation complete."
	return,float([[tods],[pspfwhm_xl],[pspfwhm_el],[psptau],[pspdelta_x],[pspdelta_y],[pspA_c], $ 
		[pspsig_grad_xl],[pspsig_curv_xl],[pspsig_grad_el],[pspsig_curv_el],[pspA]])


	;return,float([[tods],[pspfwhm_xl],[pspfwhm_el],[psptau],[pspdelta_x],[pspdelta_y],[pspA_c],[pspA]])


	
endif else begin
	return,float([[tod],[tods]]); *A/max(TODs) normalize s.t. A is peak amplitude (remove gain from preamp)
endelse

stop

end
