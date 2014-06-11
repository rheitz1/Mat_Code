% Outputs the difference in light capturing ability between two f-stops

function [times_more prop_less] = f_comparison(f1,f2)
F = [f1 f2];
% times_more = ((f2 / sqrt(2)) / (f1 / sqrt(2))) / sqrt(2);
% prop_less = ((f1 / sqrt(2)) / (f1 / sqrt(2))) / sqrt(2);


%put everything on common metric relative to f/1.4
%how many f-stops is f1
f1 = min(F);
f2 = max(F);

F1 = log10(f1) / log10(sqrt(2));
F2 = log10(f2) / log10(sqrt(2));

%times_more = F2 - F1;
times_more = 2 ^ (F2 - F1);
%prop_less = F1 / F2;
prop_less = 1 / times_more;

disp(['f/' mat2str(f1) ' is ' mat2str(round(times_more*100)/100) 'x more sensitive ' ...
    'than f/' mat2str(f2) '.'])
disp(['f/' mat2str(f2) ' is ' mat2str(round(prop_less*100)/100) '% as sensitive ' ...
    'than f/' mat2str(f1) '.'])