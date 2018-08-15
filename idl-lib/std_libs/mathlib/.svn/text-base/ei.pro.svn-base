;exponential integral
Nt = 100
logtau = dindgen(Nt)/Nt * 6.0 - 3
tau = 10^logtau
mubar = tau * 0.

N = 1000L
mu0 = (dindgen(N)+1) / N

for i = 0, Nt-1 do begin
  mu = mu0 * 1./tau[i]
  f = exp(-1./mu) * mu
  tf = 2 * tau[i]^2 * int_tabulated(mu, f, /double)
  mubar[i] = -tau[i] / alog(tf)
endfor

plot, tau, mubar, /xlog, yr= [0.4, 1.0],xr = [0.001, 100], ytit = tex('<\mu>'), xtit = tex('\tau')

; Another method
  tf = exp(-tau)*(1-tau) + tau^2 * E1(tau)
  mubar2 = -tau / alog(tf)

oplot, col=50, tau, mubar2

;	 A third: for tau > ~ 10 .

	mubar3 = 1./(1-1/tau*alog(2/tau))
;	mubar4 = 1./(1. - 1/tau*alog(1-tau +tau^2*e1(tau,/cf)))
	oplot, tau(where(tau GE 1.5)), mubar3(where(tau GE 1.5)), col =250
 ; oplot, tau, mubar4, col =200
  B = 0.5772156649 + 0.50
  mubar5 = 0.5 - (B + alog(tau) )* tau/4.
  oplot, tau, mubar5, col = 30
END


