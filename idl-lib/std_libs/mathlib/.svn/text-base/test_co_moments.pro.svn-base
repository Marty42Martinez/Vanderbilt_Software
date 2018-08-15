
; program to test CO_MOMENTS

PRO test_co_moments, x, Ndiv, double=double

; x : the test data set
; Ndiv : rough # of bins to create (default = 10)

n = n_elements(x)

if n_elements(ndiv) eq 0 then Ndiv = 10
if keyword_set(double) then x = double(x)
if keyword_set(double) then ZERO = 0.d else ZERO = 0.
xbar = total(x) / n
std = stddev(x)

; test straight-up application
co_moments, x, x*ZERO, intarr(n)+1, xa1, sa1, na1

; test binned version
; first create binning array
denom = Ndiv / 1.88
nn = round( (randomu(seed, n) * (N/denom)) > 1)
nc = intarr(n)
i = 0
finished = 0
repeat begin
	nc[i+1] = nc[i] + nn[i]
	if nc[i+1] GE n then begin
		nn[i] = nn[i] + (n - nc[i+1])
		nc[i+1] = nc[i] + nn[i]
		finished = 1
	endif
	i = i + 1
endrep until finished
nn = nn[0:i-1]
nc = nc[0:i]

; now create binned data
xb = x[0:i-1] * 0.
sb = xb
nbins = n_elements(nn)
for i = 0, nbins-1 do begin
	this = x[ nc[i] : nc[i+1]-1 ]
	if nn[i] GT 1 then xb[i] = mean(this) else xb[i] = this[0]
	if nn[i] GT 1 then sb[i] = stddev(this) else sb[i] = ZERO
endfor

co_moments, xb, sb, nn, xa2, sa2, na2

print, 'Simple test with unbinned data:'
print, 'Mean = ', xa1, ' , correct mean = ', xbar
print, 'Std = ', sa1, ' , correct std = ', std

print
print, 'Binned test with ' + strcompress(string(nbins), /remove) + ' bins:'
print, 'Mean = ', xa2, ', correct mean = ', xbar
print, 'Std = ', sa2, ' , correct std = ', std


END


