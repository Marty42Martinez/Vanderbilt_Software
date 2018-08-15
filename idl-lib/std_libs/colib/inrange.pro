FUNCTION Inrange, x, range_

valid = 0.

if ( (x ge range_[0]) AND (x le range_[1]) ) then valid=1.

return, valid

END