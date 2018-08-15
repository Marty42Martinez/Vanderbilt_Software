function richards2, A, x, deriv=deriv, pol=pol

; this program fits for a richards growth curve.


; x: independent variable

; A = parameters = [L,U,Xc,alpha]
; L= lower V asymptote = A[0]
; U = upper V asymptote = A[1]
; Xc = transition location = A[4]
; alpha = x/R dR/dx at x = Xc  = A[5]


B = -2 * A[3,*]/A[2,*]

npix = n_elements(A[0,*])
m =n_elements(x)

out = fltarr(m, npix)

if m LT npix then begin
     for i=0L,m-1 do out[i,*]= A[0,*] + (A[1,*]-A[0,*])/(1 + exp(B*(x[i]-A[4,*])))  
endif else begin   
    for i=0L,npix-1 do out[*,i] = A[0,i] + (A[1,i]-A[0,i])/(1+exp(B[0,i]*(x-A[4,i])))     
endelse

return, out

END
