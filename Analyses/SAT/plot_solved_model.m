% Fits solved LBA model across the population
%
% RPH

model = 1;



sol = struct2cell(solution);

cur_model = sol{model};

switch model
    case 1 %Fix NONE
        A = cur_model(1:3);
        b = cur_model(4:6);
        v = cur_model(7:9);
        T0 = cur_model(10:12);
        mod_str = 'Fix None';
    case 2 %Fix A
        A(1:3) = cur_model(1);
        b = cur_model(2:4);
        v = cur_model(5:7);
        T0 = cur_model(8:10);
        mod_str = 'Fix A';
    case 3 %Fix b
        A = cur_model(1:3);
        b(1:3) = cur_model(4);
        v = cur_model(5:7);
        T0 = cur_model(8:10);
        mod_str = 'Fix b';
    case 4 %Fix v
        A = cur_model(1:3);
        b = cur_model(4:6);
        v(1:3) = cur_model(7);
        T0 = cur_model(8:10);
        mod_str = 'Fix v';
    case 5 %Fix T0
        A = cur_model(1:3);
        b = cur_model(4:6);
        v = cur_model(7:9);
        T0(1:3) = cur_model(10);
        mod_str = 'Fix T0';
    case 6 %Fix A,b
        A(1:3) = cur_model(1);
        b(1:3) = cur_model(2);
        v = cur_model(3:5);
        T0 = cur_model(6:8);
        mod_str = 'Fix A,b';
    case 7 %Fix A,v
        A(1:3) = cur_model(1);
        b = cur_model(2:4);
        v(1:3) = cur_model(5);
        T0 = cur_model(6:8);
        mod_str = 'Fix A,v';
    case 8 %Fix A,T0
        A(1:3) = cur_model(1);
        b = cur_model(2:4);
        v = cur_model(5:7);
        T0(1:3) = cur_model(8);
        mod_str = 'Fix A,T0';
    case 9 %Fix b,v
        A = cur_model(1:3);
        b(1:3) = cur_model(4);
        v(1:3) = cur_model(5);
        T0 = cur_model(6:8);
        mod_str = 'Fix b,v';
    case 10 %Fix b,T0
        A = cur_model(1:3);
        b(1:3) = cur_model(4);
        v = cur_model(5:7);
        T0(1:3) = cur_model(8);
        mod_str = 'Fix b,T0';
    case 11 %Fix v,T0
        A = cur_model(1:3);
        b = cur_model(4:6);
        v(1:3) = cur_model(7);
        T0(1:3) = cur_model(8);
        mod_str = 'Fix v,T0';
    case 12 %Fix A,b,v
        A(1:3) = cur_model(1);
        b(1:3) = cur_model(2);
        v(1:3) = cur_model(3);
        T0 = cur_model(4:6);
        mod_str = 'Fix A,b,v';
    case 13 %Fix A,b,T0
        A(1:3) = cur_model(1);
        b(1:3) = cur_model(2);
        v = cur_model(3:5);
        T0(1:3) = cur_model(6);
        mod_str = 'Fix A,b,T0';
    case 14 %Fix A,v,T0
        A(1:3) = cur_model(1);
        b = cur_model(2:4);
        v(1:3) = cur_model(5);
        T0(1:3) = cur_model(6);
        mod_str = 'Fix A,v,T0';
    case 15 %Fix b,v,T0
        A = cur_model(1:3);
        b(1:3) = cur_model(4);
        v(1:3) = cur_model(5);
        T0(1:3) = cur_model(6);
        mod_str = 'Fix b,v,T0';
    case 16 %Fix ALL
        A(1:3) = cur_model(1);
        b(1:3) = cur_model(2);
        v(1:3) = cur_model(3);
        T0(1:3) = cur_model(4);
        mod_str = 'Fix ALL';
end

s = .10;

t.slow = (1:1000) + T0(1);
t.med = (1:1000) + T0(2);
t.fast = (1:1000) + T0(3);


winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s)));
loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s)));

winner.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s)));
loser.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s)));

winner.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),s) .* (1-linearballisticCDF(1:1000,A(3),b(3),1-v(3),s)));
loser.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),s) .* (1-linearballisticCDF(1:1000,A(3),b(3),v(3),s)));

figure
subplot(2,4,1:3)
plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r', ...
    t.med,winner.med,'k',t.med,loser.med,'--k', ...
    t.fast,winner.fast,'g',t.fast,loser.fast,'--g')
hold on
plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or', ...
    CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'ok', ...
    CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og','markersize',8)
xlim([150 900])
ylim([0 1])
set(gca,'xminortick','on')
box off
title(['Model = ' mat2str(model) '  ' mod_str])



%Now plot in separate plots for a different version
fig
subplot(4,4,[1:3  9:11])
plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r')
hold on
plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',18)
xlim([400 800])
ylim([0 .9])
box off
set(gca,'xminortick','on')

fig
subplot(4,4,[1:3  9:11])
plot(t.med,winner.med,'k',t.med,loser.med,'--k')
hold on
plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'ok','markersize',18)
xlim([150 400])
ylim([0 .9])
box off
set(gca,'xminortick','on')

fig
subplot(4,4,[1:3  9:11])
plot(t.fast,winner.fast,'g',t.fast,loser.fast,'--g')
hold on
plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og','markersize',18)
xlim([150 400])
ylim([0 .9])
box off
set(gca,'xminortick','on')



%Now plot all separately in same figure
fig
subplot(2,2,1)
plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r')
hold on
plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',10)
xlim([400 800])
ylim([0 .9])
box off
set(gca,'xminortick','on')
title('Accurate')

subplot(2,2,2)
plot(t.med,winner.med,'k',t.med,loser.med,'--k')
hold on
plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'ok','markersize',10)
xlim([150 400])
ylim([0 .9])
box off
set(gca,'xminortick','on')
title('Neutral')

subplot(2,2,3)
plot(t.fast,winner.fast,'g',t.fast,loser.fast,'--g')
hold on
plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og','markersize',10)
xlim([150 400])
ylim([0 .9])
box off
set(gca,'xminortick','on')
title('Fast')