% x = round(rand(50,1)*100);
% niter = 0;
% %brute force method: re-sorts every time
% for i = 1:length(x)
%     for j = i:length(x)
%         if x(i) > x(j)
%            % didchange = 1;
%             temp = x(i);
%             x(i) = x(j);
%             x(j) = temp;
%             niter = niter + 1;
%         end
%     end
% end
%
%
%
% % Put it in order as we go method
% RTarray(1:1000) = NaN;
% RTarray(1) = 0;

RTarray = [];
placed = 0;

for trl = 1:100
    currRT = round(rand*100);
    placed = 0;
    
    if trl == 1
        RTarray(1,1) = currRT;
    else
        
        keeplooking = 1;
        j = 1;
        while keeplooking
            % for j = 1:trl-1
            
            if j == trl-1
                keeplooking = 0;
            end
            if currRT < RTarray(j,1)
                %shift everything else down in reverse
                for nextTrl = trl:-1:j+1
                    RTarray(nextTrl,1) = RTarray(nextTrl-1,1);
                end
                
                %set most current value
                RTarray(j,1) = currRT;
                placed = 1;
                keeplooking = 0;
            end
            j = j + 1;
        end
        
        if placed == 0
            RTarray(trl,1) = currRT;
        end
    end
end





