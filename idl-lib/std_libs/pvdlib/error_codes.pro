;+
;
; NAME:
;       error_codes
;
; PURPOSE:
;       Include file containing error handling codes.
;
; CATEGORY:
;       Error handling
;
; LANGUAGE:
;       IDL v5
;
; CALLING SEQUENCE:
;       @error_codes
;
; CALLS:
;       None.
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       Values can be changed during program execution since there is no way to
;       declare parameters in IDL.
;
; RESTRICTIONS:
;       None.
;
; CREATION HISTORY:
;       Written by:     Paul van Delst, CIMSS/SSEC, 21-Dec-2000
;                       paul.vandelst@ssec.wisc.edu
;
;  Copyright (C) 2000 Paul van Delst, CIMSS/SSEC/UW-Madison
;
;  This program is free software; you can redistribute it and/or
;  modify it under the terms of the GNU General Public License
;  as published by the Free Software Foundation; either version 2
;  of the License, or (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with this program; if not, write to the Free Software
;  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;
;-


  ;#----------------------------------------------------------------------------#
  ;#                         -- Define error codes --                           #
  ;#----------------------------------------------------------------------------#

  SUCCESS =  1L
  FAILURE = -1L



;-------------------------------------------------------------------------------
;                          -- MODIFICATION HISTORY --
;-------------------------------------------------------------------------------
;
; $Id: error_codes.pro,v 1.1 2000/12/21 16:59:32 paulv Exp $
;
; $Date: 2000/12/21 16:59:32 $
;
; $Revision: 1.1 $
;
; $State: Exp $
;
; $Log: error_codes.pro,v $
; Revision 1.1  2000/12/21 16:59:32  paulv
; Initial checkin.
;
;
;
;
