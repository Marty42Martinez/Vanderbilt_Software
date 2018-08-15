pro groundbin , section, j1i, j2i, j3i, j1isdom,j2isdom,j3isdom

M = 100
si = sc(string(section))
restore, 'c:\polar\section\cuts\cut'+si+'.var'
n
w = where(allflag)
if w[0] ne -1 then begin  ; this section has some rots that survived the cuts
	restore, 'c:\polar\setion\section'+si+'.var'
	d = getcaldata(section)
	aoe = getaoe(section)
	g = realrots(aoe,p=p,z=z)
	z = z[g]
Nw = n_elements(w)
j1i = fltarr(M) & j1i_2 = fltarr(M)
j2i = fltarr(M) & j2i_2 = fltarr(M)
j3i = fltarr(M) & j3i_2 = fltarr(M)
for i = 0,Nw-1 do begin
	r = w[i]
	thisj1i = bindata(d.j1i[z[r]:z[r]+p[r]-1], M)
	thisj2i = bindata(d.j2i[z[r]:z[r]+p[r]-1], M)
	thisj3i = bindata(d.j3i[z[r]:z[r]+p[r]-1], M)
	j1i = j1i + thisj1i
	j2i = j2i + thisj2i
	j3i = j3i + thisj3i
	j1i_2 = j1i_2 + thisj1i^2
	j2i_2 = j2i_2 + thisj2i^2
	j3i_2 = j3i_2 + thisj3i^2
endfor

j1isdom = sqrt((j1i_2 - 1./Nw*j1i^2)/(Nw*(Nw-1.)))
j2isdom = sqrt((j2i_2 - 1./Nw*j2i^2)/(Nw*(Nw-1.)))
j3isdom = sqrt((j3i_2 - 1./Nw*j3i^2)/(Nw*(Nw-1.)))
j1i = j1i/Nw
j2i = j2i/Nw
j3i = j3i/Nw

endif

end