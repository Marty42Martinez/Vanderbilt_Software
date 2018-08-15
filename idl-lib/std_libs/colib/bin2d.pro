pro bin2d, x, y, z, xb, yb, zb, xr=xr, yr=yr, dx=dx, dy=dy, n=n, std=std, missing=missing

; Bins data onto a regular 2d grid by simply averaging all the points that
; fall within each grid box.

;INPUTS
; x : the x variable (data)
; y : the y variable (data)
; z : the dependent variable (data)
; (optional)
; xr = range of x for output to cover
; yr = range of y for output to cover
; dx = bin size in x direction
; dy = bin size in y direction
;
; OUTPUTS
;	xb : x-value of center of grid boxes (Nx)
; yb : y-value of center of grid boxes (Ny)
; zb : mean value of data within a grid box (Nx,Ny)
; std: the standard deviation of data within a grid box (Nx,Ny)
; n  : the number of points in each grid box (Nx,Ny)

if n_elements(missing) eq 0 then missing = 0.
if keyword_set(xr) then begin
	x0 = xr[0]
	x1 = xr[1]
endif else begin
	x0 = min(x)
	x1 = max(x)
endelse

if keyword_set(yr) then begin
	y0 = yr[0]
	y1 = yr[1]
endif else begin
	y0 = min(y)
	y1 = max(y)
endelse

ry = float(y1 - y0)
rx = float(x1 - x0)
if n_elements(dx) eq 0 then dx = mean( x[1:*] - x )
if n_elements(dy) eq 0 then dy = mean( y[1:*] - y )
dx = rx / round(rx/dx)
Nx = round(rx/dx)
dy = ry / round(ry/dy)
Ny = round(ry/dy)

; bin boundaries:
;		x = x0 + dx * i , i = 0 .. Nx
;		y = y0 + dy * j, j = 0 .. Ny
; bin centers
;		xc = x0 + (i+0.5)*dx, i = 0..Nx-1
;   yc = y0 + (j+0.5)*dy, j = 0..Ny-1
; pixel numbers
;						       i                         j
;               --------                 ---------
;		p = floor( (x-x0)/dx ) + Nx * floor( (y-y0)/dy )

xb = (findgen(Nx) + 0.5)*dx + x0 ; centers of x bins
yb = (findgen(Ny) + 0.5)*dy + y0 ; centers of y bins
zb = z[0]*0 + fltarr(Nx,Ny) + missing ; set up output array
std = zb * 0
n = lonarr(Nx, Ny)
; Convert from 2D space to 1D space.

loc = floor( (((x-x0)/dx) > 0) < (Nx-1) ) + Nx * floor( (((y-y0)/dy) > 0 ) < (Ny-1) ) ; pixel where each sample lives

s = sort(loc) ; sort all the pixels
loc = loc[s]

pix = lindgen(Nx*Ny) ; all POSSIBLE pixel indices (might not all have data!)

v = value_locate(loc, pix)
nv = n_elements(v)

b = -1
for p = 0, nv-1 do begin
	a = b + 1
	b = v[p]
	if b GE a then begin
		i = p mod Nx
		j = p / Nx
		w = s[a:b]
		nw = n_elements(w)
		n[i,j] = nw
	  if nw eq 1 then zb[i,j] = z[w] else zb[i,j] = mean(z[w])
		if nw gt 1 then std[i,j] = stddev(z[w])
	endif
endfor

END