function [ lowered ] = lowerRate ( higher )
%initialize tempEye matrices

lowered = zeros (size( higher ));

% initialize longest trial
longTrl = 0;
for trl = 1:size(higher,1)
    trldur = length (nonzeros(higher (trl,:)));
    steps =floor( trldur /4);
    residual = trldur - (steps*4);
    count =0;
    for timebin = 1:4:steps*4
        count = count+1;
        %  fill in current timebin with mean  value of the 4
        %RPH: Doesn't appear to be a mean value!
        lowered  (trl, count) =  higher ( trl,timebin )  ;
    end

%     if residual ~=0
%         count=count+1;
%         lowered (trl,count) = mean (higher(steps*4+1:steps*4+residual));
%     end

    % if the number of timebins on the current trial is larger than longTrl
    if count >longTrl
        % replace longTrl with count
        longTrl = count;
    end

end

lowered = lowered ( 1:size(lowered , 1) , 1:longTrl );

% lowered = downsample(higher',4);
% lowered = lowered(1:2500,1:end)';
% disp('hi')