FUNCTION month_name_to_num, monthnames

	names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

	return, elt(monthnames, names, /index)

END
