% neuron_cDex = 1;
% neuron_eDex = 1;
% LFP_cDex = 1;
% LFP_eDex = 1;
% EEG_cDex = 1;
% EEG_eDex = 1;

neuron_index = 1;
LFP_index = 1;
OL_index = 1;
OR_index = 1;


cd /volumes/Dump/Analyses/Errors/Uber_5runs_.05_FINAL_Pep/Matrices/
batch_list = dir('P*.mat');

%cd /volumes/Dump/Analyses/Errors/History_Only/Matrices


%cd ~/desktop/temp/Matrices/

for i = 1:length(batch_list);
    batch_list(i).name
    load(batch_list(i).name)
    
    allfields = fields(TDT);
    
    
    if batch_list(i).name(1) == 'Q'
        monkey(i,1) = 'Q';
    elseif batch_list(i).name(1) == 'S'
        monkey(i,1) = 'S';
    elseif batch_list(i).name(1) == 'P'
        monkey(i,1) = 'P';
    end
    
    try
        alln.allCatch.catchtotal(i,1) = n.allCatch.catchtotal;
        alln.allCatch.correct_nosacc(i,1) = n.allCatch.correct_nosacc;
        alln.allCatch.fasterr(i,1) = n.allCatch.fasterr;
        alln.allCatch.lateresp(i,1) = n.allCatch.lateresp;
    catch
        alln.allCatch.catchtotal(i,1) = NaN;
        alln.allCatch.correct_nosacc(i,1) = NaN;
        alln.allCatch.fasterr(i,1) = NaN;
        alln.allCatch.lateresp(i,1) = NaN;
    end
    
   
    
    %Neuron TDTs
    neuronlist = allfields(strmatch('DSP',allfields));
    
    
    for f = 1:size(neuronlist,1)
        
        %             try
        %                 neuronTDT.correct(neuron_cDex,1) = TDT.(neuronlist{f});
        %             catch
        %                 neuronTDT.correct(neuron_cDex,1) = NaN;
        %             end
        
        %keep track of unit and session names
        info.neuron{neuron_index,1} = [batch_list(i).name '_' neuronlist{f}];
        
        allROC.neuron.c_c(neuron_index,1:601) = ROC.(neuronlist{f}).c_c;
        allROC.neuron.e_c(neuron_index,1:601) = ROC.(neuronlist{f}).e_c;
        allROC.neuron.c_e(neuron_index,1:601) = ROC.(neuronlist{f}).c_e;
        allROC.neuron.e_e(neuron_index,1:601) = ROC.(neuronlist{f}).e_e;
        allROC.neuron.correct(neuron_index,1:601) = ROC.(neuronlist{f}).correct;
        allROC.neuron.errors(neuron_index,1:601) = ROC.(neuronlist{f}).errors;
        
        
        allROC_sub.neuron.c_c(neuron_index,1:601) = ROC_sub.(neuronlist{f}).c_c;
        allROC_sub.neuron.e_c(neuron_index,1:601) = ROC_sub.(neuronlist{f}).e_c;
        allROC_sub.neuron.c_e(neuron_index,1:601) = ROC_sub.(neuronlist{f}).c_e;
        allROC_sub.neuron.e_e(neuron_index,1:601) = ROC_sub.(neuronlist{f}).e_e;
        allROC_sub.neuron.correct(neuron_index,1:601) = ROC_sub.(neuronlist{f}).correct;
        allROC_sub.neuron.errors(neuron_index,1:601) = ROC_sub.(neuronlist{f}).errors;
        
        %storing RTs repeatedly across signals so that they are in
        %register (supports scatter plots of TDT x RT)
        allRTs.neuron.correct(neuron_index,1) = nanmean(RTs.correct);
        allRTs.neuron.errors(neuron_index,1) = nanmean(RTs.errors);
        allRTs.neuron.c_c(neuron_index,1) = RTs.c_c;
        allRTs.neuron.e_c(neuron_index,1) = RTs.e_c;
        allRTs.neuron.c_e(neuron_index,1) = RTs.c_e;
        allRTs.neuron.e_e(neuron_index,1) = RTs.e_e;
        %         alln.neuron.errors.in(neuron_index,1) = n.(neuronlist{f}).errors.in;
        %         alln.neuron.errors.out(neuron_index,1) = n.(neuronlist{f}).errors.out;
        %         alln.neuron.c_c.in(neuron_index,1) = n.(neuronlist{f}).c_c.in;
        %         alln.neuron.c_c.out(neuron_index,1) = n.(neuronlist{f}).c_c.out;
        %         alln.neuron.e_c.in(neuron_index,1) = n.(neuronlist{f}).e_c.in;
        %         alln.neuron.e_c.out(neuron_index,1) = n.(neuronlist{f}).e_c.out;
        %         alln.neuron.c_e.in(neuron_index,1) = n.(neuronlist{f}).c_e.in;
        %         alln.neuron.c_e.out(neuron_index,1) = n.(neuronlist{f}).c_e.out;
        %         alln.neuron.e_e.in(neuron_index,1) = n.(neuronlist{f}).e_e.in;
        %         alln.neuron.e_e.out(neuron_index,1) = n.(neuronlist{f}).e_e.out;
        %         alln.neuron.catch.correct_nosacc(neuron_index,1) = n.(neuronlist{f}).catch.correct_nosacc;
        %         alln.neuron.catch.correct_in(neuron_index,1) = n.(neuronlist{f}).catch.correct_in;
        %         alln.neuron.catch.errors_in(neuron_index,1) = n.(neuronlist{f}).catch.errors_in;
        
        
        try
            allRTs.neuron.catch_correct_in(neuron_index,1) = RTs.catch.correct_in;
            allRTs.neuron.catch_errors(neuron_index,1) = RTs.catch.errors;
        catch
            allRTs.neuron.catch_correct_in(neuron_index,1) = NaN;
            allRTs.neuron.catch_errors(neuron_index,1) = NaN;
        end
        
        allwf.neuron.in_correct(neuron_index,1:601) = nanmean(wf.(neuronlist{f}).correct.in);
        allwf.neuron.out_correct(neuron_index,1:601) = nanmean(wf.(neuronlist{f}).correct.out);
        allwf.neuron.in_errors(neuron_index,1:601) = wf.(neuronlist{f}).errors.in;
        allwf.neuron.out_errors(neuron_index,1:601) = wf.(neuronlist{f}).errors.out;
        
        allwf.neuron.in_c_c(neuron_index,1:601) = wf.(neuronlist{f}).correct.in_c_c;
        allwf.neuron.out_c_c(neuron_index,1:601) = wf.(neuronlist{f}).correct.out_c_c;
        allwf.neuron.in_e_c(neuron_index,1:601) = wf.(neuronlist{f}).correct.in_e_c;
        allwf.neuron.out_e_c(neuron_index,1:601) = wf.(neuronlist{f}).correct.out_e_c;
        allwf.neuron.in_c_e(neuron_index,1:601) = wf.(neuronlist{f}).correct.in_c_e;
        allwf.neuron.out_c_e(neuron_index,1:601) = wf.(neuronlist{f}).correct.out_c_e;
        allwf.neuron.in_e_e(neuron_index,1:601) = wf.(neuronlist{f}).correct.in_e_e;
        allwf.neuron.out_e_e(neuron_index,1:601) = wf.(neuronlist{f}).correct.out_e_e;
        
        try
            allTDT.neuron.correct_nosub(neuron_index,1) = TDT.(neuronlist{f}).correct_nosub;
        catch
            allTDT.neuron.correct_nosub(neuron_index,1) = NaN;
        end
        
        
        allTDT.neuron.correct(neuron_index,1) = nanmean(TDT.(neuronlist{f}).correct);
        
        try
            allTDT.neuron.errors(neuron_index,1) = TDT.(neuronlist{f}).errors;
        catch
            allTDT.neuron.errors(neuron_index,1) = NaN;
        end
        
        allTDT.neuron.correct_c_c(neuron_index,1) = TDT.(neuronlist{f}).correct_c_c;
        allTDT.neuron.correct_c_e(neuron_index,1) = TDT.(neuronlist{f}).correct_c_e;
        allTDT.neuron.correct_e_c(neuron_index,1) = TDT.(neuronlist{f}).correct_e_c;
        allTDT.neuron.correct_e_e(neuron_index,1) = TDT.(neuronlist{f}).correct_e_e;
        
        try
            allwf.neuron.catch.correct_nosacc(neuron_index,1:601) = wf.(neuronlist{f}).catch.correct_nosacc;
            allwf.neuron.catch.correct_in(neuron_index,1:601) = wf.(neuronlist{f}).catch.correct_in;
            allwf.neuron.catch.errors_in(neuron_index,1:601) = wf.(neuronlist{f}).catch.errors_in;
            
            allwf.neuron.catch.correct_nosacc_resp(neuron_index,1:601) = wf.(neuronlist{f}).catch.correct_nosacc_resp;
            allwf.neuron.catch.correct_in_resp(neuron_index,1:601) = wf.(neuronlist{f}).catch.correct_in_resp;
            allwf.neuron.catch.errors_in_resp(neuron_index,1:601) = wf.(neuronlist{f}).catch.errors_in_resp;
            
            allwf.neuron.correct.in_resp(neuron_index,1:601) = wf.(neuronlist{f}).correct.in_resp;
            allwf.neuron.correct.out_resp(neuron_index,1:601) = wf.(neuronlist{f}).correct.out_resp;
            %             alln.neuron.in_correct(neuron_cDex,1) = n.(neuronlist{f}).in;
            %             alln.neuron.out_correct(neuron_cDex,1) = n.(neuronlist{f}).out;
        catch
            allwf.neuron.catch.correct_nosacc(neuron_index,1:601) = NaN;
            allwf.neuron.catch.correct_in(neuron_index,1:601) = NaN;
            allwf.neuron.catch.errors_in(neuron_index,1:601) = NaN;
            
            allwf.neuron.catch.correct_nosacc_resp(neuron_index,1:601) = NaN;
            allwf.neuron.catch.correct_in_resp(neuron_index,1:601) = NaN;
            allwf.neuron.catch.errors_in_resp(neuron_index,1:601) = NaN;
            
            allwf.neuron.correct.in_resp(neuron_index,1:601) = NaN;
            allwf.neuron.correct.out_resp(neuron_index,1:601) = NaN;
        end
        
        
        neuron_index = neuron_index + 1;
        
    end   %for neuronlist
    
    
    LFPlist = allfields(strmatch('AD',allfields));
    
    for f = 1:size(LFPlist,1)
        
        
        
        %keep track of unit and session names
        info.LFP{LFP_index,1} = [batch_list(i).name '_' LFPlist{f}];
        
        
        %             try
        %                 neuronTDT.correct(neuron_cDex,1) = TDT.(neuronlist{f});
        %             catch
        %                 neuronTDT.correct(neuron_cDex,1) = NaN;
        %             end
        
        %storing RTs repeatedly across signals so that they are in
        %register (supports scatter plots of TDT x RT)
        %         alln.LFP.Hemi.errors.in(LFP_index,1) = n.(LFPlist{f}).Hemi.errors.in;
        %         alln.LFP.Hemi.errors.out(LFP_index,1) = n.(LFPlist{f}).Hemi.errors.out;
        %         alln.LFP.Hemi.c_c.in(LFP_index,1) = n.(LFPlist{f}).Hemi.c_c.in;
        %         alln.LFP.Hemi.c_c.out(LFP_index,1) = n.(LFPlist{f}).Hemi.c_c.out;
        %         alln.LFP.Hemi.e_c.in(LFP_index,1) = n.(LFPlist{f}).Hemi.e_c.in;
        %         alln.LFP.Hemi.e_c.out(LFP_index,1) = n.(LFPlist{f}).Hemi.e_c.out;
        %         alln.LFP.Hemi.c_e.in(LFP_index,1) = n.(LFPlist{f}).Hemi.c_e.in;
        %         alln.LFP.Hemi.c_e.out(LFP_index,1) = n.(LFPlist{f}).Hemi.c_e.out;
        %         alln.LFP.Hemi.e_e.in(LFP_index,1) = n.(LFPlist{f}).Hemi.e_e.in;
        %         alln.LFP.Hemi.e_e.out(LFP_index,1) = n.(LFPlist{f}).Hemi.e_e.out;
        %         alln.LFP.Hemi.catch.correct_nosacc(LFP_index,1) = n.(LFPlist{f}).Hemi.catch.correct_nosacc;
        %         alln.LFP.Hemi.catch.correct_in(LFP_index,1) = n.(LFPlist{f}).Hemi.catch.correct_in;
        %         alln.LFP.Hemi.catch.errors_in(LFP_index,1) = n.(LFPlist{f}).Hemi.catch.errors_in;
        %
        %         alln.LFP.RF.errors.in(LFP_index,1) = n.(LFPlist{f}).RF.errors.in;
        %         alln.LFP.RF.errors.out(LFP_index,1) = n.(LFPlist{f}).RF.errors.out;
        %         alln.LFP.RF.c_c.in(LFP_index,1) = n.(LFPlist{f}).RF.c_c.in;
        %         alln.LFP.RF.c_c.out(LFP_index,1) = n.(LFPlist{f}).RF.c_c.out;
        %         alln.LFP.RF.e_c.in(LFP_index,1) = n.(LFPlist{f}).RF.e_c.in;
        %         alln.LFP.RF.e_c.out(LFP_index,1) = n.(LFPlist{f}).RF.e_c.out;
        %         alln.LFP.RF.c_e.in(LFP_index,1) = n.(LFPlist{f}).RF.c_e.in;
        %         alln.LFP.RF.c_e.out(LFP_index,1) = n.(LFPlist{f}).RF.c_e.out;
        %         alln.LFP.RF.e_e.in(LFP_index,1) = n.(LFPlist{f}).RF.e_e.in;
        %         alln.LFP.RF.e_e.out(LFP_index,1) = n.(LFPlist{f}).RF.e_e.out;
        %         alln.LFP.RF.catch.correct_nosacc(LFP_index,1) = n.(LFPlist{f}).RF.catch.correct_nosacc;
        %         alln.LFP.RF.catch.correct_in(LFP_index,1) = n.(LFPlist{f}).RF.catch.correct_in;
        %         alln.LFP.RF.catch.errors_in(LFP_index,1) = n.(LFPlist{f}).RF.catch.errors_in;
        %
        
        allROC.LFP.Hemi.c_c(LFP_index,1:601) = ROC.(LFPlist{f}).Hemi.c_c;
        allROC.LFP.Hemi.e_c(LFP_index,1:601) = ROC.(LFPlist{f}).Hemi.e_c;
        allROC.LFP.Hemi.c_e(LFP_index,1:601) = ROC.(LFPlist{f}).Hemi.c_e;
        allROC.LFP.Hemi.e_e(LFP_index,1:601) = ROC.(LFPlist{f}).Hemi.e_e;
        
        if length(ROC.(LFPlist{f}).correct) == 3001
            x = ROC.(LFPlist{f}).correct;
            y = ROC.(LFPlist{f}).errors;
            x = x(400:1000);
            y = y(400:1000);
            ROC.(LFPlist{f}).correct = x;
            ROC.(LFPlist{f}).errors = y;
        end
        
        
        allROC.LFP.correct(LFP_index,1:601) = ROC.(LFPlist{f}).correct;
        allROC.LFP.errors(LFP_index,1:601) = ROC.(LFPlist{f}).errors;
        
        allROC_sub.LFP.Hemi.c_c(LFP_index,1:601) = ROC_sub.(LFPlist{f}).Hemi.c_c;
        allROC_sub.LFP.Hemi.e_c(LFP_index,1:601) = ROC_sub.(LFPlist{f}).Hemi.e_c;
        allROC_sub.LFP.Hemi.c_e(LFP_index,1:601) = ROC_sub.(LFPlist{f}).Hemi.c_e;
        allROC_sub.LFP.Hemi.e_e(LFP_index,1:601) = ROC_sub.(LFPlist{f}).Hemi.e_e;
        
        if length(ROC_sub.(LFPlist{f}).correct) == 3001
            x = ROC_sub.(LFPlist{f}).correct;
            y = ROC_sub.(LFPlist{f}).errors;
            x = x(400:1000);
            y = y(400:1000);
            ROC_sub.(LFPlist{f}).correct = x;
            ROC_sub.(LFPlist{f}).errors = y;
        end
        
        allROC_sub.LFP.correct(LFP_index,1:601) = ROC_sub.(LFPlist{f}).correct;
        allROC_sub.LFP.errors(LFP_index,1:601) = ROC_sub.(LFPlist{f}).errors;
        
        try
            allROC.LFP.RF.c_c(LFP_index,1:601) = ROC.(LFPlist{f}).RF.c_c;
            allROC.LFP.RF.e_c(LFP_index,1:601) = ROC.(LFPlist{f}).RF.e_c;
            allROC.LFP.RF.c_e(LFP_index,1:601) = ROC.(LFPlist{f}).RF.c_e;
            allROC.LFP.RF.e_e(LFP_index,1:601) = ROC.(LFPlist{f}).RF.e_e;
            
            allROC_sub.LFP.RF.c_c(LFP_index,1:601) = ROC_sub.(LFPlist{f}).RF.c_c;
            allROC_sub.LFP.RF.e_c(LFP_index,1:601) = ROC_sub.(LFPlist{f}).RF.e_c;
            allROC_sub.LFP.RF.c_e(LFP_index,1:601) = ROC_sub.(LFPlist{f}).RF.c_e;
            allROC_sub.LFP.RF.e_e(LFP_index,1:601) = ROC_sub.(LFPlist{f}).RF.e_e;
        catch
            allROC.LFP.RF.c_c(LFP_index,1:601) = NaN;
            allROC.LFP.RF.e_c(LFP_index,1:601) = NaN;
            allROC.LFP.RF.c_e(LFP_index,1:601) = NaN;
            allROC.LFP.RF.e_e(LFP_index,1:601) = NaN;
            
            allROC_sub.LFP.RF.c_c(LFP_index,1:601) = NaN;
            allROC_sub.LFP.RF.e_c(LFP_index,1:601) = NaN;
            allROC_sub.LFP.RF.c_e(LFP_index,1:601) = NaN;
            allROC_sub.LFP.RF.e_e(LFP_index,1:601) = NaN;
        end
        
        
        try
            allRTs.LFP.RF.correct(LFP_index,1) = nanmean(RTs.correct);
            allRTs.LFP.RF.errors(LFP_index,1) = nanmean(RTs.errors);
            allRTs.LFP.RF.c_c(LFP_index,1) = RTs.c_c;
            allRTs.LFP.RF.e_c(LFP_index,1) = RTs.e_c;
            allRTs.LFP.RF.c_e(LFP_index,1) = RTs.c_e;
            allRTs.LFP.RF.e_e(LFP_index,1) = RTs.e_e;
            
            allRTs.LFP.Hemi.correct(LFP_index,1) = nanmean(RTs.correct);
            allRTs.LFP.Hemi.errors(LFP_index,1) = nanmean(RTs.errors);
            allRTs.LFP.Hemi.c_c(LFP_index,1) = RTs.c_c;
            allRTs.LFP.Hemi.e_c(LFP_index,1) = RTs.e_c;
            allRTs.LFP.Hemi.c_e(LFP_index,1) = RTs.c_e;
            allRTs.LFP.Hemi.e_e(LFP_index,1) = RTs.e_e;
        catch
            allRTs.LFP.RF.correct(LFP_index,1) = NaN;
            allRTs.LFP.RF.errors(LFP_index,1) = NaN;
            allRTs.LFP.RF.c_c(LFP_index,1) = NaN;
            allRTs.LFP.RF.e_c(LFP_index,1) = NaN;
            allRTs.LFP.RF.c_e(LFP_index,1) = NaN;
            allRTs.LFP.RF.e_e(LFP_index,1) = NaN;
            
            allRTs.LFP.Hemi.correct(LFP_index,1) = NaN;
            allRTs.LFP.Hemi.errors(LFP_index,1) = NaN;
            allRTs.LFP.Hemi.c_c(LFP_index,1) = NaN;
            allRTs.LFP.Hemi.e_c(LFP_index,1) = NaN;
            allRTs.LFP.Hemi.c_e(LFP_index,1) = NaN;
            allRTs.LFP.Hemi.e_e(LFP_index,1) = NaN;
        end
        
        try
            allRTs.LFP.RF.catch_correct_in(LFP_index,1) = RTs.catch.correct_in;
            allRTs.LFP.RF.catch_errors(LFP_index,1) = RTs.catch.errors;
        catch
            allRTs.LFP.RF.catch_correct_in(LFP_index,1) = NaN;
            allRTs.LFP.RF.catch_errors(LFP_index,1) = NaN;
        end
        
        
        try
            allRTs.LFP.Hemi.catch_correct_in(LFP_index,1) = RTs.catch.correct_in;
            allRTs.LFP.Hemi.catch_errors(LFP_index,1) = RTs.catch.errors;
        catch
            allRTs.LFP.Hemi.catch_correct_in(LFP_index,1) = NaN;
            allRTs.LFP.Hemi.catch_errors(LFP_index,1) = NaN;
        end
        
        try %have to use try because we do not know if there was an RF or not to use
            allwf.LFP.RF.in_correct(LFP_index,1:3001) = nanmean(wf.(LFPlist{f}).RF.correct.in);
            allwf.LFP.RF.out_correct(LFP_index,1:3001) = nanmean(wf.(LFPlist{f}).RF.correct.out);
            allwf.LFP.RF.in_errors(LFP_index,1:3001) = wf.(LFPlist{f}).RF.errors.in;
            allwf.LFP.RF.out_errors(LFP_index,1:3001) = wf.(LFPlist{f}).RF.errors.out;
            
            allwf.LFP.RF.in_c_c(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.in_c_c;
            allwf.LFP.RF.out_c_c(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.out_c_c;
            allwf.LFP.RF.in_e_c(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.in_e_c;
            allwf.LFP.RF.out_e_c(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.out_e_c;
            allwf.LFP.RF.in_c_e(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.in_c_e;
            allwf.LFP.RF.out_c_e(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.out_c_e;
            allwf.LFP.RF.in_e_e(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.in_e_e;
            allwf.LFP.RF.out_e_e(LFP_index,1:3001) = wf.(LFPlist{f}).RF.correct.out_e_e;
            
            allTDT.LFP.RF.correct_nosub(LFP_index,1) = TDT.(LFPlist{f}).RF.correct_nosub;
            allTDT.LFP.RF.correct(LFP_index,1) = nanmean(TDT.(LFPlist{f}).RF.correct);
            allTDT.LFP.RF.errors(LFP_index,1) = TDT.(LFPlist{f}).RF.errors;
            allTDT.LFP.RF.correct_c_c(LFP_index,1) = TDT.(LFPlist{f}).RF.correct_c_c;
            allTDT.LFP.RF.correct_c_e(LFP_index,1) = TDT.(LFPlist{f}).RF.correct_c_e;
            allTDT.LFP.RF.correct_e_c(LFP_index,1) = TDT.(LFPlist{f}).RF.correct_e_c;
            allTDT.LFP.RF.correct_e_e(LFP_index,1) = TDT.(LFPlist{f}).RF.correct_e_e;
        catch
            allwf.LFP.RF.in_correct(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.out_correct(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.in_errors(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.out_errors(LFP_index,1:3001) = NaN;
            
            allwf.LFP.RF.in_c_c(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.out_c_c(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.in_e_c(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.out_e_c(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.in_c_e(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.out_c_e(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.in_e_e(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.out_e_e(LFP_index,1:3001) = NaN;
            
            allTDT.LFP.RF.correct_nosub(LFP_index,1) = NaN;
            allTDT.LFP.RF.correct(LFP_index,1) = NaN;
            allTDT.LFP.RF.errors(LFP_index,1) = NaN;
            allTDT.LFP.RF.correct_c_c(LFP_index,1) = NaN;
            allTDT.LFP.RF.correct_c_e(LFP_index,1) = NaN;
            allTDT.LFP.RF.correct_e_c(LFP_index,1) = NaN;
            allTDT.LFP.RF.correct_e_e(LFP_index,1) = NaN;
        end
        
        
        allwf.LFP.Hemi.in_correct(LFP_index,1:3001) = nanmean(wf.(LFPlist{f}).Hemi.correct.in);
        allwf.LFP.Hemi.out_correct(LFP_index,1:3001) = nanmean(wf.(LFPlist{f}).Hemi.correct.out);
        allwf.LFP.Hemi.in_errors(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.errors.in;
        allwf.LFP.Hemi.out_errors(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.errors.out;
        
        allwf.LFP.Hemi.in_c_c(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.in_c_c;
        allwf.LFP.Hemi.out_c_c(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.out_c_c;
        allwf.LFP.Hemi.in_e_c(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.in_e_c;
        allwf.LFP.Hemi.out_e_c(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.out_e_c;
        allwf.LFP.Hemi.in_c_e(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.in_c_e;
        allwf.LFP.Hemi.out_c_e(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.out_c_e;
        allwf.LFP.Hemi.in_e_e(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.in_e_e;
        allwf.LFP.Hemi.out_e_e(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.correct.out_e_e;
        
        allTDT.LFP.Hemi.correct_nosub(LFP_index,1) = TDT.(LFPlist{f}).Hemi.correct_nosub;
        allTDT.LFP.Hemi.correct(LFP_index,1) = nanmean(TDT.(LFPlist{f}).Hemi.correct);
        allTDT.LFP.Hemi.errors(LFP_index,1) = TDT.(LFPlist{f}).Hemi.errors;
        allTDT.LFP.Hemi.correct_c_c(LFP_index,1) = TDT.(LFPlist{f}).Hemi.correct_c_c;
        allTDT.LFP.Hemi.correct_c_e(LFP_index,1) = TDT.(LFPlist{f}).Hemi.correct_c_e;
        allTDT.LFP.Hemi.correct_e_c(LFP_index,1) = TDT.(LFPlist{f}).Hemi.correct_e_c;
        allTDT.LFP.Hemi.correct_e_e(LFP_index,1) = TDT.(LFPlist{f}).Hemi.correct_e_e;
        
        
        
        try
            allwf.LFP.RF.catch.correct_nosacc(LFP_index,1:3001) = wf.(LFPlist{f}).RF.catch.correct_nosacc;
            allwf.LFP.RF.catch.correct_in(LFP_index,1:3001) = wf.(LFPlist{f}).RF.catch.correct_in;
            allwf.LFP.RF.catch.errors_in(LFP_index,1:3001) = wf.(LFPlist{f}).RF.catch.errors_in;
            
            allwf.LFP.RF.catch.correct_nosacc_resp(LFP_index,1:601) = wf.(LFPlist{f}).RF.catch.correct_nosacc_resp;
            allwf.LFP.RF.catch.correct_in_resp(LFP_index,1:601) = wf.(LFPlist{f}).RF.catch.correct_in_resp;
            allwf.LFP.RF.catch.errors_in_resp(LFP_index,1:601) = wf.(LFPlist{f}).RF.catch.errors_in_resp;
            %             alln.neuron.in_correct(neuron_cDex,1) = n.(neuronlist{f}).in;
            %             alln.neuron.out_correct(neuron_cDex,1) = n.(neuronlist{f}).out;
        catch
            allwf.LFP.RF.catch.correct_nosacc(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.catch.correct_in(LFP_index,1:3001) = NaN;
            allwf.LFP.RF.catch.errors_in(LFP_index,1:3001) = NaN;
            
            allwf.LFP.RF.catch.correct_nosacc_resp(LFP_index,1:601) = NaN;
            allwf.LFP.RF.catch.correct_in_resp(LFP_index,1:601) = NaN;
            allwf.LFP.RF.catch.errors_in_resp(LFP_index,1:601) = NaN;
        end
        
        try
            allwf.LFP.Hemi.catch.correct_nosacc(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.catch.correct_nosacc;
            allwf.LFP.Hemi.catch.correct_in(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.catch.correct_in;
            allwf.LFP.Hemi.catch.errors_in(LFP_index,1:3001) = wf.(LFPlist{f}).Hemi.catch.errors_in;
            %             alln.neuron.in_correct(neuron_cDex,1) = n.(neuronlist{f}).in;
            %             alln.neuron.out_correct(neuron_cDex,1) = n.(neuronlist{f}).out;
            
            allwf.LFP.Hemi.catch.correct_nosacc_resp(LFP_index,1:601) = wf.(LFPlist{f}).Hemi.catch.correct_nosacc_resp;
            allwf.LFP.Hemi.catch.correct_in_resp(LFP_index,1:601) = wf.(LFPlist{f}).Hemi.catch.correct_in_resp;
            allwf.LFP.Hemi.catch.errors_in_resp(LFP_index,1:601) = wf.(LFPlist{f}).Hemi.catch.errors_in_resp;
            
        catch
            allwf.LFP.Hemi.catch.correct_nosacc(LFP_index,1:3001) = NaN;
            allwf.LFP.Hemi.catch.correct_in(LFP_index,1:3001) = NaN;
            allwf.LFP.Hemi.catch.errors_in(LFP_index,1:3001) = NaN;
            
            allwf.LFP.Hemi.catch.correct_nosacc_resp(LFP_index,1:601) = NaN;
            allwf.LFP.Hemi.catch.correct_in_resp(LFP_index,1:601) = NaN;
            allwf.LFP.Hemi.catch.errors_in_resp(LFP_index,1:601) = NaN;
        end
        
        
        
        LFP_index = LFP_index + 1;
        
    end   %for LFPlist
    
    
    
    
    
    
    %OL
    
    %     alln.OL.errors.in(OL_index,1) = n.OL_errors.contra;
    %     alln.OL.errors.out(OL_index,1) = n.OL_errors.ipsi;
    %     alln.OL.c_c.in(OL_index,1) = n.OL.c_c.in;
    %     alln.OL.c_c.out(OL_index,1) = n.OL.c_c.out;
    %     alln.OL.e_c.in(OL_index,1) = n.OL.e_c.in;
    %     alln.OL.e_c.out(OL_index,1) = n.OL.e_c.out;
    %     alln.OL.c_e.in(OL_index,1) = n.OL.c_e.in;
    %     alln.OL.c_e.out(OL_index,1) = n.OL.c_e.out;
    %     alln.OL.e_e.in(OL_index,1) = n.OL.e_e.in;
    %     alln.OL.e_e.out(OL_index,1) = n.OL.e_e.out;
    %     alln.OL.catch.correct_nosacc(OL_index,1) = n.OL.catch.correct_nosacc;
    %     alln.OL.catch.correct_in(OL_index,1) = n.OL.catch.correct_in;
    %     alln.OL.catch.errors_in(OL_index,1) = n.OL.catch.errors_in;
    
    
    %keep track of unit and session names
    info.OL{OL_index,1} = [batch_list(i).name '_OL'];
    
    
    allROC.OL.c_c(OL_index,1:601) = ROC.OL.c_c;
    allROC.OL.e_c(OL_index,1:601) = ROC.OL.e_c;
    allROC.OL.c_e(OL_index,1:601) = ROC.OL.c_e;
    allROC.OL.e_e(OL_index,1:601) = ROC.OL.e_e;
    
    if length(ROC.OL.correct) == 3001
        ROC.OL.correct = ROC.OL.correct(400:1000);
        ROC.OL.errors = ROC.OL.errors(400:1000);
    end
    
    allROC.OL.correct(OL_index,1:601) = ROC.OL.correct;
    allROC.OL.errors(OL_index,1:601) = ROC.OL.errors;
    
    allROC_sub.OL.c_c(OL_index,1:601) = ROC_sub.OL.c_c;
    allROC_sub.OL.e_c(OL_index,1:601) = ROC_sub.OL.e_c;
    allROC_sub.OL.c_e(OL_index,1:601) = ROC_sub.OL.c_e;
    allROC_sub.OL.e_e(OL_index,1:601) = ROC_sub.OL.e_e;
    
    if length(ROC_sub.OL.correct) == 3001
        ROC_sub.OL.correct = ROC_sub.OL.correct(400:1000);
        ROC_sub.OL.errors = ROC_sub.OL.errors(400:1000);
    end
        
    allROC_sub.OL.correct(OL_index,1:601) = ROC_sub.OL.correct;
    allROC_sub.OL.errors(OL_index,1:601) = ROC_sub.OL.errors;
    
    try
        allRTs.OL.correct(OL_index,1) = nanmean(RTs.correct);
        allRTs.OL.errors(OL_index,1) = nanmean(RTs.errors);
        allRTs.OL.c_c(OL_index,1) = RTs.c_c;
        allRTs.OL.e_c(OL_index,1) = RTs.e_c;
        allRTs.OL.c_e(OL_index,1) = RTs.c_e;
        allRTs.OL.e_e(OL_index,1) = RTs.e_e;
    catch
        allRTs.OL.correct(OL_index,1) = NaN;
        allRTs.OL.errors(OL_index,1) = NaN;
        allRTs.OL.c_c(OL_index,1) = NaN;
        allRTs.OL.e_c(OL_index,1) = NaN;
        allRTs.OL.c_e(OL_index,1) = NaN;
        allRTs.OL.e_e(OL_index,1) = NaN;
    end
    
    try
        allRTs.OL.catch_correct_in(OL_index,1) = RTs.catch.correct_in;
        allRTs.OL.catch_errors(OL_index,1) = RTs.catch.errors;
    catch
        allRTs.OL.catch_correct_in(OL_index,1) = NaN;
        allRTs.OL.catch_errors(OL_index,1) = NaN;
    end
    
    allwf.OL.in_correct(OL_index,1:3001) = nanmean(wf.OL.correct.contra);
    allwf.OL.out_correct(OL_index,1:3001) = nanmean(wf.OL.correct.ipsi);
    allwf.OL.in_errors(OL_index,1:3001) = wf.OL.errors.contra;
    allwf.OL.out_errors(OL_index,1:3001) = wf.OL.errors.ipsi;
    
    allwf.OL.in_c_c(OL_index,1:3001) = wf.OL.correct.in_c_c;
    allwf.OL.out_c_c(OL_index,1:3001) = wf.OL.correct.out_c_c;
    allwf.OL.in_e_c(OL_index,1:3001) = wf.OL.correct.in_e_c;
    allwf.OL.out_e_c(OL_index,1:3001) = wf.OL.correct.out_e_c;
    allwf.OL.in_c_e(OL_index,1:3001) = wf.OL.correct.in_c_e;
    allwf.OL.out_c_e(OL_index,1:3001) = wf.OL.correct.out_c_e;
    allwf.OL.in_e_e(OL_index,1:3001) = wf.OL.correct.in_e_e;
    allwf.OL.out_e_e(OL_index,1:3001) = wf.OL.correct.out_e_e;
    
    allTDT.OL.correct_nosub(OL_index,1) = TDT.OL.correct_nosub;
    allTDT.OL.correct(OL_index,1) = nanmean(TDT.OL.correct);
    allTDT.OL.errors(OL_index,1) = TDT.OL.errors;
    allTDT.OL.correct_c_c(OL_index,1) = TDT.OL.correct_c_c;
    allTDT.OL.correct_c_e(OL_index,1) = TDT.OL.correct_c_e;
    allTDT.OL.correct_e_c(OL_index,1) = TDT.OL.correct_e_c;
    allTDT.OL.correct_e_e(OL_index,1) = TDT.OL.correct_e_e;
    
    try
        allwf.OL.catch.correct_nosacc(OL_index,1:3001) = wf.OL.catch.correct_nosacc;
        allwf.OL.catch.correct_in(OL_index,1:3001) = wf.OL.catch.correct_in;
        allwf.OL.catch.errors_in(OL_index,1:3001) = wf.OL.catch.errors_in;
        
        allwf.OL.catch.correct_nosacc_resp(OL_index,1:601) = wf.OL.catch.correct_nosacc_resp;
        allwf.OL.catch.correct_in_resp(OL_index,1:601) = wf.OL.catch.correct_in_resp;
        allwf.OL.catch.errors_in_resp(OL_index,1:601) = wf.OL.catch.errors_in_resp;
        %             alln.neuron.in_correct(neuron_cDex,1) = n.(neuronlist{f}).in;
        %             alln.neuron.out_correct(neuron_cDex,1) = n.(neuronlist{f}).out;
    catch
        allwf.OL.catch.correct_nosacc(OL_index,1:3001) = NaN;
        allwf.OL.catch.correct_in(OL_index,1:3001) = NaN;
        allwf.OL.catch.errors_in(OL_index,1:3001) = NaN;
        
        
        allwf.OL.catch.correct_nosacc_resp(OL_index,1:601) = NaN;
        allwf.OL.catch.correct_in_resp(OL_index,1:601) = NaN;
        allwf.OL.catch.errors_in_resp(OL_index,1:601) = NaN;
    end
    
    
    
    OL_index = OL_index + 1;
    
    
    
    %OR
    
    %     alln.OR.errors.in(OR_index,1) = n.OR_errors.contra;
    %     alln.OR.errors.out(OR_index,1) = n.OR_errors.ipsi;
    %     alln.OR.c_c.in(OR_index,1) = n.OR.c_c.in;
    %     alln.OR.c_c.out(OR_index,1) = n.OR.c_c.out;
    %     alln.OR.e_c.in(OR_index,1) = n.OR.e_c.in;
    %     alln.OR.e_c.out(OR_index,1) = n.OR.e_c.out;
    %     alln.OR.c_e.in(OR_index,1) = n.OR.c_e.in;
    %     alln.OR.c_e.out(OR_index,1) = n.OR.c_e.out;
    %     alln.OR.e_e.in(OR_index,1) = n.OR.e_e.in;
    %     alln.OR.e_e.out(OR_index,1) = n.OR.e_e.out;
    %     alln.OR.catch.correct_nosacc(OR_index,1) = n.OR.catch.correct_nosacc;
    %     alln.OR.catch.correct_in(OR_index,1) = n.OR.catch.correct_in;
    %     alln.OR.catch.errors_in(OR_index,1) = n.OR.catch.errors_in;
    
    
    %keep track of unit and session names
    info.OR{OR_index,1} = [batch_list(i).name '_OR'];
    
    allROC.OR.c_c(OR_index,1:601) = ROC.OR.c_c;
    allROC.OR.e_c(OR_index,1:601) = ROC.OR.e_c;
    allROC.OR.c_e(OR_index,1:601) = ROC.OR.c_e;
    allROC.OR.e_e(OR_index,1:601) = ROC.OR.e_e;
    
    if length(ROC.OR.correct) == 3001
        ROC.OR.correct = ROC.OR.correct(400:1000);
        ROC.OR.errors = ROC.OR.errors(400:1000);
    end
        
    allROC.OR.correct(OR_index,1:601) = ROC.OR.correct;
    allROC.OR.errors(OR_index,1:601) = ROC.OR.errors;
    
    allROC_sub.OR.c_c(OR_index,1:601) = ROC_sub.OR.c_c;
    allROC_sub.OR.e_c(OR_index,1:601) = ROC_sub.OR.e_c;
    allROC_sub.OR.c_e(OR_index,1:601) = ROC_sub.OR.c_e;
    allROC_sub.OR.e_e(OR_index,1:601) = ROC_sub.OR.e_e;
    
    if length(ROC_sub.OR.correct) == 3001
        ROC_sub.OR.correct = ROC_sub.OR.correct(400:1000);
        ROC_sub.OR.errors = ROC_sub.OR.errors(400:1000);
    end
    
    allROC_sub.OR.correct(OR_index,1:601) = ROC_sub.OR.correct;
    allROC_sub.OR.errors(OR_index,1:601) = ROC_sub.OR.errors;
    
    try
        allRTs.OR.correct(OR_index,1) = nanmean(RTs.correct);
        allRTs.OR.errors(OR_index,1) = nanmean(RTs.errors);
        allRTs.OR.c_c(OR_index,1) = RTs.c_c;
        allRTs.OR.e_c(OR_index,1) = RTs.e_c;
        allRTs.OR.c_e(OR_index,1) = RTs.c_e;
        allRTs.OR.e_e(OR_index,1) = RTs.e_e;
    catch
        allRTs.OR.correct(OR_index,1) = NaN;
        allRTs.OR.errors(OR_index,1) = NaN;
        allRTs.OR.c_c(OR_index,1) = NaN;
        allRTs.OR.e_c(OR_index,1) = NaN;
        allRTs.OR.c_e(OR_index,1) = NaN;
        allRTs.OR.e_e(OR_index,1) = NaN;
    end
    
    try
        allRTs.OR.catch_correct_in(OR_index,1) = RTs.catch.correct_in;
        allRTs.OR.catch_errors(OR_index,1) = RTs.catch.errors;
    catch
        allRTs.OR.catch_correct_in(OR_index,1) = NaN;
        allRTs.OR.catch_errors(OR_index,1) = NaN;
    end
    
    allwf.OR.in_correct(OR_index,1:3001) = nanmean(wf.OR.correct.contra);
    allwf.OR.out_correct(OR_index,1:3001) = nanmean(wf.OR.correct.ipsi);
    allwf.OR.in_errors(OR_index,1:3001) = wf.OR.errors.contra;
    allwf.OR.out_errors(OR_index,1:3001) = wf.OR.errors.ipsi;
    
    allwf.OR.in_c_c(OR_index,1:3001) = wf.OR.correct.in_c_c;
    allwf.OR.out_c_c(OR_index,1:3001) = wf.OR.correct.out_c_c;
    allwf.OR.in_e_c(OR_index,1:3001) = wf.OR.correct.in_e_c;
    allwf.OR.out_e_c(OR_index,1:3001) = wf.OR.correct.out_e_c;
    allwf.OR.in_c_e(OR_index,1:3001) = wf.OR.correct.in_c_e;
    allwf.OR.out_c_e(OR_index,1:3001) = wf.OR.correct.out_c_e;
    allwf.OR.in_e_e(OR_index,1:3001) = wf.OR.correct.in_e_e;
    allwf.OR.out_e_e(OR_index,1:3001) = wf.OR.correct.out_e_e;
    
    allTDT.OR.correct_nosub(OR_index,1) = TDT.OR.correct_nosub;
    allTDT.OR.correct(OR_index,1) = nanmean(TDT.OR.correct);
    allTDT.OR.errors(OR_index,1) = TDT.OR.errors;
    allTDT.OR.correct_c_c(OR_index,1) = TDT.OR.correct_c_c;
    allTDT.OR.correct_c_e(OR_index,1) = TDT.OR.correct_c_e;
    allTDT.OR.correct_e_c(OR_index,1) = TDT.OR.correct_e_c;
    allTDT.OR.correct_e_e(OR_index,1) = TDT.OR.correct_e_e;
    
    try
        allwf.OR.catch.correct_nosacc(OR_index,1:3001) = wf.OR.catch.correct_nosacc;
        allwf.OR.catch.correct_in(OR_index,1:3001) = wf.OR.catch.correct_in;
        allwf.OR.catch.errors_in(OR_index,1:3001) = wf.OR.catch.errors_in;
        %             alln.neuron.in_correct(neuron_cDex,1) = n.(neuronlist{f}).in;
        %             alln.neuron.out_correct(neuron_cDex,1) = n.(neuronlist{f}).out;
        
        allwf.OR.catch.correct_nosacc_resp(OR_index,1:601) = wf.OR.catch.correct_nosacc_resp;
        allwf.OR.catch.correct_in_resp(OR_index,1:601) = wf.OR.catch.correct_in_resp;
        allwf.OR.catch.errors_in_resp(OR_index,1:601) = wf.OR.catch.errors_in_resp;
    catch
        allwf.OR.catch.correct_nosacc(OR_index,1:3001) = NaN;
        allwf.OR.catch.correct_in(OR_index,1:3001) = NaN;
        allwf.OR.catch.errors_in(OR_index,1:3001) = NaN;
        
        allwf.OR.catch.correct_nosacc_resp(OR_index,1:601) = NaN;
        allwf.OR.catch.correct_in_resp(OR_index,1:601) = NaN;
        allwf.OR.catch.errors_in_resp(OR_index,1:601) = NaN;
    end
    
    
    
    OR_index = OR_index + 1;
    
    
    keep alln info allROC allROC_sub allRTs allwf allTDT neuron_index LFP_index OR_index OL_index batch_list i
    
end
clear *index i batch_list
