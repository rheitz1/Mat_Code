function [RT_unsort,RT_sort,Sort_index,Sort_index_clean] = CalcSortRT(Target_time,Saccade_time)


%create unsorted RT variable and keep track of index #s
RT_unsort = Saccade_time - Target_time;
[RT_sort,Sort_index] = sort(RT_unsort);


%Find NaN's in unsorted file and set them to NaN in the index file
for i = 1:length(RT_unsort)
    if isnan(RT_unsort(i))
        for j = 1:length(Sort_index)
            if Sort_index(j)==i
                Sort_index(j) = NaN;
            end
        end
    end
end

%get rid of NaN's
Sort_index_clean = find(~isnan(Sort_index));

