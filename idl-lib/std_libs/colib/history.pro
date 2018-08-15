function history, n, nstart

; n : the number of most recent comands desired
; nstart: the command number to start counting backwards from
if n_elements(nstart) eq 0 then nstart = 1
c = transpose(reverse( (recall_commands())[nstart:nstart+n-1] ))

return, c

END