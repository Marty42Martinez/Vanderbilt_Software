PRO Compute_POLAR_Ctheory
	;!;!;!;!;!;!;!;!;!;!;!;!;!;!
	;
	; a f  'f77 -r8 -silent       compute.f -o compute.x'
	; a ff 'f77 -r8 -silent -fast compute.f -o compute.x'
	;
	; a r  'compute.x'
	;!;!;!;!;!;!;!;!;!;!;!;!;!;!

      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ;	call test
      ;!;!;!;!;!;!;!;!;!;!;!;!;!

	option = 0
	npixmax = 360
	lmax = 100
      ; fname =  '~/a2/polar/data/qaz_j1is2.txt'
 	fname =  'z:\polar_analysis\work\2000\november\j1i_1120_1.dat'
 	print, 'Loading ', fname
 	LoadNewPixelizedMap, npixmax,npix,dir,FWHM,Q,dQ,U,dU,fname


    print , 'Normalizing data vectors:'
 	NormalizeUnitVectors, npix,dir

 	;fname =  'qaz_cl.txt' ; REAL NAME: fiducial_Cl.dat
    fname = 'z:\polar_analysis\work\apr02\simmaps\flatcl.dat'
 	print, 'Loading ', fname
 	LoadCl, lmax,Cl,fname
      ;!;!;!;!;!;!;!;!;!;!;!;!;!
      ; USED FOR DEBUGGING ONLY:
      ; do l=2, lmax
      ;    Cl(1,l) = 1.
      ;    Cl(2,l) = 1.
      ;    Cl(3,l) = 1.
      ;    Cl(4,l) = 1.
      ; end do
      ;!;!;!;!;!;!;!;!;!;!;!;!;!

 	print, 'Computing the beam factors B_l for each pixel:'
 	GetB, npixmax,lmax,FWHM,B

    print, 'Getting Covar matrix:'
 	ComputeC, npixmax,npix,lmax,dir,B,Cl,option,C
	stopnow
	end