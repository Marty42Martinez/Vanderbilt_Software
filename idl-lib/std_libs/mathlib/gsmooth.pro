;+
; Name:  gsmooth
; Purpose: smooth an image with a gaussian template
; Calling-seq: result=gsmooth(image,sigma)
; Inputs: image: a 2d array
;  sigma: standard deviation of the smoothing function
; Author: Robert Velthuizen 020492
;-
Function gsmooth, image, sigma_, FWHM = FWHM

	if keyword_set(FWHM)	then sigma = 0.424661 * sigma_ $
							else sigma=sigma_

	if sigma lt 0.25 then return,image
	TemplateWidth=fix(2*sigma +0.5)
	Template=exp(-0.5*(indgen(TemplateWidth + 1)/sigma)^2)
	Template=Template/(template(0)+2*total(template(1,*)))

	Temp=Template(0)*image
	for i=1,TemplateWidth do $
	   Temp=Temp + Template(i)*(1.0 * shift(image,i,0) + shift(image,-i,0))

	Temp2=Template(0)*Temp
	for i=1,TemplateWidth do $
	   Temp2=Temp2 + Template(i)*(1.0 * shift(Temp,0,i) + shift(Temp,0,-i))

	return,Temp2
end