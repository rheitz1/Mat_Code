function docf(varargin)
% DOCKF Dock or undock figures.
%   DOCKF           dock the current figure; same as DOCKF GCF
%   DOCKF ON H      dock figures with handles H. H can a vector.
%   DOCKF ON ALL    dock all the figures
%   DOCKF OFF H     undock figures with handles H
%   DOCKF OFF ALL   undock all figures
%   DOCKF(H)        same as DOCKF ON H
%
% Zhang Jiang
% $Revision: 1.0 $  $Date: 2006/10/11 $

if nargin == 0
    dockf(gcf);
    return;
end

h = [];
% --- if input is figure handles, dock all
if isnumeric(varargin{1})
    try
        for iV = 1:nargin, h = [h;varargin{iV}(:)]; end
        eval(['dockf ON ',num2str(h')]);
    catch
        error('Invalid input argument.');
    end
    return;
end

% --- if input is a single string and figure handles
if isstr(varargin{1}) & nargin > 1
    switch upper(varargin{2})           % get figure handles
        case 'ALL'
            h = findall(0,'type','figure');
        otherwise
            for iV = 2:nargin, temp = str2num(varargin{iV}); h = [h;temp(:)]; end
    end
    h = sort(h);
    switch upper(varargin{1})
        case 'ON'
            set(h,'WindowStyle','docked');
        case 'OFF'
            set(h,'WindowStyle','normal');
        otherwise
            error('Invalid input argument.');
    end
else 
    error('Invalid input argument.');
    return;
end

