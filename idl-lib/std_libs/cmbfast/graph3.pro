; make first graph

cmb = readcmbfast('z:\group\polarization\cmbfast\cmbtau0.txt')
set_plot, 'PS'
device, color=1, /encap, xsize=7,ysize=10, /inches, xoff=0.5,yoff=5.0, $
	filename = 'c:\polar\work\july\5\peter3.eps'
!x.margin = [15,0]
!y.margin = [40,0]
!p.charthick = 1
!p.font = -1
;window, xsize=600,ysize=650
!p.charsize = 1
;ytit = tex('!6[!12l!6(!12l!6+1) C_{!12l}!6/2\pi!6]^{1/2} [\muK]')
ytit = '!6Frequency [GHz]'
xtit = ''

plot, sqrt(cmb.ee)*1e6*0, /xlog, /ylog, yr=[10,1000], xr =[1,2000], $
xtickname = [' ',' ',' ',' ',''], ytickname=[' '], ytit=ytit

device, /close_file
set_plot, 'win'

end