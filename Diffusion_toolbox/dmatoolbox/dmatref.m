function varargout = dmatref(num)
%DMATREF  Returns the proper references to the DMA Toolbox
%   DMATREF() prints the references to the DMA Toolbox and its accompanying
%   article to the screen.
%
%   REFS = DMATREF(), returns them in a cell array of two strings.
%
%   [REF1 REF2] = DMATREF(), returns them, each in their own string.
%
%   Author: Joachim Vandekerckhove (joachim.vandekerckhove@psy.kuleuven.be)
%   Part of the DMA Toolbox. Please read the End User License Agreement,
%   contained in 'dmateula.txt' or by invoking the DMATLICENSE command. 
%   See also http://ppw.kuleuven.be/okp/dmatoolbox.

%  Edit 0.4: Updated reference.

t{1} = ['Vandekerckhove, J. & Tuerlinckx, F. (2007). _Fitting ',...
    'the Ratcliff Diffusion Model to experimental data._ Manuscript ',...
    'submitted for publication.'];
t{2} = sprintf(['Vandekerckhove, J. & Tuerlinckx, F. (2007). _The ',...
    'Diffusion Model Analysis Toolbox [Computer software and manual]',...
    '._ Retrieved from %s.'],dmatsite);
t{3} = ['Vandekerckhove, J. & Tuerlinckx, F. (in press). Diffusion ',...
    'Model Analysis with MATLAB: a DMAT primer. _Behavior ',...
    'Research Methods._'];

if nargout==1
    if nargin
        varargout{1} = t{num};
    else
        varargout{1} = t;
    end
elseif nargout==2
    varargout{1} = t{1};
    varargout{2} = t{2};
elseif nargout==3
    varargout{1} = t{1};
    varargout{2} = t{2};
    varargout{3} = t{3};
else
    disp(' ')
    disp('When using DMAT, please cite:')
    disp(parsetoline(t{1}))
    disp(parsetoline(t{2}))
    disp(' ')
end