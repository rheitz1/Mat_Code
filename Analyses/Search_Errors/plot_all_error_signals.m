%Plots all signals, correct and error trials, one by one and asks for user
%input as to whether you want to use it or not.  If yes, the plot is saved.

cd '/volumes/Dump/Search_Data/'

batch_list = dir('*SEARCH.mat');

for i = 1:length(batch_list)
    
    batch_list(i).name
    
    try
        ChanStruct = loadChan(batch_list(i).name,'DSP');
    catch
        disp('Error loading channels, continuing...')
        continue
    end
    
    DSPlist = fieldnames(ChanStruct);
    decodeChanStruct
    
    
    load(batch_list(i).name,'Correct_','Target_','EyeX_','EyeY_','SRT','Errors_','RFs','TrialStart_','newfile')
    
    
    %get saccade metrics including saccade location (do not check for
    %Translate-encoded SaccDir_, due to some question about its accuracy.
    srt
    
    %fix 'Errors_' variable for old files
    fixErrors
    
    
    for chan = 1:length(DSPlist)
        Spike = eval(DSPlist{chan});
        %RF = RFs.(DSPname{sess});
        RF = RFs.(DSPlist{chan});
        
        if isempty(RF)
            disp('Empty RF, moving on...')
            continue
        end
        
        antiRF = mod((RF+4),8);
        
        
        inTrials_error = shake(find(Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
        outTrials_error = shake(find(Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
        
        
        SDF_in_errors = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_error,TrialStart_);
        SDF_out_errors = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_error,TrialStart_);
        
        TDT = getTDT_SP(Spike,inTrials_error,outTrials_error);
        
        f = figure;
        set(gcf,'color','white')
        plot(-100:500,SDF_in_errors,'r',-100:500,SDF_out_errors,'--r','linewidth',2)
        xlim([-100 500])
        title(['nIn = ' mat2str(length(inTrials_error)) ' nOut = ' mat2str(length(outTrials_error)) ' TDT = ' mat2str(TDT)],'fontsize',14,'fontweight','bold')
        xlabel([mat2str(batch_list(i).name) '  Cell: ' DSPlist{chan}],'fontsize',14,'fontweight','bold')
        vline(TDT)
        
        do_you_want_to_keep = input('Keeper?');
        
        if do_you_want_to_keep == 1
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/find_keeper_error_neurons_RF/' mat2str(batch_list(i).name) '_' DSPlist{chan} '.pdf'])
        end
        
        close(f)
        
        clear Spike RF antiRF inTrials_error outTrials_error SDF* TDT
    end
    
    keep batch_list i
    
    
end