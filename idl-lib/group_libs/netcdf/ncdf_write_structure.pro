pro ncdf_write_structure, filename,struc

;-------------------------------------------------------------
;+
; NAME:
;       ncdf_write_structure
; PURPOSE:
;       Writes a structure into a netcdf file
;	Caution: 
;		* nested structures are not suported 
;		* it suports only ncdf datatypes (no string,
;		  complex, double, unsigned numbers)
;		* it uses "spawn  rm" which is limiting to unix
;
; CATEGORY:In/Output
;
; CALLING SEQUENCE:
;	
;	ncdf_write_structure, filename, structure
;
; MODIFICATION HISTORY:
;       Written by R. Preusker, Dez, 1998.
;
; Copyright (C) 1998, Freie Universität Berlin
; This software may be used, copied, or redistributed as long 
; as it is not sold and this copyright notice is reproduced on 
; each copy made.  This routine is provided as is without any 
; express or implied warranties whatsoever.  
;-


n_tag=n_tags(struc)
tag_name=tag_names(struc)

id=ncdf_create(filename,/clobber)


for i= 0, n_tag - 1 do begin

	siz=size(struc.(i))
	dimid=intarr(siz(0)>1)
	
	if siz(0) eq 0 then begin
	  
	  dimname=tag_name(i)+'_dimension_'+string(0)
	  dimname=strcompress(dimname,/remove_all)
          dimid(0)=ncdf_dimdef(id,dimname,1)
          
 	endif else begin
	
	for j=1,siz(0)>1 do begin
	
	   dimname=tag_name(i)+'_dimension_'+string(j)
	   dimname=strcompress(dimname,/remove_all)
	  
           dimid(j-1)=ncdf_dimdef(id,dimname,siz(j)>1)
          
          endfor
        endelse
        
	case siz(siz(0)+1) of	 	
	
		0: begin
	 	     print,'structure tag is undefined'
	 	     print,tag_name(i)
		     print,'no output'
	 	     ncdf_close,id
	 	     spawn,['rm','-f',filename],/noshell
	 	     goto,ende
	   	   end
	 	1: varid=ncdf_vardef(id,tag_name(i),dimid,/byte)
	 	2: varid=ncdf_vardef(id,tag_name(i),dimid,/short)
	 	3: varid=ncdf_vardef(id,tag_name(i),dimid,/long)
	 	4: varid=ncdf_vardef(id,tag_name(i),dimid,/float)
	 	5: varid=ncdf_vardef(id,tag_name(i),dimid,/double)
     	     else: begin
			print,'this type of structur tag is not ncdf supported'
			print,'(nested tags and/or strings are not alowed)'
			print,'no output'
	 		ncdf_close,id
	 		spawn,['rm','-f',filename],/noshell
	 		goto,ende
	 	     end	
	     endcase	     			     
end	
	   
NCDF_ATTPUT, Id, 'Creator:','created by ncdf_write_structure',/global	
NCDF_ATTPUT, Id, 'Date:',systime(),/global	
NCDF_CONTROL, Id, /ENDEF

for i= 0, n_tag - 1 do ncdf_varput,id,tag_name(i),struc.(i)

ncdf_close,id

ende:

end



