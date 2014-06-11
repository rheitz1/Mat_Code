%% Set up: vectorize for easier plotting w/ Rose
alph.ss2.correct.pos0 = reshape(allalpha.ss2.correct(:,1,:),1,length(find(allalpha.ss2.correct(:,1,:))));
alph.ss2.correct.pos1 = reshape(allalpha.ss2.correct(:,2,:),1,length(find(allalpha.ss2.correct(:,2,:))));
alph.ss2.correct.pos2 = reshape(allalpha.ss2.correct(:,3,:),1,length(find(allalpha.ss2.correct(:,3,:))));
alph.ss2.correct.pos3 = reshape(allalpha.ss2.correct(:,4,:),1,length(find(allalpha.ss2.correct(:,4,:))));
alph.ss2.correct.pos4 = reshape(allalpha.ss2.correct(:,5,:),1,length(find(allalpha.ss2.correct(:,5,:))));
alph.ss2.correct.pos5 = reshape(allalpha.ss2.correct(:,6,:),1,length(find(allalpha.ss2.correct(:,6,:))));
alph.ss2.correct.pos6 = reshape(allalpha.ss2.correct(:,7,:),1,length(find(allalpha.ss2.correct(:,7,:))));
alph.ss2.correct.pos7 = reshape(allalpha.ss2.correct(:,8,:),1,length(find(allalpha.ss2.correct(:,8,:))));

alph.ss4.correct.pos0 = reshape(allalpha.ss4.correct(:,1,:),1,length(find(allalpha.ss4.correct(:,1,:))));
alph.ss4.correct.pos1 = reshape(allalpha.ss4.correct(:,2,:),1,length(find(allalpha.ss4.correct(:,2,:))));
alph.ss4.correct.pos2 = reshape(allalpha.ss4.correct(:,3,:),1,length(find(allalpha.ss4.correct(:,3,:))));
alph.ss4.correct.pos3 = reshape(allalpha.ss4.correct(:,4,:),1,length(find(allalpha.ss4.correct(:,4,:))));
alph.ss4.correct.pos4 = reshape(allalpha.ss4.correct(:,5,:),1,length(find(allalpha.ss4.correct(:,5,:))));
alph.ss4.correct.pos5 = reshape(allalpha.ss4.correct(:,6,:),1,length(find(allalpha.ss4.correct(:,6,:))));
alph.ss4.correct.pos6 = reshape(allalpha.ss4.correct(:,7,:),1,length(find(allalpha.ss4.correct(:,7,:))));
alph.ss4.correct.pos7 = reshape(allalpha.ss4.correct(:,8,:),1,length(find(allalpha.ss4.correct(:,8,:))));

alph.ss8.correct.pos0 = reshape(allalpha.ss8.correct(:,1,:),1,length(find(allalpha.ss8.correct(:,1,:))));
alph.ss8.correct.pos1 = reshape(allalpha.ss8.correct(:,2,:),1,length(find(allalpha.ss8.correct(:,2,:))));
alph.ss8.correct.pos2 = reshape(allalpha.ss8.correct(:,3,:),1,length(find(allalpha.ss8.correct(:,3,:))));
alph.ss8.correct.pos3 = reshape(allalpha.ss8.correct(:,4,:),1,length(find(allalpha.ss8.correct(:,4,:))));
alph.ss8.correct.pos4 = reshape(allalpha.ss8.correct(:,5,:),1,length(find(allalpha.ss8.correct(:,5,:))));
alph.ss8.correct.pos5 = reshape(allalpha.ss8.correct(:,6,:),1,length(find(allalpha.ss8.correct(:,6,:))));
alph.ss8.correct.pos6 = reshape(allalpha.ss8.correct(:,7,:),1,length(find(allalpha.ss8.correct(:,7,:))));
alph.ss8.correct.pos7 = reshape(allalpha.ss8.correct(:,8,:),1,length(find(allalpha.ss8.correct(:,8,:))));

%vectorize for easier plotting w/ Rose
alph.ss2.errors.pos0 = reshape(allalpha.ss2.errors(:,1,:),1,length(find(allalpha.ss2.errors(:,1,:))));
alph.ss2.errors.pos1 = reshape(allalpha.ss2.errors(:,2,:),1,length(find(allalpha.ss2.errors(:,2,:))));
alph.ss2.errors.pos2 = reshape(allalpha.ss2.errors(:,3,:),1,length(find(allalpha.ss2.errors(:,3,:))));
alph.ss2.errors.pos3 = reshape(allalpha.ss2.errors(:,4,:),1,length(find(allalpha.ss2.errors(:,4,:))));
alph.ss2.errors.pos4 = reshape(allalpha.ss2.errors(:,5,:),1,length(find(allalpha.ss2.errors(:,5,:))));
alph.ss2.errors.pos5 = reshape(allalpha.ss2.errors(:,6,:),1,length(find(allalpha.ss2.errors(:,6,:))));
alph.ss2.errors.pos6 = reshape(allalpha.ss2.errors(:,7,:),1,length(find(allalpha.ss2.errors(:,7,:))));
alph.ss2.errors.pos7 = reshape(allalpha.ss2.errors(:,8,:),1,length(find(allalpha.ss2.errors(:,8,:))));
 
alph.ss4.errors.pos0 = reshape(allalpha.ss4.errors(:,1,:),1,length(find(allalpha.ss4.errors(:,1,:))));
alph.ss4.errors.pos1 = reshape(allalpha.ss4.errors(:,2,:),1,length(find(allalpha.ss4.errors(:,2,:))));
alph.ss4.errors.pos2 = reshape(allalpha.ss4.errors(:,3,:),1,length(find(allalpha.ss4.errors(:,3,:))));
alph.ss4.errors.pos3 = reshape(allalpha.ss4.errors(:,4,:),1,length(find(allalpha.ss4.errors(:,4,:))));
alph.ss4.errors.pos4 = reshape(allalpha.ss4.errors(:,5,:),1,length(find(allalpha.ss4.errors(:,5,:))));
alph.ss4.errors.pos5 = reshape(allalpha.ss4.errors(:,6,:),1,length(find(allalpha.ss4.errors(:,6,:))));
alph.ss4.errors.pos6 = reshape(allalpha.ss4.errors(:,7,:),1,length(find(allalpha.ss4.errors(:,7,:))));
alph.ss4.errors.pos7 = reshape(allalpha.ss4.errors(:,8,:),1,length(find(allalpha.ss4.errors(:,8,:))));
 
alph.ss8.errors.pos0 = reshape(allalpha.ss8.errors(:,1,:),1,length(find(allalpha.ss8.errors(:,1,:))));
alph.ss8.errors.pos1 = reshape(allalpha.ss8.errors(:,2,:),1,length(find(allalpha.ss8.errors(:,2,:))));
alph.ss8.errors.pos2 = reshape(allalpha.ss8.errors(:,3,:),1,length(find(allalpha.ss8.errors(:,3,:))));
alph.ss8.errors.pos3 = reshape(allalpha.ss8.errors(:,4,:),1,length(find(allalpha.ss8.errors(:,4,:))));
alph.ss8.errors.pos4 = reshape(allalpha.ss8.errors(:,5,:),1,length(find(allalpha.ss8.errors(:,5,:))));
alph.ss8.errors.pos5 = reshape(allalpha.ss8.errors(:,6,:),1,length(find(allalpha.ss8.errors(:,6,:))));
alph.ss8.errors.pos6 = reshape(allalpha.ss8.errors(:,7,:),1,length(find(allalpha.ss8.errors(:,7,:))));
alph.ss8.errors.pos7 = reshape(allalpha.ss8.errors(:,8,:),1,length(find(allalpha.ss8.errors(:,8,:))));
 


%%
%
% allr.ss2(find(allr.ss2 == 0)) = NaN;
% allr.ss4(find(allr.ss4 == 0)) = NaN;
% allr.ss8(find(allr.ss8 == 0)) = NaN;
%
% allstd.ss2(find(allstd.ss2 == 0)) = NaN;
% allstd.ss4(find(allstd.ss4 == 0)) = NaN;
% allstd.ss8(find(allstd.ss8 == 0)) = NaN;
% %=====================
%
%
%take ABSOLUTE deviations in X and Y coordinates by subtracting from mean
% x = nanmean(allpos.ss2.deltaX,1);
% x = repmat(x,size(allpos.ss2.deltaX,1),1);
% dx.ss2 = abs(allpos.ss2.deltaX - x);
% 
% x = nanmean(allpos.ss4.deltaX);
% x = repmat(x,size(allpos.ss4.deltaX,1),1);
% dx.ss4 = abs(allpos.ss4.deltaX - x);
% 
% x = nanmean(allpos.ss8.deltaX);
% x = repmat(x,size(allpos.ss8.deltaX,1),1);
% dx.ss8 = abs(allpos.ss8.deltaX - x);
% 
% y = nanmean(allpos.ss2.deltaY);
% y = repmat(y,size(allpos.ss2.deltaY,1),1);
% dy.ss2 = abs(allpos.ss2.deltaY - y);
% 
% y = nanmean(allpos.ss4.deltaY);
% y = repmat(y,size(allpos.ss4.deltaY,1),1);
% dy.ss4 = abs(allpos.ss4.deltaY - y);
% 
% y = nanmean(allpos.ss8.deltaY);
% y = repmat(y,size(allpos.ss8.deltaY,1),1);
% dy.ss8 = abs(allpos.ss8.deltaY - y);

%% Create deviatino scores
x = nanmean(allpos.ss2.correct.degX,1);
x = repmat(x,size(allpos.ss2.correct.degX,1),1);
dx.ss2.correct = abs(allpos.ss2.correct.degX - x);
 
x = nanmean(allpos.ss4.correct.degX);
x = repmat(x,size(allpos.ss4.correct.degX,1),1);
dx.ss4.correct = abs(allpos.ss4.correct.degX - x);
 
x = nanmean(allpos.ss8.correct.degX);
x = repmat(x,size(allpos.ss8.correct.degX,1),1);
dx.ss8.correct = abs(allpos.ss8.correct.degX - x);
 
y = nanmean(allpos.ss2.correct.degY);
y = repmat(y,size(allpos.ss2.correct.degY,1),1);
dy.ss2.correct = abs(allpos.ss2.correct.degY - y);
 
y = nanmean(allpos.ss4.correct.degY);
y = repmat(y,size(allpos.ss4.correct.degY,1),1);
dy.ss4.correct = abs(allpos.ss4.correct.degY - y);
 
y = nanmean(allpos.ss8.correct.degY);
y = repmat(y,size(allpos.ss8.correct.degY,1),1);
dy.ss8.correct = abs(allpos.ss8.correct.degY - y);

x = nanmean(allpos.ss2.errors.degX,1);
x = repmat(x,size(allpos.ss2.errors.degX,1),1);
dx.ss2.errors = abs(allpos.ss2.errors.degX - x);
 
x = nanmean(allpos.ss4.errors.degX);
x = repmat(x,size(allpos.ss4.errors.degX,1),1);
dx.ss4.errors = abs(allpos.ss4.errors.degX - x);
 
x = nanmean(allpos.ss8.errors.degX);
x = repmat(x,size(allpos.ss8.errors.degX,1),1);
dx.ss8.errors = abs(allpos.ss8.errors.degX - x);
 
y = nanmean(allpos.ss2.errors.degY);
y = repmat(y,size(allpos.ss2.errors.degY,1),1);
dy.ss2.errors = abs(allpos.ss2.errors.degY - y);
 
y = nanmean(allpos.ss4.errors.degY);
y = repmat(y,size(allpos.ss4.errors.degY,1),1);
dy.ss4.errors = abs(allpos.ss4.errors.degY - y);
 
y = nanmean(allpos.ss8.errors.degY);
y = repmat(y,size(allpos.ss8.errors.degY,1),1);
dy.ss8.errors = abs(allpos.ss8.errors.degY - y);



%sum deviations in x and y dimensions
dev.ss2.correct = abs(dx.ss2.correct) + abs(dy.ss2.correct);
dev.ss4.correct = abs(dx.ss4.correct) + abs(dy.ss4.correct);
dev.ss8.correct = abs(dx.ss8.correct) + abs(dy.ss8.correct);

dev.ss2.errors = abs(dx.ss2.errors) + abs(dy.ss2.errors);
dev.ss4.errors = abs(dx.ss4.errors) + abs(dy.ss4.errors);
dev.ss8.errors = abs(dx.ss8.errors) + abs(dy.ss8.errors);


clear x y


%% Compute correlations for each set size and screen location
for sess = 1:size(allRT.ss2.correct,3);
    
    %ss2
    for screenpos = 1:8
        if ~isempty(find(~isnan(allRT.ss2.correct(:,screenpos,sess))))
            temp(:,1) = allRT.ss2.correct(:,screenpos,sess);
            temp(:,2) = dx.ss2.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss2.correct.dx(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss2.correct(:,screenpos,sess);
            temp(:,2) = dy.ss2.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss2.correct.dy(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss2.correct(:,screenpos,sess);
            temp(:,2) = dev.ss2.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss2.correct.dev(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
        else
            
            r.ss2.correct.dx(sess,screenpos) = NaN;
            r.ss2.correct.dy(sess,screenpos) = NaN;
            r.ss2.correct.dev(sess,screenpos) = NaN;
        end
    end
    
    
    
    %ss4
    for screenpos = 1:8
        if ~isempty(find(~isnan(allRT.ss4.correct(:,screenpos,sess))))
            temp(:,1) = allRT.ss4.correct(:,screenpos,sess);
            temp(:,2) = dx.ss4.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss4.correct.dx(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss4.correct(:,screenpos,sess);
            temp(:,2) = dy.ss4.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss4.correct.dy(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss4.correct(:,screenpos,sess);
            temp(:,2) = dev.ss4.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss4.correct.dev(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
        else
            r.ss4.correct.dx(sess,screenpos) = NaN;
            r.ss4.correct.dy(sess,screenpos) = NaN;
            r.ss4.correct.dev(sess,screenpos) = NaN;
        end
    end
    
    
    
    %ss8
    for screenpos = 1:8
        if ~isempty(find(~isnan(allRT.ss8.correct(:,screenpos,sess))))
            temp(:,1) = allRT.ss8.correct(:,screenpos,sess);
            temp(:,2) = dx.ss8.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss8.correct.dx(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
%             
            temp(:,1) = allRT.ss8.correct(:,screenpos,sess);
            temp(:,2) = dy.ss8.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss8.correct.dy(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss8.correct(:,screenpos,sess);
            temp(:,2) = dev.ss8.correct(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss8.correct.dev(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
        else
            r.ss8.correct.dx(sess,screenpos) = NaN;
            r.ss8.correct.dy(sess,screenpos) = NaN;
            r.ss8.correct.dev(sess,screenpos) = NaN;
        end
    end
end
clear screenpos sess



 %=========================
 % ERRORS
for sess = 1:size(allRT.ss2.errors,3);
    
    %ss2
    for screenpos = 1:8
        if ~isempty(find(~isnan(allRT.ss2.errors(:,screenpos,sess))))
            temp(:,1) = allRT.ss2.errors(:,screenpos,sess);
            temp(:,2) = dx.ss2.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss2.errors.dx(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss2.errors(:,screenpos,sess);
            temp(:,2) = dy.ss2.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss2.errors.dy(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss2.errors(:,screenpos,sess);
            temp(:,2) = dev.ss2.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss2.errors.dev(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
        else
            
            r.ss2.errors.dx(sess,screenpos) = NaN;
            r.ss2.errors.dy(sess,screenpos) = NaN;
            r.ss2.errors.dev(sess,screenpos) = NaN;
        end
    end
    
    
    
    %ss4
    for screenpos = 1:8
        if ~isempty(find(~isnan(allRT.ss4.errors(:,screenpos,sess))))
            temp(:,1) = allRT.ss4.errors(:,screenpos,sess);
            temp(:,2) = dx.ss4.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss4.errors.dx(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss4.errors(:,screenpos,sess);
            temp(:,2) = dy.ss4.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss4.errors.dy(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss4.errors(:,screenpos,sess);
            temp(:,2) = dev.ss4.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss4.errors.dev(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
        else
            r.ss4.errors.dx(sess,screenpos) = NaN;
            r.ss4.errors.dy(sess,screenpos) = NaN;
            r.ss4.errors.dev(sess,screenpos) = NaN;
        end
    end
    
    
    
    %ss8
    for screenpos = 1:8
        if ~isempty(find(~isnan(allRT.ss8.errors(:,screenpos,sess))))
            temp(:,1) = allRT.ss8.errors(:,screenpos,sess);
            temp(:,2) = dx.ss8.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss8.errors.dx(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
%             
            temp(:,1) = allRT.ss8.errors(:,screenpos,sess);
            temp(:,2) = dy.ss8.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss8.errors.dy(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
            temp(:,1) = allRT.ss8.errors(:,screenpos,sess);
            temp(:,2) = dev.ss8.errors(:,screenpos,sess);
            temp = removeNaN(temp);
            
            r.ss8.errors.dev(sess,screenpos) = corr(temp(:,1),temp(:,2));
            clear temp
            
        else
            r.ss8.errors.dx(sess,screenpos) = NaN;
            r.ss8.errors.dy(sess,screenpos) = NaN;
            r.ss8.errors.dev(sess,screenpos) = NaN;
        end
    end
end
clear screenpos sess
