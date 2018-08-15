FUNCTION grid::plot_ts,_EXTRA=_EXTRA,ts_object=ts_object,ts_data=ts_data,anomaly=anomaly

   ts_object  = self->spatial_mean(/return_time_series,anomaly=anomaly,_EXTRA=_EXTRA)
   ts_object  -> select,/all
   ts_data    = ts_object->get(/sort,_EXTRA=_EXTRA)
    
   pts = ts_object->plot(_EXTRA=_EXTRA)
  
   RETURN,pts
   
END
