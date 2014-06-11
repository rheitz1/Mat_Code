function runIndices = findRuns(runVector,runLength,runValue)
%Returns the indices of 'runLength' consecutive numbers.
%Defaults to runlength == 10
%runValue = value we are trying to find runs of.  Defaults to 1

if nargin < 2
    runLength = 10;
    runValue = 1;
end

if nargin < 3
    runValue = 1;
end

%=========================================
% NEW METHOD
% Turned off because does not return ALL
% indices meeting criterion.  Only finds
% first instance(s) where pattern matrix
% matches the input matrix
%
%

% findVec = repmat(runValue,1,runLength);
% 
% %transpose if column
% if size(runVector,1) > 1
%     runVector = runVector';
% end
% 
% runIndices = strfind(runVector,findVec);


%==========================================
% OLD METHOD
%
block_index = 1;
start_ = 1;
runIndices = [];



while start_ < length(runVector)
    for trl = start_:length(runVector)
        if runVector(trl) == runValue
            start_index = trl;
            while (trl < length(runVector) & runVector(trl) == runValue && runVector(trl + 1) == runValue)
                trl = trl + 1;

                %make sure we do not run out of bounds
                if trl >= length(runVector)
                    break
                end
            end
            end_index = trl;

            
            start_ = end_index + 1;

            if length(start_index:end_index) >= runLength
                runIndices = [runIndices start_index:end_index];
                block_index = block_index + 1;
                break
            end
        end
    end
    %terminate while loop when we hit the end
    if trl == length(runVector)
        %return transpose
        runIndices = runIndices';
        return
    end
end
