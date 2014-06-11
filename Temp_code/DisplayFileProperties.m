%code to find and display various properties of files.

clear all
close all

q = ''''; c = ','; qcq = [q c q];

batch_list = dir('D:\Data\RawData\PlxDone\HeitzSort\*_MG');

counter = 1;
for i = 1:length(batch_list)
    %     disp('Press key to begin next file...')
    %     pause
    close all
    file_path = 'D:\Data\RawData\PlxDone\HeitzSort\';
    cd 'D:\Data\RawData\PlxDone\HeitzSort\'

    eval(['load(',q,file_path,batch_list(i).name,qcq,'-mat',q,')'])
    counter;
    batch_list(i).name;
    

   % eval('getCellnames')

   fname{counter} = batch_list(i).name;
   
if Target_(:,4) == 140
    Infos(counter,1) = 'H';
elseif Target_(:,4) == 91
    Infos(counter,1) = 'L';
end

if Target_(:,12) == 8
    Infos(counter,2) = '8';
elseif Target_(:,12) == 10
    Infos(counter,2) = '1';
elseif Target_(:,12) == 9
    Infos(counter,2) = '9';
else
    counter
    batch_list(i).name
    Target_(1,4)
    Target_(1,12)
    disp(' ')
    disp(' ')
end



% if Target_(1,12) ~= Target_(end,12)
%        batch_list(i).name
%        Target_(1,12)
%        Target_(end,12)
%    end
%      
   counter = counter + 1;

    keep batch_list file_path q c qcq counter fname Infos

end