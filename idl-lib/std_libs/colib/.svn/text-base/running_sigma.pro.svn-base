function running_sigma, tod, window=window
; assumes tod is in hour-file format!!!
; WINDOW is the #of hour files to average over.
Nh = n_elements(tod[0,*]) ; # of hour files
if n_elements(window) eq 0 then window  = 1
window = fix(window)
N = Nh-window+1 ; # of final data points
sig = dblarr(Nh)
for i=0,Nh-1 do sig[i] = stddev(tod[*,i])
sigw = sig
wL = window/2
wR = window-1-wL
i1 = window/2
i2 = Nh - 1 - window/2

if window GT 1 then begin
	for i=i1,i2 do begin
		sigw[i] = mean(sig[i-wL:i+wR])
	endfor
	if i1 GT 0 then sig[0:i1-1] = sig[i1]
	if i2 LT (Nh-1) then sig[i2+1:Nh-1] = sig[i2]
endif

return, sigw

end