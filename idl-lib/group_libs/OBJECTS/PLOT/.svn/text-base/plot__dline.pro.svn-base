FUNCTION plot::dline,_EXTRA=_EXTRA

   self->getproperty,xrange=xrange
   self->getproperty,yrange=yrange
   
   x0 = MIN([xrange[0],yrange[0]])
   x1 = MAx([xrange[1],yrange[1]])
   q= PLOT([x0,x1],[x0,x1],_EXTRA=_EXTRA,/overplot,/current)
   
   self->setproperty,xrange=xrange
   self->setproperty,yrange=yrange
   
   RETURN,q
END
