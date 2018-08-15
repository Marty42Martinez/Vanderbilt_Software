function cor_variance, x1, x2, max_element = max_element

if n_params() lt 2 then x2=x1
cc = covar(x1,x2)
m = n_elements(cc)-1
if (n_elements(max_element) ne 0) then if (m gt max_element) then m=max_element
return, mean((cc[1:m])^2)  ; mean variance in micro-K^2 as function of lag
end