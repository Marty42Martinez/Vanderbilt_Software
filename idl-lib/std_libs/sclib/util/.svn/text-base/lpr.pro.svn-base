;Creates plot of 'varname' and sends it to the default system printer.
;
;DATA: n/a
;CALLS: n/a
;WRITTEN 17. Mar 98 by SC
;*********************************************************************************************
pro lpr, varname

ti='' & xti='' & yti='' & plottyp='' & lndscp='n' & prnt='y'

set_plot,'win'
read,ti,prompt='Enter  plot title:'
read,xti,prompt='Enter x-axis title:'
read,yti,prompt='Enter y-axis title:'
read,plottyp,prompt='2D, contour, surface, or shaded surface plot? <2d, c, s, ss>'
read,lndscp,prompt='Landscape mode? <y or n>'

case plottyp of
		'c': contour,varname,xtitle=xti,ytitle=yti,title=ti
		's': surface, varname,xtitle=xti,ytitle=yti,title=ti
		'ss': shade_surf,varname,xtitle=xti,ytitle=yti,title=ti
else: plot,varname,xtitle=xti,ytitle=yti,title=ti
endcase

read,prnt,prompt='Send to printer? <y or n>

if (prnt='y')  then begin
	set_plot,'printer'
	!p.multi=0

	if (lndscp='y') then begin
    	device,/landscape
	endif

	case plottyp of
        'c': contour,varname,xtitle=xti,ytitle=yti,title=ti
        's': surface, varname,xtitle=xti,ytitle=yti,title=ti
        'ss': shade_surf,varname,xtitle=xti,ytitle=yti,title=ti
	else: plot,varname,xtitle=xti,ytitle=yti,title=ti
	endcase

	device, /close
endif

set_plot, 'win'

print,'Finished.'
end