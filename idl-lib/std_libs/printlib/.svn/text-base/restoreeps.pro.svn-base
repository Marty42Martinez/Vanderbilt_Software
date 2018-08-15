PRO restoreeps, eps

if eps then begin
	device, /close_file
	if !version.os_family eq 'Windows' then set_plot, 'win' else set_plot, 'X'
	defsysv, '!oldp', exists = exists
	if exists then !p = !oldp
endif

END