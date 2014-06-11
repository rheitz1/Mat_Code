%MTClusShuffOptsDefaults.m

if ~isfield(ClusShuffOpts,'nShuffs');           ClusShuffOpts.nShuffs=5000;     end
if ~isfield(ClusShuffOpts,'BasePer');           ClusShuffOpts.BasePer=[-320 -80];   end     %in ms- this is the time window corresponding to the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the baseline period
if ~isfield(ClusShuffOpts,'ActPer');            ClusShuffOpts.ActPer=[0 800];   end      %in ms- this is the time window corresponding to the activity period, which are all the time periods you wish to test against the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the activity period
if ~isfield(ClusShuffOpts,'Thresh');            ClusShuffOpts.Thresh=1.96;  end
if ~isfield(ClusShuffOpts,'NClusCutOff');       ClusShuffOpts.NClusCutOff=6;   end %To improve speed, the algorithm operates two different ways (with the same result) based on the number of clusters in a given shuffle- one way is faster if there are more clusters and one way is faster if there are fewer clusters. This value sets the cutoff number of clusters value to determine which algorithm to use on a particular shuffle
    
    %I removed the below as an option and instead outputting both values for the same shuffling ... i.e. for a Coh test, On struc in err will be Coh, and one struc will be CohNormAboveThresh
    %NormAboveThreshStats=1;   %if set to 1, when calc'ing clus sums, this sums the difference from the thresh of each test stat above thresh val, not the raw test stat val
    %Setting to 1 will make the test more sensitive to indivdiual time and freq values way above thresh (i.e. for smaller clusters with more activation) and setting it 0 makes the test more sensitive to broader time-freq clusters of activation with individual values not as far above the threshhold
    %In practice, there are subtle but not major differences b/t setting this to 1 or 0
    
    
    %The fields CohTest, SpecTest, PCohTest, and PSpecTest sould be either 1 or 0 indicating whether or not you wnat to test that particular measurement
    %Note that this hold whether the error test being made involves shuffling, or teh analytic approximations described in Jarvis and Mitra (i.e. whether the input errType is 1 or 2)
    %For each type of test there are two test stat options- The first option makes use of the fact that the act and base pers occur in the same trials
    %and employs an appropriate within trials test, whereas the second option uses a Fisher normalized statistic that assumes a complete between trials design
    
if ~isfield(ClusShuffOpts,'CohTest');           ClusShuffOpts.CohTest=1;    end
if ~isfield(ClusShuffOpts,'CohTestStat');       ClusShuffOpts.CohTestStat=2;    end %1 for CohZPF, 2 for Fisher's Z
    %as it turns out, at least w/ one sapmle session, Fisher's Z gives almost exactly the same answer, and runs a bit quicker, so that's recommended
    %It seems that there's little correlation b/t coh at one time point in a trial and coherence at anotehr time point in the trial, so there is little gained by doing an analysis that is specific to making use of the fact that the base and act periods are collected within teh same trials
    
if ~isfield(ClusShuffOpts,'SpecTest');          ClusShuffOpts.SpecTest=0;   end
if ~isfield(ClusShuffOpts,'SpecTestStat');      ClusShuffOpts.SpecTestStat=1;   end   %1 to use a sign-rank test test stat, 2 touse the log-normalized differences as the test stat
    %For spec Tests unlike coh tests, I recommend using test stat 1... it takes considerably longer (about 5x as long for my pilot
    %session for the same number of shuffles) but seems to be more powerful...
    
if ~isfield(ClusShuffOpts,'PCohTest');          ClusShuffOpts.PCohTest=0;   end
if ~isfield(ClusShuffOpts,'PCohTestStat');      ClusShuffOpts.PCohTestStat=2;   end
if ~isfield(ClusShuffOpts,'PSpecTest');         ClusShuffOpts.PSpecTest=0;  end
if ~isfield(ClusShuffOpts,'PSpecTestStat');     ClusShuffOpts.PSpecTestStat=1;  end
    
if ~isfield(ClusShuffOpts,'TestType');          ClusShuffOpts.TestType=1;   end   %vs. Base test ... set to 2 for a TrType test
if ~isfield(ClusShuffOpts,'TrType');            ClusShuffOpts.TrType=[];    end

if ~isfield(ClusShuffOpts,'CohAdjPh');          ClusShuffOpts.CohAdjPh=1;   end   %vs. Base test ... set to 2 for a TrType test
if ~isfield(ClusShuffOpts,'CohAdjMag');         ClusShuffOpts.CohAdjMag=1;    end