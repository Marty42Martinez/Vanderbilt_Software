function nonzero, x

; Boolean function of whether or not array x has non-zero elements

return, ((where(x))[0] ne -1)

end