PRO HDFREAD, filename

   ; Open file and initialize the SDS interface.

IF N_ELEMENTS(filename) EQ 0 THEN filename = DIALOG_PICKFILE(File='example.hdf')
IF NOT HDF_ISHDF(filename) THEN BEGIN
   PRINT, 'Invalid HDF file ...'
   RETURN
   ENDIF ELSE $
   PRINT, 'Valid HDF file. Opening "' + filename + '"'
newFileID = HDF_SD_START(filename, /READ)

   ; What is in the file. Print the number of
   ; datasets, attributes, and palettes.

PRINT, 'Reading number of datasets/attributes in file ...'
HDF_SD_FILEINFO, newFileID, datasets, attributes
numPalettes = HDF_DFP_NPALS(filename)
PRINT, ''
PRINT, 'No. of Datasets:   ', datasets
PRINT, 'No. of Attributes: ', attributes
PRINT, 'No. of Palettes:   ', numPalettes
      ; Print the name of each SDS.
PRINT, ''
FOR j=0, datasets-1 DO BEGIN
   thisSDS = HDF_SD_SELECT(newFileID, j)
   HDF_SD_GETINFO, thisSDS, NAME=thisSDSName
   PRINT, 'Dataset No. ', STRTRIM(j, 2), ': ', thisSDSName
ENDFOR

   ; Print the name of each attribute.

PRINT, ''
FOR j=0, attributes-1 DO BEGIN
   HDF_SD_ATTRINFO, newFileID, j, NAME=thisAttr
   PRINT, 'File Attribute No. ', + STRTRIM(j, 2), ': ', thisAttr
ENDFOR

   ; Find the index of the "Gridded Data" SDS.

index = HDF_SD_NAMETOINDEX(newFileID, "Gridded Data")

   ; Select the Gridded Data SDS.

thisSdsID = HDF_SD_SELECT(newFileID, index)

   ; Print the names of the Gridded Data attributes.

PRINT, ''
HDF_SD_GETINFO, thisSdsID, NATTS=numAttributes
PRINT, 'Number of Gridded Data attributes: ', numAttributes
FOR j=0,numAttributes-1 DO BEGIN
   HDF_SD_ATTRINFO, thisSdsID, j, NAME=thisAttr
   PRINT, 'SDS Attribute No. ',+STRTRIM(j, 2), ': ', thisAttr
ENDFOR

   ; Get the data.

PRINT, ''
PRINT, 'Reading gridded data ...'
HDF_SD_GETDATA, thisSdsID, newGriddedData

   ; Get the palette associated with this data.

PRINT, 'Reading the color palette ...'
HDF_DFP_GETPAL, filename, thisPalette

   ; Get the gridded DIMENSION data.

longitudeDimID = HDF_SD_DIMGETID(thisSdsID, 0)
latitudeDimID = HDF_SD_DIMGETID(thisSdsID, 1)
PRINT, 'Reading the dimension data ...'
HDF_SD_DIMGET, longitudeDimID, LABEL=lonlable, SCALE=lonscale, UNIT=lonunits
HDF_SD_DIMGET, latitudeDimID, LABEL=latlable, SCALE=latscale, UNIT=latunits

   ; Get the DATE and EXPERIMENT attributes.

PRINT, 'Reading file attributes for plot ...'
dateAttID = HDF_SD_ATTRFIND(newFileID, 'DATE')
expAttID = HDF_SD_ATTRFIND(newFileID, 'EXPERIMENT')
HDF_SD_ATTRINFO, newFileID, dateAttID, DATA=thisDate
HDF_SD_ATTRINFO, newFileID, expAttID, DATA=thisExperiment

   ; Draw a contour map of the data.

PRINT, 'Drawing contour plot ...'
WINDOW, XSIZE=400, YSIZE=400
TVLCT, TRANSPOSE(CONGRID(thisPalette, 3, !D.N_COLORS-1))
TVIMAGE, BYTSCL(newGriddedData, TOP=!D.N_COLORS-1), $
   POSITION=[0.15, 0.15, 0.95, 0.87]
CONTOUR, newGriddedData, lonscale, latscale, $
   XSTYLE=1, YSTYLE=1, NLEVELS=14, /NOERASE, $
   XTITLE = lonlable + ' (' + lonunits + ')', $
   YTITLE = latlable + ' (' + latunits + ')', $
   TITLE = thisExperiment + ' on ' + thisDate, $
   POSITION=[0.15, 0.15, 0.95, 0.87], /FOLLOW, $
   CHARSIZE=1.25, C_COLOR=0
HDF_SD_END, newFileID
PRINT, 'Read operation complete.'
END