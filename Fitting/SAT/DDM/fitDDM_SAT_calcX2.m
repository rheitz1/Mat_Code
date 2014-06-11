
function X2 = fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq)

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


N.slow.correct = length(trls.slow.correct);
N.slow.errors = length(trls.slow.errors);
N.slow.all = N.slow.correct + N.slow.errors;

N.fast.correct = length(trls.fast.correct);
N.fast.errors = length(trls.fast.errors);
N.fast.all = N.fast.correct + N.fast.errors;

if include_med
    N.med.correct = length(trls.med.correct);
    N.med.errors = length(trls.med.errors);
    N.med.all = N.med.correct + N.med.errors;
end


%CDFDif takes care of subtracting T0 for you so no need to do that here, as with LBA

%Note on inf:  For some reason, unlike the LBA the DDM does not necessarily predict asymptotic
%performance at the last quantile (the 100th percentile of the observed data).  Thus, to get the
%predicted frequencies to add up to the observed frequencies, you have to add that last infinity
%quantile.  However, the observed data will always have 0 observations there, because there is nothing
%later than the 100th percentile. Maybe it will fit better this way?
pred_prop.slow.correct(1) = CDFDif(ntiles.slow.correct(1),1,params.slow);
pred_prop.slow.correct(2) = CDFDif(ntiles.slow.correct(2),1,params.slow);
pred_prop.slow.correct(3) = CDFDif(ntiles.slow.correct(3),1,params.slow);
pred_prop.slow.correct(4) = CDFDif(ntiles.slow.correct(4),1,params.slow);
pred_prop.slow.correct(5) = CDFDif(ntiles.slow.correct(5),1,params.slow);
pred_prop.slow.correct(6) = CDFDif(ntiles.slow.correct(6),1,params.slow);
pred_prop.slow.correct(7) = CDFDif(inf,1,params.slow);
pred_prop.slow.correct = diff([0 pred_prop.slow.correct]);


pred_prop.slow.errors(1) = CDFDif(ntiles.slow.errors(1),0,params.slow);
pred_prop.slow.errors(2) = CDFDif(ntiles.slow.errors(2),0,params.slow);
pred_prop.slow.errors(3) = CDFDif(ntiles.slow.errors(3),0,params.slow);
pred_prop.slow.errors(4) = CDFDif(ntiles.slow.errors(4),0,params.slow);
pred_prop.slow.errors(5) = CDFDif(ntiles.slow.errors(5),0,params.slow);
pred_prop.slow.errors(6) = CDFDif(ntiles.slow.errors(6),0,params.slow);
pred_prop.slow.errors(7) = CDFDif(inf,0,params.slow);
pred_prop.slow.errors = diff([0 pred_prop.slow.errors]);

% multiply by .all because CDFDif returns defective CDF!!  See also fitLBA_SAT_calcX2.
pred_freq.slow.correct = pred_prop.slow.correct .* N.slow.all;
pred_freq.slow.errors = pred_prop.slow.errors .* N.slow.all;

pred_prop.fast.correct(1) = CDFDif(ntiles.fast.correct(1),1,params.fast);
pred_prop.fast.correct(2) = CDFDif(ntiles.fast.correct(2),1,params.fast);
pred_prop.fast.correct(3) = CDFDif(ntiles.fast.correct(3),1,params.fast);
pred_prop.fast.correct(4) = CDFDif(ntiles.fast.correct(4),1,params.fast);
pred_prop.fast.correct(5) = CDFDif(ntiles.fast.correct(5),1,params.fast);
pred_prop.fast.correct(6) = CDFDif(ntiles.fast.correct(6),1,params.fast);
pred_prop.fast.correct(7) = CDFDif(inf,1,params.fast);
pred_prop.fast.correct = diff([0 pred_prop.fast.correct]);


pred_prop.fast.errors(1) = CDFDif(ntiles.fast.errors(1),0,params.fast);
pred_prop.fast.errors(2) = CDFDif(ntiles.fast.errors(2),0,params.fast);
pred_prop.fast.errors(3) = CDFDif(ntiles.fast.errors(3),0,params.fast);
pred_prop.fast.errors(4) = CDFDif(ntiles.fast.errors(4),0,params.fast);
pred_prop.fast.errors(5) = CDFDif(ntiles.fast.errors(5),0,params.fast);
pred_prop.fast.errors(6) = CDFDif(ntiles.fast.errors(6),0,params.fast);
pred_prop.fast.errors(7) = CDFDif(inf,0,params.fast);
pred_prop.fast.errors = diff([0 pred_prop.fast.errors]);

% multiply by .all because CDFDif returns defective CDF!!  See also fitLBA_SAT_calcX2.
pred_freq.fast.correct = pred_prop.fast.correct .* N.fast.all;
pred_freq.fast.errors = pred_prop.fast.errors .* N.fast.all;

if include_med
    pred_prop.med.correct(1) = CDFDif(ntiles.med.correct(1),1,params.med);
    pred_prop.med.correct(2) = CDFDif(ntiles.med.correct(2),1,params.med);
    pred_prop.med.correct(3) = CDFDif(ntiles.med.correct(3),1,params.med);
    pred_prop.med.correct(4) = CDFDif(ntiles.med.correct(4),1,params.med);
    pred_prop.med.correct(5) = CDFDif(ntiles.med.correct(5),1,params.med);
    pred_prop.med.correct(6) = CDFDif(ntiles.med.correct(6),1,params.med);
    pred_prop.med.correct(7) = CDFDif(inf,1,params.med);
    pred_prop.med.correct = diff([0 pred_prop.med.correct]);
    
    
    pred_prop.med.errors(1) = CDFDif(ntiles.med.errors(1),0,params.med);
    pred_prop.med.errors(2) = CDFDif(ntiles.med.errors(2),0,params.med);
    pred_prop.med.errors(3) = CDFDif(ntiles.med.errors(3),0,params.med);
    pred_prop.med.errors(4) = CDFDif(ntiles.med.errors(4),0,params.med);
    pred_prop.med.errors(5) = CDFDif(ntiles.med.errors(5),0,params.med);
    pred_prop.med.errors(6) = CDFDif(ntiles.med.errors(6),0,params.med);
    pred_prop.med.errors(7) = CDFDif(inf,0,params.med);
    pred_prop.med.errors = diff([0 pred_prop.med.errors]);
    
    % multiply by .all because CDFDif returns defective CDF!!  See also fitLBA_SAT_calcX2.
    pred_freq.med.correct = pred_prop.med.correct .* N.med.all;
    pred_freq.med.errors = pred_prop.med.errors .* N.med.all;
    
end


%add in that last quantile by assuming that the observed data have 0 observations there.
obs_freq.slow.correct = [obs_freq.slow.correct 0];
obs_freq.slow.errors = [obs_freq.slow.errors 0];
obs_freq.fast.correct = [obs_freq.fast.correct 0];
obs_freq.fast.errors = [obs_freq.fast.errors 0];
obs_prop_correct.slow = N.slow.correct / N.slow.all;
obs_prop_correct.fast = N.fast.correct / N.fast.all;


if include_med
obs_freq.med.correct = [obs_freq.med.correct 0];
obs_freq.med.errors = [obs_freq.med.errors 0];
obs_prop_correct.med = N.med.correct / N.med.all;

all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; ...
        obs_freq.med.correct' ; obs_freq.med.errors' ; ...
        obs_freq.fast.correct' ; obs_freq.fast.errors'];
    
    all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; ...
        pred_freq.med.correct' ; pred_freq.med.errors' ; ...
        pred_freq.fast.correct' ; pred_freq.fast.errors'];
else
    
    all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; ...
        obs_freq.fast.correct' ; obs_freq.fast.errors'];
    
    all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; ...
        pred_freq.fast.correct' ; pred_freq.fast.errors'];
end

X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
%disp([all_obs all_pred])

%Strange case handling
if isnan(X2); X2 = 9e90; end

%for cases where predicted frequences are negative
if any(all_pred < 0); X2 = 9e90; end



if plotFlag
    %stupid fix for plotting. Just tile parameters when they are all shared, as if they were free
    if FreeFix(1) == 1; a = repmat(a,1,max(FreeFix)); end
    if FreeFix(2) == 1; Ter = repmat(Ter,1,max(FreeFix)); end
    if FreeFix(3) == 1; eta = repmat(eta,1,max(FreeFix)); end
    if FreeFix(4) == 1; z = repmat(z,1,max(FreeFix)); end
    if FreeFix(5) == 1; sZ = repmat(sZ,1,max(FreeFix)); end
    if FreeFix(6) == 1; st = repmat(st,1,max(FreeFix)); end
    if FreeFix(7) == 1; v = repmat(v,1,max(FreeFix)); end
    
    
    subplot(1,3,1)
    plot([ntiles.slow.correct ; inf],(cumsum(obs_freq.slow.correct)./N.slow.correct).*obs_prop_correct.slow,'ok','markersize',8)
    hold on
    plot([ntiles.slow.correct ; inf],cumsum(pred_freq.slow.correct)./N.slow.all,'-xk','markersize',8)
    plot([ntiles.slow.errors ; inf],(cumsum(obs_freq.slow.errors)./N.slow.errors).*(1-obs_prop_correct.slow),'or','markersize',8)
    plot([ntiles.slow.errors ; inf],cumsum(pred_freq.slow.errors)./N.slow.all,'-xr','markersize',8)
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
        plot([ntiles.med.correct ; inf],(cumsum(obs_freq.med.correct)./N.med.correct).*obs_prop_correct.med,'ok','markersize',8)
        hold on
        plot([ntiles.med.correct ; inf],cumsum(pred_freq.med.correct)./N.med.all,'-xk','markersize',8)
        plot([ntiles.med.errors ; inf],(cumsum(obs_freq.med.errors)./N.med.errors).*(1-obs_prop_correct.med),'or','markersize',8)
        plot([ntiles.med.errors ; inf],cumsum(pred_freq.med.errors)./N.med.all,'-xr','markersize',8)
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
    plot([ntiles.fast.correct ; inf],(cumsum(obs_freq.fast.correct)./N.fast.correct).*obs_prop_correct.fast,'ok','markersize',8)
    hold on
    plot([ntiles.fast.correct ; inf],cumsum(pred_freq.fast.correct)./N.fast.all,'-xk','markersize',8)
    plot([ntiles.fast.errors ; inf],(cumsum(obs_freq.fast.errors)./N.fast.errors).*(1-obs_prop_correct.fast),'or','markersize',8)
    plot([ntiles.fast.errors ; inf],cumsum(pred_freq.fast.errors)./N.fast.all,'-xr','markersize',8)
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
    
    [ax h] = suplabel(['X2 = ' mat2str(X2)],'t');
    set(h,'fontsize',12,'fontweight','bold')
    
    pause(.001)
    cla
    
    subplot(1,3,2)
    cla
    
    subplot(1,3,1)
    cla
    
    subplot(1,3,3)
    cla
end
