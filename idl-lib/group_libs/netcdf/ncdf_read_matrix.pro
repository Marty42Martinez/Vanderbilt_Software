;Usage:
;pro ncdf_read_matrix, filename,matrix,varname=varname
;	filename	name of the file to read from		INPUT
;	matrix		datamatrix   				OUTPUt
		
function ncdf_dialog,id

	result=ncdf_inquire(id)
	var_names=make_array(result.nvars,/string)
	for i=0,result.nvars-1 do begin
		dum=ncdf_varinq(id,i)
		var_names(i)=dum.name
		end
		
	text='The file has more than one variable and no (valid) varname was given. Select a variable!'	 
	  
	result=dialog(text,/quest,buttons=var_names)
	
	return,result        	        	         	
	        	        	         		        	        	         		        	        	         	
end

	     	    	     	     	    	     


pro ncdf_read_matrix, filename,matrix,varname=varname

	;filename	name of the file to read from		INPUT
	;matrix		datamatrix   				OUTPUt
		

	s=shift(size(filename),2)
	if s(0) eq 0 then begin    ; undefinend
		filename=pickfile(title='Bitte File auswaehlen',filter='*.nc')
	endif	
	
	
	result=findfile(filename, count=c)
	if c ne 1 then begin
		print, 'File existiert nicht: ', filename
		filename=pickfile(title='Bitte File auswaehlen',filter='*.nc')
	endif	
	
	id=ncdf_open(filename)
	
	result=ncdf_inquire(id)
	
	case result.nvars of 
		1: begin
			result=ncdf_varinq(id,0)
			ncdf_varget,id,result.name,matrix
		   end
	     else: begin
	     	    	case keyword_set(varname) of
	     	    	
	     	    	1:     begin
	     	    	         result=ncdf_varid(id,varname)
	     	    	         case result of 
	     	    	          -1: begin
	     	    	          	result=ncdf_dialog(id)
	     	    	                ncdf_varget,id,result,matrix
	     	    	              end
	     	    	         else: begin 
	     	    	                ncdf_varget,id,result,matrix
	     	    	               end
	     	    	         endcase 
	     	    	       end
	     	        else:  begin 	   
	     	    	         result=ncdf_dialog(id)
	     	    	         ncdf_varget,id,result,matrix
	     	    	       end
	     	        endcase  
	     	   end
	endcase
	     	    	
	ncdf_close,id
		
ende:

	end
