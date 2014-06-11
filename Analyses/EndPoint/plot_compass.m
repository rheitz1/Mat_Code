% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)


%=======================================================
% CORRECT

figure

cond = alph.ss2.correct.pos0;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,1)));


num = length(find(~isnan(cond)));

alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);


hold on

cond = alph.ss4.correct.pos0;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,1)));

num = length(find(~isnan(cond)));

alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);

cond = alph.ss8.correct.pos0;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,1)));

num = length(find(~isnan(cond)));

alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);

lines = findobj('type','line');

set(lines(3),'linewidth',width1);
set(lines(3),'color','b')

set(lines(2),'linewidth',width2);
set(lines(2),'color','r')

set(lines(1),'linewidth',width3);
set(lines(1),'color','g')



%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 

 
cond = alph.ss2.correct.pos1;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,2)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos1;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,2)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos1;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,2)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')



 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 


cond = alph.ss2.correct.pos2;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,3)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos2;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,3)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos2;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,3)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')





 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 

 
cond = alph.ss2.correct.pos3;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,4)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos3;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,4)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos3;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,4)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')





 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 

 
cond = alph.ss2.correct.pos4;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,5)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos4;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,5)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos4;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,5)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')





 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 

 
cond = alph.ss2.correct.pos5;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,6)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos5;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,6)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos5;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,6)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')





 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 

 
cond = alph.ss2.correct.pos6;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,7)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos6;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,7)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos6;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,7)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')



 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 

 
cond = alph.ss2.correct.pos7;
width1 = rad2deg(nanmean(allstd.ss2.correct(:,8)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 

 
cond = alph.ss4.correct.pos7;
width2 = rad2deg(nanmean(allstd.ss4.correct(:,8)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.correct.pos7;
width3 = rad2deg(nanmean(allstd.ss8.correct(:,8)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')








%==================================================
% ERRORS


figure
 
cond = alph.ss2.errors.pos0;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,1)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
hold on
 
cond = alph.ss4.errors.pos0;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,1)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos0;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,1)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos1;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,2)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos1;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,2)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos1;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,2)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos2;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,3)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos2;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,3)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos2;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,3)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos3;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,4)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos3;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,4)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos3;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,4)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos4;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,5)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos4;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,5)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos4;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,5)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos5;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,6)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos5;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,6)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos5;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,6)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos6;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,7)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos6;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,7)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos6;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,7)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')
 
 
 
 
%=========================================================
% rise = 100;
% ang = deg2rad(170);
% 
% run = rise / tan(ang);
% 
% compass(run,rise)
 
 
 
cond = alph.ss2.errors.pos7;
width1 = rad2deg(nanmean(allstd.ss2.errors(:,8)));
 
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
 
 
 
cond = alph.ss4.errors.pos7;
width2 = rad2deg(nanmean(allstd.ss4.errors(:,8)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
cond = alph.ss8.errors.pos7;
width3 = rad2deg(nanmean(allstd.ss8.errors(:,8)));
 
num = length(find(~isnan(cond)));
 
alpha = rad2deg(nanmean(cond));
[x y] = pol2cart(deg2rad(alpha),num);
compass(x,y);
 
lines = findobj('type','line');
 
set(lines(3),'linewidth',width1);
set(lines(3),'color','b')
 
set(lines(2),'linewidth',width2);
set(lines(2),'color','r')
 
set(lines(1),'linewidth',width3);
set(lines(1),'color','g')


clear width* lines num cond x y