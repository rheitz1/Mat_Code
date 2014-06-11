% quick script to save saccLoc and SRT into current file
% will not work properly if you change the directory after loading file
% and prior to running this script
%
%RPH

[SRT saccLoc] = getSRT(EyeX_,EyeY_);
eval(['save(' '''' newfile '''' ',' '''' 'SRT' '''' ',' '''' 'saccLoc' '''' ',' '''' '-append' '''' ')'])