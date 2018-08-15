pro file_info, filename, lines, columns,n_lines_head=n_lines_head,n_lines_base=n_lines_base


	;filename	name of the file to be examined		INPUT
	;lines		number of lines				OUTPUT
	;columns	number of columns			OUTPUT

	;If file is not in matix form, lines contains the number of
	;elements and columns contains -1


	f=findfile(filename,count=count)

	case count of

	1: begin
	
		case keyword_set(n_lines_head) of
		1: begin
			spawn,'wc  -lw '+filename ,antwort,/sh	
			antwort=str_sep(strtrim(strcompress(antwort(0)),2),' ')
			
			lines=long(antwort(0))
			
			todo='tail -'
			todo=todo+strcompress(string(lines - n_lines_head),/rem)
			todo=todo+' '+filename
			todo= todo + ' | ' +'wc '+' -lw'
			
			spawn,todo,antwort,/sh
			
			end
			
		else:	spawn,['wc','-lw',filename],antwort,/noshell

		endcase
	
		
		antwort=str_sep(strtrim(strcompress(antwort(0)),2),' ')
		case keyword_set(n_lines_base) of
			1: lines=long(antwort(0))-n_lines_base
			else:lines=long(antwort(0))
		endcase
		
		elemente=long(antwort(1))
		columns=elemente/lines
	

		if columns ne (double(elemente)/double(lines)) $
			then 	begin 
				lines=elemente
				columns=-1			
				end
	    end

	0: stop,filename+" is not found"
	else: stop,filename+" is ambigious"

	endcase


	end
	
