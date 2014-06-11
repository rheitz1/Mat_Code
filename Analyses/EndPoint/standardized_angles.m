subt.ss2.correct = nanmean(allalpha.ss2.correct,1);
subt.ss2.correct = repmat(subt.ss2.correct,[size(allalpha.ss2.correct,1),1,1]);

standardized.ss2.correct = allalpha.ss2.correct - subt.ss2.correct;