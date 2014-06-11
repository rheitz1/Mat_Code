

%initialize
e_e.in(1:size(Correct_,1),1) = NaN;
e_c.in(1:size(Correct_,1),1) = NaN;
c_e.in(1:size(Correct_,1),1) = NaN;
c_c.in(1:size(Correct_,1),1) = NaN;

e_e.out(1:size(Correct_,1),1) = NaN;
e_c.out(1:size(Correct_,1),1) = NaN;
c_e.out(1:size(Correct_,1),1) = NaN;
c_c.out(1:size(Correct_,1),1) = NaN;


for trl = 2:size(Correct_,1)
    if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(saccLoc(trl),RF) & Target_(:,2) ~= 255
        e_e.in(trl-1,1) = trl;
    elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(saccLoc(trl),antiRF) & Target_(:,2) ~= 255
        e_e.out(trl-1,1) = trl;
        
    elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(:,2) ~= 255
        e_c.in(trl-1,1) = trl;
    elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(:,2) ~= 255
        e_c.out(trl-1,1) = trl;
        
    elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(saccLoc(trl),RF) & Target_(:,2) ~= 255
        c_e.in(trl-1,1) = trl;
    elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(saccLoc(trl),antiRF) & Target_(:,2) ~= 255
        c_e.out(trl-1,1) = trl;
        
    elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(:,2) ~= 255
        c_c.in(trl-1,1) = trl;
    elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(:,2) ~= 255
        c_c.out(trl-1,1) = trl;
    end
end

inTrials = find(Correct_(:,2) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
outTrials = find(Correct_(:,2) & ismember(Target_(:,2),mod((RF+4),8)) & SRT(:,1) < 2000 & SRT(:,1) > 50);

e_e.in = removeNaN(e_e.in);
e_c.in = removeNaN(e_c.in);
c_e.in = removeNaN(c_e.in);
c_c.in = removeNaN(c_c.in);

e_e.out = removeNaN(e_e.out);
e_c.out = removeNaN(e_c.out);
c_e.out = removeNaN(c_e.out);
c_c.out = removeNaN(c_c.out);

% RTs.e_c = SRT(e_c,1);
% RTs.c_c = SRT(c_c,1);
% RTs.c_e = SRT(c_e,1);
% RTs.e_e = SRT(e_e,1);
% 
% err_cor.in = intersect(inTrials,e_c);
% cor_cor.in = intersect(inTrials,c_c);
% [bins.c_c,cdf.c_c] = getCDF(RTs.c_c,30);
% [bins.e_c,cdf.e_c] = getCDF(RTs.e_c,30);
% 

% figure
% plot(bins.c_c,cdf.c_c,'b',bins.e_c,cdf.e_c,'r')


figure
plot(-100:500,nanmean(SDF(c_c.in,:)),'b',-100:500,nanmean(SDF(c_c.out,:)),'--b', ...
    -100:500,nanmean(SDF(e_c.in,:)),'r',-100:500,nanmean(SDF(e_c.out,:)),'--r')

% plot(-100:500,nanmean(SDF(inTrials,:)),'b',-100:500,nanmean(SDF(outTrials,:)),'--b', ...
%     -100:500,nanmean(SDF(cor_cor.in,:)),'r',-100:500,nanmean(SDF(err_cor.in,:)),'--r')