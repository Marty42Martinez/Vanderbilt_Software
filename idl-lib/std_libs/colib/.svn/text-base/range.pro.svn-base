FUNCTION range, i, i2, n

; Returns an array of integers between two specified integers (inclusively).
;
; CALLING SEQUENCE
;
;  array1 = range(4,10)  (output = [4,5,6,7,8,9,10])
;  array2 = range([4,10]) (output same as above)
;

np = n_params()
case n_params() of
 1: begin ; called with one parameter, must be 2-el array
	  if n_elements(i) le 1 then begin
	    out = 0
	  endif else begin
	    i = reform(i)
	    out = lindgen(i[1]-i[0]+1)+long(i[0])
	  endelse
	end
 2: begin
    if n_elements(i) le 1 then out = (lindgen(i2-i+1) + long(i)) $
      else out= findgen(i2)/(i2-1.) * (i[1]-i[0]) + i[0]
    end
 3: out = findgen(n)/(n-1.) * (i2-i) + i
endcase
return, out

END