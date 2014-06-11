%============
% Computes the conditional probability that direction error went to position X given
% that target appeared at position Y. Note that this is really only valid for set size
% 8; for set size 2, will appear to be directly opposite, and SS4 will skew things a bit
% too.  Also note, most conservative to use Errors_ variable, because certain positions
% are more prone to target hold errors; this eliminates sessions before Errors_ were
% encoded.

T0 = find(Errors_(:,5) == 1 & Target_(:,2) == 0 & Target_(:,5) == 8);
T1 = find(Errors_(:,5) == 1 & Target_(:,2) == 1 & Target_(:,5) == 8);
T2 = find(Errors_(:,5) == 1 & Target_(:,2) == 2 & Target_(:,5) == 8);
T3 = find(Errors_(:,5) == 1 & Target_(:,2) == 3 & Target_(:,5) == 8);
T4 = find(Errors_(:,5) == 1 & Target_(:,2) == 4 & Target_(:,5) == 8);
T5 = find(Errors_(:,5) == 1 & Target_(:,2) == 5 & Target_(:,5) == 8);
T6 = find(Errors_(:,5) == 1 & Target_(:,2) == 6 & Target_(:,5) == 8);
T7 = find(Errors_(:,5) == 1 & Target_(:,2) == 7 & Target_(:,5) == 8);

%code as column 1 = pos0 to column 8 = pos7
errors.T0(1) = length(find(saccLoc(T0) == 0)) ./length(T0);
errors.T0(2) = length(find(saccLoc(T0) == 1)) ./length(T0);
errors.T0(3) = length(find(saccLoc(T0) == 2)) ./length(T0);
errors.T0(4) = length(find(saccLoc(T0) == 3)) ./length(T0);
errors.T0(5) = length(find(saccLoc(T0) == 4)) ./length(T0);
errors.T0(6) = length(find(saccLoc(T0) == 5)) ./length(T0);
errors.T0(7) = length(find(saccLoc(T0) == 6)) ./length(T0);
errors.T0(8) = length(find(saccLoc(T0) == 7)) ./length(T0);

errors.T1(1) = length(find(saccLoc(T1) == 0)) ./length(T1);
errors.T1(2) = length(find(saccLoc(T1) == 1)) ./length(T1);
errors.T1(3) = length(find(saccLoc(T1) == 2)) ./length(T1);
errors.T1(4) = length(find(saccLoc(T1) == 3)) ./length(T1);
errors.T1(5) = length(find(saccLoc(T1) == 4)) ./length(T1);
errors.T1(6) = length(find(saccLoc(T1) == 5)) ./length(T1);
errors.T1(7) = length(find(saccLoc(T1) == 6)) ./length(T1);
errors.T1(8) = length(find(saccLoc(T1) == 7)) ./length(T1);

errors.T2(1) = length(find(saccLoc(T2) == 0)) ./length(T2);
errors.T2(2) = length(find(saccLoc(T2) == 1)) ./length(T2);
errors.T2(3) = length(find(saccLoc(T2) == 2)) ./length(T2);
errors.T2(4) = length(find(saccLoc(T2) == 3)) ./length(T2);
errors.T2(5) = length(find(saccLoc(T2) == 4)) ./length(T2);
errors.T2(6) = length(find(saccLoc(T2) == 5)) ./length(T2);
errors.T2(7) = length(find(saccLoc(T2) == 6)) ./length(T2);
errors.T2(8) = length(find(saccLoc(T2) == 7)) ./length(T2);

errors.T3(1) = length(find(saccLoc(T3) == 0)) ./length(T3);
errors.T3(2) = length(find(saccLoc(T3) == 1)) ./length(T3);
errors.T3(3) = length(find(saccLoc(T3) == 2)) ./length(T3);
errors.T3(4) = length(find(saccLoc(T3) == 3)) ./length(T3);
errors.T3(5) = length(find(saccLoc(T3) == 4)) ./length(T3);
errors.T3(6) = length(find(saccLoc(T3) == 5)) ./length(T3);
errors.T3(7) = length(find(saccLoc(T3) == 6)) ./length(T3);
errors.T3(8) = length(find(saccLoc(T3) == 7)) ./length(T3);

errors.T4(1) = length(find(saccLoc(T4) == 0)) ./length(T4);
errors.T4(2) = length(find(saccLoc(T4) == 1)) ./length(T4);
errors.T4(3) = length(find(saccLoc(T4) == 2)) ./length(T4);
errors.T4(4) = length(find(saccLoc(T4) == 3)) ./length(T4);
errors.T4(5) = length(find(saccLoc(T4) == 4)) ./length(T4);
errors.T4(6) = length(find(saccLoc(T4) == 5)) ./length(T4);
errors.T4(7) = length(find(saccLoc(T4) == 6)) ./length(T4);
errors.T4(8) = length(find(saccLoc(T4) == 7)) ./length(T4);

errors.T5(1) = length(find(saccLoc(T5) == 0)) ./length(T5);
errors.T5(2) = length(find(saccLoc(T5) == 1)) ./length(T5);
errors.T5(3) = length(find(saccLoc(T5) == 2)) ./length(T5);
errors.T5(4) = length(find(saccLoc(T5) == 3)) ./length(T5);
errors.T5(5) = length(find(saccLoc(T5) == 4)) ./length(T5);
errors.T5(6) = length(find(saccLoc(T5) == 5)) ./length(T5);
errors.T5(7) = length(find(saccLoc(T5) == 6)) ./length(T5);
errors.T5(8) = length(find(saccLoc(T5) == 7)) ./length(T5);

errors.T6(1) = length(find(saccLoc(T6) == 0)) ./length(T6);
errors.T6(2) = length(find(saccLoc(T6) == 1)) ./length(T6);
errors.T6(3) = length(find(saccLoc(T6) == 2)) ./length(T6);
errors.T6(4) = length(find(saccLoc(T6) == 3)) ./length(T6);
errors.T6(5) = length(find(saccLoc(T6) == 4)) ./length(T6);
errors.T6(6) = length(find(saccLoc(T6) == 5)) ./length(T6);
errors.T6(7) = length(find(saccLoc(T6) == 6)) ./length(T6);
errors.T6(8) = length(find(saccLoc(T6) == 7)) ./length(T6);

errors.T7(1) = length(find(saccLoc(T7) == 0)) ./length(T7);
errors.T7(2) = length(find(saccLoc(T7) == 1)) ./length(T7);
errors.T7(3) = length(find(saccLoc(T7) == 2)) ./length(T7);
errors.T7(4) = length(find(saccLoc(T7) == 3)) ./length(T7);
errors.T7(5) = length(find(saccLoc(T7) == 4)) ./length(T7);
errors.T7(6) = length(find(saccLoc(T7) == 5)) ./length(T7);
errors.T7(7) = length(find(saccLoc(T7) == 6)) ./length(T7);
errors.T7(8) = length(find(saccLoc(T7) == 7)) ./length(T7);


figure
plot(0:7,errors.T0,'k',0:7,errors.T1,'r',0:7,errors.T2,'g',0:7,errors.T3,'b',...
    0:7,errors.T4,'c',0:7,errors.T5,'m',0:7,errors.T6,'--k',0:7,errors.T7,'--r')
legend('Targ0','Targ1','Targ2','Targ3','Targ4','Targ5','Targ6','Targ7','location','northwest')
xlabel('Error location')
ylabel('Conditional Probability')