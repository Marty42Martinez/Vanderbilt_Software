PRO removeduplicates, x, y

; X and Y are 2 equal-dimension numerical arrays.  All duplicate x-entries are removed,
; and the single remaining entry takes on the average of the y-values. (assumes x array is sorted)

N = n_elements(x)
xout = x*0
yout = y*0
j = 0
i = 0
for i=0L, N-1 do begin
  w = where(x eq x[i])
  if n_elements(w) gt 1 then begin; duplicates found
     xout[j] = x[i]
     yout[j] = mean(y(w))
     i = i + n_elements(w) -1L
  endif else begin
     xout[j] = x[i]
     yout[j] = y[i]
  endelse
  j = j+1
endfor
x = xout[0:j-1]
y = yout[0:j-1]
endre