FUNCTION flakeroi::area,maskarea=maskarea

; return either area in ROI path or, optionally, area covered by mask
; (both very similar)
   IF NOT(KEYWORD_SET(maskarea)) THEN BEGIN
      ROIStats = self -> ComputeGeometry($
                          AREA = area, PERIMETER = perimeter, $
                          SPATIAL_SCALE = [self.descriptors['scale'], self.descriptors['scale'], 1.0])
      area=ABS(area)
   ENDIF ELSE BEGIN  
      area = TOTAL(self->mask() GT 0) * self.descriptors['scale']^2.0                  
   ENDELSE
   
   RETURN,FLOAT(area)

END 
