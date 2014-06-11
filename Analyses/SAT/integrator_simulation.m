%Integrator simulations

time = 1:1000;

before_integSlow = zeros(500,1000);
before_integMed = before_integSlow;
before_integFast = before_integSlow;

step_point_slow = 500;
step_point_med = 300;
step_point_fast = 200;

step_jit = 50;

baseline_slow = .3;
baseline_med = .3;
baseline_fast = .3;

leakage = .01;

for trl = 1:size(before_integSlow,1)
    
    SRT_slow(trl,1) = round(unifrnd(-step_jit,step_jit));
    SRT_med(trl,1) = round(unifrnd(-step_jit,step_jit));
    SRT_fast(trl,1) = round(unifrnd(-step_jit,step_jit));
    
    cur_step_point_slow = step_point_slow + SRT_slow(trl);
    cur_step_point_med = step_point_med + SRT_med(trl);
    cur_step_point_fast = step_point_fast + SRT_fast(trl);
    
    before_integSlow(trl,cur_step_point_slow:end) = 1;
    before_integMed(trl,cur_step_point_med:end) = 1;
    before_integFast(trl,cur_step_point_fast:end) = 1;
end

%make a baseline period and introduce some noise
before_integSlow = nanmean(before_integSlow + repmat(baseline_slow,500,1000) + (rand(500,1000)./10));
before_integMed = nanmean(before_integMed + repmat(baseline_med,500,1000) + (rand(500,1000)./10));
before_integFast = nanmean(before_integFast + repmat(baseline_fast,500,1000) + (rand(500,1000)./10));

integSlow = zeros(1,1000);
integMed = integSlow;
integFast = integSlow;

%compute integration + leakage
for tm = 2:size(integSlow,2)
    integSlow(tm) = integSlow(tm-1) + before_integSlow(tm) - (leakage .* integSlow(tm-1));
    integMed(tm) = integMed(tm-1) + before_integMed(tm) - (leakage .* integMed(tm-1));
    integFast(tm) = integFast(tm-1) + before_integFast(tm) - (leakage .* integFast(tm-1));

end


figure
plot(1:1000,integSlow,'r',1:1000,integMed,'k',1:1000,integFast,'g')