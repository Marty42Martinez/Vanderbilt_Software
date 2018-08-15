function NUM2STR,x,y
;;;;; This function converts any number to a string, with `y' digits after
;;;;; the dot. `y' is always less than 7.

   if n_elements(y) eq 0 then y = 0
   temp=size(y)
   if ((temp(0) eq 0) and (temp(1) eq 1)) then y=4 $
   else y=max([0,min([y,6])])
   temp=size(x)
   res='0'
   if  (temp(0) eq 0) then $
   if ((temp(1) ge 2) and (temp(1) le 5)) then begin xx=long(x)

      if ((temp(1) eq 4) or (temp(1) eq 5)) then begin
         temp=abs(round(10^y*(x-xx)))
         xx  =xx+ float(temp)/10^y
         xl  =long(xx)
         temp=abs(round(10^y*(xx-xl)))
         res =string(xl)
         str =strcompress(('000000'+string(temp)),/remove_all)
         leng=strlen(str)
         str =strmid(str,leng-y,y)
         if ((temp ge 1) and (str ne '')) then res=res+'.'+str
      endif else res=string(xx)
   endif
   return,strcompress(res,/remove_all)
end