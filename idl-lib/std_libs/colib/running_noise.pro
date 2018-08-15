function running_noise, tod, window=window, _extra=_extra

; assumes tod is in hour-file format!!!
; WINDOW is the #of hour files to average over.
Nh = n_elements(tod[0,*]) ; # of hour files
if n_elements(window) eq 0 then window  = 1
N = Nh-window+1 ; # of final data points

copsd, tod[*,0:0+window-1], /nograph, info=infostruct, _extra=_extra

info = replicate(infostruct, N)
for i=1,N-1 do begin
	copsd,tod[*,i:i+window-1],/nograph,info=infostruct, _extra=_extra
	info[i] = infostruct
endfor

return, info

end