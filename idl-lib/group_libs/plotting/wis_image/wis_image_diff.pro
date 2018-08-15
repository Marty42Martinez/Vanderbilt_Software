PRO wis_image_diff, image1, image2, lat, lon, void=void, _extra=_extra
; wrapper to plot differences of 2 images where they both have coverage.
; both must have same condition for bad data.


if n_elements(void) GT 0 then begin
	err = execute('bad1 = image1 ' + void)
	err = execute('bad2 = image2 ' + void)
	voidpix = where(bad1 OR bad2, comp = wgood)

	diff = image1-image2
	cor = correlate(image1[wgood], image2[wgood])
	wis_image, diff, lat, lon, void=voidpix, _extra=_extra
	print, 'Correlation = ' + num2str(cor, 4)
endif else begin

	wis_image, image1-image2, lat, lon, _extra=_extra

endelse


END





