PRO Plotlots

!x.style = 1
!y.style = 1
!p.font = 1 ; Set for True Type fonts
loadct, 12  ; load color table for 256 colors
set_plot, 'printer', /copy  ; set the printing device to the system printer, copy color table
device, xsize=18, xoff=2, yoff=6, ysize = 15, set_font="Times Bold", /tt_font

restore, 'c:\chris\data\1019rotatenomotor\longvars.var'
x = angle
;---------------------------------------------------
;tp1
plot, angle, tp1avarr, xtitle = 'Angle [Deg]', ytitle = 'Signal [V]', xrange=[0,360], $
      title = 'TP0 Binned, Dedrifted Angular Data, Rotating by Hand at 4.1 rpm'

errplot, x, tp1avarr-tp1sdarr/2, tp1avarr+tp1sdarr/2
device, /close_doc

;---------------------------------------------------
;TP1
plot, angle, tp1avarr, xtitle = 'Angle [Deg]', ytitle = 'Signal [V]', xrange=[0,360], $
      title = 'TP1 Binned, Dedrifted Angular Data, Rotating by Hand at 4.1 rpm'

errplot, x, tp1avarr-tp1sdarr/2, tp1avarr+tp1sdarr/2
device, /close_doc

;---------------------------------------------------
;j1i
plot, angle, j1iavarr, xtitle = 'Angle [Deg]', ytitle = 'Signal [V]', xrange=[0,360], $
      title = 'J1 Binned, Dedrifted Angular Data, Rotating by Hand at 4.1 rpm', $
      subt='Black=In Phase, Green = Out of Phase'

errplot, x, j1iavarr-j1isdarr/2, j1iavarr+j1isdarr/2

oplot, angle, j1oavarr, color=55
device, /close_doc

;---------------------------------------------------
;j2i
plot, angle, j2iavarr, xtitle = 'Angle [Deg]', ytitle = 'Signal [V]', xrange=[0,360], $
      title = 'J2 Binned, Dedrifted Angular Data, Rotating by Hand at 4.1 rpm', $
      subt='Black=In Phase, Green = Out of Phase'
errplot, x, j2iavarr-j2isdarr/2, j2iavarr+j2isdarr/2

oplot, angle, j2oavarr, color=55
device, /close_doc

;---------------------------------------------------
;j3i
plot, angle, j3iavarr, xtitle = 'Angle [Deg]', ytitle = 'Signal [V]', xrange=[0,360], $
      title = 'J3 Binned, Dedrifted Angular Data, Rotating by Hand at 4.1 rpm', $
      subt='Black=In Phase, Green = Out of Phase'

errplot, x, j3iavarr-j3isdarr/2, j3iavarr+j3isdarr/2

oplot, angle, j3oavarr, color=55
device, /close_doc

set_plot, 'win'
END
