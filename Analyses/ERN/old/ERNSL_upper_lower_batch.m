c_
[file_name] = textread('temp.txt', '%s');


indexAD = 0;

q = '''';
c = ',';
qcq = [q c q];

plotFlag = 1;
printFlag = 1;
findOnset = 0;



for sess = 1:size(file_name,1)
    file_name(sess)
    
    %Load LFPs only
    ChanStruct = loadChan(cell2mat(file_name(sess)),'AD');
    decodeChanStruct
    
    %Load supporting variables
    load(cell2mat(file_name(sess)),'EyeX_','EyeY_','Target_','SRT','SaccDir_','Correct_','Errors_','newfile','-mat')
    varlist = who;
    chanlist = varlist(strmatch('AD',varlist));
    clear varlist
    
    getBundle
    
    for chan = 1:length(chanlist)
        sig = eval(cell2mat(chanlist(chan)));
        
        ERNSL_upper_lower(sig,Bundle,1)
        
        
        if printFlag == 1
            eval(['print -dpdf ',q,'/volumes/Dump/Analyses/ERN/ERNScreenLoc/',[cell2mat(file_name(sess)) '_' cell2mat(chanlist(chan))],'_ERN.pdf',q])
            %eval(['print -dpdf
        end
    end
    f_
    keep file_name q c qcq plotFlag printFlag findOnset sess
end