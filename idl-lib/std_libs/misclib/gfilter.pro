;***********************************************************************
;+
;*NAME:
;
;    GFILTER
;
;*CLASS:
;
;    numerical function
;
;*CATEGORY:
;
;*PURPOSE:
;
;    To convolve a 1- or 2-dimensional gaussian point spread function
;    with the specified input array.
;
;*CALLING SEQUENCE:
;
;    GFILTER,Y,NPT,SIG,NEWY
;
;*PARAMETERS:
;
;    Y     (REQ) (I) (12) (BILFD)
;          Required input vector or array  (e.g., flux vector or image)
;
;    NPT   (REQ) (I) (0)   (F D)
;          Required scalar giving the number of data points to be included
;          in the Gaussian filter. Even values are converted to the next
;          lowest odd number.
;
;    SIG   (REQ) (I) (01) (F D)
;          Width of Gaussian (i.e., standard deviation) in units of X
;          For a 2-dimensional Gaussian with a non-symmetrical profile,
;          specify both an x & y value as a 2-element vector.
;
;    NEWY  (REQ) (O) (12) (F D)
;          Filtered Y vector or array.
;
;*EXAMPLES:
;
;    Apply a 9-point Gaussian filter with a sigma of 2.0 to Y:
;          gfilter,y,9,2.0,newy
;
;    Apply a 7x7 Gaussian with a x-sigma of 3.0 and a y-sigma of 2.5
;    to array IMAGE:
;          gfilter,image,7,[3.0,2.5],nimage
;
;
;*SYSTEM VARIABLES USED:
;
;*INTERACTIVE INPUT:
;
;*SUBROUTINES CALLED:
;
;     PARCHECK
;
;*FILES USED:
;
;*SIDE EFFECTS:
;
;*RESTRICTIONS:
;
;*NOTES:
;
;    - The first and last (npt-1)/2 data points are not changed.
;    - Even values for NPT are converted to odd numbers by
;      subtracting 1.
;
;       tested with IDL Version 2.1.0 (sunos sparc)     25 Jun 91
;       tested with IDL Version 2.1.0 (ultrix mispel)   N/A
;       tested with IDL Version 2.1.0 (vms vax)         25 Jun 91
;
;*PROCEDURE:
;
;*MODIFICATION HISTORY:
;
;    Based on GAUSSFILTER by WSPOCK
;    Oct 19 1994  RWT GSFC  modify to use variables as input
;    Nov 30 1994  RWT GSFC  add support for 2-D arrays and use
;                           gausspsf to derive gaussian profile
;
;-
;***********************************************************************
pro gfilter,y,npt,sig,newy
npar=n_params()
if (npar eq 0) then begin
   print,' gfilter,y,npt,sig,newy'
   retall
endif
parcheck,npar,[4],'GFILTER'
pcheck,y,2,011,0001         ; allow 1- or 2-dim arrays of floating pt values
if (npt mod 2) then npt = (npt - 1) > 1
siz = size(y)
;
; calculate gaussian function to be used in filter
; use input Y parameter to determine dimensions
;
nn = npt
gausspsf,nn,g,ndim=siz(0),stdev=sig,/normalize
;k = indgen(npt)
;mean = total(k) / npt
;diffsq=(k-mean)^2
;sigmasq=(total(diffsq))/npt
;g=exp((diffsq)/(-2*sigmasq))
;if sig ne 0 then begin
;    arg=(abs((k-mean)/sig)<9.)   ; set values 9 sigma to 0 to avoid trap errors
;    g=exp(-arg*arg/2)*(arg lt 9.0)
;endif else g=(0.*x)*(x ne mean)+(x eq mean) ; if sig eq 0 return delta function
gsum=total(g)
;
newy = y                  ; define all points not convolved
inc=(npt-1)/2             ; width of Gaussian & width of area not convolved
;
;     To calculate new y vector, extract NPT points from y,
;     multiply by weighting function, G, sum the elements of the
;     resulting product, and normalize by dividing by GSUM.
;
case siz(0) of

1: begin
     num=siz(1)
     j=0
     while ((j+npt) le num) do begin
         dum = (total(g*(y(j:j+npt-1)))) / gsum
         newy(j+inc)= dum
         j=j+1
     endwhile
     end

2: begin
     num = siz(1)
     nnum = siz(2)
     n = 0
     while ((n+npt) le nnum) do begin         ; y increment
            j = 0
            i = inc
            while ((j+npt) le num) do begin   ; x increment
                dum = (total(g*(y(j:j+npt-1,n:n+npt-1))))
                newy(j+inc,n+inc)= dum
                j = j + 1
                i = i + 1
            endwhile
     n = n + 1
     endwhile
    end

 endcase
;
return
end    ; gfilter