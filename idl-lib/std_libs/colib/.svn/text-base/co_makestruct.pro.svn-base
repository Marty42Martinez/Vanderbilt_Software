function co_makestruct, name=name, cnames, x

; x : data type of every element in the struct
; name : optional name of the struct
; cnames : list of tag names in the struct

n = n_elements(cnames)  ; number of tags

command = 'fundamental = {'
if keyword_set(name) then command = command + name+','
command = command + cnames[0]+':x'
for i=1,n-1 do command = command + ','+cnames[i]+':x'
command = command+'}'
err = execute(command)

return, fundamental

end