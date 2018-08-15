pro allmean, a1,a2,a3,a4,a5, start, stop, jmul

junit = ' mV'
if (jmul eq 1.0) then junit = ' V'
print, 'tp0 =', mean(a1[start:stop]),'    +/- ', stddev(a1[start:stop]), ' V'
print, 'tp1 =', mean(a2[start:stop]), '    +/- ', stddev(a2[start:stop]),' V'
print, 'j1 = ', mean(a3[start:stop])*jmul, '    +/- ', stddev(a3[start:stop])*jmul,junit
print, 'j2 = ', mean(a4[start:stop])*jmul, '    +/- ', stddev(a4[start:stop])*jmul,junit
print, 'j3 = ', mean(a5[start:stop])*jmul, '    +/- ', stddev(a5[start:stop])*jmul,junit

end