% "Re-Reference" LFP to mean of all available LFPs for file

loadList = loadChan(newfile,'LFP');

for ch = 1:size(loadList,1)
    allSig(:,:,ch) = eval(loadList(ch,:));
end

if size(allSig,3) < 3
    disp('Fewer than 3 LFP channels detected; Not re-referencing')
    reRef = 0;
    return
else
    reRef = 1;
    avSig = nanmean(allSig,3);
end

for ch = 1:size(loadList,1)
    eval([loadList(ch,:) '_reref = ' loadList(ch,:) '- avSig;'])
end

clear loadList avSig ch