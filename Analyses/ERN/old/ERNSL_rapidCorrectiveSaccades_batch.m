%plots ERN by screen location
%Errors are when errant saccade made into screen location

[file_name] = textread('ERN_QS.txt', '%s');

%because there are more channels than there are sessions, we need an
%independent index to keep track of all correct and error ERPs across
%all possible LFPs
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
    load(cell2mat(file_name(sess)),'SaccDir_','EyeX_','EyeY_','Target_','SRT','Correct_','Errors_','RFs','Decide_','newfile','-mat')
    
    getBundle
    
    varlist = who;
    chanlist = varlist(strmatch('AD',varlist));
    clear varlist
    
    for chan = 1:length(chanlist)
        sig = eval(cell2mat(chanlist(chan)));
        
        ERNSL_rapidCorrectiveSaccades(sig,Bundle,1)
        [ax,h1] = suplabel(cell2mat(chanlist(chan)),'t');
        set(h1,'fontsize',14,'fontweight','bold')
        
        if printFlag == 1
            eval(['print -dpdf ',q,'/volumes/Dump/Analyses/ERN/RapidCorrective/',[cell2mat(file_name(sess)) '_' cell2mat(chanlist(chan))],'_ERN.pdf',q])
            f_
        end
    end
    keep file_name q plotFlag printFlag findOnset sess
end
