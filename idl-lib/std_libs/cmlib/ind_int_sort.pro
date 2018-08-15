function ind_int_SORT, a, b
   flag=[replicate(0b,n_elements(a)),replicate(1b,n_elements(b))]
   s=[a,b]
   srt=sort(s)
   s=s[srt] & flag=flag[srt]
   wh=where(s eq shift(s,-1) and flag ne shift(flag, -1),cnt)
   if cnt eq 0 then return, -1
   return,srt[wh]
end