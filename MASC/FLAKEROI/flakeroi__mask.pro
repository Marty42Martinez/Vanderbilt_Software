FUNCTION flakeroi::mask

    IF PTR_VALID(self.mask) THEN BEGIN
       RETURN, *self.mask
    ENDIF ELSE BEGIN
       dims       = SIZE(*self.img, /DIMENSIONS)
       maskResult = self -> ComputeMask(DIMENSIONS =[dims[0], dims[1]])
       RETURN,maskResult
    ENDELSE 
    
END
