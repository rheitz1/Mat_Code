% %%%%%%PLX to M Conversion
% file_path ='C:\Documents and Settings\Rich\Desktop\Mat_Code\Contrast Sensitivity\';
% [filename,file_path] = uigetfile([file_path,'*.plx'],'Choose MATLAB File to Process');
% Plx_Conversion(filename,file_path);
% 
% %Find saccades
% p_sacc_det_contrast(filename,file_path)
% 
% %Plot SDFs by screen location
% %Use to find cell's RF
% 

%create a list of all variables in workspace
varlist = who;

%find indexes of cell names
CellMarker = strmatch('DSP0',varlist);

%create a list of target cells to analyze
for a = 1:length(CellMarker)
    CellNames(a,1) = varlist(CellMarker(a));
end



%Set SDF parameters
Align_Time_ = Decide_(:,1);
Plot_Time=[-1000 1000];


%find correct trials
% goodtrials = Target_(find(Correct_(:,2) == 1),:);

for i = 1:length(CellNames)
    figure
    set(gcf,'Color','white')
    CellName = eval(cell2mat(CellNames(i)));
   
    
    %draw SDFs
   
    for j = 0:max(goodtrials(:,2))
        %Will be plotting with subplot, but need to specify where each
        %screen location will fall in subplot coordinates
        switch j
            case 0
                screenloc = 6;
            case 1
                screenloc = 3;
            case 2
                screenloc = 2;
            case 3
                screenloc = 1;
            case 4
                screenloc = 4;
            case 5
                screenloc = 7;
            case 6
                screenloc = 8;
            case 7
                screenloc = 9;
        end
        
    SDF=[];
    %dynamically set "triallist" - should be equal to the # of trials for
    %each screen location
    triallist = 1:length(find(Correct_(:,2) == 1 & Target_(:,2) == j));
    [SDF] = spikedensityfunct_contrast(CellName(find(Correct_(:,2) == 1 & Target_(:,2) == j),:), Align_Time_, Plot_Time, triallist, TrialStart_);
    
    %set axis limits based on first SDF
        if j == 0
            ymax = max(SDF);
        end
        
    subplot(3,3,screenloc)
    plot(Plot_Time(1):Plot_Time(2),SDF,'r','LineWidth',.5)
    %line([mean(SaccBegin(find(Correct_(:,2) == 1 & Target_(:,2) == j))) mean(SaccBegin(find(Correct_(:,2) == 1 & Target_(:,2) == j)))],[-10 10])
    line([mean(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j))) mean(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j)))],[-10 10])
    title(CellNames(i))
    ylim([0 ymax+ymax*4])
    xlim(Plot_Time)
%     for i = 1:length(CellName(find(goodtrials(:,2) == j)))
%         for n = 1:(length(CellName(i,:)))
%         line([CellName(i,n) CellName(i,n)], [i-1 i+1])
%         end
%     end
%RFs = input('Enter matrix of locations thought to be within cell RF, separated by spaces ')
    end
end