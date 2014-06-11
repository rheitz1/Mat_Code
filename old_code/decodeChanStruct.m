% Decodes ChanStruct (structure array carrying all requested AD
% channels) into independent variables after using 'loadChan'
%
% REQUIRES that variable holding channels is called:  ChanStruct
%
% RPH
ChanNames = fieldnames(ChanStruct);

for chan = 1:length(ChanNames)
    eval([ChanNames{chan} '= ChanStruct.' ChanNames{chan} ';']);
end

clear ChanNames chan ChanStruct