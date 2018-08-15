pro gaussmoment, channel, binsz, mu, sigma

hist = histogram(channel, binsize = binsz)

histox = findgen(N_ELEMENTS(hist))*binsz + min(channel) + 0.5*binsz

gfit = gaussfit(histox,hist,gparam,n=3)
sigma=gparam[2]
mu = gparam[1]

end