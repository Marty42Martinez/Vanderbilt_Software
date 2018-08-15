;converts nxm 2-D matrix to a 1-D vector.

pro arrtovec,arg

dim=size(arg)
out=arg(*,0)
for i=1,(dim(2)-1) do begin
	out=[out,arg(*,i)]
endfor

arg=out

end