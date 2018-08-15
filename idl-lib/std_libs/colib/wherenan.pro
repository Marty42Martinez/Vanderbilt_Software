function wherenan, x, _ref_extra = _ref_extra

; returns indices where x is NaN (not-a-number).  Returns -1 if no elements of x
; are NaN.


return, where(finite(x ) eq 0, _extra = _ref_extra )

END
