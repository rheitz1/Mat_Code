function answer = spearman(X, Y, p)
% This function is for spearman rank-order correlation test
% called by cal_rank_onset

if size(X, 1) == 1
   X = X';
end
if size(Y, 1) == 1
   Y = Y';
end


N = length(X);
if N~=length(Y)
   disp('X and Y should have the same length');
end

Temp = sortrows(X);
RankX = zeros(N, 1);
%ranking
for i = 1:N
   if(RankX(i)==0)
      value=X(i);
      Tie = find(Temp==value);
      RankX(i) = mean(Tie);
   end
end

Temp = sortrows(Y);
RankY = zeros(N, 1);
%ranking
for i = 1:N
   if(RankY(i)==0)
      value=Y(i);
      Tie = find(Temp==value);
      RankY(i) = mean(Tie);
   end
end

D = RankX-RankY;
%normalize for z-test
x = RankX - mean(RankX);
y = RankY - mean(RankY);
if sqrt(sum(x.^2)*sum(y.^2))==0
   rs = NaN;
else
   rs = (sum(x.^2)+sum(y.^2)-sum(D.^2))/(2*sqrt(sum(x.^2)*sum(y.^2)));
end


z = rs*sqrt(N-1);
if isnan(z)
   answer = 0;
else
   [H,SIG] = ztest(z,0,1,p,1);
   if H == 1
      answer = 1;

   else
      answer = 0;
   end
   
% plot(X,Y)
% title(answer)
% pause 
end

%t = rs*sqrt((N-2)/(1-rs^2));
%1-tcdf(t, N-2)
