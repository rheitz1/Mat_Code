%check to see if java is enabled and if so, whether we can use parallel processing.
%
%RPH

% OLD VERSION: Matlabpool
% if usejava('desktop')
%     if matlabpool('size') > 1
%         useParallel = 1;
%     else
%         useParallel = 0;
%     end
% else
%     useParallel = 0;
% end

% NEW VERSION: Parpool
POOL = gcp('nocreate'); % If no pool, do not create new one.
if isempty(POOL)
    poolsize = 0;
    useParallel = 0;
else
    poolsize = POOL.NumWorkers;
    useParallel = 1;
end

clear POOL poolsize