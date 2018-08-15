pro ncdf_cut, infile,outfile,anfang,aufhoer,cut_dim=cut_dim	
;
;
;infile		infile						INPUT
;outflie	outfile						INPUT
;anfang		begin number(!!!) of the cut dimension		INPUT
;aufhoer	end number(!!!) of the cut dimension		INPUT
;cut_dim 	name of the dimension to cut, if not given 
;		the unlimited dimensinon is used		INPUT
;
;
; 
;
;Rene Preusker 1999 <rene@amor.met.fu-berlin.de>
;
		
	s=shift(size(infile),2)
	if s(0) eq 0 then begin    ; undefinend
		infile=pickfile(title='INPUTFILE',filter='*.nc')
	endif	

	
	result=findfile(infile, count=c)
	if c ne 1 then begin
		print, 'File existiert nicht: ', filename
		infile=pickfile(title='INPUTFILE',filter='*.nc')
		if infile eq '' then goto,ende
	endif	
	
	s=shift(size(outfile),2)	
	if s(0) eq 0 then outfile=pickfile(title='OUPUTFILE',filter='*.nc')
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;Dimensionsinfos	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	in_id=ncdf_open(infile)
	result=ncdf_inquire(in_id)
		
	dimname=strarr(result.ndims)	
	dimsize=lonarr(result.ndims)	
	for i=0,result.ndims-1 do begin
		ncdf_diminq,in_id,i,dumname,dumsize
		dimname(i)=dumname
		dimsize(i)=dumsize
	endfor	

	if not keyword_set(cut_dim) then begin
		cut_dim_id=result.recdim
		if  cut_dim_id eq -1 then begin			
			print, ['No unlimited dimension in file',	$
			'and no cut dimension given']
			goto,ende
		endif	
			
	endif else begin
		cut_dim_id=where (strlowcase(dimname) eq strlowcase(cut_dim))
		if  cut_dim_id(0) eq -1 then begin
			print, ['no dimension named:'	$
				,string(cut_dim)		$
				,'in file, try one of these:'	$
				,dimname ]
			goto,ende
		endif
	endelse					


	oo=dimsize(cut_dim_id)
	mach_weiter=between(anfang,0,oo[0]-1)		$
			and						$
		    between(aufhoer,0,oo[0]-1)	
	
	if not mach_weiter(0) then begin
		print,'Anfang                              ',anfang
		print,'Ende:                               ',ende
		print,'Aktuelle Laenge der cut dimension:  ',dimsize(cut_dim_id)
		print,'Tja, da stimmt was nicht.'
		goto,ende
	endif	
		
	dimsize(cut_dim_id)=abs(long(aufhoer)-long(anfang))+1l

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;Erzeuge Outfile	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	out_id=ncdf_create(outfile,/clobber)
	
	for i=0,result.ndims-1 do begin
		if i eq result.recdim then dum=ncdf_dimdef(out_id,dimname(i),/unlimi)	$
		else dum=ncdf_dimdef(out_id,dimname(i),dimsize(i))
	endfor	
	
	
	for i=0,result.nvars-1 do begin
	
		struct=ncdf_varinq(in_id,i)
	
		case strlowcase(struct.datatype) of
		'byte': varid=ncdf_vardef(out_id,struct.name,struct.dim,/byte)
		'char': varid=ncdf_vardef(out_id,struct.name,struct.dim,/char)
	      'double': varid=ncdf_vardef(out_id,struct.name,struct.dim,/doub)
	       'float': varid=ncdf_vardef(out_id,struct.name,struct.dim,/floa)
		'long': varid=ncdf_vardef(out_id,struct.name,struct.dim,/long)
	       'short': varid=ncdf_vardef(out_id,struct.name,struct.dim,/shor)
	         'int': varid=ncdf_vardef(out_id,struct.name,struct.dim,/shor)
	        endcase	     
	
		for j=0,struct.natts-1 do begin
			name=ncdf_attname(in_id,i,j)
			dum=ncdf_attcopy(in_id,i,name,out_id,i)
			
		endfor
	
	endfor	

	for i=0,result.ngatts-1 do begin
		name=ncdf_attname(in_id,i,/global)
		dum=ncdf_attcopy(in_id,name,out_id,/in_g,/out_g)
	endfor
	
	ncdf_control,out_id,/endef
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;schreibe Daten, slideweise,  wegen Hauptspeicher
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
			
	for i=0,result.nvars-1 do begin
	
		struct=ncdf_varinq(in_id,i)
		
		wo =where(struct.dim eq cut_dim_id(0))
		
		if wo(0) eq -1 then begin  ; variable has no dimension to cut
			count=dimsize(struct.dim)
			jjj=count(struct.ndims-1)
			count(struct.ndims-1)=1l
			offset=count*0l
			j=0l		
			dum=ncdf_varinq(in_id,i)
			print,"a ",dum.name,j,jjj,struct.dim,cut_dim_id
			while j lt jjj do begin
				ncdf_varget, in_id,i,dum,count=count,offset=offset	
				ncdf_varput,out_id,i,dum,count=count,offset=offset
				j=j+1l	
				offset(struct.ndims-1)=j
			endwhile
							
		endif else begin
			if wo(0) eq  struct.ndims-1 then begin    ; the cutted dim is the last one, good!
				count = dimsize(struct.dim)
				jjj = aufhoer(0)
				j   = anfang(0)
				offset_in  = count*0l
				offset_out = count*0l
				count(wo)  = 1l
				offset_in(wo) =anfang(0)
				dum=ncdf_varinq(in_id,i)
				print,"b ",dum.name,j,jjj,struct.dim,cut_dim_id
				while j le jjj do begin
					ncdf_varget, in_id,i,dum,count=count,offset=offset_in	
					ncdf_varput,out_id,i,dum,count=count,offset=offset_out
					j=j+1l	
					offset_in (struct.ndims-1) =  offset_in (struct.ndims-1) +1l
					offset_out(struct.ndims-1) =  offset_out(struct.ndims-1) +1l
				endwhile		
			endif else begin		; the cutted dim is not the last one
				count_in   = dimsize(struct.dim)
				count_out  = dimsize(struct.dim)
				jjj=count_in(struct.ndims-1)
				offset_in  = count_in *0l
				offset_out = count_out*0l
				count_in(struct.ndims-1) = 1l
				count_out(struct.ndims-1) = 1l
				count_in(wo)  =long(aufhoer)-long(anfang)+1l
				offset_in(wo) =long(anfang)
				j=0l
				dum=ncdf_varinq(in_id,i)
				print,"c ",dum.name,j,jjj,struct.dim,cut_dim_id
				while j lt jjj do begin
					ncdf_varget, in_id,i,dum,count=count_in,offset=offset_in	
					ncdf_varput,out_id,i,dum,count=count_out,offset=offset_out
					j=j+1l	
					offset_in(struct.ndims-1)  =  offset_in(struct.ndims-1) +1l
					offset_out(struct.ndims-1) =  offset_out(struct.ndims-1)+1l
				endwhile	
			endelse
		endelse
		
	 endfor
	
	
ncdf_close,in_id
ncdf_close,out_id
	
	
	
	
ende:	
end
	
