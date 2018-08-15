PRO grid::plot,            XRANGE=XRANGE,XSTYLE=XSTYLE,XTICKV=XTICKV,XTICKS=XTICKS, $
                           YRANGE=YRANGE,YSTYLE=YSTYLE,TITLE=TITLE,OPLOT=OPLOT,COLOR=COLOR,         $
                           mcolor=mcolor,scolor=scolor,mthick=mthick,sthick=sthick,                 $
                           mean_line=mean_line,stdv_line=stdv_line,_EXTRA=_EXTRA,                   $
                           PSYM=PSYM,SYMSIZE=SYMSIZE,dat=dat
;

(self->spatial_mean(/return_time,_EXTRA=_EXTRA))->time_series::plot,$
                           XRANGE=XRANGE,XSTYLE=XSTYLE,XTICKV=XTICKV,XTICKS=XTICKS, $
                           YRANGE=YRANGE,YSTYLE=YSTYLE,TITLE=TITLE,OPLOT=OPLOT,COLOR=COLOR,         $
                           mcolor=mcolor,scolor=scolor,mthick=mthick,sthick=sthick,                 $
                           mean_line=mean_line,stdv_line=stdv_line,_EXTRA=_EXTRA,                   $
                           PSYM=PSYM,SYMSIZE=SYMSIZE,dat=dat
		
END  
