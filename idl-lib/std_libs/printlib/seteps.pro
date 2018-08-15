PRO seteps, eps, fname, xsize=xsize, ysize=ysize, _extra = _extra, psfont=psfont, $
	grayscale = grayscale

;------------------------------------------------------------------------
; POST-SCRIPT FONTS
;-------------------------------------------
; The post-script fonts available to IDL are:
;AvantGarde-Book  Helvetica-Narrow-Oblique
;AvantGarde-BookOblique  Helvetica-Oblique
;AvantGarde-Demi  NewCenturySchlbk-Bold
;AvantGarde-DemiOblique  NewCenturySchlbk-BoldItalic
;Bookman-Demi  NewCenturySchlbk-Italic
;Bookman-DemiItalic  NewCenturySchlbk-Roman
;Bookman-Light  Palatino-Bold
;Bookman-LightItalic  Palatino-BoldItalic
;Courier  Palatino-Italic
;Courier-Bold  Palatino-Roman
;Courier-BoldOblique  Symbol
;Courier-Oblique  Times-Bold
;Helvetica  Times-BoldItalic
;Helvetica-Bold  Times-Italic
;Helvetica-BoldOblique  Times-Roman
;Helvetica-Narrow  ZapfChancery-MediumItalic
;Helvetica-Narrow-Bold  ZapfDingats
;Helvetica-Narrow-BoldOblique

; For example to set Times-Bold font, do this:
; seteps, 1, 'myfile.eps', psfont = 'Times-Bold'

; instead, you can just use the post-script keywords, listed with
; the PS_SHOW_FONTS command.

; for example, seteps, 1, 'myfile.eps', /times, /bold
;-------------------------------------------------------------------------

if n_elements(xsize) eq 0 then xsize = 7.0
if n_elements(ysize) eq 0 then ysize = 4.5
if n_elements(xoffset) eq 0 then xoffset = 0.
if n_elements(yoffset) eq 0 then yoffset = 11. - ysize


if eps then begin

	; set !oldp to !p
	defsysv, '!oldp', exists=exists
	if exists then !oldp = !p else defsysv, '!oldp', !p
	if keyword_set(psfont) then !p.font = 0

	set_plot, 'PS'
	device, color=(1-keyword_set(grayscale)), xsize=xsize,ysize=ysize, /inches, $
		xoff=xoffset,yoff=yoffset, /portrait, bits = 8, $
		filename = fname, _extra = _extra, set_font = psfont
endif




END