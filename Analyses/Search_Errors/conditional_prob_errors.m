fixErrors

c_c(1:size(Target_,1),1) = NaN;
c_e(1:size(Target_,1),1) = NaN;
e_c(1:size(Target_,1),1) = NaN;
e_e(1:size(Target_,1),1) = NaN;

for trl = 2:size(Correct_,1)
    if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255 & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        e_e(trl-1,1) = trl;
        
    elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255 & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        e_c(trl-1,1) = trl;
        
    elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1  & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255 & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        c_e(trl-1,1) = trl;
        
    elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1  & Target_(trl,2) ~= 255 & Target_(trl-1,2) ~= 255 & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        c_c(trl-1,1) = trl;
    end
end

c_c = removeNaN(c_c);
c_e = removeNaN(c_e);
e_c = removeNaN(e_c);
e_e = removeNaN(e_e);


%p(error)
pE = length(find(Errors_(:,5) == 1)) / size(Correct_,1);
%p(corr)
pC = length(find(Correct_(:,2) == 1)) / size(Correct_,1);

% p(error | correct)  = p(errors & correct) / p(correct)

pEgiveC = (length(c_e) / size(Correct_,1)) / pC;
pEgiveE = (length(e_e) / size(Correct_,1)) / pE;

pEandC = length(c_e) / size(Correct_,1)
pEandE = length(e_e) / size(Correct_,1)


%p(A) x p(B)
joint.pEpC = pE*pC
join.pEpE = pE*pE



window = 100;
baseProbErr = length(find(Errors_(:,5) == 1)) / size(Correct_,1);
s = 1;
for seq = 1:window:size(Errors_,1)-window
    sequence = Errors_(seq:seq+window-1,5);
    numErr = length(find(sequence == 1));
    
    prob(s) = 1 - binocdf(numErr,window,baseProbErr);
    clear sequence
    s = s + 1;
end

figure
plot(1:window:size(Errors_,1)-window,prob)
clear prob