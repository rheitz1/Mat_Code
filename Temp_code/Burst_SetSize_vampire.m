%Find burst onset times for neurons between different set sizes

function [] = Burst_SetSize(file)
tic
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')


%======================================
%get list of DSP channels
varlist = who('-file',file);
CellMarker = strmatch('DSP',varlist);
ADMarker = strmatch('AD',varlist);

%create a list of target cells to analyze
for a = 1:length(CellMarker)
    CellName_temp(a,1) = varlist(CellMarker(a));
end

m = 1;
for j = 1:length(CellName_temp)
    if isempty(strfind(cell2mat(CellName_temp(j)),'i') > 0)
        CellNames(m,1) = CellName_temp(j);
        m = m + 1;
    end
end
clear a m j CellName_temp
%=========================================

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')

q = '''';
c = ',';
qcq = [q c q];

Plot_Time = [-100 500];
plotFlag = 1;

for cellnum = 1:length(CellNames)
    eval(['load(' q file qcq cell2mat(CellNames(cellnum)) qcq '-mat' q ')'])
end

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'TrialStart_' qcq 'RFs' qcq 'BestRF' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);
Align_Time(1:size(Target_,1),1) = 500;

%===============================================
% MAIN LOOPS

%do for each neuron in file
for n = 1:length(CellNames)
    if ~isempty(RFs{n})
    Spikes = eval(cell2mat(CellNames(n)));

    [BurstBegin,BurstEnd,BurstSurprise,BurstStartTimes] = getBurst(Spikes);
    
    Onsets_ss2 = BurstStartTimes(find(ismember(Target_(:,2),RFs{1}) & Correct_(:,2) == 1 & Target_(:,5) == 2),1);
    Onsets_ss4 = BurstStartTimes(find(ismember(Target_(:,2),RFs{1}) & Correct_(:,2) == 1 & Target_(:,5) == 4),1);
    Onsets_ss8 = BurstStartTimes(find(ismember(Target_(:,2),RFs{1}) & Correct_(:,2) == 1 & Target_(:,5) == 8),1);
        
    
    save(['//scratch/heitzrp/Output/Burst_SetSize/Burst_' file '_' cell2mat(CellNames(n)) '.mat','-mat'])
   

    if plotFlag == 1
    figure
    orient landscape
    set(gcf,'color','white')
        
    SDF_ss2 = spikedensityfunct(Spikes,Align_Time,Plot_Time,find(ismember(Target_(:,2),RFs{1}) & Correct_(:,2) == 1 & Target_(:,5) == 2), TrialStart_);    
    SDF_ss4 = spikedensityfunct(Spikes,Align_Time,Plot_Time,find(ismember(Target_(:,2),RFs{1}) & Correct_(:,2) == 1 & Target_(:,5) == 4), TrialStart_);    
    SDF_ss8 = spikedensityfunct(Spikes,Align_Time,Plot_Time,find(ismember(Target_(:,2),RFs{1}) & Correct_(:,2) == 1 & Target_(:,5) == 8), TrialStart_);    
    burst2 = nanmedian(Onsets_ss2(:,1));
    burst4 = nanmedian(Onsets_ss4(:,1));
    burst8 = nanmedian(Onsets_ss8(:,1));
    
    minSDF = min(min(min(SDF_ss2),min(SDF_ss4)),min(SDF_ss8));
    maxSDF = max(max(max(SDF_ss2),max(SDF_ss4)),max(SDF_ss8));
    
    plot(Plot_Time(1):Plot_Time(2),SDF_ss2,'b',Plot_Time(1):Plot_Time(2),SDF_ss4,'r',Plot_Time(1):Plot_Time(2),SDF_ss8,'k','linewidth',2)
    line([burst2 burst2],[minSDF maxSDF],'color','b','linewidth',2)
    line([burst4 burst4],[minSDF maxSDF],'color','r','linewidth',2)
    line([burst8 burst8],[minSDF maxSDF],'color','k','linewidth',2)
    legend('SS 2','SS 4','SS 8','location','northwest')
    title(['Onset SS2: ' mat2str(burst2) ' Onset SS4: ' mat2str(burst4) ' Onset SS8: ' mat2str(burst8)],'fontweight','bold','fontsize',12)
    
    eval(['print -dpdf ',q,'//scratch/heitzrp/Output/Burst_SetSize/PDF/',file,'_',cell2mat(CellNames(n)),'.pdf',q])
    end
    
    else
        continue
    end
    
    keep plotFlag Align_Time Plot_Time TrialStart_ file RFs BestRF CellNames n q c qcq Target_ Correct_ Errors_ SRT
    
end
toc