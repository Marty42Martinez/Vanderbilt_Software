function corr_sig, r, df, one_tail=one_tail
;--------------------------------------------------------------------
; INPUTS:
;   r: correlation coefficient between the two data sets
;   df: the degrees of freedom
;   one_tail: set to get the 1-tailed t-score, other it's 2-tailed
;
; RETURN: significance of the correlation
;--------------------------------------------------------------------

T = r * SQRT((df-2)/(1-r*r))

if(keyword_set(one_tail))then begin
 return,1 - 0.5 * ibeta(0.5*df, 0.5, df/(df+t^2))
endif else begin
 return,1 - ibeta(0.5*df, 0.5, df/(df+t^2))
endelse

END
