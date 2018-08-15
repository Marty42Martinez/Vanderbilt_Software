function index_word, word_list, word, ERROR = error, VALUE = value
;+
; NAME:
;       INDEX_WORD
;
; PURPOSE:
;       returns the index of the first occurence of Word in the string
;       array word_list
;       (both strings are set to uppercase before comparison)
;
; CALLING SEQUENCE:
;       result = index_word(word_list, word[, ERROR=error, VALUE = value])
;
; INPUTS:
;      word_list = string array
;
;      word      = string looked for in Word_list   or integer
;
; OPTIONAL OUTPUTS:
;      error = named variable containing the error code
;            0 : no error
;            1 : invalid arguments
;            2 : Word out of range (if word is an integer)
;            3 : Word not found (it Word is a string)
;
;      value = named variable containing the value of the string(word)
;
; MODIFICATION HISTORY:
;      March 1999, Eric Hivon, Caltech
;
;-


  if N_params() LT 2 then begin
      print,'error in index_word : INDEX_WORD, Word_list, Word, [ERR]'
      error = 1
      return, -1L
  endif

  if datatype(word_list,2) ne 7 then begin
      print,'error in index_word : Word_list should be a name'
      error = 1
      return,-1L
  endif

  n_words = N_ELEMENTS(word_list)
  if datatype(word,2) le 3 then begin  ; integer
      if (word LT 0 or word GT n_words-1) then begin
          error = 2
          return, -1L
      endif
      error = 0
      value = STRTRIM(word_list(word),2)
      return,LONG(word)
  endif

  if datatype(word,2) eq 7 then begin  ; string
      template = STRTRIM( STRUPCASE(word), 2)
      len  = STRLEN(template)
      list = STRTRIM(STRUPCASE(word_list),2)
      list = STRMID(list,0,len)
      index = WHERE( list EQ template, ni)
      error = 0
      value = STRTRIM(word_list(index(0)),2)
      if (ni LT 1) then error = 3
      return,LONG(index(0))
  endif


  error = 1
  return,-1   ; Word is not string nor an integer
end



