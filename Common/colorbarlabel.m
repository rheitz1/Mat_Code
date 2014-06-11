function colorbarlabel(label, poslab, hcb)
% This function put a label on a color bar at the user given location
%
% The input arguments are:
% label = string label
% hcb = colorbar handle, if ommited a new colorbar is created
% poslab = E, W, N or S, axis where label will be localizated, default is E
% Where: E = east, W = west, N = north and S = south, 
%        E and W are on y axis and N and S are on x axis
%
% Examples: colorbarlabel('temperature', 'E', hcb),
%           colorbarlabel('temperature', 'E') or 
%           colorbarlabel('temperature')
%
% The above examples produce the same result.
%
% If poslab is not a valid case E will be used.
%
% EGR 200703
% CICESE LA PAZ
% egonzale@cicese.mx


if nargin == 1 || nargin == 2
    hcb = colorbar;
    if nargin == 1
        poslab = 'E';
    end
end

%Verify uppercase letter and correct wrong cases
poslab = upper(poslab);
if (strcmp(poslab, 'E') || strcmp(poslab, 'W') || ...
        strcmp(poslab, 'N') || strcmp(poslab, 'S') ) ~= 1
    disp('Wrong position, using the default East')
    poslab = 'E';
end

%Applay the label at the given position
switch poslab
    case 'E'
    set(hcb, 'YAxisLocation', 'Right')
    hcyl = get(hcb, 'Ylabel');%Children of hc
    set(hcyl, 'String', label)
    case 'W'
    set(hcb, 'YAxisLocation', 'Left')
    hcyl = get(hcb, 'Ylabel');%Children of hc
    set(hcyl, 'String', label)
    case 'S'
    set(hcb, 'XAxisLocation', 'Bottom')
    hcxl = get(hcb, 'Xlabel');
    set(hcxl, 'String', label)
    case 'N'
    set(hcb, 'XAxisLocation', 'Top')
    hcxl = get(hcb, 'Xlabel');
    set(hcxl, 'String', label)
end


