%script for getting stats-read SDF data
% find time of max value in grand average for each condition, then get
% individual session means at that same time point.  This is what will be
% tests
% RPH


[maxval.ss2 ci.ss2] = max(nanmean(SDF_in.targ.accurate.ss2));
[maxval.ss4 ci.ss4] = max(nanmean(SDF_in.targ.accurate.ss4));
[maxval.ss8 ci.ss8] = max(nanmean(SDF_in.targ.accurate.ss8));


%do sequential paired t-tests for each comparison

%=======================================
%Sloppy vs_ accurate T_in Target-aligned

figure
plot(-100:500,nanmean(SDF_in.targ.accurate.ss2),'b',-100:500,nanmean(SDF_in.targ.sloppy.ss2),'--b', ...
    -100:500,nanmean(SDF_in.targ.accurate.ss4),'r',-100:500,nanmean(SDF_in.targ.sloppy.ss4),'--r', ...
    -100:500,nanmean(SDF_in.targ.accurate.ss8),'g',-100:500,nanmean(SDF_in.targ.sloppy.ss8),'--g','linewidth',2)
hold on

plot(-100:500,nanmean(SDF_out.targ.accurate.ss2),'b',-100:500,nanmean(SDF_out.targ.sloppy.ss2),'--b', ...
    -100:500,nanmean(SDF_out.targ.accurate.ss4),'r',-100:500,nanmean(SDF_out.targ.sloppy.ss4),'--r', ...
    -100:500,nanmean(SDF_out.targ.accurate.ss8),'g',-100:500,nanmean(SDF_out.targ.sloppy.ss8),'--g','linewidth',1)

xlim([-50 300])
legend('Accurate','Inaccurate','location','northwest')


for t = 1:size(SDF_in.targ.accurate.ss2,2)
    [h.targ.ss2(t) p.targ.ss2(t)] = ttest(SDF_in.targ.accurate.ss2(:,t),SDF_in.targ.sloppy.ss2(:,t));
end

time_of_diff.targ.Tin.ss2 = findRuns(h.targ.ss2,10) - 100; %correct for 100 ms baseline period

if any(isbetween(time_of_diff.targ.Tin.ss2,[50 300]))
    tests.targ.Tin.ss2 = 1;
else
    tests.targ.Tin.ss2 = 0;
end



for t = 1:size(SDF_in.targ.accurate.ss4,2)
    [h.targ.ss4(t) p.targ.ss4(t)] = ttest(SDF_in.targ.accurate.ss4(:,t),SDF_in.targ.sloppy.ss4(:,t));
end

time_of_diff.targ.Tin.ss4 = findRuns(h.targ.ss4,10) - 100; %correct for 100 ms baseline period

if any(isbetween(time_of_diff.targ.Tin.ss4,[50 300]))
    tests.targ.Tin.ss4 = 1;
else
    tests.targ.Tin.ss4 = 0;
end

 
for t = 1:size(SDF_in.targ.accurate.ss8,2)
    [h.targ.ss8(t) p.targ.ss8(t)] = ttest(SDF_in.targ.accurate.ss8(:,t),SDF_in.targ.sloppy.ss8(:,t));
end
 
time_of_diff.targ.Tin.ss8 = findRuns(h.targ.ss8,10) - 100; %correct for 100 ms baseline period
 
if any(isbetween(time_of_diff.targ.Tin.ss8,[50 300]))
    tests.targ.Tin.ss8 = 1;
else
    tests.targ.Tin.ss8 = 0;
end


%=======================================
%Sloppy vs_ accurate D_in Target-aligned
 
for t = 1:size(SDF_out.targ.accurate.ss2,2)
    [h.targ.ss2(t) p.targ.ss2(t)] = ttest(SDF_out.targ.accurate.ss2(:,t),SDF_out.targ.sloppy.ss2(:,t));
end
 
time_of_diff.targ.Din.ss2 = findRuns(h.targ.ss2,10) - 100; %correct for 100 ms baseline period
 
if any(isbetween(time_of_diff.targ.Din.ss2,[50 300]))
    tests.targ.Din.ss2 = 1;
else
    tests.targ.Din.ss2 = 0;
end
 
 
 
for t = 1:size(SDF_out.targ.accurate.ss4,2)
    [h.targ.ss4(t) p.targ.ss4(t)] = ttest(SDF_out.targ.accurate.ss4(:,t),SDF_out.targ.sloppy.ss4(:,t));
end
 
time_of_diff.targ.Din.ss4 = findRuns(h.targ.ss4,10) - 100; %correct for 100 ms baseline period
 
if any(isbetween(time_of_diff.targ.Din.ss4,[50 300]))
    tests.targ.Din.ss4 = 1;
else
    tests.targ.Din.ss4 = 0;
end
 
 
for t = 1:size(SDF_out.targ.accurate.ss8,2)
    [h.targ.ss8(t) p.targ.ss8(t)] = ttest(SDF_out.targ.accurate.ss8(:,t),SDF_out.targ.sloppy.ss8(:,t));
end
 
time_of_diff.targ.Din.ss8 = findRuns(h.targ.ss8,10) - 100; %correct for 100 ms baseline period
 
if any(isbetween(time_of_diff.targ.Din.ss8,[50 300]))
    tests.targ.Din.ss8 = 1;
else
    tests.targ.Din.ss8 = 0;
end




%=======================
%=======================

%=======================================
%Sloppy vs_ accurate T_in Response-aligned

figure
plot(-400:200,nanmean(SDF_in.resp.accurate.ss2),'b',-400:200,nanmean(SDF_in.resp.sloppy.ss2),'--b', ...
    -400:200,nanmean(SDF_in.resp.accurate.ss4),'r',-400:200,nanmean(SDF_in.resp.sloppy.ss4),'--r', ...
    -400:200,nanmean(SDF_in.resp.accurate.ss8),'g',-400:200,nanmean(SDF_in.resp.sloppy.ss8),'--g','linewidth',2)
hold on
 
plot(-400:200,nanmean(SDF_out.resp.accurate.ss2),'b',-400:200,nanmean(SDF_out.resp.sloppy.ss2),'--b', ...
    -400:200,nanmean(SDF_out.resp.accurate.ss4),'r',-400:200,nanmean(SDF_out.resp.sloppy.ss4),'--r', ...
    -400:200,nanmean(SDF_out.resp.accurate.ss8),'g',-400:200,nanmean(SDF_out.resp.sloppy.ss8),'--g','linewidth',1)
 
xlim([-200 100])
legend('Accurate','Inaccurate','location','northwest')
 
 
for t = 1:size(SDF_in.resp.accurate.ss2,2)
    [h.resp.ss2(t) p.resp.ss2(t)] = ttest(SDF_in.resp.accurate.ss2(:,t),SDF_in.resp.sloppy.ss2(:,t));
end
 
time_of_diff.resp.Tin.ss2 = findRuns(h.resp.ss2,10) - 400; %correct for  baseline period
 
if any(isbetween(time_of_diff.resp.Tin.ss2,[-200 50]))
    tests.resp.Tin.ss2 = 1;
else
    tests.resp.Tin.ss2 = 0;
end
 
 
 
for t = 1:size(SDF_in.resp.accurate.ss4,2)
    [h.resp.ss4(t) p.resp.ss4(t)] = ttest(SDF_in.resp.accurate.ss4(:,t),SDF_in.resp.sloppy.ss4(:,t));
end
 
time_of_diff.resp.Tin.ss4 = findRuns(h.resp.ss4,10) - 400; %correct for baseline period
 
if any(isbetween(time_of_diff.resp.Tin.ss4,[-200 50]))
    tests.resp.Tin.ss4 = 1;
else
    tests.resp.Tin.ss4 = 0;
end
 
 
for t = 1:size(SDF_in.resp.accurate.ss8,2)
    [h.resp.ss8(t) p.resp.ss8(t)] = ttest(SDF_in.resp.accurate.ss8(:,t),SDF_in.resp.sloppy.ss8(:,t));
end
 
time_of_diff.resp.Tin.ss8 = findRuns(h.resp.ss8,10) - 400; %correct for baseline period
 
if any(isbetween(time_of_diff.resp.Tin.ss8,[-200 50]))
    tests.resp.Tin.ss8 = 1;
else
    tests.resp.Tin.ss8 = 0;
end
 
 
%=======================================
%Sloppy vs_ accurate D_in Response-aligned
 
for t = 1:size(SDF_out.resp.accurate.ss2,2)
    [h.resp.ss2(t) p.resp.ss2(t)] = ttest(SDF_out.resp.accurate.ss2(:,t),SDF_out.resp.sloppy.ss2(:,t));
end
 
time_of_diff.resp.Din.ss2 = findRuns(h.resp.ss2,10) - 400; %correct for baseline period
 
if any(isbetween(time_of_diff.resp.Din.ss2,[-200 50]))
    tests.resp.Din.ss2 = 1;
else
    tests.resp.Din.ss2 = 0;
end
 
 
 
for t = 1:size(SDF_out.resp.accurate.ss4,2)
    [h.resp.ss4(t) p.resp.ss4(t)] = ttest(SDF_out.resp.accurate.ss4(:,t),SDF_out.resp.sloppy.ss4(:,t));
end
 
time_of_diff.resp.Din.ss4 = findRuns(h.resp.ss4,10) - 400; %correct for baseline period
 
if any(isbetween(time_of_diff.resp.Din.ss4,[-200 50]))
    tests.resp.Din.ss4 = 1;
else
    tests.resp.Din.ss4 = 0;
end
 
 
for t = 1:size(SDF_out.resp.accurate.ss8,2)
    [h.resp.ss8(t) p.resp.ss8(t)] = ttest(SDF_out.resp.accurate.ss8(:,t),SDF_out.resp.sloppy.ss8(:,t));
end
 
time_of_diff.resp.Din.ss8 = findRuns(h.resp.ss8,10) - 400; %correct for  baseline period
 
if any(isbetween(time_of_diff.resp.Din.ss8,[-200 50]))
    tests.resp.Din.ss8 = 1;
else
    tests.resp.Din.ss8 = 0;
end



