function today_fits
;+
; today_fits
;
; result = today_fits()
; return the current date in the FITS Y2K compliant format
;  ccyy-mm-dd
;
; mainly copied from today() from IDL 5.2
;
;-

if n_elements(ascii_time) eq 0 then $
   ascii_time = systime(0)      ;Current time
a_time=strcompress(ascii_time)  ; compress all those spaces to 1
s = str_sep(a_time, ' ')        ;Separate fields
t = str_sep(s[3], ':')          ;Time fields separated by colon
m = where(strupcase(s[1]) eq $  ; = month  - 1
 ['JAN','FEB','MAR','APR', 'MAY', 'JUN', 'JUL', 'AUG','SEP','OCT','NOV','DEC'])

fdate = STRING([s[4],m[0]+1,s[2]],form='(i4.4,''-'',i2.2,''-'',i2.2)')


return,fdate
end

