pro read_matrix, filename,matrix,n_lines_head=n_lines_head,n_lines_base=n_lines_base

	;filename	name of the file to read		INPUT
	;matrix		datamatrix in filename			OUTPUT

	filename=findfile(filename,count=count)

	if count eq 0 then filename=pickfile(title='Bitte File auswaehlen')

	file_info,filename(0),lin,col,n_lines_head=n_lines_head,n_lines_base=n_lines_base

	matrix='no_matrix'
	a=''

	if col ne -1 then begin

		matrix=fltarr(col,lin)
		openr,lun,filename(0),/get_lun
		case keyword_set(n_lines_head) of
		1: for i=0,n_lines_head-1 do readf,lun,a
		else:
		endcase
		readf,lun,matrix
		free_lun,lun

		end
	end


