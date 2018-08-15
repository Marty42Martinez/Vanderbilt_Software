
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+
;
;*NAME: MJD_TO_DATE
;
;*CLASS: UTILITY
;
;*CATEGORY: HRS_ACQUIRE subroutine
;
;*PURPOSE:  Converts Modified Julian Date to YYDDD.FFF
;
;*CALLING SEQUENCE:
;   MJD_TO_DATE,mjd,DOY,DATE
;
;*PARAMETERS:
;   INPUT:
;   mjd  - Modified Julian Date
;   OUTPUT:
;   doy  - Day Number (ddd.fff, fff=> fractional day)
;   date - Date in terms of yyddd.fff
;
;*EXAMPLES:
;   Given new PODPS process Packet Time = 48102.739 (in units of MJD),
;   convert to OLD PODPS process Packet Time
;
;   mjd_to_date,48102.739,doy,date
;   results in:
;   doy = 210.73828 (day number)
;   date = 90211.738 (old packet time)
;
;   Convert DATE to string representation
;
;   old_time=date_conv(date,'s')
;
;   results in old_time='30-JUL-1990 17:44:51.66'
;
;*NOTES:
;   Designed for use with HRS_ACQUIRE routines but should be generic
;
;*MODIFICATION HISTORY:
;   Ver 1.0 - 12/16/91 - Steve Shore - GSFC/CSC
;-
;-------------------------------------------------------------------------------
pro mjd_to_date,mjd,doy,date, jd = jd
if n_params(0) eq 0 then begin
  print,'Calling Sequence: MJD_TO_DATE,mjd,DOY,DATE'
  retall
endif

if keyword_set(jd) then mjd_ = mjd - 2400000.5 else mjd_ = mjd

t0=[47527d,47892,48257,48622,48988,49353,49718,50083,50449,50814,51179,51544]
y0=[89000d,90000,91000,92000,93000,94000,95000,96000,97000,98000,99000,00000]
temp=dblarr(12)
for i=0,11 do temp(i)=mjd_-t0(i)
i=where(temp lt 0)
q=min(i)-1
zero=t0(q)
doy=mjd_-zero
date=y0(q)+doy+1.0 ; extra 1.0 is for MJD
return
end
