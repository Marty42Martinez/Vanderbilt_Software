function days_in_month, month_, year_

; month =  number from 1 to 12
if n_elements(year_) eq 0 then year_ = 2001 ; standard non leap year
year = long(year_)
month = fix(month_)


leap =((year / 4 eq year / 4.) AND (year / 100 ne year / 100.)) OR (year/400 eq year/400.)

days = month * 0

w = where(elt( month, [4, 6, 9, 11] ))
if w[0] ne -1 then days[w] = 30

w = where(elt( month, [1,3,5,7,8,10,12] ))
if w[0] ne -1 then days[w] = 31

w = where(elt( month, [2] ))
if w[0] ne -1 then days[w] = 28 + leap
return, days

END