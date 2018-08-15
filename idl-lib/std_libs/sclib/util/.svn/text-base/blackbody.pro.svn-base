PRO BLACKBODY

h=4.136*10e-16 		   	 ;Planck constant in eV*s
c=2.9979*10e7       	 ;Speed of light in m/s
k=8.617*10e-6       	 ;Boltzman's constant in eV/K
v=(findgen(1000)+1)*10e8	 ;Frequency in GHz
n=10					 ;number of temperatures to evaluate.
T=2.725					 ;Lowest Temperature

BE=fltarr(n,1000) & b=BE &bRJ=BE

for i=0,n-1 do begin
	BE(i,*)=(1/(exp((h*v)/(k*T))-1))
	b(i,*)=2*h*((v^3)/(c^2))*BE(i,*)*(1.602e-19);Brightness of blackbody in W/m^2/Hz/Sr
	bRJ(i,*)=2*k*T*v^2/c^2*(1.602e-19)
	T=T+1
endfor

;convert to 10^-4 ergs/(cm^2 sr sec cm^-1) to match FIRAS units
b=b*3d17
bRJ=bRJ*3d17
;convert v to wavenumber
v=v/(30.e9)

stop
end
