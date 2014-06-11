function F_1 = F_cubic_spline(el_pos,d,cond,cond_top,this_tol)
%function F = F_cubic_spline(el_pos,d,cond,cond_top,this_tol)
%
%Modified from general_spline_method_v3
%
%Creates the F matrix of the cubic spline method.
%
%el_pos:    the z-positions of the electrode contacts, default:
%100e-6:100e-6:2300e-6 
%d:         activity diameter, default: 500e-6
%cond:      cortical conductivity, default: 0.3
%cond_top:  conductivity on top of cortex, default: cond
%this_tol: tolerance of integral, default: 1e-6

%Copyright 2005 Klas H. Pettersen under the General Public License,
%
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or any later version.
%
%See: http://www.gnu.org/copyleft/gpl.html

if nargin<1; el_pos = 100e-6:100e-6:2300e-6;end;
if nargin<2; d = 500e-6; end;
if nargin<3; cond = 0.3; end;
if nargin<4; cond_top = cond; end;
if nargin<5; this_tol=1e-6; end;

% tfilename = make_filename(d,0,length(el_pos),el_pos(2)-el_pos(1),el_pos(1),cond,cond_top); %part of Fd filename
% full_filename = [matrix_folder() filesep 'Fcs' tfilename '.mat'];

F_1 = compute_F_cubic_spline(el_pos,d,cond,cond_top,this_tol);
return;



