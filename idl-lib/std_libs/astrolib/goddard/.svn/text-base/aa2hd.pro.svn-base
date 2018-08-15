<HTML>
<HEADER>
<TITLE>aa2hd.pro documentation</TITLE>
</HEADER>
<BODY BGCOLOR="000000" BACKGROUND="../pics/stars2.gif" TEXT="F0F0FF" VLINK="FFA500" LINK="FFE710">


<CENTER>
<BR>
<B>Documentation for:  <CODE>aa2hd.pro</CODE></B>
</CENTER>
<BR><BR><BR>


<B>Name:</B><BR>
<CODE>aa2hd.pro</CODE><BR><BR>

<B>Purpose:</B><BR>
This function performs a coordinate transform from
terrestrial coordinates (Altitude, Azimuth) to
equatorial coordinates (hour angle, declination).
<BR><BR>

<B>Calling Sequence:</B><BR>
<CODE>Result = AA2HD(<I>Az, Alt</I>)</CODE><BR><BR>

<B>Inputs:</B><BR>
<CODE><I>Az</I></CODE>:	Azimuth in decimal degrees.  Azimuth zero point is
	north, measured positively from north to east.<BR><BR>

</ODE><I>Alt</I></CODE>:	Altitude in decimal degrees.  Altitude zero point
	is the horizion, measured positively to the zenith.
	Maximum value of altitude of 90.0 degrees at the 
	zenith.
<BR><BR>

<B>Keywords:</B><BR>
<I><CODE>Lat</I></CODE>:	Use this keyword to specify a latitude (dd:mm:ss or decimal).
	If this keyword is not specified, a latitude of 37 52' 40''
	(Campbell Hall) is assumed.  <BR><BR>

<B>Outputs:</B><BR>
	This function returns a vector with two elements.
	<CODE>Result[0]</CODE>:  Hour angle in decimal hours.
	<CODE>Result[1]</CODE>:  Declination in decimal degrees.
<BR><BR>

<B>Restrictions:</B><BR>
This procedure will not handle vectors of coordinates.<BR><BR>

<B>Procedure:</B><BR>
The coordinate transformation is performed by forming a
rotation matrix and matrix multiplying with the input coordinate.
<BR><BR>



<B>Example:</B><BR>
<CODE>hd = AA2HD(az, alt, lat=20.0)</CODE><BR><BR>

<B>Modification History:</B><BR>
Written by Murray Brown, November 12, 1997<BR>
Documentation corrected, Curtis Frank, November 15, 1997<BR>
<I><CODE>Lat</I></CODE> keyword added,  CF, December 15, 1997<BR>


<BR><BR><BR><BR><BR>

<CENTER>
<FONT SIZE="-1">
	Last updated April 6, 1998
</FONT>
</CENTER>

</BODY>
</HTML>
