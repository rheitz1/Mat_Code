% %read in files and neurons
% f_path = 'C:\Documents and Settings\Schall Lab\My Documents\LFP\Data\Offdiagonal Average';
% %[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
% %[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
% [file_name] = textread('list.txt', '%s %s');
% 
% file = 1:size(file_name,1);
% 
% load JPSTC_matrix

function [t_vector,above_furthest,above_far,above_close,main,below_close,below_far,below_furthest,thickdiagonal] = OffDiagonalAverage_vampire2_saccade(JPSTC_matrix)

%=============================================================
% Set up time vector
% Measured relative to MAIN DIAGONAL, even when looking at regions
% far away from main.
t_vector = 41:291;

%=============================================================
% 1) Below Close

diagonalodd = [];

for k = 1:2:25;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((141 - (k-1)/2):(391 - (k-1)/2));
    diagonalodd = [diagonalodd, v];
end
oddright = mean(diagonalodd,2)';

diagonaleven = [];

for k = 2:2:24;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((141 - (k)/2):(391 - (k)/2));
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
    v = v((141 + (k-1)/2):(391 + (k-1)/2));
    diagonalodd = [diagonalodd, v];
end
oddleft = mean(diagonalodd,2)';

diagonaleven = [];
for k = -24:2:-2;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((141 + (k)/2):(391 + (k)/2));
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
    v = v((128 - (k-25)/2):(378 - (k-25)/2));
    diagonalodd = [diagonalodd, v];
end

oddright = mean(diagonalodd,2)';

diagonaleven = [];
for k = 26:2:50;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((128 - (k-26)/2):(378 - (k-26)/2));
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
    v = v(((128 + (k-25)/2) + 25):((378 + (k-25)/2)+ 25));
    diagonalodd = [diagonalodd, v];
end

oddleft = mean(diagonalodd,2)';


diagonaleven = [];
for k = -50:2:-26;
    v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
    v = v((128 + (k-26)/2 + 25):((378 + (k-26)/2) + 25));
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
v = v((114 - (k-51)/2):(364 - (k-51)/2));
diagonalodd = [diagonalodd, v];
end

oddright = mean(diagonalodd,2)';

diagonaleven = [];
for k = 52:2:74;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((114 - (k-52)/2):(364 - (k-52)/2));
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
v = v(((114 + (k-51)/2 + 52)):((364 + (k-51)/2)+ 52));
diagonalodd = [diagonalodd, v];
end

oddleft = mean(diagonalodd,2)';

diagonaleven = [];
for k = -74:2:-52;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v(((114 + (k-52)/2)+52):((364 + (k-52)/2 +52)));
diagonaleven = [diagonaleven, v];
end

evenleft = mean(diagonaleven,2)';

above_furthest = (oddleft + evenleft)/2;
clear oddleft evenleft
%================================================================



%================================================================
% Main diagonal

v = diag(JPSTC_matrix);
main = v(141:391);
%================================================================




%================================================================
% Thick Diagonal spanning above and below main (and main itself)

main = main';
thickdiagonal = (above_furthest + above_far + above_close + main + above_close + above_far + above_furthest)/7;

end





