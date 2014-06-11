
cd /volumes/Dump/Search_Data_popOut/
batch_list = dir('S*SEARCH.mat');

for sess = 1:length(batch_list)
    batch_list(sess).name
    load(batch_list(sess).name, 'Hemi','RFs','MFs','SRT','Correct_','Target_','newfile')
    
    if exist('Hemi') == 0; continue; end
    if exist('RFs') == 0; continue; end
    if exist('SRT') == 0
        load(batch_list(sess).name,'EyeX_','EyeY_')
        SRT = getSRT(EyeX_,EyeY_);
        clear EyeX_ EyeY_
    end
    
    
    loadChan(batch_list(sess).name,'DSP')
    loadChan(batch_list(sess).name,'LFP')
    
    varlist = who;
    DSPchan = varlist(strmatch('DSP',varlist));
    LFPchan = varlist(strmatch('AD',varlist));
    clear varlist
    
    if isempty(DSPchan) && isempty(LFPchan)
        disp('No Channels...')
        clear Hemi RFs SRT Correct_ Target_ DSPchan LFPchan
        continue
    end
    
    
    for chan = 1:length(LFPchan)
        sig = eval(LFPchan{chan});
        sig = fixClipped(sig);
        sig = baseline_correct(sig,[400 500]);
        
        if Hemi.(LFPchan{chan}) == 'L'
            RF = [7 0 1];
        elseif Hemi.(LFPchan{chan}) == 'R'
            RF = [3 4 5];
        end
        
        antiRF = mod((RF+4),8);
        
        in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,2) ~= 255);
        out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,2) ~= 255);
        
        in.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & Target_(:,2) ~= 255);
        in.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & Target_(:,2) ~= 255);
        in.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & Target_(:,2) ~= 255);
        
        out.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & Target_(:,2) ~= 255);
        out.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & Target_(:,2) ~= 255);
        out.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & Target_(:,2) ~= 255);
        
        allTDT.LFP.all(sess,chan) = getTDT_AD(sig,in.all,out.all);
        allTDT.LFP.ss2(sess,chan) = getTDT_AD(sig,in.ss2,out.ss2);
        allTDT.LFP.ss4(sess,chan) = getTDT_AD(sig,in.ss4,out.ss4);
        allTDT.LFP.ss8(sess,chan) = getTDT_AD(sig,in.ss8,out.ss8);
        
        
        RT = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255),1));
        
        %keep only if TDT is < mean RT
        if allTDT.LFP.all(sess,chan) > RT; allTDT.LFP.all(sess,chan) = NaN; end
        if allTDT.LFP.ss2(sess,chan) > RT; allTDT.LFP.ss2(sess,chan) = NaN; end
        if allTDT.LFP.ss4(sess,chan) > RT; allTDT.LFP.ss4(sess,chan) = NaN; end
        if allTDT.LFP.ss8(sess,chan) > RT; allTDT.LFP.ss8(sess,chan) = NaN; end
        
        clear sig RF antiRF in out
    end
    
    
    
    for chan = 1:length(DSPchan)
        sig = eval(DSPchan{chan});
        
        RF = RFs.(DSPchan{chan});
        
        if ~isempty(RF)
            antiRF = mod((RF+4),8);
        else
            disp('No RF...')
            clear sig RF
            continue
        end
        
        in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,2) ~= 255);
        out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,2) ~= 255);
        
        in.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & Target_(:,2) ~= 255);
        in.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & Target_(:,2) ~= 255);
        in.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & Target_(:,2) ~= 255);
        
        out.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & Target_(:,2) ~= 255);
        out.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & Target_(:,2) ~= 255);
        out.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & Target_(:,2) ~= 255);
        
        allTDT.SPK.all(sess,chan) = getTDT_SP(sig,in.all,out.all);
        allTDT.SPK.ss2(sess,chan) = getTDT_SP(sig,in.ss2,out.ss2);
        allTDT.SPK.ss4(sess,chan) = getTDT_SP(sig,in.ss4,out.ss4);
        allTDT.SPK.ss8(sess,chan) = getTDT_SP(sig,in.ss8,out.ss8);
        
        RT = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255),1));
        
        %keep only if TDT is < mean RT
        if allTDT.SPK.all(sess,chan) > RT; allTDT.SPK.all(sess,chan) = NaN; end
        if allTDT.SPK.ss2(sess,chan) > RT; allTDT.SPK.ss2(sess,chan) = NaN; end
        if allTDT.SPK.ss4(sess,chan) > RT; allTDT.SPK.ss4(sess,chan) = NaN; end
        if allTDT.SPK.ss8(sess,chan) > RT; allTDT.SPK.ss8(sess,chan) = NaN; end
        
        clear sig RF antiRF in out currTDT
    end
    
    mRT.all(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255),1));
    mRT.ss2(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255),1));
    mRT.ss4(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255),1));
    mRT.ss8(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255),1));
    
    mACC.all(sess,1) = length(find(Correct_(:,2) == 1)) / size(Correct_,1);
    mACC.ss2(sess,1) = length(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255)) / length(find(Target_(:,5) == 2 & Target_(:,2) ~= 255));
    mACC.ss4(sess,1) = length(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255)) / length(find(Target_(:,5) == 4 & Target_(:,2) ~= 255));
    mACC.ss8(sess,1) = length(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255)) / length(find(Target_(:,5) == 8 & Target_(:,2) ~= 255));
    
    keep batch_list sess allTDT mRT mACC
    
end
