; Main Code

!p.thick=6.0
!p.background=!d.n_colors-1

;------- read in and display image -----------

read_gif,'c:\chris\skyview\0408_rect_600_redtemp.gif',im
map_set,/aitoff,/noborder
im1=map_image(im,compress=1,scale=.08,missing=255)
tv,im1,.175,.185,xsize=9.15,ysize=6.48,/inches
map_grid,glinestyle=0,color=!d.n_colors-2,glinethick=1

;--------- overplot boxes ---------------

pycolor=intarr(4)
ramin=fltarr(4) & ramax=fltarr(4) & decmin=fltarr(4) & decmax=fltarr(4)

ramin(0)=-60.8 & ramax(0)=41.7 & decmin(0)=-52.3 & decmax(0)=-44.86 ;python5
ramin(1)=16.0 & ramax(1)=79.0 & decmin(1)=-63.5 & decmax(1)=-60.5 ;python5
ramin(2)=-28 & ramax(2)=8 & decmin(2)=-52.3 & decmax(2)=-46.7 ;python3
ramin(3)=-21 & ramax(3)=5 & decmin(3)=-51.4 & decmax(3)=-49.9 ;python4

pycolor(0)=!d.n_colors-2
pycolor(1)=!d.n_colors-2
pycolor(2)=!d.n_colors/1.25
pycolor(3)=!d.n_colors/1.65

for i=0,3 do begin

point1=[ramin(i),decmax(i)]
point2=[ramin(i),decmin(i)]
point3=[ramax(i),decmin(i)]
point4=[ramax(i),decmax(i)]

plots,point1
plots,point2,/continue,color=pycolor(i)
plots,point3,/continue,color=pycolor(i)
plots,point4,/continue,color=pycolor(i)
plots,point1,/continue,color=pycolor(i)

endfor
ncolors=!d.n_colors

end

;------- here's what i do to print to a file: ------------

xloadct
;select red temperature
;stretch bottom to 32
;stretch top to 90
pslc1
;.r pymap
pse

end