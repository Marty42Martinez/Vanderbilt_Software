FUNCTION mc_container::fill_container, num = num, aspectratio=aspectratio;, density=density

   ;asd = RANDOMU(xseed)
   KEYWORD_DEFAULT, num,            500.
   KEYWORD_DEFAULT, aspectratio,    0.48
   ;KEYWORD_DEFAULT,seed,            xseed
   
   fn = '/Users/Marty/svn_repos/raman_svn/marty/generic_psd.sav'
   restore, fn
   ;structure containing:
   ;                     hist    [100]
   ;                     xpl     [100]
   ;                     binsize .005  cm
   ;                 OR
   ;                     meashist  [560]
   ;                     xpl       [560]
   ;                     binsize   .005  cm
   
   ;stop
   
   hold = objarr(num+2) ; the +2 accounts for rounding in the first for loop
   
   ;%%%%%%%%%%%%%%;
   ;Used for testing, same number of particles in each size bin
   ;d        = [.002,.005,.01,.02,.05,.1,.15,.2,.25,.3,.4,.5,.6,.7,.8,1.0,1.5,2.]
   ;n        = n_elements(d)
   ;%%%%%%%%%%%%%%;
   
   ;n        = n_elements(psd.xpl)
   ;D_mm   = psd.xpl*10.
   ;D_LE = (6*.022*(D_mm^2.1)/!pi)^(1./3.)*(1./10)
   ;mass = (D_LE^3)*(!pi/6)*1e-3 ; mass in kilograms (rho = 1 g/cm3)
   ;mass   = (3.8e-4*d^2.)/1e3
   ;mass  = (3.8e-4*psd.xpl^2.)/1e3
   ;tot    = total(psd.meashist)
   place  = 0
   ;stop
   
   ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
   ;Five size bin Small particles;
   ;1/18/16
   ;Using these distributions to look at aggregation mechanics;
   ;part = num/9.
   
   ;dmax = [5e-5,6e-5,1e-4,3e-4,5e-4,8e-4,1e-3,2e-3,5e-3,1e-2,3e-2]
   ;dmax = [5e-5,1e-4,5e-4,1e-3,2e-3]
   ;dmax = [1e-4,1e-3,5e-3,1e-2,2e-2] ; 12/19 heavy tail dist for small and large particles 
   ;dmax = 7e-6*(findgen(2500)+1)-2.1e-5 +0.5e-3
   ;dmax = 8e-6*(findgen(2000)+1)-(8e-6)*(7e-3) + 7e-3
   
   ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
   ;Lognormal Distribution;
   
   ;%%% LogN1 %%%;
   ;dmax = lognorm(seed,num,5e-4,3e-4) 
   ;%%% LogN2 %%%;
   ;dmax = lognorm(seed,num,7e-4,2.5e-4)
   ;%%% LogN3 %%%;
   ;dmax = lognorm(seed,num,2e-3,8e-4)
   ;stop
   ;%%% LogN6 %%%;
   ;dmax = lognorm(seed,num,8e-3,1e-2)
   
   ;%%% Fspeed Density Tests %%%;
   
   ;%%% FD1 %%%;
   ;dmax = lognorm(seed,num,5e-5,2e-5)
   ;%%% FD2 %%%;
   ;dmax = lognorm(seed,num,1e-3,1e-3)
   
   ;%%% Aggregation Tests %%%:
   ;%%% Feb 2 %%%;
   ;For small particles use density of 1000 kg/m3
   ;for the large particle, use a density of 100
   ;calculate in same way that we do in densitychanges.pro
   ;dmax = lognorm(seed,num,1e-5,1e-8)
   dmax = lognorm(seed,num,1e-5,0)
   ;Changed variance to 0 in order to match aggregation mass and riming mass
   dmax = [dmax,1e-3]
   ;Feb 10;
   ;Changed small particles to have aspect ratio of 1;
   ar   = 1
   rmin   = dmax*ar/2.
 
   volume = !pi*(4./3)*(dmax/2.)*rmin^2.
   dens   = 1000
   mass   = dens*volume
   mass[-1] = (3.8e-4*(dmax[-1]*100)^2.)/1e3
   
   ;%%% Contour Plots %%%;
   ;dmaxa = lognorm(seed,num/2,5e-4,5e-4)
   ;dmaxb = lognorm(seed,num/2,1e-3,1e-3)
   ;dmax  = [dmaxa,dmaxb]
   
   
   ;mass = (3.8e-4*(dmax*100)^2.)/1e3
   for i=0,num-1 do begin
     particle = obj_new('mc_flake',mass=mass[i],dmax=dmax[i],aspectratio=ar)
     self.add, particle
   endfor
   particle = obj_new('mc_flake',mass=mass[-1],dmax=dmax[-1],aspectratio=aspectratio)
   self.add, particle
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
;For step function distributions
;   for i=0,num-1 do begin
;     particle = obj_new('mc_flake',mass=mass[i],dmax=dmax[i],aspectratio=aspectratio)
;     self.add, particle
;   endfor
;   for i=0,3*part do begin
;     particle = obj_new('mc_flake',mass=mass[0],dmax=dmax[0],aspectratio=aspectratio)
;     self.add, particle
;   endfor
;   for i=0,2*part do begin
;     particle = obj_new('mc_flake',mass=mass[1],dmax=dmax[1],aspectratio=aspectratio)
;     self.add, particle
;   endfor
;   for i=0,1*part do begin
;     particle = obj_new('mc_flake',mass=mass[2],dmax=dmax[2],aspectratio=aspectratio)
;     self.add, particle
;   endfor
;   for i=0,1*part do begin
;     particle = obj_new('mc_flake',mass=mass[3],dmax=dmax[3],aspectratio=aspectratio)
;     self.add, particle
;   endfor
;   for i=0,2*part do begin
;     particle = obj_new('mc_flake',mass=mass[4],dmax=dmax[4],aspectratio=aspectratio)
;     self.add, particle
;   endfor
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;
   
 ;  for i = 0,n-1 do begin
;     ;number = round(num/n)
;	 number = psd.meashist[i]*(num/tot)
;	 
;	 for j = 0,number do begin
;	   particle = obj_new('mc_flake',mass=mass[i],dmax=psd.xpl[i]/100,aspectratio=aspectratio)
;	   self.add,particle
;	 endfor
;     place = place+number
;   endfor
   ;stop
   
   ;Should we shuffle the obj array??
   ;I think that we need to shuffle the array in order to ensure randomness;
   ;flakes = shuffle(hold)
   
   ;self.add, flakes
   
   return, 1





end
