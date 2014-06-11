% Finds the minimum of any set of vectors or set of matrices
% RPH

function minval = findMin(varargin)

for var = 1:length(varargin)
    if ~isvector(varargin{var})
        temp1 = min(varargin{var});
        
        minvar(var) = min(temp1);
    elseif isvector(varargin{var})
        minvar(var) = min(varargin{var});
    end
end

minval = min(minvar);