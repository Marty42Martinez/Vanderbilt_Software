
Function mapsmooth, image_, width, mask=mask_, boxcar=boxcar, min_weight=min_weight, $
					missing = missing, original=original

; smooths a map with a gaussian kernel.
; will wrap in horizontal (lontitude) direction, but not in vertical (latitude) direction.
; can handle a mask to exclude missing points.

; image_ : the image to smooth
; width  : full kernel width is 2*width + 1.  For a gaussian, this is the FWHM.
;		   for a boxcar, 2*width + 1 equals the full boxcar width (so 1-> 3, 2->5, etc).
; mask   : only include points satisfying the binary (0,1) mask.
; min_weight: the minimum fractional weight to allow for smoothed values. default=0.5
; missing : the value to assign pixels that do not meet the minimum weight requirement. default=0.


	if n_elements(mask_) eq 0 then mask_ = byte(image_*0) + 1
	if n_elements(min_weight) eq 0 then min_weight = 0.5
	if n_elements(missing) eq 0 then missing = 0.0

	if ~keyword_set(boxcar) then begin
		sigma = 0.424661 * width
		TemplateWidth=round(2.5*sigma)
		if templatewidth eq 0 then return, image_
		template = fltarr(2*templatewidth+1, 2*templatewidth+1)
		exponent = template
		i = indgen(2*templatewidth+1) - templatewidth
		for j = 0, 2*templatewidth do exponent[*,j] = -0.5 * ((i+0.)^2 + (j-templatewidth+0.)^2)/sigma^2
		Template = exponent * 0.
		w = where(exponent GT -20.)
		template[w] = exp(exponent[w])
    endif else begin
    	templatewidth = fix(width)
    	if templatewidth eq 0 then return, image_
    	template = fltarr(2*templatewidth+1, 2*templatewidth+1) + 1.
    endelse
    Template = Template / total(template) ; must be normalized.
	n = templatewidth
	; add sufficients rows above & below image.
	sz = size(image_)
	type = sz[sz[0] + 1] ; type code
	image = make_array(type=type, [sz[1], sz[2] + 2*templatewidth], value=0.)
	mask = byte(image)
	image[*, n : sz[2] +n-1] = image_
	mask[*, n : sz[2] + n-1] = mask_

	image = image * mask
	out = image_ * 0.
	weight = out
	for i = -n, n do begin
	for j = -n, n do begin
		w_ij = template[i+n, j+n]
		out = out + (shift(image, i, j) * w_ij)[*, n : sz[2]+n-1]
		weight = weight + (shift(mask, i, j) * w_ij)[*, n:sz[2]+n-1]
	endfor
	endfor

	if keyword_set(original) then weight = weight * mask_

	good = where(weight GE min_weight, ngood, comp=bad, ncomp=nbad)
	if ngood GT 0 then out[good] = out[good]/weight[good]
	if nbad GT 0 then out[bad] = missing

	return, out

end