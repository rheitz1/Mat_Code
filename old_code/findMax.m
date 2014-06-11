% finds the maximum value of any set of vectors or set of matrices
% RPH

function maxval = findMax(varargin)

for var = 1:length(varargin)
    if ~isvector(varargin{var})
        temp1 = max(varargin{var});
        
        maxvar(var) = max(temp1);
    elseif isvector(varargin{var})
        maxvar(var) = max(varargin{var});
    end
end
    
maxval = max(maxvar);