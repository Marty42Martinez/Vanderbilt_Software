; Time-stamp: <xterm_keys.pro  Thu Oct 29 16:07:53 MET 1998>

pro xterm_keys
; Define PC keyboard function key sequences for xterm
; To find escape sequence, use 'print, byte(get_kbrd(1))'
; /terminate adds carriage return
; /noecho    adds carriage return without echoing command string
  if getenv('TERM') eq 'xterm' then begin
    esc = string(27b)
    define_key, 'insert',       escape=esc+'[2~',  /insert_overstrike_toggle
    define_key, 'delete',       escape=esc+'[3~',  /delete_current
    define_key, 'Home',         escape=esc+'[H',   /start_of_line
    define_key, 'End',          escape=esc+'[F',   /end_of_line
    define_key, 'home',         escape=esc+'[1~',  /start_of_line
    define_key, 'end',          escape=esc+'[4~',  /end_of_line
    define_key, 'page_up',      escape=esc+'[5~',  /previous_line
    define_key, 'page_down',    escape=esc+'[6~',  /next_line
    define_key, 'pause',        escape=esc+'[P',   /end_of_file
    define_key, 'f1',           escape=esc+'[11~', 'help',      /terminate
    define_key, 'f2',           escape=esc+'[12~', '.continue', /terminate
    define_key, 'f3',           escape=esc+'[13~', '.go'
    define_key, 'f4',           escape=esc+'[14~', '.out'
    define_key, 'f5',           escape=esc+'[15~', '.skip',     /terminate
    define_key, 'f6',           escape=esc+'[17~', '.step',     /terminate
    define_key, 'f7',           escape=esc+'[18~', '.stepover'
    define_key, 'f8',           escape=esc+'[19~', '.trace'
    define_key, 'f9',           escape=esc+'[20~', 'wdelete',   /terminate
    define_key, 'f10',          escape=esc+'[21~', 'xmanager',  /terminate
    define_key, 'f11',          escape=esc+'[23~'
    define_key, 'f12',          escape=esc+'[24~'
  endif
end
