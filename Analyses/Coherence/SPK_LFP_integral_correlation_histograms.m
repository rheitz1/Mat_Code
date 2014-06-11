%make stacked histogram (stacking by monkey).
%just sum the two, make that plot open, then plot any of the other two
%monkeys with bars closed.
compare_overlap_nooverlap = 0;
compare_in_out = 1;

x = -1:.05:1;

%===================
% Comparing overlap vs nooverlap, combining Tin and Din
[s10_over x] = hist([S_Hz10_in_overlap ; S_Hz10_out_overlap],x);
[q10_over x] = hist([Q_Hz10_in_overlap ; Q_Hz10_out_overlap],x);

[s35_over x] = hist([S_Hz35_in_overlap ; S_Hz35_out_overlap],x);
[q35_over x] = hist([Q_Hz35_in_overlap ; Q_Hz35_out_overlap],x);

[s10_noover x] = hist([S_Hz10_in_nooverlap ; S_Hz10_out_nooverlap],x);
[q10_noover x] = hist([Q_Hz10_in_nooverlap ; Q_Hz10_out_nooverlap],x);

[s35_noover x] = hist([S_Hz35_in_nooverlap ; S_Hz35_out_nooverlap],x);
[q35_noover x] = hist([Q_Hz35_in_nooverlap ; Q_Hz35_out_nooverlap],x);

qs_10_over = q10_over + s10_over;
qs_35_over = q35_over + s35_over;

qs_10_noover = q10_noover + s10_noover;
qs_35_noover = q35_noover + s35_noover;
%======================



%======================
% Comparing Tin vs Din, separately for each overlap/nonoverlap condition


[s10_over_in x] = hist(S_Hz10_in_overlap,x);
[s10_over_out x] = hist(S_Hz10_out_overlap,x);

[s10_noover_in x] = hist(S_Hz10_in_nooverlap,x);
[s10_noover_out x] = hist(S_Hz10_out_nooverlap,x);

[s35_over_in x] = hist(S_Hz35_in_overlap,x);
[s35_over_out x] = hist(S_Hz35_out_overlap,x);

[s35_noover_in x] = hist(S_Hz35_in_nooverlap,x);
[s35_noover_out x] = hist(S_Hz35_out_nooverlap,x);

[q10_over_in x] = hist(Q_Hz10_in_overlap,x);
[q10_over_out x] = hist(Q_Hz10_out_overlap,x);

[q10_noover_in x] = hist(Q_Hz10_in_nooverlap,x);
[q10_noover_out x] = hist(Q_Hz10_out_nooverlap,x);

[q35_over_in x] = hist(Q_Hz35_in_overlap,x);
[q35_over_out x] = hist(Q_Hz35_out_overlap,x);

[q35_noover_in x] = hist(Q_Hz35_in_nooverlap,x);
[q35_noover_out x] = hist(Q_Hz35_out_nooverlap,x);

qs10_over_in = s10_over_in + q10_over_in;
qs10_over_out = s10_over_out + q10_over_out;

qs10_noover_in = s10_noover_in + q10_noover_in;
qs10_noover_out = s10_noover_out + q10_noover_out;


qs35_over_in = s35_over_in + q35_over_in;
qs35_over_out = s35_over_out + q35_over_out;

qs35_noover_in = s35_noover_in + q35_noover_in;
qs35_noover_out = s35_noover_out + q35_noover_out;


if compare_overlap_nooverlap
    figure
    bar(x,qs_10_over,'r')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','r')
    set(h(1),'linewidth',2)
    
    hold on
    
    bar(x,s10_over,'r')
    
    
    bar(x,qs_35_over,'b')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','b')
    set(h(1),'linewidth',2)
    
    bar(x,s35_over,'b')
    
    xlim([-1 1])
    fon
    
    legend('X','X')
    title('Overlap')
    
    %=============================
    
    figure
    bar(x,qs_10_noover,'r')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','r')
    set(h(1),'linewidth',2)
    
    hold on
    
    bar(x,s10_noover,'r')
    
    
    bar(x,qs_35_noover,'b')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','b')
    set(h(1),'linewidth',2)
    
    bar(x,s35_noover,'b')
    
    xlim([-1 1])
    fon
    
    legend('X','X')
    title('No Overlap')
end

if compare_in_out
    figure
    subplot(2,2,1)
    bar(x,qs10_over_in,'r')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','r')
    set(h(1),'linewidth',2)
    
    hold on
    
    bar(x,s10_over_in,'r')
    
    
    bar(x,qs10_over_out,'b')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','b')
    set(h(1),'linewidth',2)
    
    bar(x,s10_over_out,'b')
    
    xlim([-1 1])
    fon
    
    legend('X','X')
    title('10 Hz Overlap')
  
    
    
    subplot(2,2,2)
    bar(x,qs10_noover_in,'r')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','r')
    set(h(1),'linewidth',2)
    
    hold on
    
    bar(x,s10_noover_in,'r')
    
    
    bar(x,qs10_noover_out,'b')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','b')
    set(h(1),'linewidth',2)
    
    bar(x,s10_noover_out,'b')
    
    xlim([-1 1])
    fon
    
    legend('X','X')
    title('10Hz NoOverlap')
    
    
    subplot(2,2,3)
    bar(x,qs35_over_in,'r')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','r')
    set(h(1),'linewidth',2)
    
    hold on
    
    bar(x,s35_over_in,'r')
    
    
    bar(x,qs35_over_out,'b')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','b')
    set(h(1),'linewidth',2)
    
    bar(x,s35_over_out,'b')
    
    xlim([-1 1])
    fon
    
    legend('X','X')
    title('35 Hz Overlap')
  
    
    
    subplot(2,2,4)
    bar(x,qs35_noover_in,'r')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','r')
    set(h(1),'linewidth',2)
    
    hold on
    
    bar(x,s35_noover_in,'r')
    
    
    bar(x,qs35_noover_out,'b')
    h = findobj(gca,'Type','patch');
    set(h(1),'facecolor','none')
    set(h(1),'edgecolor','b')
    set(h(1),'linewidth',2)
    
    bar(x,s35_noover_out,'b')
    
    xlim([-1 1])
    fon
    
    legend('X','X')
    title('35Hz NoOverlap')
end