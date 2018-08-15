; ----------------------------------------------------------------------
FUNCTION extract_ttype, exthdr
;
;  finds the value (in UPPER CASE and up to the 1st space) 
;  of the keywords TTYPEi from the header of an extension
;   if TTYPEi is not defined, a string equal to i is returned
;   if TTYPEi and TTYPEj are defined with the same value, i and j is
;     returned instead
;
;   March 3, 1999, Eric Hivon, Caltech
;


n_col = ROUND(FLOAT(SXPAR(exthdr,'TFIELDS')))
if n_col eq 0 then begin
    ttype_name = STRING(1)
    return, ttype_name
endif

default_name = STRTRIM( STRING( INDGEN(n_col) + 1, Form='(i2)'), 2)
ttype_name = default_name
for i=0, n_col-1 do begin
    name = STRUPCASE(STRTRIM(SXPAR(exthdr,'TTYPE'+default_name(i)),2))
    name = (STR_SEP(name,' '))(0)  ; up to 1st space
    if name NE '0' then ttype_name(i) = name
endfor

for i=0, n_col-1 do begin
    for j=i+1, n_col-1 do begin
        if (ttype_name(i) EQ ttype_name(j)) then begin
            ttype_name(i) = default_name(i)
            ttype_name(j) = default_name(j)
        endif
    endfor
endfor

return, ttype_name
end
