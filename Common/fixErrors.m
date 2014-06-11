% Fix Errors and create vectors of correct and erroneous trials. 
% Fix Errors is relevant for old Quincy data that did not have the
% 'Errors_' variable encoded.
%1) not a catch trial
%2) SRT is less than 2000 ms and greater than 50 ms

% RPH

if isempty(find(~isnan(Errors_(:,:))))
    %if the Errors_ variable exists but is full of NaN's (Quincy files run on old protocol)
    Errors_(find(Correct_(:,2) == 0),5) = 1;
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
else
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
end
