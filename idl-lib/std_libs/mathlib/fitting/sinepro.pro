PRO SinePRO, x, C, F, pder

; user supplies X (array of independent variables) and C (array of parameters)

; function is simply F = C[0] * sin(C[1]*x + C[2])

N = 1
s = sin(C[1]*x + C[2])
c = cos(C[1]*x + C[2])
F = C[0] * s
if N_Params() ge 4 then $
pder= [ [s], [C[0]*x*c], [C[0]*c] ]

END