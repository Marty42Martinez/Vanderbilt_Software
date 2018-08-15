; make first graph

cmb = readcmbfast('z:\group\polarization\cmbfast\cmbtau0.txt', correction=2.5066)
set_plot, 'PS'
outname = 'c:\polar\work\july\5\peter1.eps'
checkdir, outname
device, color=1, /encapsulated, xsize=7,ysize=10, /inches, $
	filename = outname

!x.margin = [15,0]
!y.margin = [38,0]
!p.charthick = 1
!p.font = -1
;window, xsize=600,ysize=650

ytit = tex('!3[!12l!3(!12l!3+1) C_{!12l}!3/2\pi!3]^{1/2} [\muK]')
xtit = '!6Multipole Moment - !13l!3'
plot, sqrt(cmb.tt)*1e6, /xlog, /ylog, yr=[0.01,1e5], xr =[1,2000], $
	ytit=ytit, xtit=xtit

oplot, sqrt(cmb.ee)*1e6, col = 100, thick = 2

oplot, sqrt(abs(cmb.te))*1e6, col = 140, thick = 2

!p.charthick = 1.

legend, ['!6Temperature','TE Correlation','E-Polarization'], lines = [0,0,0], $
	thick = [1,2,2], col = [0,140,100], pos = [20,1e4], charsize = 1., spacing=2

device, /close_file
set_plot, 'win'

end