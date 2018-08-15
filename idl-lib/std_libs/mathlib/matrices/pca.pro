; SIMPLE PCA PROGRAM

FUNCTION PCA, data, mask = mask, eigenvalues = eigenvalues, $
			eigenvectors = eigenvectors, double=double, covar=covar, $
			correlation = correlation

; INPUT VARIABLES/KEYWORDS
; data : matrix where ROWS are your individual channels.  Columns represent different pixels.
; mask : indices of pixels to use in analysis (OPTIONAL, default = all)
; double : Set this keyword to enforce double-precision arithmetic everywhere.
; correlation : act on the CORRELATION between pixels, not the covariance.

; RETURN VALUES
; if success: Matrix containing principle components of data, stored as rows of the matrix.
;	Note: This matrix is for ALL the data, not just the masked-off part.
; if failure: The value -1.

; OUTPUT KEYWORDS
; 	eigenvalues : The variances of the principle components of the data.
; 	eigenvectors : Matrix containing the eigenvectors used to perform the data rotation.
;	covar : The (nchan by nchan) covariance matrix of the original data.


	sd =size(data)
	doub = keyword_set(double)
	correlation = keyword_set(correlation)

	npix = sd[1]
	if sd[0] GT 1 then nchan = sd[2] else nchan = 1

	if nchan eq 1 then begin
		print, 'You only have 1 channel!  Cannot do PCA!'
		return, -1
	endif

	if n_elements(mask) eq 0 then mask = lindgen(npix)

	; construct covariance matrix
	if doub then covar = dblarr(nchan,nchan) else covar = fltarr(nchan, nchan)
	for i = 0, nchan-1 do begin
	for j = i, nchan-1 do begin
		covar[i,j] = correlate(data[mask,i], data[mask,j], covariance=(1-correlation), double=double)
		if i ne j then covar[j,i] = covar[i,j]
	endfor
	endfor

	; Find Eigenvalues and Eigenvectors of Covariance Matrix
	eigenvalues = LA_EIGENQL(covar, EIGENVECTORS=eigenvectors, failed=failed, status=status, double=double)

	; Error Checking
	if status ne 0 then begin
		if failed ne 0 then print, 'FAILED TO CONVERGE FOR THESE EIGENVALUES: ' + strcompress(failed, /remove)
		print, 'FAILED! STATUS = ' + strcompress(status, /remove)
		return, -1
	endif

	; by default, LA_EIGENQL returns eigenvalues in ascending order.  Change to be in DESCENDING order.
	eigenvalues = reverse(eigenvalues)
	eigenvectors = reverse(eigenvectors, 2)

	; now construct principle components

	PC = eigenvectors ## data

	return, PC

END





