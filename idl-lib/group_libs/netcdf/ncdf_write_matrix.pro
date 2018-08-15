pro ncdf_write_matrix, filename,matrix,varname=varname,old=old

	;filename	name of the file to create and to write INPUT
	;matrix		datamatrix   				INPUT


	case keyword_set(varname) of
	1: name=varname
	0: name='matrix'
	endcase
	
	case keyword_set(old) of
	0: begin

		siz=size(matrix)
	
		dimid=intarr(siz(0))
	
		id=ncdf_create(filename,/clobber)
	
		for i=1,siz(0) do begin
	
		 dimname='dimension_'+string(i)
		 dimname=strcompress(dimname,/remove_all)
	
		 dimid(i-1)=NCDF_DIMDEF(id,dimname,siz(i))
		
		end
		
		case siz(siz(0)+1) of
	
	 	0: begin
	 	     print,'matrix is undefined'
		     print,'no output'
	 	     ncdf_close,id
	 	     spawn,['rm','-f',filename],/noshell
	 	     goto,ende
	   	   end
	     	
	 	1: begin
		     varid=ncdf_vardef(id,name,dimid,/byte)
	     	   end		
		
	 	2: begin
		     varid=ncdf_vardef(id,name,dimid,/short)
	     	   end		
		
	 	3: begin
		     varid=ncdf_vardef(id,name,dimid,/long)
	     	   end		
		
	 	4: begin
		     varid=ncdf_vardef(id,name,dimid,/float)
	     	   end
	     		
	 	5: begin
		     varid=ncdf_vardef(id,name,dimid,/double)
	     	   end
	     			     
      	     else: begin
			print,'this type of matrix is not ncdf supported'
			print,'no output'
	 		ncdf_close,id
	 		spawn,['rm','-f',filename],/noshell
	 		goto,ende
	           end
		

		endcase
	
	     NCDF_ATTPUT, Id, 'Creator:','created by ncdf_write_matrix',/global	
	     NCDF_ATTPUT, Id, 'Date:',systime(),/global	
	
	     NCDF_CONTROL, Id, /ENDEF
	
	     ncdf_varput,id,name,matrix

	     ncdf_close,id
			
	   end
	   
	   
	1: begin
	
	     id=ncdf_open(filename,/write)
	     
	     result=ncdf_inquire(id)
	     
	     erg=0
	     for I=0, result.nvars-1 do begin
	     	blub=ncdf_varinq(id,i)
	     	erg = erg + (blub.name eq name)
	     end	
	     
	     if erg eq 0 then begin
	     
	     	NCDF_CONTROL, Id, /redef
	     	
		siz=size(matrix)
	
		dimid=intarr(siz(0))
		
		for i=1,siz(0) do begin
	
			dimname=name+'_dimension_'+string(i)
		 	dimname=strcompress(dimname,/remove_all)
			dimid(i-1)=NCDF_DIMDEF(id,dimname,siz(i))
		
		end

		case siz(siz(0)+1) of
	
		 	0: begin
		 	     print,'matrix is undefined'
			     print,'no output'
		 	     ncdf_close,id
		 	     goto,ende
		   	   end
	     	
		 	1: begin
			     varid=ncdf_vardef(id,name,dimid,/byte)
		     	   end		
		
		 	2: begin
			     varid=ncdf_vardef(id,name,dimid,/short)
	 	    	   end		
		
	 		3: begin
		 	    varid=ncdf_vardef(id,name,dimid,/long)
	  	   	   end		
		
	 		4: begin
		  	   varid=ncdf_vardef(id,name,dimid,/float)
	   	  	   end
	     		
	 		5: begin
		  	   varid=ncdf_vardef(id,name,dimid,/double)
	    	 	   end
	     			     
      		     else: begin
				print,'this type of matrix is not ncdf supported'
				print,'no output'
	 			ncdf_close,id
		 		goto,ende
		           end
		

		endcase
	        NCDF_CONTROL, Id, /ENDEF

		ncdf_varput,id,name,matrix
						
	     	ncdf_close,id
	     	goto,ende
	 
	     end	
	     	
	     ncdf_varget,id,name,dum
	     
	     s1=size(dum)
	     s2=size(matrix)
	     
	     if n_elements(s1) ne n_elements(s2) then begin
	        print, '    Size of matrix does not fit !!'
		print, 'Definition in nc-file:', s1
		print, 'Definition of matrix :', s2
		ncdf_close,id
		goto,ende
	     end
	     
	     case (total(s1 eq s2) eq n_elements(s1)) of
	     	
	     	1: ncdf_varput,id,name,matrix
	     
		else: begin
			print, 'Size of matrix does not fit !!'
			print, 'Definition in nc-file:', s1
			print, 'Definition of matrix :', s2
			ncdf_close,id
			stop
			goto,ende
		      end
	     endcase		      
	     ncdf_close,id	
	   end 
	endcase
			
ende:

end
