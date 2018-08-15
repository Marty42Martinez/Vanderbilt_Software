FUNCTION grid::plot_spatial_mean,_EXTRA=_EXTRA

   ts  = self->spatial_mean(_EXTRA=_EXTRA,/return_time_series)
   ts->plot,_EXTRA=_EXTRA
   RETURN,ts
   
END
