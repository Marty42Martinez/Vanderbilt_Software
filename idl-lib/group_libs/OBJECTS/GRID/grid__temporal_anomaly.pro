FUNCTION grid::temporal_anomaly,months=months,years=years,refyears=refyears,tag=tag,reference=reference

   KEYWORD_DEFAULT,refyears,FINDGEN(50)+1970
   
   self->select,years=refyears,tag=tag,months=months
   reference = self->temporal_mean(/data)
   
   self->select,years=years,tag=tag,months=months
   period    = self->temporal_mean(/data)    
      
   ano = period-reference
   ind = WHERE(reference EQ self.missing OR period EQ self.missing,cnt)
   IF cnt GT 0 THEN ano[ind]=self.missing	  
   RETURN,ano
  
END
