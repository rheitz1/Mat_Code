% Daniel Shima 9/20/2007
% New script for port from Lab 030 OS9 Psychtoolbox-2 to Lab 023 OSX Psychtoolbox-3,
% used to generate stimulus presentation commands f1.m through f9.m,

clear all;
numeric_vector = '123456789';

for i = 1:length(numeric_vector)

    eval(['fid = fopen(''f' numeric_vector(i) '.m'',''w'');']);

    fprintf(fid,'%% Daniel Shima 9/20/2007\n');
    fprintf(fid,'%% For f%c.m port from Lab 030 OS9 Psychtoolbox-2 to Lab 023 OSX Psychtoolbox-3,\n',numeric_vector(i));
    fprintf(fid,'%% made cosmetic modifications,\n');
    fprintf(fid,'%% added DEBUG 2,\n');
    fprintf(fid,'%% make modifications in make_f_command_files.m and run, not in this file itself,\n');
    fprintf(fid,'\n');
    fprintf(fid,'function f%c\n',numeric_vector(i));
    fprintf(fid,'\n');
    fprintf(fid,'global CUR_WINDOW SrcWindow\n');
    fprintf(fid,'global DEBUG DOTS_CLUT\n');
    fprintf(fid,'\n');
    fprintf(fid,'if (DEBUG == 0 || DEBUG == 2)\n');
    fprintf(fid,'    Screen(''CopyWindow'',SrcWindow(%c),CUR_WINDOW);\n',numeric_vector(i));
    fprintf(fid,'end\n');

    st = fclose(fid);

end
