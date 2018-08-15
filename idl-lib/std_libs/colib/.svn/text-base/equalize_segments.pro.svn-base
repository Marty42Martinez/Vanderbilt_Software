function equalize_segments, data, segments

; segments : output from the "segment.pro" function
; data : your data

ns = n_elements(segments[*,0])



for i=0,ns -1 do begin
	r = range(segments[i,*])
	if i eq 0 then out = data[r] - mean(data[r]) else out = [out, data[r]-mean(data[r])]
endfor

return, out

end
