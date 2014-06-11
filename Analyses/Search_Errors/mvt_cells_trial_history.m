
[file_name cell_name] = textread('mvt_cells.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];


for file = 1:size(file_name,1)
    
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'EyeX_' qcq 'EyeY_' qcq 'MFs' qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
    Spike = eval(cell2mat(cell_name(file)));
    
    RF = MFs.(cell2mat(cell_name(file)));
    antiRF = mod((RF+4),8);
    
    
    srt
    fixErrors
    SDF = sSDF(Spike,Target_(:,1),[-100 500]);
    SDF_r = sSDF(Spike,SRT(:,1)+500,[-400 200]);
    
    %for finding RT disregarding saccade location
    
%     c_c(1:size(Target_,1),1) = NaN;
%     c_e(1:size(Target_,1),1) = NaN;
%     e_c(1:size(Target_,1),1) = NaN;
%     e_e(1:size(Target_,1),1) = NaN;
%     
%     for trl = 2:size(Correct_,1)
%         if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255
%             e_e(trl-1,1) = trl;
%             
%         elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255
%             e_c(trl-1,1) = trl;
%             
%         elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1  & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255
%             c_e(trl-1,1) = trl;
%             
%         elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1  & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255
%             c_c(trl-1,1) = trl;
%         end
%     end
%     
%     c_c = removeNaN(c_c);
%     c_e = removeNaN(c_e);
%     e_c = removeNaN(e_c);
%     e_e = removeNaN(e_e);
%     
%     RT.c_c(file,1) = nanmean(SRT(c_c,1));
%     RT.e_c(file,1) = nanmean(SRT(e_c,1));
%     RT.c_e(file,1) = nanmean(SRT(c_e,1));
%     RT.e_e(file,1) = nanmean(SRT(e_e,1));
%     
%     clear c_c e_c c_e e_e
%     
    
    
    
    %for finding in and out responses
    e_e.in(1:size(Correct_,1),1) = NaN;
    e_c.in(1:size(Correct_,1),1) = NaN;
    c_e.in(1:size(Correct_,1),1) = NaN;
    c_c.in(1:size(Correct_,1),1) = NaN;
    
    e_e.out(1:size(Correct_,1),1) = NaN;
    e_c.out(1:size(Correct_,1),1) = NaN;
    c_e.out(1:size(Correct_,1),1) = NaN;
    c_c.out(1:size(Correct_,1),1) = NaN;
    
    
    
    for trl = 2:size(Correct_,1)
        if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
            e_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
            e_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
            e_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
            e_c.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
            c_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
            c_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
            c_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
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
    
    targwf.c_c.in(file,1:601) = nanmean(SDF(c_c.in,:));
    targwf.c_c.out(file,1:601) = nanmean(SDF(c_c.out,:));
    targwf.e_c.in(file,1:601) = nanmean(SDF(e_c.in,:));
    targwf.e_c.out(file,1:601) = nanmean(SDF(e_c.out,:));
    targwf.c_e.in(file,1:601) = nanmean(SDF(c_e.in,:));
    targwf.c_e.out(file,1:601) = nanmean(SDF(c_e.out,:));
    targwf.e_e.in(file,1:601) = nanmean(SDF(e_e.in,:));
    targwf.e_e.out(file,1:601) = nanmean(SDF(e_e.out,:));
    
    respwf.c_c.in(file,1:601) = nanmean(SDF_r(c_c.in,:));
    respwf.c_c.out(file,1:601) = nanmean(SDF_r(c_c.out,:));
    respwf.e_c.in(file,1:601) = nanmean(SDF_r(e_c.in,:));
    respwf.e_c.out(file,1:601) = nanmean(SDF_r(e_c.out,:));
    respwf.c_e.in(file,1:601) = nanmean(SDF_r(c_e.in,:));
    respwf.c_e.out(file,1:601) = nanmean(SDF_r(c_e.out,:));
    respwf.e_e.in(file,1:601) = nanmean(SDF_r(e_e.in,:));
    respwf.e_e.out(file,1:601) = nanmean(SDF_r(e_e.out,:));
    
    %target aligned
    f = figure;
    set(gcf,'color','white')
    plot(-100:500,nanmean(SDF(c_c.in,:)),'k',-100:500,nanmean(SDF(c_c.out,:)),'--k',-100:500, ...
        nanmean(SDF(e_c.in,:)),'b',-100:500,nanmean(SDF(e_c.out,:)),'--b',-100:500, ...
        nanmean(SDF(c_e.in,:)),'r',-100:500,nanmean(SDF(c_e.out,:)),'--r',-100:500, ...
        nanmean(SDF(e_e.in,:)),'g',-100:500,nanmean(SDF(e_e.out,:)),'--g')
    
    
    legend('cor-cor in','cor-cor out','err-cor in','err-cor out','cor-err in','cor-err out','err-err in','err-err out')
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/mvt_cell_trial_history/PDF/' cell2mat(file_name(file)) '_' cell2mat(cell_name(file)) '_targ.pdf'])
    
    close(f)
    
    
    %response aligned
    f = figure;
    set(gcf,'color','white')
    plot(-400:200,nanmean(SDF_r(c_c.in,:)),'k',-400:200,nanmean(SDF_r(c_c.out,:)),'--k',-400:200, ...
        nanmean(SDF_r(e_c.in,:)),'b',-400:200,nanmean(SDF_r(e_c.out,:)),'--b',-400:200, ...
        nanmean(SDF_r(c_e.in,:)),'r',-400:200,nanmean(SDF_r(c_e.out,:)),'--r',-400:200, ...
        nanmean(SDF_r(e_e.in,:)),'g',-400:200,nanmean(SDF_r(e_e.out,:)),'--g')
    
    
    legend('cor-cor in','cor-cor out','err-cor in','err-cor out','cor-err in','cor-err out','err-err in','err-err out')
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/mvt_cell_trial_history/PDF/' cell2mat(file_name(file)) '_' cell2mat(cell_name(file)) '_resp.pdf'])
    
    close(f)
    
    keep targwf respwf RT file_name cell_name file q c qcq
    
end
keep targwf respwf RT file file_name 
save('/volumes/Dump/Analyses/Errors/mvt_cell_trial_history/Matrices/Agg.mat','-mat')


%plotting
figure
set(gcf,'color','white')
subplot(1,2,1)
plot(-100:500,nanmean(targwf.c_c.in(1:12,:)),'k',-100:500,nanmean(targwf.c_c.out(1:12,:)),'--k', ...
    -100:500,nanmean(targwf.e_c.in(1:12,:)),'r',-100:500,nanmean(targwf.e_c.out(1:12,:)),'--r', ...
    -100:500,nanmean(targwf.c_e.in(1:12,:)),'b',-100:500,nanmean(targwf.c_e.out(1:12,:)),'--b', ...
    -100:500,nanmean(targwf.e_e.in(1:12,:)),'g',-100:500,nanmean(targwf.e_e.out(1:12,:)),'--g')
xlim([-100 500])

subplot(1,2,2)
plot(-400:200,nanmean(respwf.c_c.in(1:12,:)),'k',-400:200,nanmean(respwf.c_c.out(1:12,:)),'--k', ...
    -400:200,nanmean(respwf.e_c.in(1:12,:)),'r',-400:200,nanmean(respwf.e_c.out(1:12,:)),'--r', ...
    -400:200,nanmean(respwf.c_e.in(1:12,:)),'b',-400:200,nanmean(respwf.c_e.out(1:12,:)),'--b', ...
    -400:200,nanmean(respwf.e_e.in(1:12,:)),'g',-400:200,nanmean(respwf.e_e.out(1:12,:)),'--g')
xlim([-400 200])
title('Quincy')


figure
set(gcf,'color','white')
subplot(1,2,1)
plot(-100:500,nanmean(targwf.c_c.in(13:15,:)),'k',-100:500,nanmean(targwf.c_c.out(13:15,:)),'--k', ...
    -100:500,nanmean(targwf.e_c.in(13:15,:)),'r',-100:500,nanmean(targwf.e_c.out(13:15,:)),'--r', ...
    -100:500,nanmean(targwf.c_e.in(13:15,:)),'b',-100:500,nanmean(targwf.c_e.out(13:15,:)),'--b', ...
    -100:500,nanmean(targwf.e_e.in(13:15,:)),'g',-100:500,nanmean(targwf.e_e.out(13:15,:)),'--g')
xlim([-100 500])

subplot(1,2,2)
plot(-400:200,nanmean(respwf.c_c.in(13:15,:)),'k',-400:200,nanmean(respwf.c_c.out(13:15,:)),'--k', ...
    -400:200,nanmean(respwf.e_c.in(13:15,:)),'r',-400:200,nanmean(respwf.e_c.out(13:15,:)),'--r', ...
    -400:200,nanmean(respwf.c_e.in(13:15,:)),'b',-400:200,nanmean(respwf.c_e.out(13:15,:)),'--b', ...
    -400:200,nanmean(respwf.e_e.in(13:15,:)),'g',-400:200,nanmean(respwf.e_e.out(13:15,:)),'--g')
xlim([-400 200])
title('Seymour')


%ALL
figure
fw
subplot(1,2,1)
plot(-100:500,nanmean(targwf.c_c.in),'k',-100:500,nanmean(targwf.c_c.out),'--k',-100:500,nanmean(targwf.e_c.in),'b',-100:500,nanmean(targwf.e_c.out),'--b',-100:500,nanmean(targwf.c_e.in),'r',-100:500,nanmean(targwf.c_e.out),'--r',-100:500,nanmean(targwf.e_e.in),'g',-100:500,nanmean(targwf.e_e.out),'--g')
xlim([-100 500])

subplot(1,2,2)
plot(-400:200,nanmean(respwf.c_c.in),'k',-400:200,nanmean(respwf.c_c.out),'--k',-400:200,nanmean(respwf.e_c.in),'b',-400:200,nanmean(respwf.e_c.out),'--b',-400:200,nanmean(respwf.c_e.in),'r',-400:200,nanmean(respwf.c_e.out),'--r',-400:200,nanmean(respwf.e_e.in),'g',-400:200,nanmean(respwf.e_e.out),'--g')
xlim([-400 200])

