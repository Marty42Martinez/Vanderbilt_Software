;-------------------------------------------------------------
;+
; NAME:
;       REFINANCE
; PURPOSE:
;       Explore the costs and benifits of refinancing a loan.
; CATEGORY:
; CALLING SEQUENCE:
;       refinance
; INPUTS:
; KEYWORD PARAMETERS:
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 30 Mar, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro refinance, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Explore the costs and benifits of refinancing a loan.'
	  print,' refinance'
	  print,'   No args, prompts.'
	  return
	endif
 
	print,' '
	print,' ---==< Refinance >==---'
	print,' '
	print,' Explore the costs and benifits of refinancing a loan.'
	print,' '
	print,' --- Current loan ---
	amt0 = ''
	read,' Enter amount left on current loan: ',amt0
	if amt0 eq '' then return
	amt0 = amt0 + 0.
	yi0 = ''
	read,' Enter current yearly interest rate: ',yi0
	if yi0 eq '' then return
	yi0 = yi0 + 0.
	pmt0 = ''
	read,' Enter current monthly payment: ',pmt0
	if pmt0 eq '' then return
	pmt0 = pmt0 + 0.
	ny0 = 100	; Any large value works here.
	print,' '
	print,' --- Possible new loans ---'
	ny1 = ''
	read,' Enter number of years for loan: ',ny1
	if ny1 eq '' then return
	ny1 = ny1 + 0.
	print,' May enter a list of potential interest rates'
	print,' and a list of corresponding of points.'
	print,' Spaces, tabs, and commas are allowed.'
	print,' '
	ir1 = ''
        read,' Enter list of potential interest rates: ',ir1
        if ir1 eq '' then return
	ir1 = repchr(ir1,',')
	wordarray, ir1, ir
        ir = ir + 0.
	pt1 = ''
        read,' Enter list of corresponding points: ',pt1
        if pt1 eq '' then return
	pt1 = repchr(pt1,',')
	wordarray, pt1, pt
        pt = pt + 0.
	n_tests = n_elements(ir)
	if n_elements(ir) ne n_elements(pt) then begin
	  bell
	  print,' Must have same number of points as interest rates.'
	  return
	endif
	clcst = ''
	print,' '
	print,' CLosing costs are typically about 3% of the loan amount.'
	read,' Enter estimated closing costs in dollars: ',clcst
	if clcst eq '' then return
	clcst = clcst + 0.
	flag = ''
	print,' '
	print,' Closing costs and points may be paid up front or'
	print,' added to the loan.'
	read,' Add closing costs and points to loan? y/n: ',flag
	flag = strupcase(flag)
	print,' '
	extra = ''
	print,' For payment you may enter actual payment or how much'
	print,' extra (above required) to pay on principal.  To specify'
	print,' extra enter it as a negative value.'
	read,' Enter payment: ',extra
	extra = extra + 0.
 
	fmd = '(a,"$",f10.2)'
	fmp = '(a,f7.4)'
	fmr = '(a,f7.4)'
	print,' '
	print,' ---------  Original loan  -------------'
	mort,amt0,yi0,ny0,pmt0,/nolist,sum=sum
	print,' Amount remaining:       ',amt0+0.,form=fmd
	print,' Yearly interest rate:   ',yi0+0.,form=fmr
	print,' Total remaining cost:   ',sum(0),form=fmd
	print,' Cost of credit:         ',sum(1),form=fmd
	print,' Number of payments:     ',fix(sum(4))
	print,' Actual monthly payment: ',pmt0+0.,form=fmd
 
	print,' '
	print,' ---------  Potential loans  ------------'
	for i = 0, n_tests-1 do begin
	  amt = amt0+0.
	  pt_costs = amt*pt(i)/100.
	  if flag eq 'Y' then amt = amt + pt_costs + clcst
	  mort,amt,ir(i),ny1,extra,/nolist,sum=sum
	  print,' Total loan amount:        ',amt, form=fmd
	  print,' Yearly interest rate:     ',ir(i), form=fmr
	  print,' Points:                   ',pt(i), form=fmp
	  print,' Closing costs:            ',clcst, form=fmd
	  if flag eq 'Y' then begin
	    print,' Points and closing costs added to loan.'
	    print,' Total cost:               ',sum(0), form=fmd
	    print,' Cost of credit:           ',sum(1), form=fmd
	  endif else begin
	    print,' Points and closing costs paid up front.'
	    print,' Total cost:               ',sum(0)+pt_costs+clcst, form=fmd
	    print,' Cost of credit:           ',sum(1)+pt_costs+clcst, form=fmd
	  endelse
	  print,' Number of payments:       ',fix(sum(4))
	  print,' Minimum required payment: ',sum(5), form=fmd
	  tmp = extra
	  if extra lt 0 then tmp = sum(5) - extra
	  print,' Actual monthly payment:   ',tmp, form=fmd
	  print,' '
	endfor
 
	return
	end
