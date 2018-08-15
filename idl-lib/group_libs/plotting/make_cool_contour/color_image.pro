function color_image ,in, mini=mini, maxi=maxi

	idx=where(finite(in),co)
	if co eq 0 then return,in
	if keyword_set(mini) then min_in=mini else min_in=min(in[idx])
	if keyword_set(maxi) then max_in=maxi else max_in=max(in[idx])

	inin =in[idx] > min_in
	inin =inin < max_in

	inin=float(float(inin-min_in)/float(max_in-min_in)*255.)

	color_convert,(1.-bytscl(inin)/255.)*240.,inin*0.+1.,inin*0.+1.,r,g,b,/hsv_rgb


	rr=byte(in*0)
	gg=rr
	bb=rr
	;stop
	rr[idx]=r
	gg[idx]=g
	bb[idx]=b

	;stop
	return,byte([[[rr]],[[gg]],[[bb]]])

end
