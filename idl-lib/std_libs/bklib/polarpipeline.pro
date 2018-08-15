pro polarpipeline, section

;This is the main program. for each section of data.
;It produces the final data vectors and covar matrices
;for all correlators.



;************************************************************************************

;STEP 1 : unpack data and flag bad data.
;This produces TOD,ROD and all applicable flags


;STEP 1 SUB PROGRAMS:


;CREATETOD.PRO
;TODTEST.PRO
;CREATEROD.PRO
;RODTEST.PRO
;MASTERFLAG.PRO



;CREATETOD.PRO:
;
; PURPOSE: produce TOD from hourfiles.

; CALLING SEQUENCE:  createtod, section
;
; INPUT: hourfiles.dat
;
; PROCEDURE: convert N_HOURFILES of form sectionXX.dat data
;from 9000xN_CHANNELS to 9000XNFILES for each DATA channel
;of interest

; OUTPUT: sectionXXtod.var {j1itod,j2itod,etc}
;
; SIDE EFFECTS:
;
; RESTRICTIONS: see input
;
; MODIFICATION HISTORY: COD has a version  [09/18/00]




;TODTEST.PRO:
;
; PURPOSE: Apply statistical tests to TOD,
;based on 5 or so statisitcal properties of the TOD
;which are arranged as a structure. The structure
;has n_files entries. The tests are all coming from the PSD of
;the data in an hourfile. The tests are:

;j1i,j2i,j3i 1-phi components vs. 1-phi threshold
;j1i,j2i,j3i 2-phi components. vs. 2-phi threshold
;j1i,j2i,j3i 1/f knees vs. knee threshold
;RMS of all samples [noise floor between 2 frequencies] vs. NET threshold
;others?


;Initially, set all thresholds arbitrarily, then see how much
;data is lost. Iterate if necessary

;
;Each of the above generates a flag, so we make
; 4tests*3corr's = 12 flags. Afterwards, we go back and
; look at files before/after and make a second flag, so
;there are 24 flags!

;TBD: Setting of thresholds. How to use the flags:
;We may choose to blank the data based on a subset [ie not
;all ] of the flags

; CALLING SEQUENCE:  todtest, section
;
; INPUT: sectionXXtod.var, format must be array(9000,n_files)
;
; PROCEDURE: take in TOD, for each hourfile
; Apply tests: [ie, is the 1-phi > tod1phithresh ?]
;produce todflag:

;flag types: channel_tod_test_flag_1

;eg: j1i_tod_phi_flag_1,
;	 j2i_tod_net_flag_1
;these are vectors which are nfiles long, 12 total

;After all individual
;hourfiles have been flagged, go back and flag any hourfile
;before or after. This produces [channel_tod_test_flag_2],
;which are vectors which are nfiles long, 12 total



;OUTPUT: sectionXXtodflags.var, which contain the two types
;flags, tod1,tod2, for each channel, for each flag. Also, save
;the data values of the tests [ie, save the 1-phi] for
;later use
;
; SIDE EFFECTS:
;
; RESTRICTIONS: see input
;
; MODIFICATION HISTORY: no version, assigned to COD [09/19/00]



;CREATEROD.PRO
;
; PURPOSE: produce ROD from TOD.

; CALLING SEQUENCE:  createrod, section
;
; INPUT: sectionXXtod.var, format must be array(9000,n_files)
;
; PROCEDURE: convert sectionXXtod.var {j1itod,j1otod,...} data
;from 9000xNFILES to 600xNROTS (need to specify size [600] to
;allocate memory), for all data (even for hour files which
; failed todtest)
;produces


; OUTPUT: sectionXXrod.var {j1irod,j2irod,etc}
;
; SIDE EFFECTS:
;
; RESTRICTIONS: see input
;
; MODIFICATION HISTORY: no version yet [09/18/00]



;RODTEST.PRO:
;
; PURPOSE: Apply statistical tests to ROD.

;
; CALLING SEQUENCE:  rodtest, section
;
; INPUT: sectionXXrod.var, format must be array(600,nrots)
;
; OUTPUT: sectionXXrodflag.var , contains all flags and values
; of test variables.
;
; SIDE EFFECTS:
;
; PROCEDURE: Take a rotation, calculate its mean and stddev.
;Flag an entire rotation
;if it has a n*sigma_rot point in it. After all individual
;rotations have been flagged, go back and flag any rotation
;before or after.

;Each of the above generates a flag [j1irodflag1], so we make
; 1test*3corr's = 3 flags. Afterwards, we go back and
; look at files before/after and set a second flag [j1irodflag2]
; so there are 6 flags.
;
;flag types: j1irodflag1,j1irodflag2

; RESTRICTIONS: see input
;
; MODIFICATION HISTORY: BK has version called 'rodtest.pro'




;MASTERFLAG.PRO:
;
; PURPOSE: take all sub-flags to produce a master flag which
; we now use to determine which data is kept and combined via
;weighted avgs.

;
; CALLING SEQUENCE:  masterflag, section
;
; INPUT: sectionXXrod.var, format must be array(600,nrots) and
;        sectionXXrodflag.var
;        sectionXXtodflag.var

; OUTPUT: sectionXXdata.var
;
; SIDE EFFECTS:
;
; PROCEDURE: Take in all data and flags from a
;single data section. Produce final ROD from all
; data which passes all ROD & TOD tests, for each channel. Timestamp
; each kept rotation. .
; RESTRICTIONS: see input
;
; MODIFICATION HISTORY:


;************************************************************************************

;STEP 2: Takes in rod and calculates Stokes parameters, for
;all rotations and calulates Stokes for all rotations [even those
;that fail all tests -- we may want to run tests on bad rotations
;later].
;STEP 2 SUBPROS
;two options here: to bin or not to bin?

;binstokes.pro -- bin the data into pre/post bins then fit
;for stokes with individual errors per point

;nobinstokes.pro -- assign each point the rms of the data, then
;fit for stokes

;************************************************************************************


;STEP 3: Takes in rod, masterflag, and timestamp data and projects
;data into bins in RA, then weighted averages all data and
;calculates error bars [covariance matrices for each sky-pixel]

;STEP 2 SUBPROS
;createpod.pro

end