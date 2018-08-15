FUNCTION decay,t,A
offset=A[0]
mag=A[1]
tau=A[2]
ft=offset+mag*exp(-t/tau)
return,[ [ft],[1.0],[exp(-t/tau)],[(mag*t/tau^2)*exp(-t/tau)]]
end