%save maxFire

Plot_Time = [-50 300];
LFP_Plot_Time = [-500 2500];
%read in files and neurons
f_path = 'C:\Data\Search_Data\';
%[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
[file_name cell_name] = textread('temp.txt', '%s %s');


for file = 1:size(file_name,1)
    %echo current file and cell
    disp([file_name(file) cell_name(file)])

    load([f_path cell2mat(file_name(file))])
    
     Align_Time(1:size(Target_,1),1) = 500;

    %Get all cells in file
    getCellnames

    %find relevant RFs
    for cl = 1:length(CellNames)
        if strmatch(cell_name(file),CellNames(cl)) == 1
            RF = RFs{cl};
            cel = cl;
        end
    end
    
    
    
    
    anti_RF = getAntiRF(RF);

    inTrials = find(ismember(Target_(:,2),RF));
    outTrials = find(ismember(Target_(:,2),anti_RF));

    %get CellNames again (should only have one left after clearing all rest
    getCellnames

    TotalSpikes = [];
    %correct Cell name will always be 1st one as long as only one in
    %workspace
    TotalSpikes = eval(cell2mat(CellNames(1)));
    Spikes = TotalSpikes(inTrials,:);
Target_(:,13) = NaN;


    %================ S E T   L U M I N A N C E   V A L U E S ========
    %=================================================================

    %set critical values in each of three groups to categorical numbers
    %includes CLUT of 140, which was ungunnable but clearly visible
    %when dark adapted.  Low-range files will lose approx. half of its
    %data, beginning at 101 and up to 137, which are not included by
    %the below criterias
    Target_(find(Target_(:,3) >= 140 & Target_(:,3) < 160),13) = 1;
    Target_(find(Target_(:,3) >= 160 & Target_(:,3) < 190),13) = 2;
    Target_(find(Target_(:,3) >= 190),13) = 3;




    lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);
    cut1 = 1.5;
    cut2 = 2.5;
    lum(1) = min(Target_(find(Target_(:,3) > 1),3));
    lum(2) = max(Target_(find(Target_(:,3) > 1),3));

    Lows = find(ismember(Target_(:,2),RF) & Target_(:,13) < cut1);
    Mids = find(ismember(Target_(:,2),RF) & Target_(:,13) >= cut1 & Target_(:,13) < cut2);
    Highs = find(ismember(Target_(:,2),RF) & Target_(:,13) >= cut2);

    SDF_low = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,Lows, TrialStart_);
    SDF_mid = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,Mids, TrialStart_);
    SDF_high = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,Highs, TrialStart_);
    
    maxFire_Low = max(SDF_low);
    maxFire_Mid = max(SDF_mid);
    maxFire_High = max(SDF_high);

    maxFire_all(file,1) = maxFire_Low;
    maxFire_all(file,2) = maxFire_Mid;
    maxFire_all(file,3) = maxFire_High;
    
    
        %Keep record of maxFires
    maxFire_Record(file,1) = file_name(file);
    maxFire_Record(file,2) = cell_name(file);
    maxFire_Record(file,3) = mat2cell(maxFire_Low);
    maxFire_Record(file,4) = mat2cell(maxFire_Mid);
    maxFire_Record(file,5) = mat2cell(maxFire_High);
    
    save([f_path 'maxFire_Record'],'maxFire_Record','-mat')
    
    
    keep maxFire_Record Plot_Time cell_name f_path file file_name
end