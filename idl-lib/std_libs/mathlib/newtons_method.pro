function newtons_method, function_name, x0, p1_, p2_, p3_, max_iter=max_iter, $
   min_iter=min_iter, tol=tol, iter=iter, _extra=_extra, offset=offset, verbose=verbose, $
   upper=upper, lower=lower

; Perform's newtons' method to find the zero of a user-defined function.  Can do both scalar and vector input.
; For the case of vectors, after each iteration it will only keep working on the cases
; that have not yet converged.  Convergence occurs after each solution has stopped changing by
; a certain fractional amount.

; REQUIRED INPUT PARAMETERS
; function_name : the name of the function which must be of the form described below

; OPTIONAL INPUT PARAMETERS
; x0            : the first guess (default=0), scalar or vector
; p1_           : An extra parameter [scalar or vector] to be passed to the function. ONLY use if x0 set.
; p2_           : An extra parameter [scalar or vector] to be passed to the function. ONLY use if x0 set.
; p3_           : An extra parameter [scalar or vector] to be passed to the function. ONLY use if x0 set.
;
; INPUT KEYWORDS
; max_iter : the maximum number of iterations allowed [default=10], scalar
; min_iter : the min number of iterations to be performed [default=2], scalar
; tol      : solution tolerance [default=1e-5]
; offset   : solve for f(x) = offset instead of f(x) = 0. scalar or vector
; upper    : upper bound for x (used for faster convergence)
; lower    : lower bound for x (used for faster convergence)
; _extra   : extra keyword parameters passed to the function
; verbose  : print a message at each iteration

; OUTPUT KEYWORDS
; iter     : the number of iterations performed (for each x0), same length as x0

; USER-SUPPLIED FUNCTIONAL FORM
;   The user-defined function must take a single scalar or vecto
;   (x) as an input, and return a value of the same dimension as x.
;	It must also calculate the DERIVATIVE of the function with respect to x,
;	and return this in a keyword parameter DERIV.
; 	The function may accept additional input parameters AND/OR keywords.
;	Any additional input parameters of the same dimension as x should be
;	supplied through p1, p2, etc (the additional parameter variables).
;
;   FUNCTION function_name, x [, p1 [, p2 [, p3]]], deriv=deriv, _extra=_extra
;

np = (n_params() - 2) > 0

if n_elements(x0) eq 0 then x0 = 0.
if n_elements(min_iter) eq 0 then min_iter = 2
if n_elements(max_iter) eq 0 then max_iter = 10
if n_elements(tol) eq 0 then tol = 1e-5

n = n_elements(x0) ; number of zeros we're finding
i = 0
x = x0
w = lindgen(n)
count = n
iter = intarr(n)
if n_elements(offset) eq 0 then offset = 0.
offset = offset + 0. * x0 ; make sure offset has correct dimensionality

if np GE 1 then n1 = n_elements(p1_) else n1 = 0
if np GE 2 then n2 = n_elements(p2_) else n2 = 0
if np GE 3 then n3 = n_elements(p3_) else n3 = 0

repeat begin
  i=i+1
  iter[w] = iter[w] + 1
  oldx = x
  if count eq n then begin
  	 if np GE 1 then p1 = p1_
  	 if np GE 2 then p2 = p2_
  	 if np GE 3 then p3 = p3_
  endif else begin
  	 if np GE 1 AND n1 eq n then p1 = p1_[w]
  	 if np GE 2 AND n2 eq n then p2 = p2_[w]
  	 if np GE 3 AND n3 eq n then p3 = p3_[w]
  endelse

  case np of
  0: y = CALL_FUNCTION(function_name, oldx[w], deriv=deriv, _extra=_extra)
  1: y = CALL_FUNCTION(function_name, oldx[w], p1, deriv=deriv, _extra=_extra)
  2: y = CALL_FUNCTION(function_name, oldx[w], p1, p2, deriv=deriv, _extra=_extra)
  3: y = CALL_FUNCTION(function_name, oldx[w], p1, p2, p3, deriv=deriv, _extra=_extra)
  endcase

  x[w] = oldx[w] + (offset-y)/deriv
  if keyword_set(upper) then x = x < upper
  if keyword_set(lower) then x = x > lower
  change = abs((x-oldx)/x) ; fractional change in solution
  if i GE min_iter then w = where(change GT tol, count)
  if keyword_set(verbose) then print, i, x[0], change[0]
endrep until (i GT max_iter) OR (count eq 0)

return, x

END