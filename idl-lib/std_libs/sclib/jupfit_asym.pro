;JUPFIT.PRO

;**MAIN**


print,'Restoring raster data...'
restore, file='/home/cordone/analysis/idl_code/degraster.sav'
print,'Data restored.'

;**interpolate gyro pointing up 16x (to match chopper sampling)

print,'Interpolating gyro data...'
RASTINTERP,ggxl,ggel,x,y,n_elements(chopv(1,*))
print,'Done.'

;center coords on (0,0), convert to arcmin
x=60.*(x-average(x))
y=60.*(y-average(y))

;make unit peak-to-peak vector describing chop
f_chop=x
f_chop(*)=chopv(1,*)
f_chop=f_chop/(max(f_chop)-min(f_chop))

;***********************************
;*******user interface is here*******

;Wiener filter data?
WienerFilter=0

;kill harmonics of 0.625 Hz?
kill5=0

;Simulation? (False= use real data)
Sim=1

;STARTING PARAMETERS GO HERE
fwhm_xl=22  
fwhm_el=24    
tau=0.003
delta_x=0.3
delta_y=1.2
A_c=146.25
sig_grad_xl=0.3
sig_curv_xl=0.7
sig_grad_el=0.
sig_curv_el=0.
A=0.03

;*************************************
;*************************************

point=[[x],[y],[f_chop]]
par=[fwhm_xl,fwhm_el,tau,delta_x,delta_y,A_c,sig_grad_xl,sig_curv_xl,sig_grad_el,sig_curv_el,A]
	
;Simulated time stream (if selected) is created here
If sim then begin
	print,'**Simulation mode**'
	sim_par=[19.,23.,0.005,1.,-2.,151.89,0.0,1.,0.3,0.4,0.02]
	print,'Input parameters are:'
	print,transpose(sim_par),format='("           ",g9.4)'
	S=rprast_asym(point,sim_par,/nopd,SN=5.) & S=S(*,1)
endif else begin

	;data goes here
	S=c3[1,*]

	;Kludge to remove big glitch in c4 raster
	;S[114000:118000]=0.

	statraw=moment(S(125000:*))
	sigmaraw=sqrt(statraw(1))

	if kill5 then begin
		print,'Killing off 0.625 Hz frequency bin and all harmonics.'
		Sf=fft(S)
		fbin=n_elements(S)/160.  ;# of bins/Hz
		ind=findgen(100)
		deadbin=round([[0.625*fbin*ind],(n_elements(S)-1)-[0.625*fbin*ind]])
		filt=fltarr(n_elements(S)) & filt(*)=1.
		filt(deadbin)=0.
		filt(deadbin+1)=0.
		filt(deadbin-1)=0.		
		S=float(fft(Sf*filt,/inverse))
	endif
endelse

if WienerFilter then begin	
	;**use starting guess to make simulated TOD for Wiener filter calculation
	print,'Simulating time ordered data for signal power spectrum estimation...'
	M=rprast(point,par,/nopd)
	print,'Simulation complete.'

	;Ms - "smeared" model of TOD including transfer function
	;M - raw TOD model
	Ms=M(*,1)
	M=M(*,0)

	;calculate optimal filter

	print,'Calculating and applying optimal filter.'
	So=wiener(S,Ms)
	print,'Optimal filter applied.'
endif else begin
	So=S
endelse

;plot data being fitted
plot,so

;Model function to use for fit.
funcs='rprast_asym'

print,'Calling Levenberg-Marquardt fitting routine.'
lmmin,point,So,funcs,par,sigma,covar,alpha,chisq

if sim eq 0 then covar=(sigmaraw^2/sigma^2)*covar

;calculate parameter correlation matrix		
pcm=covar/sqrt(diag(covar)##diag(covar))

print,"Parameter","Uncertainty",format='(a12,"         ",a12)'
print,[transpose(par),transpose(sqrt(diag(covar)))],format='("  ",g9.4,"                ",g7.2)'

print,'Beam solid angle is '+numstr(2*!pi*par[0]*par[1])+' arcmin^2.'
;Output antenna temperature given 67 K arcmin^2 Jupiter brightness temp
omega_beam=(2*!pi*par[0]*par[1])/(2.35^2)
T_A=67./omega_beam
print,'Antenna temperature is '+numstr(T_A*1000)+' mK.'

if (sim eq 0) then begin
	NET=((sigmaraw/par[8])*T_A*1000)*sqrt(0.00625)
	print,'Naive NET estimate is '+numstr(NET)+' mK rt(s).'
endif

stop
end
