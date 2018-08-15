;calculates and removes offset from array "sigarr", ignoring any zero values
pro nozav,sigarr

;offind=where((sigarr ne 0),count)
;offset = total(sigarr(offind))/count

;this works too (and it's quicker)

offset=total(sigarr)/total(sigarr ne 0)



print,'The total offset is ',offset

offsetarr=sigarr
offsetarr(*,*)=offset
sigarr=sigarr-offsetarr*(sigarr ne 0)

end

