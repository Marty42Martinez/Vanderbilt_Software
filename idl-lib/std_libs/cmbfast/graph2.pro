; make first graph

cmb = readcmbfast('z:\group\polarization\cmbfast\cmbtau0.txt')
set_plot, 'PS'
device, color=1, /encapsulated,xsize=7,ysize=4.5, /inches, xoff=0.5,yoff=0, $
	filename = 'c:\polar\work\july\5\peter2.eps'
!x.margin = [15,0]
!y.margin = [20,0]
!p.charthick = 1
!p.font = -1
th = 6
;window, xsize=600,ysize=650
!p.charsize = 1
ytit = tex('!6[!12l!6(!12l!6+1) C_{!12l}!6/2\pi!6]^{1/2} [\muK]')
xtit = '!6Multipole Moment - !13l!3'
plot, sqrt(cmb.ee)*1e6*0, /xlog, /ylog, yr=[0.01,10], xr =[1,2000], $
	ytit=ytit, xtit=xtit, ytickname=['0.01','0.1','1','10']
oplot, sqrt(cmb.ee)*1e6, col =100, thick = th
oplot, sqrt(abs(cmb.te))*1e6, col = 140, thick = th

!p.charthick = 1.

legend, ['!6TE Correlation','E-Polarization'], lines = [0,0], $
	thick = [th,th], col = [140,100], pos = [1.3,6], charsize = 0.8, spacing=1.3, box=0


device, /close_file
set_plot, 'win'

end