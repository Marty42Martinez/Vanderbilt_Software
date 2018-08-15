
;=============================================================================

PRO mollcursor, cursor_type=cursor_type
;+
;=-----------------------------------------------------------------------------
; NAME:   
;     MOLLCURSOR
; PURPOSE:
;     get sky position (long, lat), number and value of a pixel
;     selected on a Healpix of QuadCube map in Mollview projection 
; CALLING SEQUENCE:
;       MOLLCURSOR, [CURSOR_TYPE=]
; INPUTS:
;      None
; OPTIONAL INPUT:
; OPTIONAL KEYWORD
;      cursor_type
; OUTPUTS:
; OPTIONAL OUTPUTS : 
;      Long, Lat, value, pixel number
; SIDE EFFECT:
; RESTRICIONS:
;      runs on the X-window created by the latest execution of Mollview
; PROCEDURE CALLS:
;      Moll2pix
; HISTORY:
;       June 98 : copied by EH from 
;        coor_cursor (F.X.Desert, JUL-1992) and xcursor (R. Sterner, Nov-1993)
;       March 1999 : updated for improved Mollview
;=-----------------------------------------------------------------------------
;-

@mollcom ; define common
; file_in = file_in1    ; to be used by mollcursor
; select_in = select_in1

; Initialisation
N_POINTS= 1L


; loaddata, file_in1, select_in1, data, SAVE=save1, ONLINE=online1 ; reread the original data, the other parameters are in the common
;------------------------------------------------------------------

coordinate = decode_coord(coord_out)
long_name = 'Long' & lat_name = 'Lat' ; for galactic and ecliptic
if (coord_out eq 'Q') then begin ; for equatorial
    long_name = '  RA'
    lat_name  = ' Dec'
endif

value = '         Pixel Value'
blank = '                    '
len1 = STRLEN(value)
if (sunits NE ' ') then begin
    sunits2 = STRTRIM(sunits,2)
    len2 = STRLEN(sunits2)
    value = STRMID(blank,0,(len1-len2-8)>1)+'Value ('+sunits2+')'
endif

pix_num0 = ' pix #'
if (pix_type eq 'R') then pix_num = '  Ring'+pix_num0
if (pix_type eq 'N') then pix_num = '  Nest'+pix_num0
if (pix_type eq 'Q') then pix_num = '  Q.C.'+pix_num0


string_instruct = 'Left: display position, Middle: record position, Right: Quit'
string_head     = '   # '+long_name+' (Deg)  '+lat_name+' (Deg)'+value+pix_num
string_coord    = coordinate + ' coordinates'

;--------------------------------------------------------------------

top = widget_base(/column,title=' ')
id = widget_label(top,val=string_instruct)
id = widget_label(top,val=string_coord)
id = widget_label(top,val=string_head)
id = widget_label(top,val=' ',/dynamic_resize)
widget_control, top, /real
widget_control, id, set_val=' '
 

PRINT
PRINT,'Instructions :'
PRINT,string_instruct
PRINT
PRINT,'selected pixels ('+string_coord+')'
PRINT,string_head
IF KEYWORD_SET (cursor_type) EQ 0 THEN ct= 34 ELSE ct= cursor_type
DEVICE, CURSOR_STANDARD= ct
NEW_POINT:
;--------

CURSOR, xpos, ypos, /WAIT, /DATA
IF (!ERR EQ 4) THEN GOTO, CLOSING
IF (!ERR GT 3) THEN GOTO, NEW_POINT
button = !err
moll2pix, xpos, ypos, id_pix, lon_deg, lat_deg
if (id_pix ge 0) then begin
;     string_out = string(n_points, lon_deg, lat_deg, data(id_pix), id_pix,format='(i4,f11.2,f11.2,e20.5,i12)')
    string_out = string(n_points, lon_deg, lat_deg, data_plot(id_pix), id_pix,format='(i4,f11.2,f11.2,e20.5,i12)')
    IF (button EQ 2) THEN begin
        IF n_points EQ 1 THEN list_pix = id_pix ELSE list_pix = [list_pix, id_pix]
        print,string_out
        n_points= n_points + 1
    ENDIF
    widget_control, id, set_val=string_out
endif

; Suspend going on for a while
WAIT, 0.5

GOTO, NEW_POINT

CLOSING:
;------
widget_control, top, /dest
DEVICE, /CURSOR_ORIGINAL
;if (n_points gt 1) then print,list_pix
print

RETURN
END



