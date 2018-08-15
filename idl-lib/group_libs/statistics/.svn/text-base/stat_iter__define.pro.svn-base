FUNCTION stat_iter::init,n

   KEYWORD_DEFAULT,n,1
   
   self.n   = n                  ; 2nd dimension.... 
                                 ; allows to pass 2d arrays. 
                                 ; all mean values will be over 
                                 ; 1st dimension. 
   self.mx  = PTR_NEW(FLTARR(n)) ; MEAN of X
   self.rx  = PTR_NEW(FLTARR(n)) ; RAW 2nd MOMENT of X
   self.vx  = PTR_NEW(FLTARR(n)) ; Variance of X
   self.my  = PTR_NEW(FLTARR(n)) ; MEAN of Y
   self.ry  = PTR_NEW(FLTARR(n)) ; RAW 2nd MOMENT of y
   self.vy  = PTR_NEW(FLTARR(n)) ; Variance of Y
   self.rxy = PTR_NEW(FLTARR(n)) ; RAW covar of x and y
   self.cxy = PTR_NEW(FLTARR(n)) ; COVAR of x and y
   self.nn  = PTR_NEW(FLTARR(n)) ; number of points in sample
      
   RETURN,1

END
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
PRO stat_iter::cleanup
   PTR_FREE,self.mx
   PTR_FREE,self.rx
   PTR_FREE,self.vx
   PTR_FREE,self.my
   PTR_FREE,self.ry
   PTR_FREE,self.vy
   PTR_FREE,self.rxy
   PTR_FREE,self.cxy
   PTR_FREE,self.nn
END
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION stat_iter::get
  
  out = {       $
            mx  : *self.mx,  $
            rx  : *self.rx,  $ 
            vx  : *self.vx,  $
            my  : *self.my,  $
            ry  : *self.ry,  $
            vy  : *self.vy,  $
            rxy : *self.rxy, $
            cxy : *self.cxy, $
            nn  : *self.nn   $
         }
  RETURN,out
END
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
PRO stat_iter::add,x,y,okmask

   nnew  = FLOAT(TOTAL(okmask,1)) + *self.nn

   mxnew = (*self.mx * *self.nn + TOTAL(okmask*x,1)) / nnew
   mynew = (*self.my * *self.nn + TOTAL(okmask*y,1)) / nnew

   rxnew  = (*self.rx  * *self.nn + TOTAL(okmask*x*x,1)) / nnew 
   rynew  = (*self.ry  * *self.nn + TOTAL(okmask*y*y,1)) / nnew 
   rxynew = (*self.rxy * *self.nn + TOTAL(okmask*x*y,1)) / nnew 
   
   *self.mx  = mxnew
   *self.rx  = rxnew
   *self.vx  = rxnew-mxnew^2.0
   *self.my  = mynew
   *self.ry  = rynew
   *self.vy  = rynew-mynew^2.0
   *self.rxy = rxynew
   *self.cxy = rxynew-mxnew*mynew
   *self.nn  = nnew

END
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++++++++++++++++++++
PRO stat_iter__define
   stat = { stat_iter,       $
            n   : 0L,        $
            mx  : PTR_NEW(), $
            rx  : PTR_NEW(), $ 
            vx  : PTR_NEW(), $
            my  : PTR_NEW(), $
            ry  : PTR_NEW(), $
            vy  : PTR_NEW(), $
            rxy : PTR_NEW(), $
            cxy : PTR_NEW(), $
            nn  : PTR_NEW()  $
           } 
END
