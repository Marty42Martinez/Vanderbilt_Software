FUNCTION flakeroi::perimeter

    ROIStats = self -> ComputeGeometry($
                      AREA = geomArea, PERIMETER = perimeter, $
                      SPATIAL_SCALE = [self.descriptors['scale'], self.descriptors['scale'], 1.0])
    
    RETURN,FLOAT(perimeter)

END 
