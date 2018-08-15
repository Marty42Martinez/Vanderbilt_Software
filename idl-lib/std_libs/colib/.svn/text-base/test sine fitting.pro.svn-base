; Program to test sine fitting function

N = 1000.

x = findgen(N)/27.
y = 10 * sin(3.*x + 4.5) + randomn(seed,N)*5. -45

yfit = sinefit(x,y,A,/verbose)
plot, x, y
oplot, x, yfit, col = 50, th = 2

END