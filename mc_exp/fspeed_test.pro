;Ralf used this to test the physical accuracy of fspeed_calc

;c_snow  = obj_new('mc_container',num=1000,density=100.)
;c_graup = obj_new('mc_container',num=1000,density=400.)
;c_liq   = obj_new('mc_container',num=1000,density=1000.)

;want to plot fallspeed vs d_fluffy for each container along with tabulated data
;use c -> fallspeed()
;u_snow   = c_snow -> evaluate('fallspeed')
;u_graup  = c_graup -> evaluate('fallspeed')
;u_liq    = c_liq -> evaluate('fallspeed')

d        = [0.05,0.1,0.2,0.5,1,1.5,2,2.5,3,4,5,6,7,8,10,15,20]*1E-3
d_cm     = 100*d
m_dend   = (3.8e-4*d_cm^2.)/1e3
m_dend2  = (5.9e-4*d_cm^2.)/1e3
m_dend3  = (2.5e-3*d_cm^2.5)/1e3
m_graup  = (6.5e-2*d_cm^3.)/1e3
m_hex    = (1.9e-2*d_cm^3.)/1e3
stop
;m_snow   = !PI/6*d^3.0 * 100.
;m_graup   = !PI/6*d^3.0 * 400.
m_liq    = !PI/6*d^3.0 * 1000.
;d_rain   = 0.93997 * d +  39.4022 * d^2

dle_dend = 100*((m_dend*6)/(1000.*!pi))^(1./3)
dle_dend2 = 100*((m_dend2*6)/(1000.*!pi))^(1./3)
dle_dend3 = 100*((m_dend3*6)/(1000.*!pi))^(1./3)
dle_hex  = 100*((m_hex*6)/(1000.*!pi))^(1./3)

;d1    = c_snow -> evaluate('phys_d')
;d2    = c_graup -> evaluate('phys_d')
;d3    = c_liq -> evaluate('phys_d')

;m_snow2    = c_snow -> get('mass_arr')
;m_graup2   = c_graup -> get('mass_arr')
;m_liq     = c_liq -> get('mass_arr')

;m_snow2  = m_snow2[0,*]
;m_graup2  = m_graup2[0,*]

;p_snow1 = plot(d_cm/100.,m_snow,color='red',thick=3,name='mass:Rogers and Yao planar dendrite',xtitle='Maximum Dimension [m]',ytitle='Particle Mass [kg]')
;p_snow2 = plot(d1,m_snow2,color='red',overplot=1,name='mass:sphere with density=100')
;p_snow3 = plot(d_cm/100.,m_graup,color='blue',thick=3)
;p_snow4 = plot(d2,m_graup2,color='blue',overplot=1)
;stop
;
;m_snow  = m_snow[0,*]
;m_graup  = m_graup[0,*]
;m_liq  = m_liq[0,*]

n           = n_elements(d)
u_dend      = fltarr(n)
u_graup     = fltarr(n)
u_hex       = fltarr(n)

;u_snow2     = fltarr(n)
;u_graup2    = fltarr(n)
;u_liq2      = fltarr(n)

maxd_dend   = fltarr(n)
maxd_graup  = fltarr(n)
maxd_hex    = fltarr(n)



for i = 0,n-1 do begin
  u_dend[i] = fspeed_calc(m_dend[i],d[i],max_d=max_d1)
  maxd_dend[i] = max_d1
  u_graup[i] = fspeed_calc(m_dend2[i],d[i],max_d=max_d2)
  maxd_graup[i] = max_d2
  u_hex[i] = fspeed_calc(m_dend3[i],d[i],max_d=max_d3)
  maxd_hex[i] = max_d3
  ;u_rain[i] = fspeed_calc(m_liq[i],d_rain[i])
  ;u_snow2[i] = old_fspeed_calc(100.,d[i])
  ;u_graup2[i] = old_fspeed_calc(400.,d[i])
  ;u_liq2[i] = old_fspeed_calc(1000.,d[i])
endfor

u_denda = 1.60*dle_dend^0.3
u_dend2 = 1.60*dle_dend2^0.3
u_dend3 = 1.60*dle_dend3^0.3

u_hex2  = 2.34*dle_hex^0.3
u_graup2 = 3.43*d_cm^0.6
;stop

rain_dia = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,$
            1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0,$
			3.2,3.4,3.6,3.8,4.0,4.2,4.4,4.6,4.8,5.0,$
			5.2,5.4,5.6,5.8]*1e-3

rain_fs  = [0.27,0.72,1.17,1.62,2.06,2.47,2.87,3.27,$
            3.67,4.03,4.64,5.17,5.65,6.09,6.49,6.90,$
			7.27,7.57,7.82,8.06,8.26,8.44,8.60,8.72,$
			8.83,8.92,8.98,9.03,9.07,9.09,9.12,9.14,$
			9.16,9.17]
			
d_rain   = 0.93997 * rain_dia +  39.4022 * rain_dia^2
m_liq    = !PI/6*rain_dia^3.0 * 1000.
n2 = n_elements(rain_dia)
u_rain      = fltarr(n2)
u_rain2     = .01*2.01e3*(100*rain_dia/2.)^0.5

for i = 0,n2-1 do u_rain[i] = fspeed_calc(m_liq[i],d_rain[i])
;stop

A = plot(maxd_dend,u_dend,color='red',symbol='o',name='Westbrook and Heymsfield:Planar Dendrite 1',$
  ytitle='fallspeed [m/s]',xtitle='Maximum Dimension [m]',title=' Calculated Fall speeds',thick=3,font_size=40)
B = plot(maxd_graup,u_graup,color='blue',symbol='o',name='Westbrook and Heymsfield:Planar Dendrite 2',overplot=1,thick=3)
;C = plot(maxd_hex,u_hex,color='green',symbol='o',name='Westbrook and Heymsfield:Hexagonal Plate',overplot=1,thick=3)
;Da = plot(rain_dia,rain_fs,color='purple',symbol = 'o',name='Measured by Gunn and Kinzer',overplot=0)
;Db = plot(d_rain,u_rain,xtitle='Droplet Diameter [m]',ytitle='Fallspeed [m/s]',color='blue',symbol='o',overplot=1,name='Calculation method: Westbrook and Heymsfield')
;Dc = plot(d_rain,u_rain2,font_size=30,color='red',title='Rain droplet fall speed',symbol='o',overplot=1,xrange=[0,0.008],name='Calculation method: Rogers and Yao')
E = plot(maxd_dend,u_denda,color='red',symbol='d',name='Rogers and Yao:Planar Dendrite 1',overplot=1)
F = plot(maxd_dend,u_dend2,color='blue',symbol='d',name='Rogers and Yao: Planar Dendrite 2',overplot=1)
;G = plot(maxd_dend,u_dend3,color='blue',symbol='d',name='Rogers and Yao:Graupel',overplot=1)


l = legend(target=[A,B,E,F],/auto_text_color, font_size=15)	

;%%%%%%%%%%%%%%%%%%%%%;
;%%%%Percent Error%%%%;
;%%%%%%%%%%%%%%%%%%%%%;
opt1 = 100*abs(u_dend - u_denda)/u_denda
opt2 = 100*abs(u_graup - u_dend2)/u_dend2


one = plot(maxd_dend,opt1,color='red',symbol='o',name='Planar Dendrite 1',$
  ytitle='Percent Error [%]',xtitle='Maximum Dimension [m]',title='Fallspeed Calculation Error',thick=2,font_size=40)
two = plot(maxd_dend,opt2,color='blue',symbol='o',name='Planar Dendrite 2',overplot=1,thick=2)
l2 = legend(target=[one,two],/auto_text_color, font_size=20)
;stop

;a_dens = 1.0
;p_dens1 = 100.
;p_dens2 = 400.
;p_dens3 = 1000.
;p_dens4 = 980.
;
;p_dia   = (FINDGEN(100)+1)/10000.
;;dc      = 0.93997*p_dia + 39.4022*p_dia^2.
;;stop
;u1      = FLTARR(100)
;u2      = FLTARR(100)
;u3      = FLTARR(100)
;u4    = FLTARR(100)
;
;FOR i=0,99 DO BEGIN
;   u1[i]=FSPEED_CALC(p_dens1,p_dia[i],a_dens)
;   u2[i]=FSPEED_CALC(p_dens2,p_dia[i],a_dens)
;   u3[i]=FSPEED_CALC(p_dens3,p_dia[i],a_dens)
;   u4[i]=FSPEED_CALC(p_dens4,p_dia[i],a_dens)
;ENDFOR
;
;rain_dia = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,$
;            1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0,$
;			3.2,3.4,3.6,3.8,4.0,4.2,4.4,4.6,4.8,5.0,$
;			5.2,5.4,5.6,5.8]*1e-3
;
;rain_fs  = [0.27,0.72,1.17,1.62,2.06,2.47,2.87,3.27,$
;            3.67,4.03,4.64,5.17,5.65,6.09,6.49,6.90,$
;			7.27,7.57,7.82,8.06,8.26,8.44,8.60,8.72,$
;			8.83,8.92,8.98,9.03,9.07,9.09,9.12,9.14,$
;			9.16,9.17]
;			
;;stop
;
;;PLOT,p_dia,u1,yrange=[0,15]
;;OPLOT,p_dia,u2
;;OPLOT,p_dia,u3
;
;A = plot(p_dia,u1,yrange=[0,20],/ystyle,color='red',name='dens:100 kg m-3',$
;  ytitle='fallspeed [ms-1]',xtitle='Particle diameter [m]')
;B = plot(p_dia,u2,color='blue',name='dens:400 kg m-3',overplot=1)
;C = plot(p_dia,u3,color='green',name='Corrected dens:1000 kg m-3',overplot=1,thick=3)
;D = plot(rain_dia,rain_fs,color='purple',symbol = 'o',name='Tabulated Rainfall',overplot=1)
;E = plot(p_dia,u4,color='green',symbol = 'o',name='non corrected dens = 999',overplot=1)
;l = legend(target=[A,B,C,D],/auto_text_color)


END
