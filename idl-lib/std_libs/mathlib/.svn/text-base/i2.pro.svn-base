function I2, m, df, a

dt = 0.049855

; returns the integral i need right now
; df = fny - f*
; m = integer you're on (lag)

; a[0] = squared coeff, a[1] = cubic coeff, a[2] = quartic coeff

R = 2 * !Pi * m * dt
S = sin(2*R*df)
C = cos(2*R*df)

term1 = a[0] * ( df^2/R*S + 2*df/R^2*C - 2/R^3*S )
term2 = a[1] * ( df^3/R*S + 3*df^2/R^2*C - 6*df/R^3*S - 6/R^4 * C)
term3 = a[2] * ( df^4/R*S + 4*df^3/R^2*C - 12*df^2/R^3*S - 24*df/R^4*C + 24/R^5*S )

return, term1+term2+term3

end
