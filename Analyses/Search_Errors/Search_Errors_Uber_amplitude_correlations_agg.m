cd /volumes/Dump/Analyses/Errors/amplitude_correlations/Matrices/

file_list = dir('*.mat');


r.SPK_LFP.in_correct = [];
r.SPK_LFP.out_correct = [];
r.SPK_LFP.in_incorrect = [];
r.SPK_LFP.out_incorrect = [];

r.LFP_EEG.in_correct = [];
r.LFP_EEG.out_correct = [];
r.LFP_EEG.in_incorrect = [];
r.LFP_EEG.out_incorrect = [];

r.SPK_EEG.in_correct = [];
r.SPK_EEG.out_correct = [];
r.SPK_EEG.in_incorrect = [];
r.SPK_EEG.out_incorrect = [];

p_val.SPK_LFP.in_correct = [];
p_val.SPK_LFP.out_correct = [];
p_val.SPK_LFP.in_incorrect = [];
p_val.SPK_LFP.out_incorrect = [];

p_val.LFP_EEG.in_correct = [];
p_val.LFP_EEG.out_correct = [];
p_val.LFP_EEG.in_incorrect = [];
p_val.LFP_EEG.out_incorrect = [];

p_val.SPK_EEG.in_correct = [];
p_val.SPK_EEG.out_correct = [];
p_val.SPK_EEG.in_incorrect = [];
p_val.SPK_EEG.out_incorrect = [];

allinfo.SPK_LFP = [];
allinfo.SPK_EEG = [];
allinfo.LFP_EEG = [];


for file = 1:length(file_list)
    
    load(file_list(file).name)
    
    try
        r.SPK_LFP.in_correct = [r.SPK_LFP.in_correct ; cor.SPK_LFP.in_correct];
        p_val.SPK_LFP.in_correct = [p_val.SPK_LFP.in_correct ; p.SPK_LFP.in_correct];
        
        r.SPK_LFP.out_correct = [r.SPK_LFP.out_correct ; cor.SPK_LFP.out_correct];
        p_val.SPK_LFP.out_correct = [p_val.SPK_LFP.out_correct ; p.SPK_LFP.out_correct];
        
        r.SPK_LFP.in_incorrect = [r.SPK_LFP.in_incorrect ; cor.SPK_LFP.in_incorrect];
        p_val.SPK_LFP.in_incorrect = [p_val.SPK_LFP.in_incorrect ; p.SPK_LFP.in_incorrect];
        
        r.SPK_LFP.out_incorrect = [r.SPK_LFP.out_incorrect ; cor.SPK_LFP.out_incorrect];
        p_val.SPK_LFP.out_incorrect = [p_val.SPK_LFP.out_incorrect ; p.SPK_LFP.out_incorrect];
        
        allinfo.SPK_LFP = [allinfo.SPK_LFP ; info.SPK_LFP];
    end
    
    try
        r.LFP_EEG.in_correct = [r.LFP_EEG.in_correct ; cor.LFP_EEG.in_correct];
        p_val.LFP_EEG.in_correct = [p_val.LFP_EEG.in_correct ; p.LFP_EEG.in_correct];
        
        r.LFP_EEG.out_correct = [r.LFP_EEG.out_correct ; cor.LFP_EEG.out_correct];
        p_val.LFP_EEG.out_correct = [p_val.LFP_EEG.out_correct ; p.LFP_EEG.out_correct];
        
        r.LFP_EEG.in_incorrect = [r.LFP_EEG.in_incorrect ; cor.LFP_EEG.in_incorrect];
        p_val.LFP_EEG.in_incorrect = [p_val.LFP_EEG.in_incorrect ; p.LFP_EEG.in_incorrect];
        
        r.LFP_EEG.out_incorrect = [r.LFP_EEG.out_incorrect ; cor.LFP_EEG.out_incorrect];
        p_val.LFP_EEG.out_incorrect = [p_val.LFP_EEG.out_incorrect ; p.LFP_EEG.out_incorrect];
        
        allinfo.LFP_EEG = [allinfo.LFP_EEG ; info.LFP_EEG];
        
    end
    
    try
        r.SPK_EEG.in_correct = [r.SPK_EEG.in_correct ; cor.SPK_EEG.in_correct];
        p_val.SPK_EEG.in_correct = [p_val.SPK_EEG.in_correct ; p.SPK_EEG.in_correct];
        
        r.SPK_EEG.out_correct = [r.SPK_EEG.out_correct ; cor.SPK_EEG.out_correct];
        p_val.SPK_EEG.out_correct = [p_val.SPK_EEG.out_correct ; p.SPK_EEG.out_correct];
        
        r.SPK_EEG.in_incorrect = [r.SPK_EEG.in_incorrect ; cor.SPK_EEG.in_incorrect];
        p_val.SPK_EEG.in_incorrect = [p_val.SPK_EEG.in_incorrect ; p.SPK_EEG.in_incorrect];
        
        r.SPK_EEG.out_incorrect = [r.SPK_EEG.out_incorrect ; cor.SPK_EEG.out_incorrect];
        p_val.SPK_EEG.out_incorrect = [p_val.SPK_EEG.out_incorrect ; p.SPK_EEG.out_incorrect];
        
        allinfo.SPK_EEG = [allinfo.SPK_EEG ; info.SPK_EEG];
    end
    
    keep file_list file r p_val allinfo
end

clear file file_list