clear newmat
clear avmat
rand('seed',5150)

nReps = 1;

for rep = 1:nReps
    rep
    for trl = 1:size(avSig,1)
                
        shft = round(rand*50);
        newmat(trl,1:size(avSig,2),:) = circshift(avSig(trl,:,:),[0 shft 0]);
    end
    avmat(1:size(avSig,2),:,rep) = squeeze(nanmean(newmat,1));
    clear newmat
end

figure
plot(-200:500,nanmean(avmat,3))
axis ij

