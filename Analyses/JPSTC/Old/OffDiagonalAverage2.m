% %read in files and neurons
% f_path = 'C:\Documents and Settings\Schall Lab\My Documents\LFP\Data\Offdiagonal Average';
% %[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
% %[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
% [file_name] = textread('list.txt', '%s %s');
% 
% file = 1:size(file_name,1);
% 
% load JPSTC_matrix

function [smalltime,middletime,largetime,widetime,left3, left2, left1, main, right1, right2, right3, thickdiagonal] = OffDiagonalAverage2(JPSTC_matrix)
% figure

plotFlag = 1;
% orient landscape

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Small Window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plot Positive Diagonal %%%
%  Save Diagonal in Matrix
diagonalodd = [];
for k = 1:2:25;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((91 - (k-1)/2):(341 - (k-1)/2));
diagonalodd = [diagonalodd, v];
end

start = med(91-(k-1)/2);
oddright = mean(diagonalodd,2)';
% diagonalodd = rot90(diagonalodd);
% oddright = mean(diagonalodd);

diagonaleven = [];
for k = 2:2:24;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((91 - (k)/2):(341 - (k)/2));
diagonaleven = [diagonaleven, v];
end

% diagonaleven = rot90(diagonaleven);
% evenright1 = mean(diagonaleven);

evenright = mean(diagonaleven,2)';

right1 = (oddright + evenright)/2;



% Plot time vs. diagonal
if plotFlag == 1
smalltime = 100:350;
subplot(5,4,[5 20]); plot (smalltime, right1);
axis([91 368 -0.2 1])
hold all
title ('Off Diagonal Average');
xlabel ('Lag');
ylabel ('Coherence');
end

%%% Plot Negative Diagonal %%%


%  Save Diagonal in Matrix
diagonalodd = [];
for k = -25:2:-1;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((91 + (k-1)/2):(341 + (k-1)/2));
diagonalodd = [diagonalodd, v];
end

diagonalodd = mean(diagonalodd,2)';
% diagonalodd = rot90(diagonalodd);
% oddleft1 = mean(diagonalodd);


diagonaleven = [];
for k = -24:2:-2;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((91 + (k)/2):(341 + (k)/2));
diagonaleven = [diagonaleven, v];
end

diagonaleven = mean(diagonaleven,2)';
% diagonaleven = rot90(diagonaleven);
% evenleft1 = mean(diagonaleven);

left1 = (oddleft1 + evenleft1)/2;


% Plot time vs. diagonal

if plotFlag == 1
subplot(5,4,[5 20]); plot (smalltime, left1, 'r');
axis([91 368 -0.2 1])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Middle Window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plot Positive Diagonal %%%
%  Save Diagonal in Matrix
diagonalodd = [];
for k = 25:2:49;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((78 - (k-25)/2):(328 - (k-25)/2));
diagonalodd = [diagonalodd, v];
end

diagonalodd = rot90(diagonalodd);
oddright2 = mean(diagonalodd);

diagonaleven = [];
for k = 26:2:50;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((78 - (k-26)/2):(328 - (k-26)/2));
diagonaleven = [diagonaleven, v];
end

diagonaleven = rot90(diagonaleven);
evenright2 = mean(diagonaleven);

right2 = (oddright2 + evenright2)/2;

middletime = 109:359;

subplot(5,4,[5 20]); plot (middletime, right2, '--b');


%%% Plot Negative Diagonal %%%


%  Save Diagonal in Matrix
diagonalodd = [];
for k = -49:2:-25;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v(((78 + (k-25)/2) + 25):((328 + (k-25)/2)+ 25));
diagonalodd = [diagonalodd, v];
end

diagonalodd = rot90(diagonalodd);
oddleft2 = mean(diagonalodd);


diagonaleven = [];
for k = -50:2:-26;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((78 + (k-26)/2 + 25):((328 + (k-26)/2) + 25));
diagonaleven = [diagonaleven, v];
end

diagonaleven = rot90(diagonaleven);
evenleft2 = mean(diagonaleven);

left2 = (oddleft2 + evenleft2)/2;


% Plot time vs. diagonal


subplot(5,4,[5 20]); plot (middletime, left2, '--r');


clear v w diagonal 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Large Window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plot Positive Diagonal %%%
%  Save Diagonal in Matrix
diagonalodd = [];
for k = 51:2:75;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((64 - (k-51)/2):(314 - (k-51)/2));
diagonalodd = [diagonalodd, v];
end

diagonalodd = rot90(diagonalodd);
oddright3 = mean(diagonalodd);

diagonaleven = [];
for k = 52:2:74;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v((64 - (k-52)/2):(314 - (k-52)/2));
diagonaleven = [diagonaleven, v];
end

diagonaleven = rot90(diagonaleven);
evenright3 = mean(diagonaleven);

right3 = (oddright3 + evenright3)/2;

largetime = 118:368;

subplot(5,4,[5 20]); plot (largetime, right3, ':b');


%%% Plot Negative Diagonal %%%


%  Save Diagonal in Matrix
diagonalodd = [];
for k = -75:2:-51;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v(((64 + (k-51)/2 + 52)):((314 + (k-51)/2)+ 52));
diagonalodd = [diagonalodd, v];
end

diagonalodd = rot90(diagonalodd);
oddleft3 = mean(diagonalodd);

diagonaleven = [];
for k = -74:2:-52;
v = diag(JPSTC_matrix,k); %for matrix X, returns a column vector v formed from the elements of the kth diagonal of X.
v = v(((64 + (k-52)/2)+52):((314 + (k-52)/2 +52)));
diagonaleven = [diagonaleven, v];
end

diagonaleven = rot90(diagonaleven);
evenleft3 = mean(diagonaleven);

left3 = (oddleft3 + evenleft3)/2;

% Plot time vs. diagonal


subplot(5,4,[5 20]); plot (largetime, left3, ':r');


clear v w diagonal 
% Plot main diagonal

v = diag(JPSTC_matrix);
main = v(91:341);

maintime = 91:341;

subplot(5,4,[5 20]); plot (maintime, main, 'k', 'LineWidth',2);


%%% Plot Thick Diagonal %%%

main = main';

thickdiagonal = (left3 + left2 + left1 + main + right1 + right2 + right3)/7;

widetime = 105:355;

subplot(5,4,[5 20]); plot (widetime, thickdiagonal, 'g', 'LineWidth',2);


legend ('Diagonal 1:25', 'Diagonal -25:-1', 'Diagonal 25:50', 'Diagonal -50:-25', 'Diagonal 50:75', 'Diagonal -75:-50', 'Main Diagonal', 'Diagonal -75:75');


subplot(5,4, [1:4])

% Title

text(0.4, 0.5, ['File: S013008002-RH_SEARCH', ])


text(0.1, 0.1, ['Date Generated: ', datestr(now,2)])


text(0.8, 0.1, 'Channels: AD01 vs. AD03');


axis off

%print -dpdf

clear  k time figurewindow lowerbound n upperbound window verticalmean widediagonal m v
end





