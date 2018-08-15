function bundle, name=name, cnames, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11

; BUNDLE
;
; Bundles together arrays of the SAME length into an ARRAY of STRUCTS (not the other way around).
; The arrays need not be of the same type, just of the same length (if they aren't this will cause errors).
;
; You can have up to 12 arrays.
;
; name: the name of the struct element.  If this is left out, the struct will be anonymous.
; cnames : the names of the struct fields
; a0, a1...a11 : the names of the arrays.  You must have at least 1 array.

np = n_params()-1
N = n_elements(a1)

if n_elements(cnames) ne np then begin
	print, 'The number of field names does not equal the # of fields!'
	return, -1
endif

; Create the fundamental struct element

command = 'fundamental = {'
if keyword_set(name) then command = command + name+','
command = command + cnames[0]+':a0[0]'
for i=1,np-1 do command = command + ','+cnames[i]+':a'+sc(i)+'[0]'
command = command+'}'
err = execute(command)

; Now build up an array of these structs
s = size(a0)
shape = s[1:s[0]]
bund = replicate(fundamental, shape)

; Now fill in the struct
bund.(0) = a0
if np gt 1 then bund.(1) = a1
if np gt 2 then bund.(2) = a2
if np gt 3 then bund.(3) = a3
if np gt 4 then bund.(4) = a4
if np gt 5 then bund.(5) = a5
if np gt 6 then bund.(6) = a6
if np gt 7 then bund.(7) = a7
if np gt 8 then bund.(8) = a8
if np gt 9 then bund.(9) = a9
if np gt 10 then bund.(10) = a10
if np gt 11 then bund.(11) = a11

return, bund

end