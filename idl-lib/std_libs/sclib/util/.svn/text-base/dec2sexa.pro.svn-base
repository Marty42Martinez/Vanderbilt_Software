;Converts decimal variable dec to sexadecimal form
;
;DATA: n/a
;CALLS: n/a
;WRITTEN: 6. Mar 98 by SC
;****************************************************************

pro dec2sexa,dec,h,m,s,sexaform,TIME=time

	h=floor(dec)
	m=floor((dec-h)*60)
	s=(((dec-h)*60)-m)*60

	if keyword_set(time) then sexaform='((f7.4,"h",1x,"=",1x,i2,"h",2x,i2,"m",2x,f5.2,"s"),/)' $
	else sexaform='((f7.4,"deg",1x,"=",1x,i2,"deg",2x,i2,"arcmin",2x,f5.2,"arcsec"),/)'
	print,dec,h,m,s,format=sexaform
end