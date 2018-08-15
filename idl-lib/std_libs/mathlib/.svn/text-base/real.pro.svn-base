function real, num

; returns the real part of the number num
; if num is double-precision, the result is double precision, else it is float.

typ = size(num, /type)

if (typ eq 5) or (typ eq 9) then return, double(num)

return, float(num)

end