FUNCTION fw,which_procedure,openit=openit

 asd = FILE_WHICH(which_procedure)
 
 IF N_ELEMENTS(asd) EQ 1 AND asd[0] NE '' AND KEYWORD_SET(openit) THEN $
    SPAWN,'nedit '+asd+' &' 

 RETURN,asd

END
