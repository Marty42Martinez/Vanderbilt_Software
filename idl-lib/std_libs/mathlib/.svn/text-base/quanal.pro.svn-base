function QUanal, x, dx

; this function analyzes a segment of data (with error bars)
; and returns some shit in a nifty struct

out = {Qstruct_analyzed, offset:fltarr(2), slope:fltarr(2), rcs:fltarr(3), pval:fltarr(3)}


N = n_elements(x)

cs = total( (x/dx)^2 )
out.rcs[0] = cs/N
out.pval[0] = 1 - chisqr_pdf(cs, N)

;*******************************
; Next find offset

offset = bindata(x, err=dx, werr=werr, 1)
out.offset = [offset[0], werr[0]]

cs = total( ((x-offset[0])/dx)^2 )
out.rcs[1] = cs/(N-1.)
out.pval[1] = 1. - chisqr_pdf(cs, N-1)

;*******************************
; Next Find Slope

hf = findgen(N)
lfit = linfit(hf, x, measure_errors=dx, yfit=yfit, sigma=sigma)
out.slope = [lfit[1], sigma[1]]

cs = total( ((x-yfit)/dx)^2 )

out.rcs[2] = cs/(N-2.)
out.pval[2] = 1. - chisqr_pdf(cs, N-2)

return, out

end