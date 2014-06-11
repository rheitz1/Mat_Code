[SRT saccLoc] = getSRT(EyeX_,EyeY_);
trls = find(Target_(:,5) == 2 & ismember(saccLoc,[7 0 1 3 4 5]));


tapers = PreGenTapers([.2 5]);

for tr = 1:length(trls)
    act_dir(tr,1) = saccLoc(trls(tr));
    [Left(1:281,1:104,tr),f,tout] = LFPSpec(AD09(trls(tr),:),tapers,1000,.01,[0 100],0,-500,0,4);
    [Right(1:281,1:104,tr),f,tout] = LFPSpec(AD10(trls(tr),:),tapers,1000,.01,[0 100],0,-500,0,4);
end


for tr = 1:size(Right,3)
    Trial_prestim_power.Right(tr,1) = nanmean(nanmean(Right(find(tout <= -200),find(f >= 60),tr)));
    Trial_prestim_power.Left(tr,1) = nanmean(nanmean(Left(find(tout <= -200),find(f >= 60),tr)));
end

for tr = 1:length(Trial_prestim_power.Left)
    if Trial_prestim_power.Left(tr) > Trial_prestim_power.Right(tr)
        direc(tr,1) = 'L';
    elseif Trial_prestim_power.Left(tr) < Trial_prestim_power.Right(tr)
        direc(tr,1) = 'R';
    else
        direc(tr,1) = 'X';
    end
end


for tr = 1:length(act_dir)
    if ismember(act_dir(tr),[7 0 1])
        real_direc(tr,1) = 'R';
    elseif ismember(act_dir(tr),[3 4 5])
        real_direc(tr,1) = 'L';
    else
        real_direc(tr,1) = 'X';
    end
end

for tr = 1:length(real_direc)
    if real_direc(tr) == direc(tr)
        hits(tr) = 1;
    else
        hits(tr) = 0;
    end
end

figure
hist(hits,30)
sum(hits) / length(hits)