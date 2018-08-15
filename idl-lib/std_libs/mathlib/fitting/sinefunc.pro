PRO Sinefunc, x, A, F, pder

; user supplies X (array of independent variables) and C (array of parameters)

; function is simply F = A[0] * sin(A[1]*x + A[2]) + A[3]

N = 1
s = sin(A[1]*x + A[2])
c = cos(A[1]*x + A[2])
F = A[0] * s + A[3]
if N_Params() ge 4 then pder= [ [s], [A[0]*x*c], [A[0]*c],[x*0+1]]

END