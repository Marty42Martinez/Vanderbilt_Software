function make_1f,n,f_knee, samp_rate=samp_rate


if n_elements(samp_rate) eq 0 then samp_rate = 20.
Fny = samp_rate/2.
;adds a 1/f component to the input noise vector
        nd=n_elements(n)
		m = mean(n)
        if n_elements(f_knee) ne 0 then begin  ;apply f_knee, assuming 20 Hz
                                        ;sampling
                noise=zero_pad(n-m)

                f=findgen(n_elements(noise)/2.)+1.
                f=Fny*f/max(f)
                onef=sqrt((f+f_knee)/f)

                noise=fft(fft(noise)*[onef,conj(reverse(onef))],/inverse)
                noise=float(noise[0:nd-1])

        endif else begin

        print,'No knee frequency specified.'

        endelse

        return,noise+m

end

