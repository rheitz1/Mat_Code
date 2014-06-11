function trials_to_delete = getEmpty(empty_trials,runLength)
%for use to find empty Spike trials.  Will eliminate when find 'runLength' (default
%== 10) empty trials in a row.

%more generally, given a matrix of 1's and 0's, will return the indices of
%'runLength' consecutive 1's.

block_index = 1;
start_ = 1;
trials_to_delete = [];

if nargin < 2
    runLength = 10;
end

while start_ < length(empty_trials)
    for trl = start_:length(empty_trials)
        if empty_trials(trl) == 1
            start_index = trl;
            while (trl < length(empty_trials) & empty_trials(trl) == 1 && empty_trials(trl + 1) == 1)
                trl = trl + 1;

                %make sure we do not run out of bounds if end of matrix has
                %no spikes.
                if trl >= length(empty_trials)
                    break
                end
            end
            end_index = trl;

            %set for loop start point to be the next trial after the block
            start_ = end_index + 1;

            %if find a run of at least 10 empty trials, remove
            if length(start_index:end_index) >= runLength
                %        trials_to_delete{block_index} = start_index:end_index;
                trials_to_delete = [trials_to_delete start_index:end_index];
                block_index = block_index + 1;
                break
            end
        end
    end
    %terminate while loop when we hit the end (value of start_ will always
    %have to be less than length(empty_trials)
    if trl == length(empty_trials)
        %return transpose
        trials_to_delete = trials_to_delete';
        return
    end
end
