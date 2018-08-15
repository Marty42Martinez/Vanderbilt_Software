FUNCTION flakeroi::centroid

    ROIStats = self -> ComputeGeometry($
                      AREA = geomArea, centroid = centroid)
    
    RETURN,FLOAT(centroid)

END 
