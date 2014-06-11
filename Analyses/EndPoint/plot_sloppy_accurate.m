figure
subplot(2,2,1)
plot(-100:500,nanmean(SDF_in.targ.accurate.ss2),'k',-100:500,nanmean(SDF_out.targ.accurate.ss2),'--k',-100:500,nanmean(SDF_in.targ.accurate.ss4),'b',-100:500,nanmean(SDF_out.targ.accurate.ss4),'--b',-100:500,nanmean(SDF_in.targ.accurate.ss8),'r',-100:500,nanmean(SDF_out.targ.accurate.ss8),'--k')
title('accurate')
xlim([-100 500])


subplot(2,2,2)
plot(-400:200,nanmean(SDF_in.resp.accurate.ss2),'k',-400:200,nanmean(SDF_out.resp.accurate.ss2),'--k',-400:200,nanmean(SDF_in.resp.accurate.ss4),'b',-400:200,nanmean(SDF_out.resp.accurate.ss4),'--b',-400:200,nanmean(SDF_in.resp.accurate.ss8),'r',-400:200,nanmean(SDF_out.resp.accurate.ss8),'--k')
title('accurate')
xlim([-400 200])


subplot(2,2,3)
plot(-100:500,nanmean(SDF_in.targ.sloppy.ss2),'k',-100:500,nanmean(SDF_out.targ.sloppy.ss2),'--k',-100:500,nanmean(SDF_in.targ.sloppy.ss4),'b',-100:500,nanmean(SDF_out.targ.sloppy.ss4),'--b',-100:500,nanmean(SDF_in.targ.sloppy.ss8),'r',-100:500,nanmean(SDF_out.targ.sloppy.ss8),'--k')
title('sloppy')
xlim([-100 500])
 
 
subplot(2,2,4)
plot(-400:200,nanmean(SDF_in.resp.sloppy.ss2),'k',-400:200,nanmean(SDF_out.resp.sloppy.ss2),'--k',-400:200,nanmean(SDF_in.resp.sloppy.ss4),'b',-400:200,nanmean(SDF_out.resp.sloppy.ss4),'--b',-400:200,nanmean(SDF_in.resp.sloppy.ss8),'r',-400:200,nanmean(SDF_out.resp.sloppy.ss8),'--k')
title('sloppy')
xlim([-400 200])
