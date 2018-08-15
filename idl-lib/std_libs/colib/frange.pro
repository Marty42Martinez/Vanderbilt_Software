FUNCTION frange, x0, x1, n

; Returns an array of integers between two specified integers (inclusively).
;
; CALLING SEQUENCE
;
;  array1 = range(4,10)  (output = [4,5,6,7,8,9,10])
;  array2 = range([4,10]) (output same as above)
;

return, findgen(n)/(n-1) * (x1-x0) + x0

END