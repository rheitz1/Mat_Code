%Fix Errors

if exist('Errors_') == 1
    if isempty(find(~isnan(Errors_(:,:))))
        Errors_(find(Correct_(:,2) == 0),5) = 1;

        
        %Edited 10/26/07 to include ALL trials, not just correct ones (b/c
        %visual response is before decision)
        CorrectTrials = find(Target_(:,2) ~= 255 & Target_(:,3) > 3);
    else
        CorrectTrials = find(Target_(:,2) ~= 255 & Target_(:,3) > 3);
    end
else
    Errors_(1:length(Correct_),1:6) = NaN;
    Errors_(find(Correct_(:,2) == 0),6) = 1;
    CorrectTrials = find(Target_(:,2) ~= 255 & Target_(:,3) > 3);
end