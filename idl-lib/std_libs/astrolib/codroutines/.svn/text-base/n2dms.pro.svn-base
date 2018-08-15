function n2dms, a

;converts an angle to degrees:minutes:seconds format
; keep up to 3 dec places past dec point.
;print, a, format='(f12.9)'
angle = abs(a)
;print, angle, format='(f12.9)'
d = double(floor(angle))
m = double(floor((angle - d)*60.))
s = ((angle - d)*60.- m)*60.
d = floor(d)
m = floor(m)
;print, s

if d le 9 then d = '0'+sc(d) else d = sc(d)
if m le 9 then m = '0'+sc(m) else m = sc(m)
if s le 9 then s = '0'+num2str(s,3) else s = num2str(s,3)
; elinate trailing 0's on seconds

s = elimtrailzeros(s)
out = d+':'+m+':'+s
if a lt 0 then out = '-'+out

return, out

end