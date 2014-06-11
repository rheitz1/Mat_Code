%quick script to remove MED conditions from SAT for debugging, testing, etc.
%
%RPH

remove = find(SAT_(:,1) == 2);
disp(['Removing ' mat2str(length(remove)) ' MED trials'])

varlist = who;
Alist = varlist(strmatch('AD',varlist));
Dlist = varlist(strmatch('DSP',varlist));

for chan = 1:length(Alist)
    eval([cell2mat(Alist(chan)) '(remove,:) = [];'])
end

for chan = 1:length(Dlist)
    eval([cell2mat(Dlist(chan)) '(remove,:) = [];'])
end

Target_(remove,:) = [];
SAT_(remove,:) = [];
SRT(remove,:) = [];
Errors_(remove,:) = [];

try
EyeX_(remove,:) = [];
EyeY_(remove,:) = [];
end

Correct_(remove,:) = [];

try
TrialStart_(remove,:) = [];
end

clear remove Alist Dlist chan varlistw