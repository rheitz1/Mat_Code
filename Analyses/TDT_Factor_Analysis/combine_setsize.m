allTDT.SPK.ss2(find(allTDT.SPK.ss2 == 0)) = NaN;
allTDT.SPK.ss4(find(allTDT.SPK.ss4 == 0)) = NaN;
allTDT.SPK.ss8(find(allTDT.SPK.ss8 == 0)) = NaN;

curpos_sess = 1;

for sess = 1:size(allTDT.SPK.ss2,1)
    curpos_spk = 1;
    for spk = 1:size(allTDT.SPK.ss2,2)
        if ~isnan(allTDT.SPK.ss2(sess,spk)) && ~isnan(allTDT.SPK.ss4(sess,spk)) && ...
                ~isnan(allTDT.SPK.ss8(sess,spk))
            spike.ss2(curpos_sess,curpos_spk) = allTDT.SPK.ss2(sess,spk);
            spike.ss4(curpos_sess,curpos_spk) = allTDT.SPK.ss4(sess,spk);
            spike.ss8(curpos_sess,curpos_spk) = allTDT.SPK.ss8(sess,spk);
            
            curpos_spk = curpos_spk + 1;
        end
    end
    curpos_sess = curpos_sess + 1;
end




allTDT.LFP.ss2(find(allTDT.LFP.ss2 == 0)) = NaN;
allTDT.LFP.ss4(find(allTDT.LFP.ss4 == 0)) = NaN;
allTDT.LFP.ss8(find(allTDT.LFP.ss8 == 0)) = NaN;
 
curpos_sess = 1;
 
for sess = 1:size(allTDT.LFP.ss2,1)
    curpos_LFP = 1;
    for LFP = 1:size(allTDT.LFP.ss2,2)
        if ~isnan(allTDT.LFP.ss2(sess,LFP)) && ~isnan(allTDT.LFP.ss4(sess,LFP)) && ...
                ~isnan(allTDT.LFP.ss8(sess,LFP))
            lfp.ss2(curpos_sess,curpos_LFP) = allTDT.LFP.ss2(sess,LFP);
            lfp.ss4(curpos_sess,curpos_LFP) = allTDT.LFP.ss4(sess,LFP);
            lfp.ss8(curpos_sess,curpos_LFP) = allTDT.LFP.ss8(sess,LFP);
            
            curpos_LFP = curpos_LFP + 1;
        end
    end
    curpos_sess = curpos_sess + 1;
end
