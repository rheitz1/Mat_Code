outdir = 'C:\Documents and Settings\Administrator\Desktop\Mat_Code\Analyses\Contrast Sensitivity\PDF\';


%load appropriate file
f_path = 'C:\data\Search_Data\';
[file_name cell_name] = textread('Blocked_setsize.txt', '%s %s');
Align_ = 'r';
extension = 'move';

for file = 1:size(file_name,1)
    load([f_path cell2mat(file_name(file))])

    %Determine monkey
    if exist('newfile')
        if strfind(newfile,'Q') == 1
            monkey = 'Q';
            ASL_Delay = 0;
        elseif strfind(newfile,'dat') == 1
            monkey = 'Q';
            ASL_Delay = 0;
        else
            monkey = 'S';
            ASL_Delay = 1;
        end
    end


    if exist('SRT') == 0
        [SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay);
    end

    %set up alignment options for SDF
    if Align_ == 's'
        Align_Time(1:length(Correct_),1) = 500;
        SDFPlot_Time = [-200 800];
    elseif Align_ == 'r'
        Align_Time = SRT(:,1);
        SDFPlot_Time = [-400 200];
        %When Saccade aligned, still have 500 ms baseline + SRT.
        Align_Time = Align_Time + 500;
    end


    %check to make sure RFs exist in file
    if exist('RFs') == 0
        disp('No RFs present in file')
        return
    end


    fixErrors


    %find 'valid' Correct trials
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);

    %=============================
    %run scripts
    getCellnames
    %fixErrors


    varlist = who;
    cells = varlist(strmatch('DSP',varlist));



    %match RF with relevant cell
    %y = strmatch(cell_list{i},varlist_clean);
    y = strmatch(cell_name{file},cells);

    if Align_ == 's'
        RF = RFs{y};
    elseif Align_ == 'r'
        RF = MFs{y};
    end
    anti_RF = getAntiRF(RF);
    
    disp('hi')
end
