PRO binxy, x_, y_, xb, yb, dx=dx, bins=bins, $
	std=std, sdom=sdom, xlog=xlog, ylog=ylog, clean=clean, $
	n=n, center=center, xoffset=xoffset

;Procedure to bin x-y data (for plotting purposes mostly)
if n_elements(bins) eq 0 then bins = 20
if n_elements(clean) eq 0 then clean = 1
if n_elements(xoffset) eq 0 then xoffset = 0.
; sort data in x
s = sort(x_)
x = x_[s]
y = y_[s]

; clean the data (default)
if clean then begin
	w = where(finite(x) * finite(y))
	x = x[w]
	y = y[w]
endif

; Deal with xlog and ylog situations :
xlog = keyword_set(xlog)
ylog = keyword_set(ylog)
if xlog then begin
	wx = where(x LE 0.)
	if wx[0] ne -1 then begin
		print, '/xlog invalid...x has some non-positive values.'
		return
	endif
	x = alog10(x)
endif

if ylog then begin
	wy = where(y LE 0.)
	if wy[0] ne -1 then begin
		print, '/ylog invalid...y has some non-positive values.'
		return
	endif
	y = alog10(y)
endif

; Do the binning
n = n_elements(x)
xf = x[n-1]
x0 = x[0]
rx = float(xf - x0)
if n_elements(dx) eq 0 then dx = rx/bins $ ; xspacing to use
	else begin
		dx = rx / round(rx/dx)
		bins = round(rx/dx)
	endelse

p = -1
n = lonarr(bins)
xb = x[0] * 0. + fltarr(bins)
yb = y[0] * 0. + fltarr(bins)
std = fltarr(bins)
sdom = std
for b = 0, bins-1 do begin
	q = (value_locate(x, x0 + dx*(b+1)))[0]
	nn = q-p ; # of hits in this bin
	if nn gt 0 then begin
		xbin = x[p+1:q]
		ybin = y[p+1:q]
		if keyword_set(center) then xb[b] = x0 + dx*(b+0.5) else xb[b] = total(xbin)/nn
		xb[b] = xb[b] + dx * xoffset
		yb[b] = total(ybin)/nn
		if nn gt 1 then begin ; set the stddev and sdom
			std[b] = stddev(ybin)
			sdom[b] = std[b] / sqrt(nn)
		endif
	endif
	p = q
	n[b] = nn
endfor

; remove dead bins
w = where(n ne 0)
xb = xb[w]
yb = yb[w]

; fix x and y if logarithmic
if xlog then xb = 10.^xb
if ylog then begin
	yb = 10.^yb
	std = (10.^(yb + std) - 10.^(yb-std) )/2.
	sdom = (10.^(yb + sdom) - 10.^(yb-sdom) )/2.
endif

END




