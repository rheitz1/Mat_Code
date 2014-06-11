function [] = getWaves(file_path, fileID, outfile)
%get waveforms for each cell & save to file

disp('Retrieving spike waveforms...')
load([file_path outfile],'-mat')

%clear a few variables that are always there to help
%deal with memory issues
clear EyeX_ EyeY_

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  get spike waveforms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getCellnames %find cell names in current file

%set unit IDs
unitIDs = ['a','b','c','d','e','f','g','h','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
q = '''';
fixedname = [fileID '.plx'];

for k = 1:length(CellNames)
    tempname = mat2str(cell2mat(CellNames(k)));
    unitID = tempname(end-1);
    unitID_index = find(unitID == unitIDs);
    chanID = tempname(end-3:end-2);
    %note: unitID shifted by 1 because first plexon unit is 0.
    fixedchan = eval(chanID);
    [n,npw,ts,wave] = plx_waves_v([file_path fixedname],fixedchan,unitID_index);
    eval(['waves_' cell2mat(CellNames(k)) '= wave;' ])
    clear n npw ts wave
    %save to file
    save([file_path,outfile],['waves_' CellNames{k}],'-append','-mat')
    %remove saved variable from memory
    clear(['waves_' cell2mat(CellNames(k))])
end