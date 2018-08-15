function trig_exp, beta, nu, b, sine=sine

; performs the integral 3.897 in Gradshteyn and Ryzhik

; sine : if you set this keyword, it will do the sine integral, else the cosine integral.

;c = .577215664901532860606512d 	; Euler's constant
;gamma = exp(c)

e = exp(0.25/beta *complex(nu,b)^2)
phi = m_errorf(0.5/sqrt(beta) * complex(nu,b))
z = e*(1-phi)
A = double(z) ; real part
B = imaginary(z) ; imag part
c = 0.5 * sqrt(!dpi/beta)
if keyword_set(sine) then return, -1 * B * c else return, A * c

end