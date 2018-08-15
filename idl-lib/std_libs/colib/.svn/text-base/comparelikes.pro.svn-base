pro CompareLikes, dir1, dir2, submap=submap, tit1=tit1,tit2=tit2, main=main, outname=outname,channels=channels, deoffset=deoffset, _extra=_extra, D_=D_

if n_elements(D_) eq 0 then D_ =100
cnames = ['j1i','j2i','j3i','j1o','j2o','j3o']

if n_elements(channels) eq 0 then channels = [0,1,2,3,4,5]
!p.multi = [0,2,n_elements(channels)/2]
;window, xsize=800,ysize=600
;wset, 0
!y.omargin = [3,4]
!p.font = -1
!p.charsize = 1.4
!p.charthick = 1.
if n_elements(tit1) eq 0 then tit1 = ''
if n_elements(tit2) eq 0 then tit2 = ''
if n_elements(main) eq 0 then main = ''
maintit = main+' - '+tit1+' vs '+tit2

xtit = tex('\sigma [\muK]')
ytit = 'Liklihood'


for c = 0,n_elements(channels)-1 do begin
	channel = channels[c]/2 + 3*(channels[c] mod 2)
	cname = cnames[channel]
	exist1 =1 & exist2 = 1
	if n_elements(submap) NE 0 then begin
		restore, dir1+'submaps_'+cname+'.var'
		delta1 = findgen(D_)
		w1 = where(Qmapsigma[submap,*])
		if w1[0] ne -1 then begin
		Qlik1 = FlatL(reform(Qmaps[submap,w1]),reform(Qmapsigma[submap,w1]),delta1, /double,deoffset=deoffset)
		Ulik1 = FlatL(reform(Umaps[submap,w1]),reform(Umapsigma[submap,w1]),delta1, /double,deoffset=deoffset)
		endif else exist1=0
		if n_params() gt 1 then begin
			restore, dir2+'submaps_'+cname+'.var'
			delta2 = findgen(D_)
			w2 = where(Qmapsigma[submap,*])
			if w2[0] ne -1 then begin
			Qlik2 = FlatL(reform(Qmaps[submap,w2]),reform(Qmapsigma[submap,w2]),delta2, /double,deoffset=deoffset)
			Ulik2 = FlatL(reform(Umaps[submap,w2]),reform(Umapsigma[submap,w2]),delta2, /double,deoffset=deoffset)
			endif else exist2 =0
		endif

		xr = [0,200]
	endif else begin
		cmrestore, dir1+'full_lik_'+cname+'.var', Qlik1, Ulik1,Delta1, names=['Qlik','Ulik','Delta']
		if n_params() gt 1 then begin
			cmrestore, dir2+'full_lik_'+cname+'.var', Qlik2, Ulik2,Delta2, names=['Qlik','Ulik','Delta']
		endif
		xr = [0,100]
		if (channel mod 3) eq 0 then xr = [0,50]
	endelse
		tit = cname
		if n_params() eq 1 then begin
			exist2 = 0
			delta2 = delta1
		endif
		delta = findgen(max([max(delta1),max(delta2)]))
		plot, delta, Qlik1, xr=xr, yr = [0,1], xtit=xtit,ytit=ytit,tit=tit, /nodata, _extra=_extra
		if exist1 then	oplot, delta1, Qlik1
		if exist2 then oplot, delta2, Qlik2, line=2
		if exist1 then oplot, delta1, Ulik1, col=100
		if exist2 then oplot, delta2, Ulik2, col=100, lines=2
		if channel eq 0 then $
		legend, /top, /right, col = [0,0,100,100], ['Q '+tit1,'Q '+tit2,'U '+tit1,'U '+tit2],lines =[0,2,0,2], box=0, charsize=0.7

endfor

xyouts, 0.3,0.95, /normal, maintit
if keyword_set(outname) then gifscreen, outname

end