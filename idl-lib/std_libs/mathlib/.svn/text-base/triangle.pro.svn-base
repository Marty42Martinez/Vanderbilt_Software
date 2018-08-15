function triangle, x

; like the "cos" function but makes a triangle wave from -1 to +1
; x has units of radians (just like cosine).

if size(x,/type) eq 4 then pi = !pi else pi = !dpi

return, 2*abs((((x mod (2*pi)) + 2*pi) mod (2*pi))/pi - 1) -1

end