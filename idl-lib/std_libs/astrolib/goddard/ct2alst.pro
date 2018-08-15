<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title> ----- Documentation for /home/ay120b/idl/ct2alst.pro ----- </title>
<!-- produced automatically using doc2html.pro -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
</head>
<BODY BGCOLOR="000000" BACKGROUND="../pics/stars2.gif" TEXT="F0F0FF" VLINK="FFA500" LINK="FFE710">

<CENTER><p>
----- Documentation for /home/ay120b/idl/ct2alst.pro -----
</CENTER><p>
<pre>

 NAME:
     CT2ALST
 PURPOSE:
     To convert from Local Civil Time to Local APPARENT Sidereal
     Time. (See ct2lst to convert to local mean sidereal time.)

 CALLING SEQUENCE:
     CT2ALST, Lst, Lng, Tz, Time, [Day, Mon, Year] 
                       or
     CT2ALST, Lst, Lng, dummy, JD

 INPUTS:
     Lng  - The longitude in degrees (east of Greenwich) of the place for 
            which the local sidereal time is desired, scalar.   The Greenwich 
            sidereal time (GST) can be found by setting Lng = 0.
     Tz  - The time zone of the site in hours.  Use this to easily account 
            for Daylight Savings time (e.g. 4=EDT, 5 = EST/CDT), scalar
            This parameter is not needed (and ignored) if Julian date is 
            supplied.
     Time or JD  - If more than four parameters are specified, then this is 
               the time of day of the specified date in decimal hours.  If 
               exactly four parameters are specified, then this is the 
               Julian date of time in question, scalar or vector

 OPTIONAL INPUTS:
      Day -  The day of the month (1-31),integer scalar or vector
      Mon -  The month, in numerical format (1-12), integer scalar or 
      Year - The year (e.g. 1987)

 OUTPUTS:
       Lst   The Local Sidereal Time for the date/time specified in hours.

 RESTRICTIONS:
       If specified, the date should be in numerical form.  The year should
       appear as yyyy.

 PROCEDURE:
       The Julian date of the day and time is question is used to determine
       the number of days to have passed since 0 Jan 2000.  This is used
       in conjunction with the GST of that date to extrapolate to the current
       GST; this is then used to get the LST.    See Astronomical Algorithms
       by Jean Meeus, p. 84 (Eq. 11-4) for the constants used.

 EXAMPLE:
       Find the Greenwich apparent sidereal time (GAST) on 1988 April
       10, 00 UT

       For GAST, we set lng=0, and for UT we set Tz = 0

       IDL> CT2ALST, lst, 0, 0, 0, 10, 4, 1988

               ==> lst =  13.229376 (= 13h 13m 45.753s)

       The astronomical almanac lists 13h 13m 45.7430s


 PROCEDURES USED:
       jdcnv - Convert from year, month, day, hour to julian date
       nutate - approximate longitude nutation 

 MODIFICATION HISTORY:
     Adapted from the FORTRAN program GETSD by Michael R. Greason, STX, 
               27 October 1988.
     Use IAU 1984 constants Wayne Landsman, HSTX, April 1995, results 
               differ by about 0.1 seconds  
     Converted to IDL V5.0   W. Landsman   September 1997
     Longitudes measured *east* of Greenwich   W. Landsman    December 1998
     Slight modification to CT2LST by Erik Shirokoff, Oct 2001.

</pre>

<p><hr>
<center>
This document was prepared automatically using doc2html.pro<br>
Fri Dec 14 17:49:02 PST 2001
</center>
</body>
</html>
