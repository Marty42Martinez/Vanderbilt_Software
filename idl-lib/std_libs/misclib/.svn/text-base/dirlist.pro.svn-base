;************************************************************************
;+
;*NAME:
;
;  	DIRLIST
;
;*CLASS:
;
;	File Display
;
;*CATEGORY:
;
;*PURPOSE:
;
;       To create directory listings without spawning to system commands
;       (i.e., to partially emulate vms DIR or unix ls commands).
;
;*CALLING SEQUENCE:
;
;  	DIRLIST,FNAME,slist,num,out=ofn,nopath=nopath,noprint=noprint
;
;*PARAMETERS:
;
;       FNAME (REQ) (I) (0) (S)
;               file name (with or without wildcards).
;
;       SLIST (OPT) (O) (01) (S)
;               string array of found files.
;
;       NUM    (OPT) (O) (01) (S)
;               number of files found.
;
;       out   (OPT) (I) (1) (S)
;               Optional name for writing directory listing to an output
;               file. If specified, listing is not displayed on terminal.
;
;       nopath   (OPT) (I) (1) (S)
;               Optional keyword for removing the full path name from the
;               directory listing. Only name and extension are output.
;
;       noprint   (OPT) (I) (1) (S)
;               Optional keyword for preventing display of directory
;               listing.
;
;*SYSTEM VARIABLES USED:
;
;	none
;
;*INTERACTIVE INPUT:
;
;*SUBROUTINES CALLED:
;
;    	PARCHECK
;
;*FILES USED:
;
;        OFN - optional output file containing directory listing
;              (default extension is .lis)
;
;*SIDE EFFECTS:
;
;*RESTRICTIONS:
;
;*NOTES:
;
;*PROCEDURE:
;
;        Uses findfile to locate files.
;
;*I_HELP nn:
;
;*EXAMPLES:
;
;
;*MODIFICATION HISTORY:
;
;      	Written by R. Thompson 3/15/95
;
;-
;************************************************************************
 pro dirlist,fname,slist,num,out=ofn,nopath=nopath,noprint=noprint
;
 npar = n_params(0)
 if npar eq 0 then begin
    print,' DIRLIST,FNAME,slist,num,out=ofn,nopath=nopath,noprint=noprint'
    retall
 endif  ; npar
 parcheck,npar,[1,2,3],'dirlist'
;
; initialize parameters
;
i = 0
ans = ''
otxt = strarr(900)
slist = findfile(fname,count=num)
if (num le 0) then return
;
; initialize parameters & open output file (if any)
;
if (keyword_set(ofn)) then begin
   decompose,ofn,dis,uic,fnam,ex,ve
   if (ex eq '') then ex = '.lis'
   ofn = dis + uic + fnam + ex + ve
   openw,lu1,ofn,/get_lun
endif else lu1 = -1
;
; print out each entry in file list
;
for j=0,num-1 do begin
      nam = slist(j)
      if (keyword_set(nopath)) then begin
          decompose,nam,dis,uic,fnam,ex,ve
          nam = fnam + ex
          slist(j) = nam
      endif
      hform = string(bytarr(80) + 32b)
      hform(0) = nam
      if (lu1 ne -1) then printf,lu1,hform else $
      if (not keyword_set(noprint)) then printf,lu1,hform
endfor
if (lu1 ne -1) then free_lun,lu1
;
return
end  ; dirlist

