
cd /volumes/Dump/Search_Data/
batch_list = dir('S*SEARCH.mat');
% 
% q = '''';
% c = ',';
% qcq = [q c q];
% PDFflag = 1;
% saveFlag = 1;



validCell_upright = 0;
validCell_other = 0;
for i = 1:length(batch_list)
    
    
    load(batch_list(i).name,'Stimuli_')
    
    if exist('Stimuli_')
        getStim
        
        if (strmatch(Targ,'T','exact') & strmatch(orient,'Up','exact'))
            load(batch_list(i).name) %full load if meet criteria
            batch_list(i).name %echo valid file name
            
            %shorten_file
            
            varlist = who;
            DSPlist = varlist(strmatch('DSP',varlist'));
            
            for spk = 1:length(DSPlist)
                RF = RFs.(cell2mat(DSPlist(spk)));
                
                if isempty(RF)
                    disp('Empty RF...moving on')
                    continue
                end
                
                if length(RF) == 7
                    disp('All-Over RF detected; skipping')
                    continue
                else
                    validCell_upright = validCell_upright + 1;
                end
                
                antiRF = mod((RF+4),8);
                
                Spike = eval(cell2mat(DSPlist(spk)));
                
                inTrials = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
                outTrials = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
                
                SDF_in = spikedensityfunct(Spike,Target_(:,1),[-100 400],inTrials,TrialStart_);
                SDF_out = spikedensityfunct(Spike,Target_(:,1),[-100 400],outTrials,TrialStart_);
                
                %find onset latency
                
                Burst = getBurst(Spike);
                BurstStart_upright(validCell_upright,1) = nanmedian(Burst(:,1));
                
                f = figure;
                plot(-100:400,SDF_in,'r',-100:400,SDF_out,'--r')
                vline(BurstStart_upright(validCell_upright,1),'k')
                
                fon
                title([batch_list(i).name ' ' DSPlist(spk)])
                
                eval(['print -dpdf /volumes/Dump/Analyses/Bichot_Effect/PDF/' batch_list(i).name '_' cell2mat(DSPlist(spk)) '_upright.pdf'])
                close(f)
            end
            
        else
            load(batch_list(i).name) %full load if meet criteria
            batch_list(i).name %echo valid file name
            
            %shorten_file
            
            varlist = who;
            DSPlist = varlist(strmatch('DSP',varlist'));
            
            for spk = 1:length(DSPlist)
                RF = RFs.(cell2mat(DSPlist(spk)));
                
                if isempty(RF)
                    disp('Empty RF...moving on')
                    continue
                end
                
                if length(RF) == 7
                    disp('All-Over RF detected; skipping')
                    continue
                else
                    validCell_other = validCell_other + 1;
                end
                
                antiRF = mod((RF+4),8);
                
                Spike = eval(cell2mat(DSPlist(spk)));
                
                inTrials = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
                outTrials = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
                
                SDF_in = spikedensityfunct(Spike,Target_(:,1),[-100 400],inTrials,TrialStart_);
                SDF_out = spikedensityfunct(Spike,Target_(:,1),[-100 400],outTrials,TrialStart_);
                
                %find onset latency
                Burst = getBurst(Spike);
                BurstStart_other(validCell_other,1) = nanmedian(Burst(:,1));
                
                f = figure;
                plot(-100:400,SDF_in,'r',-100:400,SDF_out,'--r')
                vline(BurstStart_other(validCell_other,1),'k')
                
                fon
                title([batch_list(i).name ' ' DSPlist(spk)])
                eval(['print -dpdf /volumes/Dump/Analyses/Bichot_Effect/PDF/' batch_list(i).name '_' cell2mat(DSPlist(spk)) '_other.pdf'])
                close(f)
            end
        end
        keep batch_list i validCell* validCell* BurstStart*
        
    else
        disp('Stimuli_ variable not encoded')
        
    end
end

save('/volumes/Dump/Analyses/Bichot_Effect/Bichot_Effect.mat','-mat')