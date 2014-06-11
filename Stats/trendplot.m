function [p r2]=trendplot(x,y,range)
%Plots data points and first through sixth degree polynomials.
%Displays polynomial coefficients and r-squared values in command window.
%Allows user to choose range.  Also allows user to remove trendlines that
%don't appear to fit.

%Run trend function on given data. Display coefficients and r-squared
%values for each trendline.
[p r2]=trend(x,y); 


%Use user-provided range if given, otherwise use range from data x-values.
try
    X=range;
catch
    X=linspace(x(1),x(length(x)));
end

%Calculate y-values for each trendline across the range of X.
linear_fit=polyval(p(1,:),X);
quad_fit=polyval(p(2,:),X);
cubic_fit=polyval(p(3,:),X);
poly4_fit=polyval(p(4,:),X);
poly5_fit=polyval(p(5,:),X);
poly6_fit=polyval(p(6,:),X);


repeat='y';
include(1:7)=1;     %Array with 1's for included graphs and 0's for excluded graphs
legend_labels={'Linear' 'Quadratic' 'Cubic' '4th order poly' '5th order poly' '6th order poly' 'Data'};
dummy_labels=legend_labels;

%Loop that repeats as long as user is removing unwanted trendlines.
while repeat=='y' || repeat=='Y'
    close all hidden;   %Close all figures.
    figure;             %New figure.
    hold on;
    
    %Determine which graphs to display.
    if include(1)==1
        plot(X,linear_fit,'Color',[128/255 0 64/255],'LineWidth',2);
    end;
    if include(2)==1
        plot(X,quad_fit,'LineWidth',2);
    end;
    if include(3)==1
        plot(X,cubic_fit,'Color',[0 117/255 0],'LineWidth',2);
    end;
    if include(4)==1
        plot(X,poly4_fit,'r-','LineWidth',2);
    end;
    if include(5)==1
        plot(X,poly5_fit,'-.','Color',[120/255 69/255 1],'LineWidth',2);
    end;
    if include(6)==1
        plot(X,poly6_fit,'k:','LineWidth',2);
    end;
    if include(7)==1
        plot(x,y,'k*','LineWidth',3);
    end;
    
    legend(legend_labels);
    
    repeat=input('Remove a trendline (Y/N)?','s');
    if repeat=='y' || repeat =='Y'
        remove=input('Enter order numbers to be removed separated by spaces:','s');
        
        %Change include array and legend_labels values to 0 for trendlines to be removed.
        for k=1:length(remove)
            include(str2num(remove(k)))=0;
            try
                dummy_labels{str2num(remove(k))}='0';
            end
        end
        
        %Lines 78-93 essentially change the size of legend_labels to match
        %the new trendline setup.
        legend_labels=dummy_labels;
        sum=0;
        for k=1:length(legend_labels)
            if legend_labels{k}=='0'
                sum=sum+1;
            end
        end
        legend_labels_temp=cell(1,length(legend_labels)-sum);
        j=1;
        for k=1:length(legend_labels)
            if xor(isempty(str2num(legend_labels{k})),0)
                legend_labels_temp{j}=legend_labels{k};
                j=j+1;
            end
        end
        legend_labels=legend_labels_temp;
        
    end
    
end

%--------------------------------------------------
function [poly, r_squared]=trend(x,y)
%calculates polynomial coefficients with degree 1 to 6 for given data
%x = x values for data points
%y = y values for data points


X=x;
Y=y;
XP=linspace(x(1),x(length(x)));
for k=1:6
    coeff(k).array=polyfit(X,Y,k);
    YP(k,:)=polyval(coeff(k).array,XP);
    J(k)=sum((polyval(coeff(k).array,X)-Y).^2);
end

mu=mean(Y);
for k=1:6
    S(k)=sum((Y-mu).^2);
    r_squared(k)=1-J(k)/S(k);
end

for r=1:6
    for c=1:7-(r+1)
        poly(r,c)= 0;
    end
    i=1;
    for c=7-r:7
        poly(r,c)=coeff(r).array(i);
        i=i+1;
    end
end