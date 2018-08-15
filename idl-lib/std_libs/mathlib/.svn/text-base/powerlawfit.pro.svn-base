function powerlawfit, x,y, yfit=yfit

; finds the best fit to y = y0 * x^(alpha)
; determines y0 and alpha

	lnx = alog(x)
	lny = alog(y)

	lnfit = linfit(lnx,lny,yfit=yfit)

	alpha = lnfit[1]
	y0 = exp(lnfit[0])
	yfit = exp(yfit)

	return, [y0,alpha]

end

