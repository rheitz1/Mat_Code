%use to integrate differences between targ_in and targ_out
close all;
%set parameters

nSims = 100; %number of simulations to run
nDraw =10; %number of neurons to randomly draw and pool when calculating the SDF

SRT = Saccade_(:,1) - Target_(:,1);

%Align_Time_(1:length(Decide_),1) = 500;
%Align_Time_ = Decide_(:,1);
Align_Time_ = Target_(:,1); %aligned on target onset

Plot_Time=[-500 1000];


%get list of neurons
varlist = who;
cellID = varlist(strmatch('DSP',varlist));

% m = 1;
% for j = 1:length(cellID);
%     if isempty(strfind(cell2mat(cellID(j)),'i')>0);
%         CellNames(m,1) = cellID(j);
%         m = m+1;
%     end
% end
% 
% for cell_num = 1:length(CellNames)
%     SDFmatrix(:,:,cell_num) = eval(cell2mat(CellNames(cell_num)));
% end

%get targ_in and targ_out trials (include only correct, so reference GOCorrect)
%not sure what "Correct_" variable is doing; not coincident with GOCorrect.
   T_in_hard = nonzeros(GOCorrect(:,[RFs+1],1));
   D_in_hard = GOCorrect(~ismember(GOCorrect,T_in_hard));
   D_in_hard = nonzeros(D_in_hard);
% Correct, split up easy and hard
   T_in_easy = nonzeros(GOCorrect(:,[RFs+1],2));
   D_in_easy = GOCorrect(~ismember(GOCorrect,T_in_easy));
   D_in_easy = nonzeros(D_in_easy);

%Take a random sample (without replacement) for T_in trials
%Take a random sample (with replacement) for D_in trials
%Get SDF for both and plot


%for file 'fecfef_m153.mat', best cell is DSP01c.  Limit analysis to this
%for the time being.

%randsample takes random value 1:n (first arg; second arg specifies how many
%numbers you want drawn


for n = 1:nSims
   rand_in_easy = randsample(length(T_in_easy),nDraw,false);
   rand_out_easy = randsample(length(D_in_easy),nDraw,true);
   rand_in_hard = randsample(length(T_in_hard),nDraw,false);
   rand_out_hard = randsample(length(D_in_hard),nDraw,true);

   [SDF_in_easy] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, rand_in_easy, TrialStart_);
   [SDF_out_easy] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, rand_out_easy, TrialStart_);
   [SDF_in_hard] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, rand_in_hard, TrialStart_);
   [SDF_out_hard] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, rand_out_hard, TrialStart_);
   
   
subplot(4,1,1)
cla
plot(Plot_Time(1):Plot_Time(2),SDF_in_easy,'Color','r')
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_out_easy,'Color','b')

subplot(4,1,2)
cla

SDF_diff_easy(n,1:length(SDF_in_easy)) = SDF_in_easy - SDF_out_easy;

subplot(4,1,3)
cla
plot(Plot_Time(1):Plot_Time(2),SDF_in_hard,'Color','r')
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_out_hard,'Color','b')

subplot(4,1,4)
cla

SDF_diff_hard(n,1:length(SDF_in_hard)) = SDF_in_hard - SDF_out_hard;
     plot(Plot_Time(1):Plot_Time(2),SDF_diff_hard)
%      pause
     n
end
subplot(4,1,2)
plot(Plot_Time(1):Plot_Time(2),mean(SDF_diff_easy));

subplot(4,1,4)
plot(Plot_Time(1):Plot_Time(2),mean(SDF_diff_hard));
%RTcdf
bins = [Plot_Time(1):Plot_Time(2)];
num_easy_trials = numel(nonzeros(GOCorrect(:,:,1)));
num_hard_trials = numel(nonzeros(GOCorrect(:,:,2)));
SRTeasy_trials = zeros(num_easy_trials,1);
SRThard_trials = zeros(num_hard_trials,1);
counter = 1;
for i = 1:length(GOCorrect(:,1,1));
    for j = 1:length(GOCorrect(1,:,1));
        SRTeasy_trials(counter) = GOCorrect(i,j,1);
        counter = counter+1;
    end
end
counter = 1;
for i = 1:length(GOCorrect(:,1,2))
    for j = 1:length(GOCorrect(1,:,2))
        SRThard_trials(counter) = GOCorrect(i,j,2);
        counter = counter+1;
    end
end
SRTeasy_trials = nonzeros(SRTeasy_trials);
SRThard_trials = nonzeros(SRThard_trials);
SRTeasy = zeros(length(SRTeasy_trials),1);
SRThard = zeros(length(SRThard_trials),1);
for i = 1:length(SRTeasy)
    SRTeasy(i) = SRT(SRTeasy_trials(i));
end
for i = 1:length(SRThard)
    SRThard(i) = SRT(SRThard_trials(i));
end

RThist_easy = hist(SRTeasy,bins);
RThist_hard = hist(SRThard,bins);
RTcdf_easy = cumsum(RThist_easy)/length(SRTeasy);
RTcdf_hard = cumsum(RThist_hard)/length(SRThard);

mean_diff = mean(SRThard)-mean(SRTeasy)

SDF_diff_index = [Plot_Time(1):Plot_Time(2)]
RTpred_easy = zeros(length(SDF_diff_easy(:,1)),1)
RTpred_hard = zeros(length(SDF_diff_hard(:,1)),1)

Criterion_easy = 15
Criterion_hard = 15
%SDF_diff_index(nanmean(Saccade_(:,1))-20)
%mean(SDF_diff_easy(:,mean(round(SRTeasy)-Plot_Time(1)+20)))
%mean(SDF_diff_hard(:,mean(round(SRThard)-Plot_Time(1)+20)))

for j = 1:length(SDF_diff_easy(:,1))
   for i = 1:length(SDF_diff_easy(1,:))
    if SDF_diff_easy(j,i) >= Criterion_easy
        if RTpred_easy(j) == 0
            RTpred_easy(j) = SDF_diff_index(i)
        end
    end
   end
end
for j = 1:length(SDF_diff_hard(:,1))
   for i = 1:length(SDF_diff_hard(1,:))
    if SDF_diff_hard(j,i) >= Criterion_hard
        if RTpred_hard(j) == 0
            RTpred_hard(j) = SDF_diff_index(i)
        end
    end
   end
end

RTpred_easy;
RTpred_hard;
CellNames;

RTpred_hist_easy = hist(RTpred_easy,bins);
RTpred_hist_hard = hist(RTpred_hard,bins);
RTpred_cdf_easy = cumsum(RTpred_hist_easy)/length(RTpred_easy);
RTpred_cdf_hard = cumsum(RTpred_hist_hard)/length(RTpred_hard);


subplot(4,1,1)
hold on
plotyy(1,1,Plot_Time(1):Plot_Time(2),RTcdf_easy)
plotyy(1,1,Plot_Time(1):Plot_Time(2),RTpred_cdf_easy)

subplot(4,1,3)
hold on
plotyy(1,1,Plot_Time(1):Plot_Time(2),RTcdf_hard)
plotyy(1,1,Plot_Time(1):Plot_Time(2),RTpred_cdf_hard)
hold off

