;+
; NAME:
;   TNMIN
;
; AUTHOR:
;   Craig B. Markwardt, NASA/GSFC Code 662, Greenbelt, MD 20770
;   craigm@lheamail.gsfc.nasa.gov
;   UPDATED VERSIONs can be found on my WEB PAGE: 
;      http://cow.physics.wisc.edu/~craigm/idl/idl.html
;
; PURPOSE:
;   Performs Truncated-Newton function minimization (with gradients).
;
; MAJOR TOPICS:
;   Optimization and Minimization
;
; CALLING SEQUENCE:
;   parms = TNMIN(MYFUNCT, start_parms, FUNCTARGS=fcnargs, NFEV=nfev,
;                 MAXITER=maxiter, ERRMSG=errmsg, NPRINT=nprint,
;                 QUIET=quiet, XTOL=xtol, STATUS=status, 
;                 FGUESS=fguess, PARINFO=parinfo, BESTMIN=bestmin,
;                 ITERPROC=iterproc, ITERARGS=iterargs, niter=niter)
;
; DESCRIPTION:
;
;  TNMIN uses the Truncated-Newton method to minimize an arbitrary IDL
;  function with respect to a given set of free parameters.  The
;  user-supplied function must compute the gradient with respect to
;  each parameter.
;
;  If you want to solve a least-squares problem, to perform *curve*
;  *fitting*, then you will probably want to use the routines MPFIT,
;  MPFITFUN and MPFITEXPR.  Those routines are specifically optimized
;  for the least-squares problem.  TNMIN is suitable for cases where a
;  single function depends on several (possibly many) parameters and
;  it should be minimized.  [ Maximization can also be performed if
;  the IDL routine returns the *negative* of the desired function. ]
;
;  TNMIN is similar to MPFIT in that it allows parameters to be fixed,
;  simple bounding limits to be placed on parameter values, and
;  parameters to be tied to other parameters.  See PARINFO below for
;  discussion and examples.
;
;  There are a few simple constraints on the IDL function.  It must
;  accept a list of "parameters" (and optionally other data wich aids
;  in computing the function), and compute the value of the function
;  and its derivatives (see MYFUNCT below).
;
;  TNMIN is based on TN.F by Stephen Nash.
;
; INPUTS:
;   MYFUNCT - a string variable containing the name of the function to
;             be minimized.  The IDL routine should return the value
;             of the function and its gradients.  It should be
;             declared in the following way (or in some equivalent):
;
;             ** MYFUNCT must accept at least one keyword parameter ***
;             FUNCTION MYFUNCT, p, dp, X=x, Y=y
;              ; Parameter values are passed in "p"
;              ; Calculation of the function value
;              f = p(0)+2*p(2)-17*p(1)^2
;              dp = dblarr(n_elements(p))
;              ; Calculation of each gradient component
;              dp(0) = 1 & dp(1) = 2 & dp(3) = -34D*p(1)
;              ; Return the function value
;              return, f
;             END
;             ** MYFUNCT must accept at least one keyword parameter ***
;
;             The keyword parameters X, Y in the example above are
;             suggestive but not required (if for example the function
;             depends on X and Y data).  Any parameters can be passed
;             to MYFUNCT by using the FUNCTARGS keyword to TNMIN.
;
;             You must compute gradient components analytically (TNMIN
;             does not have any provision to perform a numerical
;             derivative).  The IDL routine should compute the
;             gradient of the function as a one-dimensional array of
;             values, one for each of the parameters.  They are passed
;             back to TNMIN via "dp" as shown above.
;             
;             The derivatives with respect to fixed parameters are
;             ignored; zero is an appropriate value to insert for
;             those derivatives.  
;
;   START_PARAMS - An array of starting values for each of the
;                  parameters of the model.
;
;                  This parameter is optional if the PARINFO keyword
;                  is used.  See below.  The PARINFO keyword provides
;                  a mechanism to fix or constrain individual
;                  parameters.  If both START_PARAMS and PARINFO are
;                  passed, then the starting *value* is taken from
;                  START_PARAMS, but the *constraints* are taken from
;                  PARINFO.
; 
;
; RETURNS:
;
;   Returns the array of best-fit parameters.
;
;
; KEYWORD PARAMETERS:
;
;   BESTMIN - the best minimum function value that TNMIN could find.
;
;   ERRMSG - a string error or warning message is returned.
;
;   FGUESS - provides the routine a guess to the minimum value.
;            Default: 0
;
;   FUNCTARGS - A structure which contains the parameters to be passed
;               to the user-supplied function specified by MYFUNCT via
;               the _EXTRA mechanism.  This is the way you can pass
;               additional data to your user-supplied function without
;               using common blocks.
;
;               Consider the following example:
;                if FUNCTARGS = { XVAL:[1.D,2,3], YVAL:[1.D,4,9]}
;                then the user supplied function should be declared
;                like this:
;                FUNCTION MYFUNCT, P, XVAL=x, YVAL=y
;
;               By default, no extra parameters are passed to the
;               user-supplied function.
;
;   ITERARGS - The keyword arguments to be passed to ITERPROC via the
;              _EXTRA mechanism.  This should be a structure, and is
;              similar in operation to FUNCTARGS.
;              Default: no arguments are passed.
;
;   ITERPROC - The name of a procedure to be called upon each NPRINT
;              iteration of the MPFIT routine.  It should be declared
;              in the following way:
;
;              PRO ITERPROC, MYFUNCT, p, iter, fnorm, FUNCTARGS=fcnargs, $
;                PARINFO=parinfo, QUIET=quiet, ...
;                ; perform custom iteration update
;              END
;         
;              ITERPROC must either accept all three keyword
;              parameters (FUNCTARGS, PARINFO and QUIET), or at least
;              accept them via the _EXTRA keyword.
;          
;              MYFUNCT is the user-supplied function to be minimized,
;              P is the current set of model parameters, ITER is the
;              iteration number, and FUNCTARGS are the arguments to be
;              passed to MYFUNCT.  FNORM is should be the function
;              value.  QUIET is set when no textual output should be
;              printed.  See below for documentation of PARINFO.
;
;              In implementation, ITERPROC can perform updates to the
;              terminal or graphical user interface, to provide
;              feedback while the fit proceeds.  If the fit is to be
;              stopped for any reason, then ITERPROC should set the
;              common block variable ERROR_CODE to negative value (see
;              MPFIT_ERROR common block below).  In principle,
;              ITERPROC should probably not modify the parameter
;              values, because it may interfere with the algorithm's
;              stability.  In practice it is allowed.
;
;              Default: an internal routine is used to print the
;                       parameter values.
;
;   MAXITER - The maximum number of iterations to perform.  If the
;             number is exceeded, then the STATUS value is set to 5
;             and MPFIT returns.
;             Default: 200 iterations
;
;   NFEV - the number of MYFUNCT function evaluations performed.
;
;   NITER - number of iterations completed.
;
;   NPRINT - The frequency with which ITERPROC is called.  A value of
;            1 indicates that ITERPROC is called with every iteration,
;            while 2 indicates every other iteration, etc.  
;            Default value: 1
;
;   PARINFO - Provides a mechanism for more sophisticated constraints
;             to be placed on parameter values.  When PARINFO is not
;             passed, then it is assumed that all parameters are free
;             and unconstrained.  In no case are values in PARINFO
;             modified during a call to MPFIT.
;
;             PARINFO should be an array of structures, one for each
;             parameter.  Each parameter is associated with one
;             element of the array, in numerical order.  The structure
;             can have the following entries (none are required):
;
;               - VALUE - the starting parameter value (but see
;                         START_PARAMS above).
;
;               - FIXED - a boolean value, whether the parameter is to 
;                         be held fixed or not.  Fixed parameters are
;                         not varied by MPFIT, but are passed on to 
;                         MYFUNCT for evaluation.
;
;               - LIMITED - a two-element boolean array.  If the
;                 first/second element is set, then the parameter is
;                 bounded on the lower/upper side.  A parameter can be
;                 bounded on both sides.  Both LIMITED and LIMITS must
;                 be given together.
;
;               - LIMITS - a two-element float or double array.  Gives
;                 the parameter limits on the lower and upper sides,
;                 respectively.  Zero, one or two of these values can
;                 be set, depending on the value of LIMITED.  Both 
;                 LIMITED and LIMITS must be given together.
;
;               - TIED - a string expression which "ties" the
;                 parameter to other free or fixed parameters.  Any
;                 expression involving constants and the parameter
;                 array P are permitted.  Example: if parameter 2 is
;                 always to be twice parameter 1 then use the
;                 following: parinfo(2).tied = '2 * P(1)'.  Since they
;                 are totally constrained, tied parameters are
;                 considered to be fixed; no errors are computed for
;                 them.
; 
;             Other tag values can also be given in the structure, but
;             they are ignored.
;
;             Example:
;             parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
;                                  limits:[0.D,0]}, 5)
;             parinfo(0).fixed = 1
;             parinfo(4).limited(0) = 1
;             parinfo(4).limits(0)  = 50.D
;             parinfo(*).value = [5.7D, 2.2, 500., 1.5, 2000.]
;
;             A total of 5 parameters, with starting values of 5.7,
;             2.2, 500, 1.5, and 2000 are given.  The first parameter
;             is fixed at a value of 5.7, and the last parameter is
;             constrained to be above 50.
;
;             Default value:  all parameters are free and unconstrained.
;
;   QUIET - set this keyword when no textual output should be printed
;           by MPFIT
;
;   STATUS - NOT IMPLEMENTED
;
;   XTOL - a nonnegative input variable. Termination occurs when the
;          relative error between two consecutive iterates is at most
;          XTOL. therefore, XTOL measures the relative error desired
;          in the approximate solution.
;          Default: 1D-10
;
;
; EXAMPLE:
;
;   FUNCTION F, X, DF, _EXTRA=extra  ;; *** MUST ACCEPT KEYWORDS
;     F  = (X(0)-1)^2 + (X(1)+7)^2
;     DF = [ 2D * (X(0)-1), 2D * (X(1)+7) ] ; Gradient
;     RETURN, F
;   END
;
;   P = TNMIN('F', [0D, 0D], BESTMIN=F0)
;   Minimizes the function F(x0,x1) = (x0-1)^2 + (x1+7)^2.
;
;
; COMMON BLOCKS:
;
;   COMMON TNMIN_ERROR, ERROR_CODE
;
;     User routines may stop the fitting process at any time by
;     setting an error condition.  This condition may be set in either
;     the user's model computation routine (MYFUNCT), or in the
;     iteration procedure (ITERPROC).
;
;     To stop the fitting, the above common block must be declared,
;     and ERROR_CODE must be set to a negative number.  After the user
;     procedure or function returns, TNMIN checks the value of this
;     common block variable and exits immediately if the error
;     condition has been set.  By default the value of ERROR_CODE is
;     zero, indicating a successful function/procedure call.
;
;
; REFERENCES:
;
;   TRUNCATED-NEWTON METHOD, TN.F
;      Stephen G. Nash, Operations Research and Applied Statistics
;      Department
;
; MODIFICATION HISTORY:
;   Derived from TN.F by Stephen Nash with many changes and additions,
;      to conform to MPFIT paradigm, 19 Jan 1999, CM
;   Changed web address to COW, 25 Sep 1999, CM
;   Alphabetized documented keyword parameters, 02 Oct 1999, CM
;   Changed to ERROR_CODE for error condition, 28 Jan 2000, CM
;
;-
; Copyright (C) 1998-2000, Craig Markwardt
; This software is provided as is without any warranty whatsoever.
; Permission to use, copy and distribute unmodified copies for
; non-commercial purposes, and to modify and use for personal or
; internal use, is granted.  All other rights are reserved.
;-

common tnmin_error, error_code
forward_function tnmin_enorm, tnmin_step1, tnmin

;%% TRUNCATED-NEWTON METHOD:  SUBROUTINES
;   FOR OTHER MACHINES, MODIFY ROUTINE MCHPR1 (MACHINE EPSILON)
;   WRITTEN BY:  STEPHEN G. NASH
;                OPERATIONS RESEARCH AND APPLIED STATISTICS DEPT.
;                GEORGE MASON UNIVERSITY
;                FAIRFAX, VA 22030
;******************************************************************

;; Following are machine constants that can be loaded once.  I have
;; found that bizarre underflow messages can be produced in each call
;; to MACHAR(), so this structure minimizes the number of calls to
;; one.
pro tnmin_setmachar, double=double
  common tnmin_dmachar, dmachep, dmaxnum, dminnum, dmaxlog, dminlog, dmaxgam
  common tnmin_fmachar, fmachep, fmaxnum, fminnum, fmaxlog, fminlog, fmaxgam
  if NOT keyword_set(double) then begin
      if n_elements(fmachep) GT 0 then return
      dummy = check_math(1, 1)
      mch = machar()
      fmachep = mch.eps
      fmaxnum = mch.xmax
      fminnum = mch.xmin
      fmaxlog = alog(mch.xmax)
      fminlog = alog(mch.xmin)
      fmaxgam = 171.624376956302725D
      dummy = check_math(0, 0)
  endif else begin
      if n_elements(dmachep) GT 0 then return
      dummy = check_math(1, 1)
      mch = machar(/double)
      dmachep = mch.eps
      dmaxnum = mch.xmax
      dminnum = mch.xmin
      dmaxlog = alog(mch.xmax)
      dminlog = alog(mch.xmin)
      dmaxgam = 171.624376956302725D
      dummy = check_math(0, 0)
  endelse

  return
end

; Dummy procedure to define common block
pro tnmin_dummy
  common tnmin_work, lgv, lz1, lzk, lv, lsk, lyk, ldiagb, lsr, lyr, $
    lhyr, lhg, lhyk, lpk, lemat, lwtest, loldg
  a = 1
  return
end

pro tnmin_tie, p, _ptied
  _wh = where(_ptied NE '', _ct)
  if _ct EQ 0 then return
  for _i = 0, _ct-1 do begin
      _cmd = 'p('+strtrim(_wh(_i),2)+') = '+_ptied(_wh(_i))
      _err = execute(_cmd)
      if _err EQ 0 then begin
          message, 'ERROR: Tied expression "'+_cmd+'" failed.'
          return
      endif
  endfor
end

function tnmin_enorm, vec
; Very simple-minded sum-of-squares
;  ans0 = sqrt(total(vec^2, 1))

  sz = size(vec)
  isdouble = (sz(sz(0)+1) EQ 5)
  common tnmin_dmachar
  common tnmin_fmachar
  tnmin_setmachar, double=isdouble
  if isdouble then begin
      RDWARF  = sqrt(dminnum) * 0.9
      RGIANT  = sqrt(dmaxnum) * 0.9
  endif else begin
      RDWARF  = sqrt(fminnum) * 0.9
      RGIANT  = sqrt(fmaxnum) * 0.9
  endelse
  sz = size(vec)
  if sz(0) EQ 0 then return, abs(vec)
  if sz(0) EQ 1 then begin
      nr = 1L
      nc = sz(1)
  endif
  if sz(0) EQ 2 then begin
      nr = sz(2)
      nc = sz(1)
  endif
  if sz(0) EQ 2 AND (sz(1) EQ 1) then begin
      vec = vec(*)
      nr = 1L
      nc = n_elements(vec)
  endif
  ans = replicate(vec(0)*0, nr)
  zero = vec(0)*0
  if n_elements(ans) EQ 1 then ans = zero

  for j = 0, nr-1 do begin
      s1 = zero
      s2 = zero
      s3 = zero
      x1max = zero
      x3max = zero
      agiant = rgiant/float(nc)
      x = vec(*,j)
      xabs = abs(x)

      big = (xabs GE agiant)
      sml = (xabs LE rdwarf AND xabs GT 0)

      wh = where(NOT big AND NOT sml, ct)
      if ct GT 0 then s2 = total(xabs(wh)^2)

      wh = where(big, ct)
      if ct GT 0 then begin
          x1max = max(xabs(wh))
          s1 = total((xabs(wh)/x1max)^2)
      endif

      wh = where(sml, ct)
      if ct GT 0 then begin
          x3max = max(xabs(wh))
          s3 = total((xabs(wh)/x3max)^2)
      endif

      if s1 NE 0 then begin
          ans(j) = x1max*sqrt(s1 + (s2/x1max)/x1max)
      endif else if s2 NE 0 then begin
          if s2 GE x3max then $
            temp = s2*((x3max/s2)*(x3max*s3)+1) $
          else $
            temp = x3max*((s2/x3max)+(x3max*s3))
          ans(j) = sqrt(temp)
      endif else begin
          ans(j) = x3max*sqrt(s3)
      endelse
  endfor

  return, ans
end

pro tnmin_initp3, diagb, emat, n, lreset, yksk, yrsr, bsk, $
         sk, yk, sr, yr, modet, upd1

;stop
  if keyword_set(upd1)   then goto, INITP3_UPD1
  if keyword_set(lreset) then goto, INITP3_LRESET
  bsk  = diagb * sr
  sds  = total(sr*bsk)
  srds = total(sk*bsk)
  yrsk = total(yr*sk)
  bsk  = diagb*sk - bsk*srds/sds + yr*yrsk/yrsr
  emat = diagb-diagb*diagb*sr*sr/sds + yr*yr/yrsr
  sds  = total(sk*bsk)
  emat = emat - bsk*bsk/sds + yk*yk/yksk
  goto, INITP3_FINISH

INITP3_LRESET:
  bsk  = diagb * sk
  sds  = total(sk*bsk)
  emat = diagb - diagb*diagb*sk*sk/sds + yk*yk/yksk
  goto, INITP3_FINISH

INITP3_UPD1:
  emat = diagb

INITP3_FINISH:  
  if modet LT 1 then return
  dn = max(emat, min=d1)
  cond = dn/d1
  return
end


pro tnmin_initpc, diagb, emat, n, modet, upd1, yksk, gsk, yrsr, lreset
  common tnmin_work

  ;; These shenanigans are required because common block elements
  ;; can't be an lvalue as a parameter
  wlhyk = lhyk & wlsk = lsk & wlyk = lyk & wlsr = lsr & wlyr = lyr
  
  tnmin_initp3, diagb, emat, n, lreset, yksk, yrsr, wlhyk, $
    wlsk, wlyk, wlsr, wlyr, modet, upd1

  lhyk = wlhyk & lsk = wlsk & lyk = wlyk & lsr = wlsr & lyr = wlyr
  return
end

pro tnmin_ssbfgs, n, gamma, sj, yj, hjv, hjyj, yjsj, yjhyj, $
         vsj, vhyj, hjp1v
; self-scaled bfgs
  delta = (1D + gamma*yjhyj/yjsj)*vsj/yjsj - gamma*vhyj/yjsj
  beta  = -gamma*vsj/yjsj
  hjp1v = gamma*hjv + delta*sj + beta*hjyj
  return
end

pro tnmin_mslv, g, y, n, sk, yk, diagb, sr, yr, hyr, hg, hyk, $
         upd1, yksk, gsk, yrsr, lreset, first

;  stop
  if keyword_set(upd1) then goto, MSLV_UPD1
  one = 1D
  gsk = total(g*sk)
  ykhyk = 0 & yrhyr = 0
  if keyword_set(lreset) then goto, MSLV_LRESET

; compute hg and hy where h is the inverse of the diagonals
  hg = g/diagb
  if keyword_set(first) then begin
      hyk = yk/diagb
      hyr = yr/diagb
      yksr = total(yk*sr)
      ykhyr = total(yk*hyr)
  endif
  gsr = total(g*sr)
  ghyr = total(g*hyr)
  if keyword_set(first) then yrhyr = total(yr*hyr)
  tnmin_ssbfgs, n, one, sr, yr, hg, hyr, yrsr, yrhyr, gsr, ghyr, hg
  if keyword_set(first) then $
    tnmin_ssbfgs, n, one, sr, yr, hyk, hyr, yrsr, yrhyr, yksr, ykhyr, hyk
  ykhyk = total(hyk*yk)
  ghyk  = total(hyk*g)
  tnmin_ssbfgs, n, one, sk, yk, hg, hyk, yksk, ykhyk, gsk, ghyk, y
  return

MSLV_LRESET:
; compute gh and hy where h is the inverse of the diagonals
  hg = g/diagb
  if keyword_set(first) then begin
      hyk = yk/diagb
      ykhyk = total(yk*hyk)
  endif
  ghyk = total(g*hyk)
  tnmin_ssbfgs, n, one, sk, yk, hg, hyk, yksk, ykhyk, gsk, ghyk, y
  return

MSLV_UPD1:
  y = g/diagb
  return
end
 
pro tnmin_msolve, g, y, n, upd1, yksk, gsk, yrsr, lreset, first
  common tnmin_work

  wlsk = lsk & wlyk = lyk & wldiagb = ldiagb & wlsr = lsr & wlyr = lyr
  wlhyr = lhyr & wlhg = lhg & wlhyk = lhyk 

  tnmin_mslv, g, y, n, wlsk, wlyk, wldiagb, wlsr, wlyr, wlhyr, $
    wlhg, wlhyk, upd1, yksk, gsk, yrsr, lreset, first

  lsk = wlsk & lyk = wlyk & ldiagb = wldiagb & lsr = wlsr & lyr = wlyr
  lhyr = wlhyr & lhg = wlhg & lhyk = wlhyk
  return
end

;
; THIS ROUTINE COMPUTES THE PRODUCT OF THE MATRIX G TIMES THE VECTOR
; V AND STORES THE RESULT IN THE VECTOR GV (FINITE-DIFFERENCE VERSION)
;
pro tnmin_gtims, v, gv, n, x, g, fcn, first, delta, accrcy, xnorm, $
        xnew, ifree, ptied=ptied, fcnargs=fcnargs

  if keyword_set(first) then begin
      delta = sqrt(accrcy)*(1D + xnorm)
      first = 0
  endif
  dinv = 1D/delta

  xpnew = xnew
  xpnew(ifree) = x + delta*v
  if n_elements(ptied) GT 0 then tnmin_tie, xpnew, ptied
;  stop
  gv0 = 0
  f = call_function(fcn, xpnew, gv0, _extra=fcnargs)
  gv = gv0(ifree)
  gv = (gv-g)*dinv
  return
end

;
; UPDATE THE PRECONDITIOING MATRIX BASED ON A DIAGONAL VERSION
; OF THE BFGS QUASI-NEWTON UPDATE.
;
pro tnmin_ndia3, n, e, v, gv, r, vgv, modet
  vr = total(v*r)
  e = e - r*r/vr + gv*gv/vgv
  wh = where(e LE 1D-6, ct)
  if ct GT 0 then e(wh) = 1
  return
end

;
; THIS ROUTINE PERFORMS A PRECONDITIONED CONJUGATE-GRADIENT
; ITERATION IN ORDER TO SOLVE THE NEWTON EQUATIONS FOR A SEARCH
; DIRECTION FOR A TRUNCATED-NEWTON ALGORITHM.  WHEN THE VALUE OF THE
; QUADRATIC MODEL IS SUFFICIENTLY REDUCED,
; THE ITERATION IS TERMINATED.
;
; PARAMETERS
;
; MODET       - INTEGER WHICH CONTROLS AMOUNT OF OUTPUT
; ZSOL        - COMPUTED SEARCH DIRECTION
; G           - CURRENT GRADIENT
; GV,GZ1,V    - SCRATCH VECTORS
; R           - RESIDUAL
; DIAGB,EMAT  - DIAGONAL PRECONDITONING MATRIX
; NITER       - NONLINEAR ITERATION #
; FEVAL       - VALUE OF QUADRATIC FUNCTION
pro tnmin_modlnp, modet, zsol, gv, r, v, diagb, emat, $
         x, g, zk, n, niter, maxit, nfeval, nmodif, nlincg, $
         upd1, yksk, gsk, yrsr, lreset, fcn, whlpeg, whupeg, $
         accrcy, gtp, gnorm, xnorm, $
         xnew, ifree, ptied=ptied, fcnargs=fcnargs

; General initialization
  if maxit EQ 0 then return
  first = 1
  rhsnrm = gnorm
  tol = 1d-12
  qold = 0D

; Initialization for preconditioned conjugate-gradient algorithm  
;  stop
  tnmin_initpc, diagb, emat, n, modet, upd1, yksk, gsk, yrsr, lreset

  r = -g
  v = g * 0
  zsol = v
  
; Main iteration
  for k = 1L, maxit do begin
      nlincg = nlincg + 1
      ;; if modet GT 1 then print, k
      
; CG iteration to solve system of equations
      if whlpeg(0) NE -1 then r(whlpeg) = 0
      if whupeg(0) NE -1 then r(whupeg) = 0
      tnmin_msolve, r, zk, n, upd1, yksk, gsk, yrsr, lreset, first
      if whlpeg(0) NE -1 then zk(whlpeg) = 0
      if whupeg(0) NE -1 then zk(whupeg) = 0
      rz = total(r*zk)
      if rz/rhsnrm LT tol then goto, MODLNP_80
      if k EQ 1 then beta = 0D else beta = rz/rzold
      v = zk + beta*v
      if whlpeg(0) NE -1 then v(whlpeg) = 0
      if whupeg(0) NE -1 then v(whupeg) = 0
      tnmin_gtims, v, gv, n, x, g, fcn, first, delta, accrcy, xnorm, $
        xnew, ifree, ptied=ptied, fcnargs=fcnargs
      if whlpeg(0) NE -1 then gv(whlpeg) = 0
      if whupeg(0) NE -1 then gv(whupeg) = 0
      nfeval = nfeval + 1
      vgv = total(v*gv)
      if vgv/rhsnrm LT tol then goto, MODLNP_50
      tnmin_ndia3, n, emat, v, gv, r, vgv, modet
; compute linear step length
      alpha = rz/vgv
      ;; if modet GE 1 then print, alpha
      zsol = zsol + alpha*v
      r = r - alpha*gv
; test for convergence
      gtp = total(zsol*g)
      pr = total(r*zsol)
      qnew = 0.5D * (gtp + pr)
      qtest = k*(1D - qold/qnew)
      if qtest LT 0D then goto, MODLNP_70
      qold = qnew
      if qtest LE 0.5D then goto, MODLNP_70
; perform cautionary test
      if gtp GT 0 then goto, MODLNP_40
      rzold = rz
  endfor
  k = k-1
  goto, MODLNP_70

MODLNP_40:
  ;; if modet GE -1 then print, k
  zsol = zsol - alpha*v
  gtp = total(zsol*g)
  goto, MODLNP_90

MODLNP_50:
  ;; if modet GT -2 then print, what?
MODLNP_60:
  if k GT 1 then goto, MODLNP_70
  tnmin_msolve, g, zsol, n, upd1, yksk, gsk, yrsr, lreset, first
  zsol = -zsol
  if whlpeg(0) NE -1 then zsol(whlpeg) = 0
  if whupeg(0) NE -1 then zsol(whupeg) = 0
  gtp = total(zsol*g)
MODLNP_70:
  ;; if modet GE -1 then print, k, rnorm
  goto, MODLNP_90
MODLNP_80:
  ;; if modet GE -1 then print, what?
  if k GT 1 then goto, MODLNP_70
  zsol = -g
  if whlpeg(0) NE -1 then zsol(whlpeg) = 0
  if whupeg(0) NE -1 then zsol(whupeg) = 0
  gtp = total(zsol*g)
  goto, MODLNP_70

; store (or restore) diagonal preconditioning
MODLNP_90:
  diagb = emat
  return
end

function tnmin_step1, fnew, fm, gtp, smax, epsmch

; ********************************************************
; STEP1 RETURNS THE LENGTH OF THE INITIAL STEP TO BE TAKEN ALONG THE
; VECTOR P IN THE NEXT LINEAR SEARCH.
; ********************************************************

  d = abs(fnew-fm)
  alpha = 1D
  if 2D*d LE (-gtp) AND d GE epsmch then alpha = -2D*d/gtp
  if alpha GE smax then alpha = smax
  return, alpha
end

;
; ************************************************************
; GETPTC, AN ALGORITHM FOR FINDING A STEPLENGTH, CALLED REPEATEDLY BY
; ROUTINES WHICH REQUIRE A STEP LENGTH TO BE COMPUTED USING CUBIC
; INTERPOLATION. THE PARAMETERS CONTAIN INFORMATION ABOUT THE INTERVAL
; IN WHICH A LOWER POINT IS TO BE FOUND AND FROM THIS GETPTC COMPUTES A
; POINT AT WHICH THE FUNCTION CAN BE EVALUATED BY THE CALLING PROGRAM.
; THE VALUE OF THE INTEGER PARAMETERS IENTRY DETERMINES THE PATH TAKEN
; THROUGH THE CODE.
; ************************************************************
pro tnmin_getptc, big, small, rtsmll, reltol, abstol, tnytol, $
         fpresn, eta, rmu, xbnd, u, fu, gu, xmin, fmin, gmin, $
         xw, fw, gw, a, b, oldf, b1, scxbnd, e, step, factor, $
         braktd, gtest1, gtest2, tol, ientry, itest

  a1 = 0D & scale = 0D & chordm = 0D & chordu = 0D & d1 = 0D & d2 = 0D
  denom = 0D
  zero = 0D
  point1 = 0.1D
  half = 0.5D
  one = 1D
  three = 3D
  five = 5D
  eleven = 11D

  if ientry EQ 1 then begin ;; else clause = 20 (OK)
      ;; check input parameters
GETPTC_10:
      itest = 2
      if (u LE zero) OR (xbnd LE tnytol) OR (gu GT zero) then return
      itest = 1
      if (xbnd LT abstol) then abstol = xbnd
      tol = abstol
      twotol = tol + tol

      a = zero
      xw = zero
      xmin = zero
      oldf = fu
      fmin = fu
      fw = fu
      gw = gu
      gmin = gu
      step = u
      factor = five

      braktd = 0

      scxbnd = xbnd
      b = scxbnd + reltol*abs(scxbnd) + abstol
      e = b + b
      b1 = b
      
      gtest1 = -rmu*gu
      gtest2 = -eta*gu
; set ientry to indicate that this is the first iteration
      ientry = 2
      goto, GETPTC_210
  endif 

; ientry = 2
GETPTC_20:
  if (fu GT fmin) then goto, GETPTC_60
  
  chordu = oldf - (xmin +u)*gtest1
  if NOT (fu LE chordu) then begin
      chordm = oldf - xmin*gtest1
      gu = -gmin
      denom = chordm - fmin
      if abs(denom) LT 1D-15 then begin
          denom = 1D-15
          if chordm-fmin LT 0D then denom = -denom
      endif
      if xmin NE zero then gu = gmin*(chordu-fu)/denom
      fu = (half*u*(gmin+gu) + fmin) > fmin
GETPTC_60:
      if NOT (u LT zero) then begin
          b = u
          braktd = 1
      endif else begin
          a = u
      endelse
      xw = u & fw = fu & gw = gu
  endif else begin
GETPTC_30:
      fw = fmin & fmin = fu 
      gw = gmin & gmin = gu
      xmin = xmin + u & a = a-u & b = b-u & scxbnd = scxbnd-u
      xw = -u
      if NOT (gu LE 0) then begin
          b = zero 
          braktd = 1
      endif else begin
          a = zero
      endelse
      tol = abs(xmin)*reltol + abstol
  endelse

  twotol = tol+tol
  xmidpt = half*(a+b)

; Check termination criteria
  if (abs(xmidpt) LE twotol - half*(b-a)) OR (abs(gmin) LE gtest2) $
    AND (fmin LT oldf) AND (abs(xmin-xbnd) GT tol) OR NOT braktd then begin
      itest = 0
      if xmin NE zero then return

      itest = 3
      if abs(oldf-fw) LE fpresn*(one+abs(oldf)) then return
      tol = point1*tol
      if tol LT tnytol then return
      reltol = point1*reltol
      abstol = point1*abstol
      twotol = point1*twotol
  endif

GETPTC_100:
  r = zero & q = zero & s = zero
  if NOT (abs(e) LE tol) then begin  ;; else clause = 150 (OK)
      r = three*(fmin-fw)/xw + gmin + gw
      absr = abs(r)
      q = absr
      if NOT (gw EQ 0 OR gmin EQ 0) then begin ;; else clause = 140 (OK)
          abgw = abs(gw)
          abgmin =abs(gmin)
          s = sqrt(abgmin)*sqrt(abgw)
          if NOT ((gw/abgw)*gmin GT 0) then begin ;; else clause = 130 (OK)
              sumsq = one
              p = zero
              if NOT (absr GE s) then begin ;; else clause = 110 (OK)
                  if s GT rtsmll then p = s*rtsmll
                  if absr GE p then sumsq = one + (absr/s)^2
                  scale = s
              endif else begin ;; flow to 120 (OK)
GETPTC_110:
                  if absr GT rtsmll then p = absr*rtsmll
                  if s GE p then sumsq = one + (s/absr)^2
              endelse ;; flow to 120 (OK)
GETPTC_120:
              sumsq = sqrt(sumsq)
              q = big
              if scale LT big/sumsq then q = scale*sumsq
          endif else begin ;; flow to 140
GETPTC_130:
              q = sqrt(abs(r+s))*sqrt(abs(r-s))
              if NOT (r GE s OR r LE -s) then begin ;; else flow to 140 (OK)
                  r = zero
                  q = zero
                  goto, GETPTC_150
              endif
          endelse
      endif 
GETPTC_140:
      if xw LT zero then q = -q
      s = xw*(gmin-r-q)
      q = gw - gmin + q + q
      if (q GT zero) then s = -s
      if (q LE zero) then q = -q
      r = e
      if b1 NE step OR braktd then e = step
  endif

GETPTC_150:
  a1 = a
  b1 = b
  step = xmidpt
  if NOT braktd then begin ;; else flow to 160 (OK)
      step = -factor*xw
      if step GT scxbnd then step = scxbnd
      if step NE scxbnd then factor = five*factor
      ;; flow to 170 (OK)
  endif else begin
GETPTC_160:
      if (a NE zero OR xw GE zero) AND (b NE zero OR xw LE zero) then $
        goto, GETPTC_180
      d1 = xw
      d2 = a
      if a EQ zero then d2 = b
      u = -d1/d2
      step = five*d2*(point1 + one/u)/eleven
      if u LT one then step = half*d2*sqrt(u)
  endelse
GETPTC_170:
  if step LE zero then a1 = step
  if step GT zero then b1 = step
GETPTC_180:
  if NOT (abs(s) LE abs(half*q*r) OR s LE q*a1 OR s GE q*b1) then begin
      ;; else clause = 200 (OK)
      step = s/q
      if NOT (step - a GE twotol AND b - step GE twotol) then begin 
          ;; else clause = 210 (OK)
          if NOT (xmidpt GT zero) then step = -tol else step = tol
          ;; flow to 210 (OK)
      endif
  endif else begin
GETPTC_200:
      e = b-a
  endelse

GETPTC_210:
  if NOT (step LT scxbnd) then begin ;; else clause = 220 (OK)
      step = scxbnd
      scxbnd = scxbnd - (reltol*abs(xbnd)+abstol)/(one + reltol)
  endif
GETPTC_220:  
  u = step
  if abs(step) LT tol AND step LT zero then u = -tol
  if abs(step) LT tol AND step GE zero then u = tol
  itest = 1
  return
end
      
;
;      LINE SEARCH ALGORITHMS OF GILL AND MURRAY
;
pro tnmin_linder, n, fcn, small, epsmch, reltol, abstol, $
         tnytol, eta, sftbnd, xbnd, p, gtp, x, f, alpha, g, nftotl, $
         iflag, xnew, ifree, ptied=ptied, fcnargs=fcnargs

  common tnmin_work

  lsprnt = 0L
  nprnt = 10000L
  rtsmll = sqrt(small)
  big = 1D/small
  itcnt = 0L

; Set the estimated relative precision
  fpresn = 10D*epsmch
  numf = 0L
  u = alpha
  fu = f
  fmin = f
  gu = gtp
  rmu = 1D-4

; First entry sets up the initial interval of uncertainty
  ientry = 1L
LINDER_10:
; Test for too many iterations  
  itcnt = itcnt + 1
  if itcnt GT 20 then begin
      iflag = 1
      return
  endif
  tnmin_getptc, big, small, rtsmll, reltol, abstol, tnytol, $
    fpresn, eta, rmu, xbnd, u, fu, gu, xmin, fmin, gmin, $
    xw, fw, gw, a, b, oldf, b1, scxbnd, e, step, factor, $
    braktd, gtest1, gtest2, tol, ientry, itest

  ;; Print line search info here
; if itest = 1 the algorithm requires the function value to be
; calculated
  if itest EQ 1 then begin
      ualpha = xmin + u
      xpnew = xnew
      xpnew(ifree) = x + ualpha*p
      if n_elements(ptied) GT 0 then tnmin_tie, xpnew, ptied
      wlg0 = 0
      fu = call_function(fcn, xpnew, wlg0, _extra=fcnargs)
      wlg = wlg0(ifree)
      numf = numf + 1
      gu = total(wlg*p)
      
      if fu LE fmin AND fu LE oldf-ualpha*gtest1 then g = wlg
      goto, LINDER_10
  endif
  nftotl = numf
  iflag = 1
  if itest NE 0 then return
  
  iflag = 0
  f = fmin
  alpha = xmin
  x = x + alpha*p
  return
end

pro tnmin_defiter, fcn, x, iter, fnorm, fmt=fmt, FUNCTARGS=fcnargs, $
         quiet=quiet, _EXTRA=iterargs

  if keyword_set(quiet) then return
  if n_params() EQ 3 then begin
      fnorm = call_function(fcn, x, df, _EXTRA=fcnargs)
  endif

  print, iter, fnorm, $
    format='("Iter ",I6,"   FUNCTION = ",G20.8)'
  if n_elements(fmt) GT 0 then begin
      print, x, format=fmt
  endif else begin
      p = '  P('+strtrim(lindgen(n_elements(x)),2)+') = ' $
        + strtrim(string(x,format='(G20.6)'),2) + '  '
      print, '         '+p, format='(A)'
  endelse
  
  return
end

;      SUBROUTINE TNBC (IERROR, N, X, F, G, W, LW, SFUN, LOW, UP, IPIVOT)
;      IMPLICIT          DOUBLE PRECISION (A-H,O-Z)
;      INTEGER           IERROR, N, LW, IPIVOT(N)
;      DOUBLE PRECISION  X(N), G(N), F, W(LW), LOW(N), UP(N)
;
; THIS ROUTINE SOLVES THE OPTIMIZATION PROBLEM
;
;   MINIMIZE     F(X)
;      X
;   SUBJECT TO   LOW <= X <= UP
;
; WHERE X IS A VECTOR OF N REAL VARIABLES.  THE METHOD USED IS
; A TRUNCATED-NEWTON ALGORITHM (SEE "NEWTON-TYPE MINIMIZATION VIA
; THE LANCZOS ALGORITHM" BY S.G. NASH (TECHNICAL REPORT 378, MATH.
; THE LANCZOS METHOD" BY S.G. NASH (SIAM J. NUMER. ANAL. 21 (1984),
; PP. 770-778).  THIS ALGORITHM FINDS A LOCAL MINIMUM OF F(X).  IT DOES
; NOT ASSUME THAT THE FUNCTION F IS CONVEX (AND SO CANNOT GUARANTEE A
; GLOBAL SOLUTION), BUT DOES ASSUME THAT THE FUNCTION IS BOUNDED BELOW.
; IT CAN SOLVE PROBLEMS HAVING ANY NUMBER OF VARIABLES, BUT IT IS
; ESPECIALLY USEFUL WHEN THE NUMBER OF VARIABLES (N) IS LARGE.
;
; SUBROUTINE PARAMETERS:
;
; IERROR  - (INTEGER) ERROR CODE
;           ( 0 => NORMAL RETURN
;           ( 2 => MORE THAN MAXFUN EVALUATIONS
;           ( 3 => LINE SEARCH FAILED TO FIND LOWER
;           (          POINT (MAY NOT BE SERIOUS)
;           (-1 => ERROR IN INPUT PARAMETERS
; N       - (INTEGER) NUMBER OF VARIABLES
; X       - (REAL*8) VECTOR OF LENGTH AT LEAST N; ON INPUT, AN INITIAL
;           ESTIMATE OF THE SOLUTION; ON OUTPUT, THE COMPUTED SOLUTION.
; G       - (REAL*8) VECTOR OF LENGTH AT LEAST N; ON OUTPUT, THE FINAL
;           VALUE OF THE GRADIENT
; F       - (REAL*8) ON INPUT, A ROUGH ESTIMATE OF THE VALUE OF THE
;           OBJECTIVE FUNCTION AT THE SOLUTION; ON OUTPUT, THE VALUE
;           OF THE OBJECTIVE FUNCTION AT THE SOLUTION
; W       - (REAL*8) WORK VECTOR OF LENGTH AT LEAST 14*N
; LW      - (INTEGER) THE DECLARED DIMENSION OF W
; SFUN    - A USER-SPECIFIED SUBROUTINE THAT COMPUTES THE FUNCTION
;           AND GRADIENT OF THE OBJECTIVE FUNCTION.  IT MUST HAVE
;           THE CALLING SEQUENCE
;             SUBROUTINE SFUN (N, X, F, G)
;             INTEGER           N
;             DOUBLE PRECISION  X(N), G(N), F
; LOW, UP - (REAL*8) VECTORS OF LENGTH AT LEAST N CONTAINING
;           THE LOWER AND UPPER BOUNDS ON THE VARIABLES.  IF
;           THERE ARE NO BOUNDS ON A PARTICULAR VARIABLE, SET
;           THE BOUNDS TO -1.D38 AND 1.D38, RESPECTIVELY.
; IPIVOT  - (INTEGER) WORK VECTOR OF LENGTH AT LEAST N, USED
;           TO RECORD WHICH VARIABLES ARE AT THEIR BOUNDS.
;
; THIS IS AN EASY-TO-USE DRIVER FOR THE MAIN OPTIMIZATION ROUTINE
; LMQNBC.  MORE EXPERIENCED USERS WHO WISH TO CUSTOMIZE PERFORMANCE
; OF THIS ALGORITHM SHOULD CALL LMQBC DIRECTLY.
;
;----------------------------------------------------------------------
; THIS ROUTINE SETS UP ALL THE PARAMETERS FOR THE TRUNCATED-NEWTON
; ALGORITHM.  THE PARAMETERS ARE:
;
; ETA    - SEVERITY OF THE LINESEARCH
; MAXFUN - MAXIMUM ALLOWABLE NUMBER OF FUNCTION EVALUATIONS
; XTOL   - DESIRED ACCURACY FOR THE SOLUTION X*
; STEPMX - MAXIMUM ALLOWABLE STEP IN THE LINESEARCH
; ACCRCY - ACCURACY OF COMPUTED FUNCTION VALUES
; MSGLVL - CONTROLS QUANTITY OF PRINTED OUTPUT
;          0 = NONE, 1 = ONE LINE PER MAJOR ITERATION.
; MAXIT  - MAXIMUM NUMBER OF INNER ITERATIONS PER STEP
;
function tnmin, fcn, xall, fguess=fguess, functargs=fcnargs, parinfo=parinfo, $
                xtol=accrcy, epsfcn=epsfcn, $
                nfev=nfev, maxiter=maxiter, errmsg=errmsg, $
                nprint=nprint, status=status, nocatch=nocatch, $
                iterproc=iterproc, iterargs=iterargs, niter=niter, quiet=quiet,$
                autoderivative=autoderiv, bestmin=f

  if n_elements(nprint) EQ 0 then nprint = 1
  if n_elements(iterproc) EQ 0 then iterproc = 'TNMIN_DEFITER'
  if n_elements(autoderiv) EQ 0 then autoderiv = 1
  if n_elements(msglvl) EQ 0 then msglvl = 0
  if n_params() EQ 0 then begin
      message, "USAGE: PARMS = TNMIN('MYFUNCT', START_PARAMS, ... )", /info
      return, !values.d_nan
  endif
  status = 0L
  errmsg = ''
  catch_msg = 'in TNMIN'

  ;; Handle error conditions gracefully
  if NOT keyword_set(nocatch) then begin
      catch, catcherror
      if catcherror NE 0 then begin
          catch, /cancel
          message, 'Error detected while '+catch_msg+':', /info
          message, !err_string, /info
          message, 'Error condition detected. Returning to MAIN level.', /info
          return, !values.d_nan
      endif
  endif

  sz = size(xall)
  isdouble = (sz(sz(0)+1) EQ 5)
  common tnmin_dmachar
  common tnmin_fmachar
  tnmin_setmachar, double=isdouble
  if isdouble then begin
      MCHPR1 = dmachep
  endif else begin
      MCHPR1 = fmachep
  endelse

  ;; Parinfo:
  ;; --------------- STARTING/CONFIG INFO (passed in to routine, not changed)
  ;; .value   - starting value for parameter
  ;; .fixed   - parameter is fixed
  ;; .limited - a two-element array, if parameter is bounded on
  ;;            lower/upper side
  ;; .limits - a two-element array, lower/upper parameter bounds, if
  ;;           limited vale is set
  ;; .step   - step size in Jacobian calc, if greater than zero

  catch_msg = 'parsing input parameters'
  ;; Parameters can either be stored in parinfo, or x.  Parinfo takes
  ;; precedence if it exists.
  if n_elements(xall) EQ 0 AND n_elements(parinfo) EQ 0 then begin
      errmsg = 'ERROR: must pass parameters in P or PARINFO'
      goto, TERMINATE
  endif
  if n_elements(xall) EQ 0 then begin
      parinfo_size = size(parinfo)
      if parinfo_size(parinfo_size(0)+2) EQ 0 then begin
          errmsg = 'ERROR: either P or PARINFO must be supplied.'
          goto, TERMINATE
      endif
      if parinfo_size(parinfo_size(0)+1) NE 8 then begin
          errmsg = 'ERROR: PARINFO must be a structure.'
          goto, TERMINATE
      endif
      xall = parinfo(*).value
      sz = size(xall)
      ;; Convert to double if parameters are not float or double
      if sz(sz(0)+1) NE 4 AND sz(sz(0)+1) NE 5 then $
        xall = double(xall)
  endif
  if n_elements(parinfo) EQ 0 then begin
      parinfo = replicate({value:0.D, fixed:0, $
                           limited:[0,0], limits:[0.D,0], step:0.D}, $
                           n_elements(xall))
      if n_elements(xall) EQ 1 then parinfo(0).value = xall(0) $
      else parinfo(*).value = xall
  endif
  parinfo_size = size(parinfo)
  if parinfo_size(parinfo_size(0)+1) NE 8 then begin
      errmsg = 'ERROR: PARINFO must be a structure.'
      goto, TERMINATE
  endif

  ;; Decide what parameter information has been supplied
  parinfo_tags = tag_names(parinfo)

  ;; FIXED parameters ?
  wh = where(parinfo_tags EQ 'FIXED', ct)
  if ct GT 0 then begin
      ;; Get freely adjustable parameters
      pfixed = parinfo(*).fixed EQ 1
  endif else begin
      pfixed = byte(xall) * 0
  endelse
  ;; TIEd parameters?
  wh = where(parinfo_tags EQ 'TIED', ct)
  if ct GT 0 then begin
      wh = where(parinfo(*).tied NE '', ct)
      if ct GT 0 then begin
          ptied = parinfo(*).tied
          pfixed = pfixed OR (ptied NE '')
      endif
  endif

  ;; Finish up the free parameters
  ifree = where(pfixed NE 1, ct)
  if ct EQ 0 then begin
      errmsg = 'ERROR: no free parameters'
      goto, TERMINATE
  endif
  
  ;; Compose only VARYING parameters
  xnew = xall      ;; xnew is the set of parameters to be returned
  x = xnew(ifree)  ;; x is the set of free parameters

  ;; LIMITED parameters ?
  wh = where(parinfo_tags EQ 'LIMITED', ct)
  wh = where(parinfo_tags EQ 'LIMITS', lct)
  if ct GT 0 AND lct GT 0 then begin
      ;; Error checking on limits in parinfo
      wh = where((parinfo(*).limited(0) AND xall LT parinfo(*).limits(0)) $
                 OR (parinfo(*).limited(1) AND xall GT parinfo(*).limits(1)),$
                 ct)
      if ct GT 0 then begin
          errmsg = 'ERROR: parameters are not within PARINFO limits'
          goto, TERMINATE
      endif
      wh = where(parinfo(*).limited(0) AND parinfo(*).limited(1) $
                 AND parinfo(*).limits(0) GE parinfo(*).limits(1) $
                 AND NOT pfixed, ct)
      if ct GT 0 then begin
          errmsg = 'ERROR: PARINFO parameter limits are not consistent'
          goto, TERMINATE
      endif

      ;; Transfer structure values to local variables
      qulim = parinfo(ifree).limited(1)
      ulim  = parinfo(ifree).limits(1)
      qllim = parinfo(ifree).limited(0)
      llim  = parinfo(ifree).limits(0)

  endif else begin

      ;; Fill in local variables with dummy values
      qulim = bytarr(n_elements(ifree))
      ulim  = x * 0
      qllim = qulim
      llim  = x * 0

  endelse
      
  wh = where(parinfo_tags EQ 'STEP', ct)
  if ct GT 0 then begin
      step  = parinfo(ifree).step
  endif else begin
      step  = x * 0
  endelse

  n = n_elements(x)
  if n_elements(maxiter) EQ 0 then begin
      maxiter = (n/2) < 50 > 1
  endif
  if n_elements(accrcy) EQ 0 then accrcy = 100D*MCHPR1
  if n_elements(xtol) EQ 0 then xtol = sqrt(accrcy)

  ;; Check input parameters for errors
  if (n LE 0) OR (xtol LE 0) OR (maxiter LE 0) then begin
      errmsg = 'ERROR: input keywords are inconsistent'
      goto, TERMINATE
  endif

  maxfun = 150L*n
  eta = 0.25D
  stepmx = 10D

  w = replicate(x(0)*0, n*14)
  lw = n*14
  g = replicate(x(0)*0, n)

;; call minimizer
;
; THIS ROUTINE IS A BOUNDS-CONSTRAINED TRUNCATED-NEWTON METHOD.
; THE TRUNCATED-NEWTON METHOD IS PRECONDITIONED BY A LIMITED-MEMORY
; QUASI-NEWTON METHOD (THIS PRECONDITIONING STRATEGY IS DEVELOPED
; IN THIS ROUTINE) WITH A FURTHER DIAGONAL SCALING (SEE ROUTINE NDIA3).
; FOR FURTHER DETAILS ON THE PARAMETERS, SEE ROUTINE TNBC.
;

;
; initialize variables
;
  common tnmin_work
  lgv = 0 & lz1 = 0 & lzk = 0 & lv = 0 & lsk = 0 & lyk = 0 & ldiagb = 0 
  lsr = 0 & lyr = 0 & lhyr = 0 & lhg = 0 & lhyk = 0 & lpk = 0 & lemat = 0
  lwtest = 0 & loldg = 0

  if n_elements(fguess) EQ 0 then fguess = 1D
  f = fguess
  conv = 0 & lreset = 0 & upd1 = 0 & newcon = 0
  gsk = 0D & yksk = 0D & gtp = 0D & gtpnew = 0D & yrsr = 0D
  
  upd1 = 1
  ireset = 0L
  nfev   = 0L
  numf   = 0L
  nmodif = 0L
  nlincg = 0L
  fstop  = f
  conv   = 0
  zero   = x(0)*0
  one    = zero + 1
  nm1    = n - 1
  
;
; check parameters and set constants -- from CHKUCP
;
  epsmch = MCHPR1
  small = epsmch*epsmch
  tiny = small
  nwhy = -1L
  rteps = sqrt(epsmch)
  rtol = xtol
  if abs(rtol) LT accrcy then rtol = 10D * rteps
  if eta LT 0 OR eta GE 1 OR stepmx LT rtol OR maxfun LT 1 then begin
      errmsg = 'ERROR: input keywords are inconsistent'
      goto, TERMINATE
  endif
  nwhy = 0L
  rtolsq = rtol*rtol
  peps = accrcy^0.6666D
  xnorm = tnmin_enorm(x)
  alpha = 0D
  ftest = 0D

; From SETUCR
;
; CHECK INPUT PARAMETERS, COMPUTE THE INITIAL FUNCTION VALUE, SET
; CONSTANTS FOR THE SUBSEQUENT MINIMIZATION
;
  fm = f
  catch_msg = 'calling TNMIN_TIE'
  if n_elements(ptied) GT 0 then tnmin_tie, xnew, ptied
  catch_msg = 'calling '+fcn
  g0 = 0
  fnew = call_function(fcn, xnew, g0, _extra=fcnargs)
  nftotl = 1L
  niter = 0L
  oldf = fnew
  g = g0(ifree)

  common tnmin_error, tnerr

  if nprint GT 0 AND iterproc NE '' then begin
      iflag = 0L
      if (niter-1) MOD nprint EQ 0 then begin
          catch_msg = 'calling '+iterproc
          tnerr = 0
          call_procedure, iterproc, fcn, xnew, niter, fnew, $
            FUNCTARGS=fcnargs, parinfo=parinfo, quiet=quiet, _EXTRA=iterargs
          iflag = tnerr
          if iflag LT 0 then begin
              errmsg = 'WARNING: premature termination by "'+iterproc+'"'
              goto, TNMIN_160
          endif
      endif
  endif


  fold = fnew
  flast = fnew

; From LMQNBC
;
; TEST THE LAGRANGE MULTIPLIERS TO SEE IF THEY ARE NON-NEGATIVE.
; BECAUSE THE CONSTRAINTS ARE ONLY LOWER BOUNDS, THE COMPONENTS
; OF THE GRADIENT CORRESPONDING TO THE ACTIVE CONSTRAINTS ARE THE
; LAGRANGE MULTIPLIERS.  AFTERWORDS, THE PROJECTED GRADIENT IS FORMED.
;
  catch_msg = 'zeroing derivatives of pegged parameters'
  lmask = qllim AND (x EQ llim) AND (g GE 0)
  umask = qulim AND (x EQ ulim) AND (g LE 0)
  whlpeg = where(lmask, nlpeg)
  whupeg = where(umask, nupeg)
  if nlpeg GT 0 then g(whlpeg) = 0
  if nupeg GT 0 then g(whupeg) = 0
  gtg = total(g*g)
  
; print results of iteration here ***

;
; check if the initial point is a local minimum
;
  ftest = one + abs(fnew)
  if (gtg LT 1D-4 * epsmch*ftest*ftest) then goto, TNMIN_130

;
; set initial values to other parameters
;
  icycle = nm1
  toleps = rtol + rteps
  rtleps = rtolsq + epsmch
  gnorm  = sqrt(gtg)
  difnew = zero
  epsred = 5D-2
  fkeep  = fnew

;
; set the diagonal of the approximate hessian to unity
;
  ldiagb = replicate(one, n)
  
  wlpk = lpk & wlgv = lgv & wlz1 = lz1 & wlv = lv & wldiagb = ldiagb
  wlemat = lemat & wlzk = lzk

; compute the new search direction
  modet = msglvl - 3
  tnmin_modlnp, modet, wlpk, wlgv, wlz1, wlv, wldiagb, wlemat, $
    x, g, wlzk, n, niter, maxiter, nfev, nmodif, nlincg, upd1, yksk, $
    gsk, yrsr, lreset, fcn, whlpeg, whupeg, accrcy, gtpnew, gnorm, xnorm, $
    xnew, ifree, ptied=ptied, fcnargs=fcnargs

  lpk = wlpk & lgv = wlgv & lz1 = wlz1 & lv = wlv & ldiagb = wldiagb
  lemat = wlemat & lzk = wlzk

TNMIN_20:


  loldg = g
  pnorm = tnmin_enorm(lpk)
  oldf = fnew
  oldgtp = gtpnew

; prepare to compute the step length
  pe = pnorm + epsmch

; compute the absolute and relative tolerance
  reltol = rteps*(xnorm + one)/pe
  abstol = -epsmch*ftest/(oldgtp - epsmch)
  
; compute the smallest allowable spacing between points in the 
; linear search
  tnytol = epsmch*(xnorm+one)/pe
  ;; From STPMAX
  spe = stepmx / pe
  mmask = (NOT lmask AND NOT umask)
  wh = where(mmask AND (lpk GT 0) AND qulim AND (ulim - x LT spe*lpk), ct)
  if ct GT 0 then begin
      spe = min( (ulim(wh)-x(wh)) / lpk(wh))
  endif
  wh = where(mmask AND (lpk LT 0) AND qllim AND (llim - x GT spe*lpk), ct)
  if ct GT 0 then begin
      spe = min( (llim(wh)-x(wh)) / lpk(wh))
  endif

  ;; From LMQNBC
; set the initial step length
  alpha = tnmin_step1(fnew, fm, oldgtp, spe, epsmch)

; perform the linear search

  wlpk = lpk
  tnmin_linder, n, fcn, small, epsmch, reltol, abstol, tnytol, $
    eta, zero, spe, wlpk, oldgtp, x, fnew, alpha, g, numf, nwhy, $
    xnew, ifree, ptied=ptied, fcnargs=fcnargs
  lpk = wlpk
  newcon = 0
  if NOT (abs(alpha-spe) GT 10D*epsmch) then begin
      newcon = 1
      nwhy = 0L

      ;; From MODZ
      mmask = (NOT lmask AND NOT umask)
      wh = where(mmask AND (lpk LT 0) AND qllim $
                 AND (x-llim LE 10D*epsmch*(abs(llim)+1D)),ct)
      if ct GT 0 then begin
          flast = fnew
          lmask(wh) = 1
          x(wh) = llim(wh)
          whlpeg = where(lmask, nlpeg)
      endif
      wh = where(mmask AND (lpk GT 0) AND qulim $
                 AND (ulim-x LE 10D*epsmch*(abs(ulim)+1D)),ct)
      if ct GT 0 then begin
          flast = fnew
          umask(wh) = 1
          x(wh) = ulim(wh)
          whupeg = where(umask, nupeg)
      endif
      xnew(ifree) = x

      ;; From LMQNBC
      flast = fnew
  endif
  ;; print, alpha, pnorm
  fold = fnew
  niter = niter + 1
  nftotl = nftotl + numf
  
  if nprint GT 0 AND iterproc NE '' then begin
      iflag = 0L
      xx = xnew
      xx(ifree) = x
      if (niter-1) MOD nprint EQ 0 then begin
          catch_msg = 'calling '+iterproc
          tnerr = 0
          call_procedure, iterproc, fcn, xx, niter, fnew, $
            FUNCTARGS=fcnargs, parinfo=parinfo, quiet=quiet, _EXTRA=iterargs
          iflag = tnerr
          if iflag LT 0 then begin
              errmsg = 'WARNING: premature termination by "'+iterproc+'"'
              goto, TNMIN_160
          endif
      endif
  endif

; If required, print the details of this iteration
  ;; I won't require it :-)
  if nwhy LT 0 then goto, TNMIN_160
  if NOT (nwhy EQ 0 OR nwhy EQ 2) then begin
      nwhy = 3L
      goto, TNMIN_140
  endif
  if nwhy GT 1 then begin
      xnew(ifree) = x
      if n_elements(ptied) GT 0 then tnmin_tie, xnew, ptied
      g0 = 0
      fnew = call_function(fcn, xnew, g0, _extra=fcnargs)
      g = g0(ifree)
      nftotl = nftotl + 1
  endif
  nwhy = 2L
  if nftotl GT maxfun then goto, TNMIN_150
  nwhy = 0L

  difold = difnew
  difnew = oldf - fnew
  
  if icycle EQ 1 then begin
      if difnew GT 2D*difold then epsred = epsred + epsred
      if difnew LT 0.5D*difold then epsred = 0.5D*epsred
  endif
  wlgv = g
  if nlpeg GT 0 then wlgv(whlpeg) = 0
  if nupeg GT 0 then wlgv(whupeg) = 0
  gtg = total(wlgv*wlgv)
  gnorm = sqrt(gtg)
  ftest = one + abs(fnew)
  xnorm = tnmin_enorm(x)

  ;; From CNVTST
  ltest = (flast - fnew) LE (-.5D*gtpnew)
  wh = where((lmask AND g LT 0) OR (umask AND g GT 0), ct)
  if ct GT 0 then begin
      conv = 0
      if NOT ltest then begin
          mx = max(abs(g(wh)), wh2)
          lmask(wh(wh2)) = 0 & umask(wh(wh2)) = 0
          flast = fnew
          goto, CNVTST_DONE
      endif
  endif 
  if ((alpha*pnorm LT toleps*(one+xnorm)) AND (abs(difnew) LT rtleps*ftest) $
      AND (gtg LT peps*ftest*ftest)) OR (gtg LT 1D-4*accrcy*ftest) then $
    conv = 1 else conv = 0

CNVTST_DONE:
  ;; From LMQNBC

  if conv then goto, TNMIN_130
  if nlpeg GT 0 then g(whlpeg) = 0
  if nupeg GT 0 then g(whupeg) = 0

; stop
  if NOT newcon then begin
      lyk = g - loldg
      lsk = alpha*lpk
      yksk = total(lyk*lsk)
      lreset = 0
      if icycle EQ nm1 OR difnew LT EPSRED*(fkeep-fnew) then lreset = 1
      if NOT lreset then begin
          yrsr = total(lyr*lsr)
          if yrsr LE zero then lreset = 1
      endif
      upd1 = 0
  endif

TNMIN_90:  
  wlpk = lpk & wlgv = lgv & wlz1 = lz1 & wlv = lv & wldiagb = ldiagb
  wlemat = lemat & wlzk = lzk

  modet = msglvl - 3
  tnmin_modlnp, modet, wlpk, wlgv, wlz1, wlv, wldiagb, wlemat, $
    x, g, wlzk, n, niter, maxiter, nfev, nmodif, nlincg, upd1, yksk, $
    gsk, yrsr, lreset, fcn, whlpeg, whupeg, accrcy, gtpnew, gnorm, xnorm, $
    xnew, ifree, ptied=ptied, fcnargs=fcnargs

  lpk = wlpk & lgv = wlgv & lz1 = wlz1 & lv = wlv & ldiagb = wldiagb
  lemat = wlemat & lzk = wlzk

  if newcon then goto, TNMIN_20
  if NOT lreset then begin
      lsr = lsr + lsk
      lyr = lyr + lyk
      icycle = icycle + 1
      goto, TNMIN_20
  endif
  
TNMIN_110:
  ireset = ireset + 1
  lsr = lsk
  lyr = lyk
  fkeep = fnew
  icycle = 1L
  goto, TNMIN_20

TNMIN_130:
  ifail = 0
  f = fnew
  xnew(ifree) = x
  nfev = nftotl + nfev
  return, xnew
  
TNMIN_140:
  oldf = fnew
TNMIN_150:
  f = oldf
  ;; print status message here
TNMIN_160:
  ifail = nwhy
  nfev = nftotl + nfev
  xnew(ifree) = x
  return, xnew

TERMINATE:
  return, !values.d_nan
end

