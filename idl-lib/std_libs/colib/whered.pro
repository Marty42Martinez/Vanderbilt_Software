FUNCTION whereD, index, field

; PURPOSE : Given a list of values as returned by the where command on a field with Nd dimensions,
;						 returns an (Nd by Ni) array of the individual indices for each dimension.
;						If index is a scalar, then the return will simply be a Nd-element array.

;-----------------------------------------------------------------------------------------
; INPUT VARIABLES
;----------------
; CALLING METHOD ONE : USE EXACTLY LIKE WHERE
;	 	* Only pass one parameter
;		index : a scalar or array of "expressions", strictly a byte array of 0s and 1s.
;
;		EXAMPLE:	w = whereD(data gt 4)
;
;	CALLING METHOD TWO: Pass whereD the actual index values as returned by "where".
;		* Requires two parameters:
; index : a scalar or 1D array of indices returned by the where function.
; field : a multi-dimensional field with dimensionality [N1, N2, ...]
;
;		EXAMPLE: i = where(data gt 4)
;						 w = whereD(i, data)
;
;-----------------------------------------------------------------------------------------
; RETURN VARIABLE:
;-----------------
;		an array (either integer or long, depending on what's needed),
;		of dimensionality Nd by Ni, containing the full coordinate indices corresponding
;		to index.  In case of calling method one, returns -1 if no elements meet criterion.

; CWO, 12/2003.

if n_elements(field) eq 0 then begin
;	CALLING METHOD ONE: (use just like where)
	ind = where(index)
	if ind[0] eq -1 then return, -1 else begin
		d= size(index, /dim) ; shape of field
		dmult = n_elements(index) ; size of field
	endelse
endif else begin
;	CALLING METHOD TWO (pass return value of where AND original data array)
	ind = index
	d = size(field, /dim)  ; shape of field
	dmult = n_elements(field) ; size of field
endelse

Nd = n_elements(d)   ; # of dimensions
Ni = n_elements(ind)  ; # of indices to perform calculation on

indexD = intarr(Nd,ni) + ind[0]*0 ; shape of output = [Nd, Ni]

tally = 0 * ind
for i = nd-1, 0, -1 do begin
	dmult = dmult / d[i]
	indexD[i,*] = (ind - tally) / dmult
	tally = tally + indexD[i,*] * dmult
endfor

return, indexD

END



