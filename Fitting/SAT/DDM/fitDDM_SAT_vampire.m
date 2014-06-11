function [] = fitDDM_SAT_vampire(filename,model)

if ischar(model); model = str2num(model); end

%cd //scratch/heitzrp/ALLDATA/

plotFlag = 1;

load(filename,'Correct_','Target_','SRT','SAT_','Errors_')
filename


[sol fitSt] = fitDDM_SAT(model,plotFlag);
freeParams = find(model) > 1;

str = ['.'];
if ismember(freeParams,1); str = 'fix_a_'; end
if ismember(freeParams,2); str = [str 'fix_Ter_']; end
if ismember(freeParams,3); str = [str 'fix_eta_']; end
if ismember(freeParams,4); str = [str 'fix_z_']; end
if ismember(freeParams,5); str = [str 'fix_sZ_']; end
if ismember(freeParams,6); str = [str 'fix_st_']; end
if ismember(freeParams,7); str = [str 'fix_v_']; end
if length(freeParams) == 7; str = '.ALL_FREE'; end
if isempty(freeParams) str = '.ALL_FIXED'; end

eval(['solution' str ' = sol;'])
eval(['fitStat' str ' = fitSt;'])

save(['//scratch/heitzrp/Output/DDM/Solutions/' filename '_' str '.mat'],'solution','fitStat','-mat')

eval(['print -dpdf //scratch/heitzrp/Output/DDM/Plots/' filename '_' str(2:end) '.pdf'])

print -dpdf 

end

