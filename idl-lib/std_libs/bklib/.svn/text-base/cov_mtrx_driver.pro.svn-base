pro POLAR_Ctheory, cl_file, lmax, fwhm, npix, C_e, C_b

; in version 1, only do Q,U option (no T).

; this computes the cov. matrix for a ring-like scan strategy, at some constant declination.

LoadCl, cl_file, TT, EE, BB, TE

beam = getBl(fwhm, lmax)




!x.style=1.
plot,theta/!dtor,qq/1e-12,/xl, xr = [.01,20], $
title = 'Q & U Real Space Correlation Functions',$
xtitle = 'Angle [deg]',ytitle = "Q(n)Q(n') [uK^2]"
oplot,theta/!dtor,uu/1e-12, col = 55, linestyle = 1
tq[0:4] = 0.
oplot,theta/!dtor,tq/1e-12/3, linestyle = 2, col = 155
legend,['<QQ>', '<UU>', '<TQ>/3'],linestyle=[0,1,2],/top,/right, colors = [0,55,155]
 sdfgs
end