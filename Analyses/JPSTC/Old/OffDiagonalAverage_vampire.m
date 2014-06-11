% %read in files and neurons
% f_path = 'C:\Documents and Settings\Schall Lab\My Documents\LFP\Data\Offdiagonal Average';
% %[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
% %[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
% [file_name] = textread('list.txt', '%s %s');
% 
% file = 1:size(file_name,1);
% 
% load JPSTC_matrix

function [t_above_furthest,t_above_far,t_above_close,t_main,t_below_close,t_below_far,t_below_furthest,above_furthest,above_far,above_close,main,below_close,below_far,below_furthest,thickdiagonal] = OffDiagonalAverage_vampire(JPSTC_matrix)

%=============================================================
% Set up time vectors to plot by
%1) Below main, close (bottom-right relative to main)

%note we are calculating this off the 'odd' diagonals, and note that
%diagonals are 'flipped' relative to surface plot
%a)91 = time point of first diagonal closest to main
%b)find width of band we are averaging by, take middle value and round up
%c)add b to starting value so that we are always indexing to time point
%consistent with main diagonal
%d) subtract 50 to account for baseline time
%follow similar logic for ending point
% t_start = 91 - ceil(median(linspace(1,length(1:2:25),length(1:2:25)))) - 50;
% t_end = 341 - ceil(median(linspace(1,length(1:2:25),length(1:2:25)))) - 50;
% t_below_close = t_start:t_end;
t_below_close = 34:284;

%2) Above main, close
% t_start = 91 + ceil(median(linspace(1,length(1:2:25),length(1:2:25)))) - 50;
% t_end = 341 + ceil(median(linspace(1,length(1:2:25),length(1:2:25)))) - 50;
% t_above_close = t_start:t_end;
t_above_close = 48:298;

%3) below main, far
t_below_far = 124:374;

%4) above main, far
t_above_far = 22:272;

%5) main diagonal and wide diagonal
t_main = 41:291;

%6) above far + close (large window)
t_above_furthest = 9:259;

%7) below far + close (large window)
t_below_furthest = 74:324;

%=============================================================
% 1) Below Close

diagonalodd = [];

for k = 1:2:25;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((91 - (k-1)/2):(341 - (k-1)/2));
    diagonalodd = [diagonalodd, v];
end
oddright = mean(diagonalodd,2)';

diagonaleven = [];

for k = 2:2:24;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((91 - (k)/2):(341 - (k)/2));
    diagonaleven = [diagonaleven, v];
end
evenright = mean(diagonaleven,2)';

below_close = (oddright + evenright)/2;
clear oddright evenright
%================================================================



%================================================================
% 2) Above Close (down-right relative to main)

diagonalodd = [];
for k = -25:2:-1;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((91 + (k-1)/2):(341 + (k-1)/2));
    diagonalodd = [diagonalodd, v];
end
oddleft = mean(diagonalodd,2)';

diagonaleven = [];
for k = -24:2:-2;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((91 + (k)/2):(341 + (k)/2));
    diagonaleven = [diagonaleven, v];
end
evenleft = mean(diagonaleven,2)';


above_close = (oddleft + evenleft)/2;
clear oddleft evenleft
%================================================================



%================================================================
% 3) Below Far

diagonalodd = [];
for k = 25:2:49;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((78 - (k-25)/2):(328 - (k-25)/2));
    diagonalodd = [diagonalodd, v];
end

oddright = mean(diagonalodd,2)';

diagonaleven = [];
for k = 26:2:50;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((78 - (k-26)/2):(328 - (k-26)/2));
    diagonaleven = [diagonaleven, v];
end

evenright = mean(diagonaleven,2)';

below_far = (oddright + evenright)/2;
clear oddright evenright

%==================================================================



%==================================================================
%Above Far

diagonalodd = [];
for k = -49:2:-25;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v(((78 + (k-25)/2) + 25):((328 + (k-25)/2)+ 25));
    diagonalodd = [diagonalodd, v];
end

oddleft = mean(diagonalodd,2)';


diagonaleven = [];
for k = -50:2:-26;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((78 + (k-26)/2 + 25):((328 + (k-26)/2) + 25));
    diagonaleven = [diagonaleven, v];
end

evenleft = mean(diagonaleven,2)';

above_far = (oddleft + evenleft)/2;
clear oddleft evenleft
%================================================================


%================================================================
% Below Furthest

diagonalodd = [];
for k = 51:2:75;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((64 - (k-51)/2):(314 - (k-51)/2));
diagonalodd = [diagonalodd, v];
end

oddright = mean(diagonalodd,2)';

diagonaleven = [];
for k = 52:2:74;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((64 - (k-52)/2):(314 - (k-52)/2));
diagonaleven = [diagonaleven, v];
end

evenright = mean(diagonaleven,2)';

below_furthest = (oddright + evenright)/2;
clear oddright evenright
%================================================================



%================================================================
% Above Furthest

diagonalodd = [];
for k = -75:2:-51;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v(((64 + (k-51)/2 + 52)):((314 + (k-51)/2)+ 52));
diagonalodd = [diagonalodd, v];
end

oddleft = mean(diagonalodd,2)';

diagonaleven = [];
for k = -74:2:-52;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v(((64 + (k-52)/2)+52):((314 + (k-52)/2 +52)));
diagonaleven = [diagonaleven, v];
end

evenleft = mean(diagonaleven,2)';

above_furthest = (oddleft + evenleft)/2;
clear oddleft evenleft
%================================================================



%================================================================
% Main diagonal

v = diag(JPSTC_matrix);
main = v(91:341);
%================================================================




%================================================================
% Thick Diagonal spanning above and below main (and main itself)

main = main';
thickdiagonal = (above_furthest + above_far + above_close + main + above_close + above_far + above_furthest)/7;

end





