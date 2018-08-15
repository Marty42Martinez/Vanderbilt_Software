function filterfunc, f, fc=fc, n=n

if n_elements(fc) eq 0 then fc = 5.0 ; Hz

if n_elements(n) eq 0 then n = 2
;f is the set of frequencies;

;fuctional form is  bandpass= 1/(1+(f/fc)^2)

return, 2.4/(1.+(f/fc)^n)

end