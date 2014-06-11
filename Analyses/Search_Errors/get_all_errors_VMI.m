%sub for various uses; iterates through all search files

cd /volumes/Dump/Search_Data/
  [file_name cell_name] = textread('S_errorcells.txt', '%s %s');

  q = '''';
  c = ',';
  qcq = [q c q];
  
 for file = 1:size(file_name,1)

     try
     eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'EyeX_' qcq 'EyeY_' qcq 'RFs' qcq 'MFs' qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
     disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
 
     Spike = eval(cell2mat(cell_name(file)));
     RF = RFs.(cell2mat(cell_name(file)));
     MF = RF; %because only using vis and vis-move, just use RF
     
     getBundle
     VMI(file,1) = getVMI(Spike,Bundle,RF,RF);
     
     catch
         disp('File not found...')
         VMI(file,1) = NaN;
     end
     
 end   