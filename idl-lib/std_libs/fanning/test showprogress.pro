; batch to test showprogress thingy

progressBar = Obj_New("SHOWPROGRESS",message='hello', color=50)
progressBar->Start
FOR j=0,9 DO BEGIN
 Wait, 0.5  ; Would probably be doing something ELSE here!
 progressBar->Update, (j+1)*10
ENDFOR
progressBar->Destroy
Obj_Destroy, progressBar

END