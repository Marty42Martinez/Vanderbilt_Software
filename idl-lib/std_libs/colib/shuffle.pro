function shuffle, arr, seed

return, arr(sort(randomu(seed,n_elements(arr))))

end
