PRO binxy, x_, y_, xb, yb, dx=dx, bins=bins, median=median, $
	std=std, sdom=sdom, xlog=xlog, ylog=ylog, clean=clean, $
	n=n, center=center, xoffset=xoffset, climits=conf_limits, confidence=conf

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
conf_limits = fltarr(bins,2)
sdom = std
for b = 0, bins-1 do begin
	q = (value_locate(x, x0 + dx*(b+1)))[0]
	nn = q-p ; # of hits in this bin
	if nn gt 0 then begin
		xbin = x[p+1:q]
		ybin = y[p+1:q]
		if keyword_set(center) then xb[b] = x0 + dx*(b+0.5) else xb[b] = total(xbin)/nn
		xb[b] = xb[b] + dx * xoffset
		if keyword_set(median) then begin
			if nn eq 1 then yb[b] = ybin else yb[b] = median(ybin)
		endif else yb[b] = total(ybin)/nn
		if nn gt 1 then begin ; set the stddev and sdom
			std[b] = stddev(ybin)
			sdom[b] = std[b] / sqrt(nn)
		endif
		if nn GT 2 and keyword_set(conf) then begin ; get confidence limits
			ss = sort(ybin)
			ysor = ybin[ss]
			vm = nn/2.
		    delta = nn * conf/2.
		    ymed = ybin[vm]
		    if (vm-delta) LT 0. OR ymed eq ysor[0] then begin
		    ; conf limit on the right
		       conf_limits[b,0:1] = ysor[[0, nn*conf ]]
		    endif else begin
		       if (vm+delta) GT (nn-1) OR ymed eq ysor[nn-1] then $
		       conf_limits[b,0:1] = ysor[[nn*(1.-conf), nn-1]] else $
		       conf_limits[b,0:1] = ysor[[ (vm-delta)>0, (vm+delta)<(nn-1) ]]
		    endelse
		endif


	endif
	p = q
	n[b] = nn
endfor

; remove dead bins
w = where(n ne 0)
xb = xb[w]
yb = yb[w]
std = std[w]
sdom = sdom[w]
conf_limits = conf_limits[w,*]

; fix x and y if logarithmic
if xlog then xb = 10.^xb
if ylog then begin
	yb = 10.^yb
	std = (10.^(yb + std) - 10.^(yb-std) )/2.
	sdom = (10.^(yb + sdom) - 10.^(yb-sdom) )/2.
endif

END




