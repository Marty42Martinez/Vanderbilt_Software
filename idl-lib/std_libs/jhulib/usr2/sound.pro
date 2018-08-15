;-------------------------------------------------------------
;+
; NAME:
;       SOUND
; PURPOSE:
;       Gives sound on sparc station 1.
; CATEGORY:
; CALLING SEQUENCE:
;       sound, f
; INPUTS:
;       f = frequency array (Hz).             in
;       May be 2-d: f = [[f1],[f2],...]
;       where length of f1 = length of f2 ...
; KEYWORD PARAMETERS:
;       Keywords:
;         OUT = c.  Returns array to be sent to sparc speaker.
;         IN = c.   Play given array through sparc speaker.
;            If IN is given then f is ignored.
;         /PLAY = play sound from array f or IN.
;            Must be used to play sound.
;         ENVELOPE=env  Loudness envelope (def=all 1).
;            Must have as many points as f.  May be 2-d with
;            a separate envelope for each freq array.
;         SMAX=smax  Max loudness (0 to 1., def=1.).
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Note: f is processed at the rate of 8192
;         elements/second.  So for 1 second of
;         sound the array must be 8192 elements long.
; MODIFICATION HISTORY:
;       R. Sterner, 26 Dec, 1989
;
; Copyright (C) 1989, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro sound, f, help=hlp, out=c, in=cin, play=ply, $
	  envelope=env, smax=smax, debug=dbg
 
	if keyword_set(hlp) then begin
	  print,' Gives sound on sparc station 1.'
	  print,' sound, f'
	  print,'   f = frequency array (Hz).             in'
	  print,'   May be 2-d: f = [[f1],[f2],...]'
	  print,'   where length of f1 = length of f2 ...'
	  print,' Keywords:'
	  print,'   OUT = c.  Returns array to be sent to sparc speaker.'
	  print,'   IN = c.   Play given array through sparc speaker.'
	  print,'      If IN is given then f is ignored.'
	  print,'   /PLAY = play sound from array f or IN.
	  print,'      Must be used to play sound.'
	  print,'   ENVELOPE=env  Loudness envelope (def=all 1).'
	  print,'      Must have as many points as f.  May be 2-d with'
	  print,'      a separate envelope for each freq array.'
	  print,'   SMAX=smax  Max loudness (0 to 1., def=1.).'
	  print,' Note: f is processed at the rate of 8192'
	  print,'   elements/second.  So for 1 second of'
	  print,'   sound the array must be 8192 elements long.'
	  return
	endif
 
	if n_elements(smax) eq 0 then smax = 1.
 
	eflag = 0
	if n_elements(env) ne 0 then begin
	  eflag = 1
	  sz = size(env)
	  if sz(0) eq 1 then lste=0 else lste=sz(2)-1
	endif
 
	if n_params(0) gt 0 then begin
	  t = 2.*!dpi/8192.
	  sz = size(f)
	  nx = sz(1) + 0.			; Length of each component.
	  if sz(0) eq 1 then begin		; Only one component.
	    s = sin(cumulate(t*(f>1)))		; Waveform.
	    if eflag then s = env(*,lste)*s	; Loudness envelope.
	  endif else begin			; Multiple components.
	    s = sin(cumulate(t*(f(*,0)>1)))     ; First component.
	    if eflag then s = env(*,lste)*s     ; Loudness envelope.
	    for j = 1, sz(2)-1 do begin		; Add other components.
	      s2 = sin(cumulate(t*(f(*,j)>1)))
	      if eflag then s2 = env(*,lste)*s2; Loudness envelope.
	      s = s + s2			; Add result.
	    endfor
	  endelse
	  c = s/max(abs(s))
	  c = fix(c*smax*32767)
	endif
 
	if keyword_set(dbg) then stop,'Stopped in sound.'
 
	if n_elements(cin) gt 0 then c = cin	; Use sound array provided.
 
	if keyword_set(ply) then begin		; Play sound.
	  on_ioerror, done
	  get_lun, lun
	  openw, lun, '/dev/audio'
	  writeu, lun, c
	  free_lun, lun
done:	  free_lun, lun
	endif
 
	return
	end
