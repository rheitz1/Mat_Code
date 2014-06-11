%threshold coherence plots based on if there was significance or not from
%shuffle tests
[c ix.time] = intersect(tout,tout_shuff);


in = abs(shuff_all.in.all.Pcoh(ix.time,:,:));
out = abs(shuff_all.out.all.Pcoh(ix.time,:,:));
d = in - out;



d(find(shuff_all.in_v_out.all.Pos == 0)) = NaN;

figure
imagesc(tout_shuff,f_shuff,nanmean(d,3)')
axis xy
colorbar


%count up # of sessions with significant gamma band coherence

for sess = 1:size(d,3)
    if isempty(find(~isnan(d(:,find(f_shuff>=35),sess))))
        issig(sess,1) = 0;
    else
        issig(sess,1) = 1;
    end
end