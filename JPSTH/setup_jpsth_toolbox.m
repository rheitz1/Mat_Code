% SETUP_JPSTH_TOOLBOX adds JPSTH Toolbox directory to your MATLAB path and compiles MEX files if necessary

% setup_jpsth_toolbox.m
% 
% Copyright 2008 Vanderbilt University.  All rights reserved.
% John Haitas, Jeremiah Cohen, and Jeff Schall
% 
% This file is part of JPSTH Toolbox.
% 
% JPSTH Toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% JPSTH Toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with JPSTH Toolbox.  If not, see <http://www.gnu.org/licenses/>.

function setup_jpsth_toolbox()
	
	local_install = 0;
	
	source_dir = pwd;
	targetdirectory =  fullfile(matlabroot, 'toolbox');
	jpsth_toolbox_dir = fullfile(targetdirectory, 'jpsth');
	
	% unload the MEX functions otherwise install fails on Windows
	clear('equation3')
	clear('covariogram_brody')
	
	% Check OS
	isWin=strcmp(computer,'PCWIN') | strcmp(computer,'PCWIN64');
	isOSX=strcmp(computer,'MAC') | strcmp(computer,'MACI');
	isLinux=strcmp(computer,'GLNX86');
	
	% Does SAVEPATH work?
	if exist('savepath')
	   err=savepath;
	else
	   err=path2rc;
	end

	if err
	    p=fullfile(matlabroot,'toolbox','local','pathdef.m');
	    fprintf(['Sorry, SAVEPATH failed. Probably the pathdef.m file lacks write permission. \n'...
	        'Please ask a user with administrator privileges to enable \n'...
	        'write by everyone for the file:\n''%s''\n'],p);
	    fprintf(['Once "savepath" works (no error message), run ' mfilename ' again.\n']);
	    fprintf('Alternatively you can choose to continue with installation, but then you will have\n');
	    fprintf('to resolve this permission isssue later and add the path to the JPSTH Toolbox manually.\n');
	    answer=input('Do you want to continue the installation despite the failure of SAVEPATH (yes or no)? ','s');
	    if ~strcmp(answer,'yes')
	        error('SAVEPATH failed. Please get an administrator to allow everyone to write pathdef.m.');
	    end
	end

	% Do we have sufficient privileges to install at the requested location?
	p='JPSTHtoolbox123test';
	[success,m,mm]=mkdir(targetdirectory,p);
	if success
	    rmdir(fullfile(targetdirectory,p));
	else
	    if strcmp(m,'Permission denied')
	        if isOSX
	            fprintf([
	            'Sorry. You would need administrator privileges to install the \n'...
	            'JPSTH Toolbox into the ''%s'' folder. You can either quit now \n'...
	            '(say "no", below) and get a user with administrator privileges to run \n'...
	            'setup_jpsth_toolbox for you, or you can install now into the \n'...
	            '/Users/Shared/ folder, which doesn''t require special privileges. We \n'...
	            'recommend installing into the /Applications/ folder, because it''s the \n'...
	            'normal place to store programs. \n\n'],targetdirectory);
	            answer=input('Even so, do you want to install the JPSTH Toolbox into the \n/Users/Shared/ folder (yes or no)? ','s');
	            if ~strcmp(answer,'yes')
	                fprintf('You didn''t say yes, so I cannot proceed.\n');
	                error('Need administrator privileges for requested installation into folder: %s.',targetdirectory);
	            end
	            targetdirectory='/Users/Shared';
	        else
	            % Windows: We simply fail in this case:
	            fprintf([
	            'Sorry. You would need administrator privileges to install the \n'...
	            'JPSTH Toolbox into the ''%s'' folder. Please rerun the script, choosing \n'...
	            'a location where you have write permission, or ask a user with administrator \n'...
	            'privileges to run setup_jpsth_toolbox for you.\n\n'],targetdirectory);
	            error('Need administrator privileges for requested installation into folder: %s.',targetdirectory);
	        end
	    else
	        error(mm,m);
	    end
	end
	fprintf('Good. Your privileges suffice for the requested installation into folder %s.\n\n',targetdirectory);

	% Delete old JPSTH Toolbox
	skipdelete = 0;
	while (exist(fullfile(targetdirectory,'jpsth'),'dir')) && (skipdelete == 0)
	    fprintf('Hmm. You already have an old JPSTH Toolbox folder:\n');
	    p=fullfile(targetdirectory,'jpsth');
	    if ~exist(p,'dir')
	        p=fileparts(which(fullfile('jpsth',['equation3.' mexext])));
	        if length(p)==0
	            w=what('jpsth');
	            p=w(1).path;
	        end
	    end
	    fprintf('%s\n',p);
	    fprintf('That old JPSTH Toolbox should be removed before we install a new one.\n');
	    if ~exist(fullfile(p,['equation3.' mexext]))
	        fprintf(['WARNING: Your old JPSTH Toolbox folder lacks a equation3.' mexext 'file. \n'...
	            'Maybe it contains stuff you want to keep. Here''s a DIR:\n']);
	        dir(p)
	    end

	    fprintf('First we remove all references to "jpsth" from the MATLAB path.\n');
	    pp=genpath(p);
	    warning('off','MATLAB:rmpath:DirNotFound');
	    rmpath(pp);
	    warning('on','MATLAB:rmpath:DirNotFound');

	    if exist('savepath')
	       savepath;
	    else
	       path2rc;
	    end

	    fprintf('Success.\n');

	    s=input('Shall I delete the old JPSTH Toolbox folder and all its contents \n(recommended in most cases), (yes or no)? ','s');
	    if strcmp(s,'yes')
	        skipdelete = 0;
	        fprintf('Now we delete "jpsth" itself.\n');
	        [success,m,mm]=rmdir(p,'s');
	        if success
	            fprintf('Success.\n\n');
	        else
	            fprintf('Error in RMDIR: %s\n',m);
	            fprintf('If you want, you can delete the JPSTH Toolbox folder manually and rerun this script to recover.\n');
	            error(mm,m);
	        end
	    else
	        skipdelete = 1;
	    end
	end

	% Remove "jpsth" from path
	while any(regexp(path,[filesep 'jpsth[' filesep pathsep ']']))
	    fprintf('Your old JPSTH Toolbox appears in the MATLAB path:\n');
	    paths=regexp(path,['[^' pathsep ']*' pathsep],'match');
	    fprintf('Your old JPSTH Toolbox appears %d times in the MATLAB path.\n',length(paths));
	    answer=input('Before you decide to delete the paths, do you want to see them (yes or no)? ','s');
	    if ~strcmp(answer,'yes')
	        fprintf('You didn''t say "yes", so I''m taking it as no.\n');
	    else
	        for p=paths
	            s=char(p)
	            if any(regexp(s,[filesep 'jpsth[' filesep pathsep ']']))
	                fprintf('%s\n',s);
	            end
	        end
	    end
	    answer=input('Shall I delete all those instances from the MATLAB path (yes or no)? ','s');
	    if ~strcmp(answer,'yes')
	        fprintf('You didn''t say yes, so I cannot proceed.\n');
	        fprintf('Please use the MATLAB "File:Set Path" command to remove all instances of "jpsth" from the path.\n');
	        error('Please remove JPSTH Toolbox from MATLAB path.');
	    end
	    for p=paths
	        s=char(p);
	        if any(regexp(s,[filesep 'jpsth[' filesep pathsep ']']))
	            rmpath(s);
	        end
	    end
	    if exist('savepath')
	       savepath;
	    else
	       path2rc;
	    end

	    fprintf('Success.\n\n');
	end
	
	
    
    copyfile(source_dir, jpsth_toolbox_dir);
    delete(fullfile(jpsth_toolbox_dir,'setup_jpsth_toolbox.m'));
	
	% could be traces of version control
	svn_dir = fullfile(jpsth_toolbox_dir,'.svn');
	if exist(svn_dir)==7
		rmdir(svn_dir,'s');
		disp('Removed traces of version control');
	end
	

	% compile mex if necessary
	if exist('equation3')~=3
		cd(jpsth_toolbox_dir);
		mex('equation3.c');
		mex('covariogram_brody.c');
		disp('MEX files successfully compiled');
		cd(source_dir);
	else
		disp('MEX files already compiled');
	end
	
	% Add JPSTH Toolbox to MATLAB path
	fprintf('Now adding the new JPSTH Toolbox folder (and all its subfolders) to your MATLAB path.\n');
	p=jpsth_toolbox_dir;
	pp=genpath(p);
	addpath(pp);

	if exist('savepath')
	   err=savepath;
	else
	   err=path2rc;
	end

	if err
	    fprintf('SAVEPATH failed. JPSTH Toolbox is now already installed and configured for use on your Computer,\n');
	    fprintf('but i could not save the updated Matlab path, probably due to insufficient permissions.\n');
	    fprintf('You will either need to fix this manually via use of the path-browser (Menu: File -> Set Path),\n');
	    fprintf('or by manual invocation of the savepath command (See help savepath). The third option is, of course,\n');
	    fprintf('to add the path to the JPSTH Toolbox folder and all of its subfolders whenever you restart Matlab.\n\n\n');
	else 
	    fprintf('Success.\n\n');
	end
	
	% add jpsth toolbox to path
	path(genpath(jpsth_toolbox_dir),path);
	savepath;
	disp('added JPSTH Toolbox to top of path');

	
	% MATLAB doesn't see MEX functions until we rehash toolbox
	rehash toolbox
	
	fprintf('\nJPSTH Toolbox installed\n');
end

function file_ops(source_dir,jpsth_toolbox_dir)
        if exist(jpsth_toolbox_dir)==7
                disp('Found previous JPSTH Toolbox')
                rmpath(genpath(jpsth_toolbox_dir));
                rmdir(jpsth_toolbox_dir,'s');
                disp('Removed previous JPSTH Toolbox');
        end
        
        copyfile(source_dir, jpsth_toolbox_dir);
        delete(fullfile(jpsth_toolbox_dir,'setup_jpsth_toolbox.m'));
end