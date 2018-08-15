pro mkdir, dir

; little windows program to make a directory if it doesn't already exist

	check = findfile( dir, count=direxists )
	if (direxists eq 0) then spawn, 'mkdir '+'"'+dir+'"', /noshell
end