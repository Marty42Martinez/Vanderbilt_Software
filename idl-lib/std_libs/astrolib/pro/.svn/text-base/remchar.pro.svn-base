function remchar,st,char	;Remove character

;I converted this to a function 5/18/2000 (cwo)
;+
; NAME:
;	REMCHAR
; PURPOSE:
;	Remove all appearances of character (char) from string (st)
;
; CALLING SEQUENCE:
;	REMCHAR, ST, CHAR
;
; INPUT-OUTPUT:
;	ST  - String from which character will be removed, scalar or vector
; INPUT:
;	CHAR- Single character to be removed from string or all elements of a
;		string array
;
; EXAMPLE:
;	If a = 'a,b,c,d,e,f,g' then
;
;	IDL> remchar,a, ','
;
;      will give a = 'abcdefg'
;
; REVISIONS HISTORY
;	Written D. Lindler October 1986
;	Test if empty string needs to be returned   W. Landsman  Feb 1991
;	Work on string arrays    W. Landsman   August 1997
;	Converted to IDL V5.0   W. Landsman   September 1997
;-
                                 ;Convert string to byte

 bchar = byte(char) & bchar = bchar[0]          ;Convert character to byte
 outst = st
 for i = 0,N_elements(outst)-1 do  begin
 bst = byte(outst[i])
 good = where( bst NE bchar, Ngood)
 if Ngood GT 0 then outst[i] = string(bst[good]) else outst[i] = ''

 endfor

 return, outst
 end
