FUNCTION Firstseg, data, range_, minsize=minsize

N = n_elements(data)
if n_elements(minsize) eq 0 then minsize=1000
minsize = long(minsize)
; find start point

found=0.
sofar = 0.
done = 0.
i=-1L
repeat begin
	i = i+1
	if inrange(data(i),range_) then begin
		sofar = sofar+1.
		if (sofar eq 1.) then start=i
	endif else sofar=0.
	if sofar GE minsize then found=1.
	if (found AND (sofar eq 0)) then done=1.
endrep until (done OR (i EQ N-1))

if (found AND not(done)) then seg = [start,N-1] ; segment found, but continues to end of data array
if done then seg = [start,i-1] ; normal graceful exit condition
if not(found) then seg=0.  ; no appropriate segment found in data array
if found then seg = shear(data,seg)
return, seg

END