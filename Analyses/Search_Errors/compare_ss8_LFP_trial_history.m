
cd /volumes/Dump/Search_Data/
batch_list = dir('S*SEARCH.mat');

totalLFP = 0;

for i = 1:length(batch_list)
    batch_list(i).name
    
    load(batch_list(i).name,'Hemi','Target_','newfile','EyeX_','EyeY_','Correct_')
    srt
    ChanStruct = loadChan(batch_list(i).name,'LFP');
    
    try
        LFPlist = fields(ChanStruct);
        decodeChanStruct
        
        
        for LFPchan = 1:length(LFPlist)
            
            
            LFP = eval(cell2mat(LFPlist(LFPchan)));
            LFP = fixClipped(LFP);
            LFP = baseline_correct(LFP,[400 500]);
            
            
            if Hemi.(cell2mat(LFPlist(LFPchan))) == 'L'
                RF = [7 0 1];
                antiRF = [3 4 5];
            elseif Hemi.(cell2mat(LFPlist(LFPchan))) == 'R'
                RF = [3 4 5];
                antiRF = [7 0 1];
            end
            
            
            %set up trial history
            e_e.in(1:size(Correct_,1),1) = NaN;
            e_c.in(1:size(Correct_,1),1) = NaN;
            c_e.in(1:size(Correct_,1),1) = NaN;
            c_c.in(1:size(Correct_,1),1) = NaN;
            
            e_e.out(1:size(Correct_,1),1) = NaN;
            e_c.out(1:size(Correct_,1),1) = NaN;
            c_e.out(1:size(Correct_,1),1) = NaN;
            c_c.out(1:size(Correct_,1),1) = NaN;
            
            
            %limit to set size 8
            for trl = 2:size(Correct_,1)
                if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    e_e.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    e_e.out(trl-1,1) = trl;
                    
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    e_c.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    e_c.out(trl-1,1) = trl;
                    
                elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    c_e.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    c_e.out(trl-1,1) = trl;
                    
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    c_c.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255 & Target_(trl,5) == 8
                    c_c.out(trl-1,1) = trl;
                end
            end
            
            
            e_e.in = removeNaN(e_e.in);
            e_c.in = removeNaN(e_c.in);
            c_e.in = removeNaN(c_e.in);
            c_c.in = removeNaN(c_c.in);
            
            e_e.out = removeNaN(e_e.out);
            e_c.out = removeNaN(e_c.out);
            c_e.out = removeNaN(c_e.out);
            c_c.out = removeNaN(c_c.out);
            
            f = figure;
            set(gcf,'color','white')
            
            totalLFP = totalLFP + 1;
            wf.LFP.c_c.in(totalLFP,1:3001) = nanmean(LFP(c_c.in,:));
            wf.LFP.c_c.out(totalLFP,1:3001) = nanmean(LFP(c_c.out,:));
            wf.LFP.e_c.in(totalLFP,1:3001) = nanmean(LFP(e_c.in,:));
            wf.LFP.e_c.out(totalLFP,1:3001) = nanmean(LFP(e_c.out,:));
            wf.LFP.c_e.in(totalLFP,1:3001) = nanmean(LFP(c_e.in,:));
            wf.LFP.c_e.out(totalLFP,1:3001) = nanmean(LFP(c_e.out,:));
            wf.LFP.e_e.in(totalLFP,1:3001) = nanmean(LFP(e_e.in,:));
            wf.LFP.e_e.out(totalLFP,1:3001) = nanmean(LFP(e_e.out,:));
            
            
            plot(-500:2500,nanmean(LFP(c_c.in,:)),'k',-500:2500,nanmean(LFP(c_c.out,:)),'--k', ...
                -500:2500,nanmean(LFP(e_c.in,:)),'b',-500:2500,nanmean(LFP(e_c.out,:)),'--b', ...
                -500:2500,nanmean(LFP(c_e.in,:)),'r',-500:2500,nanmean(LFP(c_e.out,:)),'--r', ...
                -500:2500,nanmean(LFP(e_e.in,:)),'g',-500:2500,nanmean(LFP(e_e.out,:)),'--g')
            
            axis ij
            xlim([-100 500])
            
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/trial_history_ss8/PDF/' batch_list(i).name '_' cell2mat(LFPlist(LFPchan)) '.pdf'])
            close(f)
            
            
            clear c_c e_c c_e e_e RF antiRF LFP
            
        end
        
        keep batch_list i totalLFP wf
        
    catch
        disp('Error loading channels')
        continue
    end
    
end

save('/volumes/Dump/Analyses/Errors/trial_history_ss8/Matrices/allwf.mat','-mat')




