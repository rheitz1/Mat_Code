% calculate "smiley face" optimality figure from Churchland (2006)
%
% RPH

function [ALLcurrDATA_crt ALLcurrDATA_err] = compileFano_vis_optimality(filename,path)

%=============
% OPTIONS

Plot_Time_Targ = [-300 100];
test_interval = [100:300];

%=============
%load(filename)

ALLcurrDATA_crt.all = []; %initialize so will not fail when all neuron signals are skipped due to low firing rate.
ALLcurrDATA_crt.slow = [];
ALLcurrDATA_crt.fast = [];

ALLcurrDATA_err.all = [];
ALLcurrDATA_err.slow = [];
ALLcurrDATA_err.fast = [];

varlist = who('-file',filename);
NeuronList = strmatch('DSP',varlist);

load(filename,'Correct_','Target_','SAT_','Errors_','SRT','MStim_')

for n = 1:length(NeuronList)
    load(filename,varlist{NeuronList(n)})
end

if exist('SAT_') & length(find(isnan(SAT_(:,1)))) < 30 & ~all(SAT_(:,1) == 4)%a few PopOut_FEF data files have random numbers in SAT_ variable, probably due to strobe overloading
    isSAT = 1;
else
    isSAT = 0;
end


%If there are uStim trials, remove them
nR = find(~isnan(MStim_(:,1)));
shorten_file


disp(['Total of ' mat2str(length(NeuronList)) ' neurons detected'])

for neuron = 1:length(NeuronList)
    disp(['Analyzing neuron ' mat2str(neuron) ' out of ' mat2str(length(NeuronList))])
    
    unit{neuron} = varlist{NeuronList(neuron)};
    
    sig = eval(varlist{NeuronList(neuron)});
    
    
    SDF = sSDF(sig,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    
    
    
    
    
    %Make sure the overall neural firing rate isn't too low
    if max(nanmean(SDF)) < 10
        disp('Skipping due to low firing rate...')
        continue
    end
    
    
    if ~isSAT
        %stds = nanstd(SRT(find(Correct_(:,2) == 1),1));
        %trls = find(Correct_(:,2) == 1 & SRT(:,1) >= (nanmean(SRT(:,1)) - 3 * stds) & SRT(:,1) <= (nanmean(SRT(:,1)) + 3 * stds));
        trls = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 600);
        trls_err = find(Correct_(:,2) == 0 & SRT(:,1) > 50 & SRT(:,1) < 600);
        
        currSDFav_crt = nanmean(SDF(trls,test_interval),2);
        currSDFav_crt(find(currSDFav_crt == 0)) = NaN;
        
        currGrandMean_crt = nanmean(nanmean(SDF(trls,test_interval)));
        currDiffs_crt = currSDFav_crt - currGrandMean_crt;
        
        currDATA_crt = [currDiffs_crt SRT(trls,1)];
        currDATA_crt = removeNaN(currDATA_crt);
        
        ALLcurrDATA_crt.all = [ALLcurrDATA_crt.all ; currDATA_crt]; %for appending multiple neuron in 1 file
        
        
        
        currSDFav_err = nanmean(SDF(trls_err,test_interval),2);
        currSDFav_err(find(currSDFav_err == 0)) = NaN;
        
        currGrandMean_err = nanmean(nanmean(SDF(trls_err,test_interval)));
        currDiffs_err = currSDFav_err - currGrandMean_err;
        
        currDATA_err = [currDiffs_err SRT(trls_err,1)];
        currDATA_err = removeNaN(currDATA_err);
        
        ALLcurrDATA_err.all = [ALLcurrDATA_err.all ; currDATA_err];
        
    else
        getTrials_SAT
        
        
        currSDFav_crt.slow = nanmean(SDF(slow_correct_made_dead,test_interval),2);
        currSDFav_crt.slow(find(currSDFav_crt.slow == 0)) = NaN;
        
        currGrandMean_crt.slow = nanmean(nanmean(SDF(slow_correct_made_dead,test_interval)));
        currDiffs_crt.slow = currSDFav_crt.slow - currGrandMean_crt.slow;
        
        currDATA_crt.slow = [currDiffs_crt.slow SRT(slow_correct_made_dead,1)];
        currDATA_crt.slow = removeNaN(currDATA_crt.slow);
        
        ALLcurrDATA_crt.slow = [ALLcurrDATA_crt.slow ; currDATA_crt.slow]; %for appending multiple neuron in 1 file
        
        
        currSDFav_crt.fast = nanmean(SDF(fast_correct_made_dead_withCleared,test_interval),2);
        currSDFav_crt.fast(find(currSDFav_crt.fast == 0)) = NaN;
        
        currGrandMean_crt.fast = nanmean(nanmean(SDF(fast_correct_made_dead_withCleared,test_interval)));
        currDiffs_crt.fast = currSDFav_crt.fast - currGrandMean_crt.fast;
        
        currDATA_crt.fast = [currDiffs_crt.fast SRT(fast_correct_made_dead_withCleared,1)];
        currDATA_crt.fast = removeNaN(currDATA_crt.fast);
        
        ALLcurrDATA_crt.fast = [ALLcurrDATA_crt.fast ; currDATA_crt.fast]; %for appending multiple neuron in 1 file
        
        
        
        
        
        
        
        currSDFav_err.slow = nanmean(SDF(slow_errors_made_dead,test_interval),2);
        currSDFav_err.slow(find(currSDFav_err.slow == 0)) = NaN;
        
        currGrandMean_err.slow = nanmean(nanmean(SDF(slow_errors_made_dead,test_interval)));
        currDiffs_err.slow = currSDFav_err.slow - currGrandMean_err.slow;
        
        currDATA_err.slow = [currDiffs_err.slow SRT(slow_errors_made_dead,1)];
        currDATA_err.slow = removeNaN(currDATA_err.slow);
        
        ALLcurrDATA_err.slow = [ALLcurrDATA_err.slow ; currDATA_err.slow]; %for appending multiple neuron in 1 file
        
        
        currSDFav_err.fast = nanmean(SDF(fast_errors_made_dead_withCleared,test_interval),2);
        currSDFav_err.fast(find(currSDFav_err.fast == 0)) = NaN;
        
        currGrandMean_err.fast = nanmean(nanmean(SDF(fast_errors_made_dead_withCleared,test_interval)));
        currDiffs_err.fast = currSDFav_err.fast - currGrandMean_err.fast;
        
        currDATA_err.fast = [currDiffs_err.fast SRT(fast_errors_made_dead_withCleared,1)];
        currDATA_err.fast = removeNaN(currDATA_err.fast);
        
        ALLcurrDATA_err.fast = [ALLcurrDATA_err.fast ; currDATA_err.fast]; %for appending multiple neuron in 1 file
        
    end
    %============================================
    % Compute the following only for SAT sessions
    
    %     if isSAT
    %         getTrials_SAT
    %
    %     end
    %
    %     save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
    %         'ALLDATA*','-mat')
    %
    
end %for neuron
