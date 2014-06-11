
function LL = fitDDM_SAT_calcLL(param,srt,trls)

plotFlag = 0;


FreeFix = evalin('caller','FreeFix');
a = param(evalin('caller','1:length(a)'));
Ter = param(evalin('caller','length(a)+1:length(a)+length(Ter)'));
eta = param(evalin('caller','length(a)+length(Ter)+1:length(a)+length(Ter)+length(eta)'));
z = param(evalin('caller','length(a)+length(Ter)+length(eta)+1:length(a)+length(Ter)+length(eta)+length(z)'));
sZ = param(evalin('caller','length(a)+length(Ter)+length(eta)+length(z)+1:length(a)+length(Ter)+length(eta)+length(z)+length(sZ)'));
st = param(evalin('caller','length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+1:length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+length(st)'));
v = param(evalin('caller','length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+length(st)+1:length(param)'));
include_med = evalin('caller','include_med');


%set parameters based on free/shared
if include_med
    if FreeFix(1) == 1
        params.slow(1) = a;
        params.med(1) = a;
        params.fast(1) = a;
    elseif FreeFix(1) == 3
        params.slow(1) = a(1);
        params.med(1) = a(2);
        params.fast(1) = a(3);
    end
    
    if FreeFix(2) == 1
        params.slow(2) = Ter;
        params.med(2) = Ter;
        params.fast(2) = Ter;
    elseif FreeFix(2) == 3
        params.slow(2) = Ter(1);
        params.med(2) = Ter(2);
        params.fast(2) = Ter(3);
    end
    
    if FreeFix(3) == 1
        params.slow(3) = eta;
        params.med(3) = eta;
        params.fast(3) = eta;
    elseif FreeFix(3) == 3
        params.slow(3) = eta(1);
        params.med(3) = eta(2);
        params.fast(3) = eta(3);
    end
    
    if FreeFix(4) == 1
        params.slow(4) = z;
        params.med(4) = z;
        params.fast(4) = z;
    elseif FreeFix(4) == 3
        params.slow(4) = z(1);
        params.med(4) = z(2);
        params.fast(4) = z(3);
    end
    
    if FreeFix(5) == 1
        params.slow(5) = sZ;
        params.med(5) = sZ;
        params.fast(5) = sZ;
    elseif FreeFix(5) == 3
        params.slow(5) = sZ(1);
        params.med(5) = sZ(2);
        params.fast(5) = sZ(3);
    end
    
    if FreeFix(6) == 1
        params.slow(6) = st;
        params.med(6) = st;
        params.fast(6) = st;
    elseif FreeFix(6) == 3
        params.slow(6) = st(1);
        params.med(6) = st(2);
        params.fast(6) = st(3);
    end
    
    if FreeFix(7) == 1
        params.slow(7) = v;
        params.med(7) = v;
        params.fast(7) = v;
    elseif FreeFix(7) == 3
        params.slow(7) = v(1);
        params.med(7) = v(2);
        params.fast(7) = v(3);
    end
    
else %not include med (Neutral) condition
    if FreeFix(1) == 1
        params.slow(1) = a;
        params.fast(1) = a;
    elseif FreeFix(1) == 2
        params.slow(1) = a(1);
        params.fast(1) = a(2);
    end
    
    if FreeFix(2) == 1
        params.slow(2) = Ter;
        params.fast(2) = Ter;
    elseif FreeFix(2) == 2
        params.slow(2) = Ter(1);
        params.fast(2) = Ter(2);
    end
    
    if FreeFix(3) == 1
        params.slow(3) = eta;
        params.fast(3) = eta;
    elseif FreeFix(3) == 2
        params.slow(3) = eta(1);
        params.fast(3) = eta(2);
    end
    
    if FreeFix(4) == 1
        params.slow(4) = z;
        params.fast(4) = z;
    elseif FreeFix(4) == 2
        params.slow(4) = z(1);
        params.fast(4) = z(2);
    end
    
    if FreeFix(5) == 1
        params.slow(5) = sZ;
        params.fast(5) = sZ;
    elseif FreeFix(5) == 2
        params.slow(5) = sZ(1);
        params.fast(5) = sZ(2);
    end
    
    if FreeFix(6) == 1
        params.slow(6) = st;
        params.fast(6) = st;
    elseif FreeFix(6) == 2
        params.slow(6) = st(1);
        params.fast(6) = st(2);
    end
    
    if FreeFix(7) == 1
        params.slow(7) = v;
        params.fast(7) = v;
    elseif FreeFix(7) == 2
        params.slow(7) = v(1);
        params.fast(7) = v(2);
    end
    
end

slow_correct_made_dead = trls.slow.correct;
slow_errors_made_dead = trls.slow.errors;
fast_correct_made_dead_withCleared = trls.fast.correct;
fast_errors_made_dead_withCleared = trls.fast.errors;

if include_med
    med_correct = trls.med.correct;
    med_errors = trls.med.errors;
end

f_correct.slow = PDFDif(srt(trls.slow.correct,1)',1,params.slow)';
f_errors.slow = PDFDif(srt(trls.slow.errors,1)',0,params.slow)';
f_correct.med = PDFDif(srt(trls.med.correct,1)',1,params.med)';
f_errors.med = PDFDif(srt(trls.med.errors,1)',0,params.med)';
f_correct.fast = PDFDif(srt(trls.fast.correct,1)',1,params.fast)';
f_errors.fast = PDFDif(srt(trls.fast.errors,1)',0,params.fast)';

f_all = [f_correct.slow ; f_errors.slow ; f_correct.med ; f_errors.med ; f_correct.fast ; f_errors.fast];
f_all(find(f_all < 1e-5)) = 1e-5;

LL = -nansum(log(f_all));

t = 0:.01:1;
winner.slow = CDFDif(t,1,params.slow);
loser.slow = CDFDif(t,0,params.slow);

winner.fast = CDFDif(t,1,params.fast);
loser.fast = CDFDif(t,0,params.fast);


CDF.slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead,srt);
CDF.fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared,srt);

if include_med
    winner.med = CDFDif(t,1,params.med);
    loser.med = CDFDif(t,0,params.med);
    CDF.med = getDefectiveCDF(med_correct,med_errors,srt);
end

%stupid fix for plotting. Just tile parameters when they are all shared, as if they were free

if plotFlag
    
    if FreeFix(1) == 1; a = repmat(a,1,max(FreeFix)); end
    if FreeFix(2) == 1; Ter = repmat(Ter,1,max(FreeFix)); end
    if FreeFix(3) == 1; eta = repmat(eta,1,max(FreeFix)); end
    if FreeFix(4) == 1; z = repmat(z,1,max(FreeFix)); end
    if FreeFix(5) == 1; sZ = repmat(sZ,1,max(FreeFix)); end
    if FreeFix(6) == 1; st = repmat(st,1,max(FreeFix)); end
    if FreeFix(7) == 1; v = repmat(v,1,max(FreeFix)); end
    
    
    
    subplot(1,3,1)
    plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok','markersize',8);
    hold on
    plot(CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',8)
    plot(0:.01:1,winner.slow,'k')
    plot(0:.01:1,loser.slow,'r')
    xlim([0 1])
    ylim([0 1])
    box off
    
    text(.100,.95,['a = ' mat2str(round(a(1)*100)/100)])
    text(.100,.90,['Ter = ' mat2str(round(Ter(1)*100)/100)])
    text(.100,.85,['eta = ' mat2str(round(eta(1)*100)/100)])
    text(.100,.80,['z = ' mat2str(round(z(1)*100)/100)])
    text(.100,.75,['sZ = ' mat2str(round(sZ(1)*100)/100)])
    text(.100,.70,['st = ' mat2str(round(st(1)*100)/100)])
    text(.100,.65,['v = ' mat2str(round(v(1)*100)/100)])
    
    
    
    if include_med
        subplot(1,3,2)
        plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok','markersize',8);
        hold on
        plot(CDF.med.err(:,1),CDF.med.err(:,2),'or','markersize',8)
        plot(0:.01:1,winner.med,'k')
        plot(0:.01:1,loser.med,'r')
        xlim([0 1])
        ylim([0 1])
        box off
        
        text(.100,.95,['a = ' mat2str(round(a(2)*100)/100)])
        text(.100,.90,['Ter = ' mat2str(round(Ter(2)*100)/100)])
        text(.100,.85,['eta = ' mat2str(round(eta(2)*100)/100)])
        text(.100,.80,['z = ' mat2str(round(z(2)*100)/100)])
        text(.100,.75,['sZ = ' mat2str(round(sZ(2)*100)/100)])
        text(.100,.70,['st = ' mat2str(round(st(2)*100)/100)])
        text(.100,.65,['v = ' mat2str(round(v(2)*100)/100)])
    end
    
    subplot(1,3,3)
    plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok','markersize',8);
    hold on
    plot(CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
    plot(0:.01:1,winner.fast,'k')
    plot(0:.01:1,loser.fast,'r')
    xlim([0 1])
    ylim([0 1])
    box off
    
    text(.100,.95,['a = ' mat2str(round(a(3)*100)/100)])
    text(.100,.90,['Ter = ' mat2str(round(Ter(3)*100)/100)])
    text(.100,.85,['eta = ' mat2str(round(eta(3)*100)/100)])
    text(.100,.80,['z = ' mat2str(round(z(3)*100)/100)])
    text(.100,.75,['sZ = ' mat2str(round(sZ(3)*100)/100)])
    text(.100,.70,['st = ' mat2str(round(st(3)*100)/100)])
    text(.100,.65,['v = ' mat2str(round(v(3)*100)/100)])
    
    [ax h] = suplabel(['LL = ' mat2str(LL)],'t');
    set(h,'fontsize',12,'fontweight','bold')
    
    pause(.001)
    cla
    
    subplot(1,3,3)
    cla
    
    subplot(1,3,2)
    cla
    
    subplot(1,3,1)
    cla
    
end