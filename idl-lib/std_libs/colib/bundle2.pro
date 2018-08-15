function bundle2, name=name, cnames, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, $
							a10, a11, a12, a13, a14, a15, a16, a17, a18, a19

; BUNDLE2
;
; Bundles together ANYTHING into a struct.  this is a struct, not an array of structs. (unlike bundle).
;
; You can have up to 20 variables.
;
; name: the name of the struct element.  If this is left out, the struct will be anonymous.
; cnames : the names of the struct fields
; a0, a1...a20 : the variables to bundle together.  You must have at least 1 variable.

np = n_params()-1
N = n_elements(a1)

if n_elements(cnames) ne np then begin
	print, 'The number of field names does not equal the # of fields!'
	return, -1
endif

; Create the fundamental struct element

command = 'fundamental = {'
if keyword_set(name) then command = command + name+','
command = command + cnames[0]+':a0'
for i=1,np-1 do command = command + ','+cnames[i]+':a'+strcompress(i,/rem)
command = command+'}'
err = execute(command)

return, fundamental

end