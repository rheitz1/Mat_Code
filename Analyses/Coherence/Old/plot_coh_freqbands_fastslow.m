%baseline correct coherence matrices
plotFlag = 1;

for sess = 1:size(coh_correct_targ_fast_all,3)
    sess

%     spec1_correct_fast = spec1_correct_targ_fast_all(:,:,sess)';
%     spec1_correct_slow = spec1_correct_targ_slow_all(:,:,sess)';
%     spec1_errors_fast = spec1_correct_targ_fast_all(:,:,sess)';
%     spec1_errors_slow = spec1_correct_targ_slow_all(:,:,sess)';
%     
%     spec2_correct_fast = spec2_correct_targ_fast_all(:,:,sess)';
%     spec2_correct_slow = spec2_correct_targ_slow_all(:,:,sess)';
%     spec2_errors_fast = spec2_correct_targ_fast_all(:,:,sess)';
%     spec2_errors_slow = spec2_correct_targ_slow_all(:,:,sess)';
    
    coh_correct_fast = coh_correct_targ_fast_all(:,:,sess)';
    coh_correct_slow = coh_correct_targ_slow_all(:,:,sess)';
%     coh_errors_fast = coh_errors_targ_fast_all(:,:,sess)';
%     coh_errors_slow = coh_errors_targ_slow_all(:,:,sess)';
%     
    %baseline correct matrices using first 4 values
%     spec1_correct_fast_base = repmat(nanmean(spec1_correct_fast(:,1:20),2),1,size(spec1_correct_fast,2));
%     spec1_correct_slow_base = repmat(nanmean(spec1_correct_slow(:,1:20),2),1,size(spec1_correct_slow,2));
%     spec1_errors_fast_base = repmat(nanmean(spec1_errors_fast(:,1:20),2),1,size(spec1_errors_fast,2));
%     spec1_errors_slow_base = repmat(nanmean(spec1_errors_slow(:,1:20),2),1,size(spec1_errors_slow,2));
% 
%     spec2_correct_fast_base = repmat(nanmean(spec2_correct_fast(:,1:20),2),1,size(spec2_correct_fast,2));
%     spec2_correct_slow_base = repmat(nanmean(spec2_correct_slow(:,1:20),2),1,size(spec2_correct_slow,2));
%     spec2_errors_fast_base = repmat(nanmean(spec2_errors_fast(:,1:20),2),1,size(spec2_errors_fast,2));
%     spec2_errors_slow_base = repmat(nanmean(spec2_errors_slow(:,1:20),2),1,size(spec2_errors_slow,2));
%     
    coh_correct_fast_base = repmat(nanmean(coh_correct_fast(:,1:20),2),1,size(coh_correct_fast,2));
    coh_correct_slow_base = repmat(nanmean(coh_correct_slow(:,1:20),2),1,size(coh_correct_slow,2));
%     coh_errors_fast_base = repmat(nanmean(coh_errors_fast(:,1:20),2),1,size(coh_correct_fast,2));
%     coh_errors_slow_base = repmat(nanmean(coh_errors_slow(:,1:20),2),1,size(coh_errors_slow,2));
%     
    %==================
%     spec1_correct_fast_bc = spec1_correct_fast - spec1_correct_fast_base;
%     spec1_correct_slow_bc = spec1_correct_slow - spec1_correct_slow_base;
%     spec1_errors_fast_bc = spec1_errors_fast - spec1_errors_fast_base;
%     spec1_errors_slow_bc = spec1_errors_slow - spec1_errors_slow_base;
%     
%     spec2_correct_fast_bc = spec2_correct_fast - spec2_correct_fast_base;
%     spec2_correct_slow_bc = spec2_correct_slow - spec2_correct_slow_base;
%     spec2_errors_fast_bc = spec2_errors_fast - spec2_errors_fast_base;
%     spec2_errors_slow_bc = spec2_errors_slow - spec2_errors_slow_base;
%     
    coh_correct_fast_bc = coh_correct_fast - coh_correct_fast_base;
    coh_correct_slow_bc = coh_correct_slow - coh_correct_slow_base;
%     coh_errors_fast_bc = coh_errors_fast - coh_errors_fast_base;
%     coh_errors_slow_bc = coh_errors_slow - coh_errors_slow_base;
%     
    %=====================
%     %keep track of all baseline corrected matrices
%     spec1_correct_fast_bc_all(1:206,1:281,sess) = spec1_correct_fast - spec1_correct_fast_base;
%     spec1_correct_slow_bc_all(1:206,1:281,sess) = spec1_correct_slow - spec1_correct_slow_base;
%     spec1_errors_fast_bc_all(1:206,1:281,sess) = spec1_errors_fast - spec1_errors_fast_base;
%     spec1_errors_slow_bc_all(1:206,1:281,sess) = spec1_errors_slow - spec1_errors_slow_base;
%     
%     spec2_correct_fast_bc_all(1:206,1:281,sess) = spec2_correct_fast - spec2_correct_fast_base;
%     spec2_correct_slow_bc_all(1:206,1:281,sess) = spec2_correct_slow - spec2_correct_slow_base;
%     spec2_errors_fast_bc_all(1:206,1:281,sess) = spec2_errors_fast - spec2_errors_fast_base;
%     spec2_errors_slow_bc_all(1:206,1:281,sess) = spec2_errors_slow - spec2_errors_slow_base;
%     
    coh_correct_fast_bc_all(1:206,1:281,sess) = coh_correct_fast - coh_correct_fast_base;
    coh_correct_slow_bc_all(1:206,1:281,sess) = coh_correct_slow - coh_correct_slow_base;
%     coh_errors_fast_bc_all(1:206,1:281,sess) = coh_errors_fast - coh_errors_fast_base;
%     coh_errors_slow_bc_all(1:206,1:281,sess) = coh_errors_slow - coh_errors_slow_base;
%     
    
    %ALPHA: 1-20 Hz
%     spec1_correct_fast_1_20(sess,1:281) = nanmean(spec1_correct_fast_bc(1:20,:));
%     spec1_correct_slow_1_20(sess,1:281) = nanmean(spec1_correct_slow_bc(1:20,:));
%     spec1_errors_fast_1_20(sess,1:281) = nanmean(spec1_errors_fast_bc(1:20,:));
%     spec1_errors_slow_1_20(sess,1:281) = nanmean(spec1_errors_slow_bc(1:20,:));
%     
%     spec2_correct_fast_1_20(sess,1:281) = nanmean(spec2_correct_fast_bc(1:20,:));
%     spec2_correct_slow_1_20(sess,1:281) = nanmean(spec2_correct_slow_bc(1:20,:));
%     spec2_errors_fast_1_20(sess,1:281) = nanmean(spec2_errors_fast_bc(1:20,:));
%     spec2_errors_slow_1_20(sess,1:281) = nanmean(spec2_errors_slow_bc(1:20,:));
%     
    coh_correct_fast_1_20(sess,1:281) = nanmean(coh_correct_fast_bc(1:20,:));
    coh_correct_slow_1_20(sess,1:281) = nanmean(coh_correct_slow_bc(1:20,:));
%     coh_errors_fast_1_20(sess,1:281) = nanmean(coh_errors_fast_bc(1:20,:));
%     coh_errors_slow_1_20(sess,1:281) = nanmean(coh_errors_slow_bc(1:20,:));
%     
    %LOW GAMMA: 25-45 Hz
%     spec1_correct_fast_25_45(sess,1:281) = nanmean(spec1_correct_fast_bc(25:45,:));
%     spec1_correct_slow_25_45(sess,1:281) = nanmean(spec1_correct_slow_bc(25:45,:));
%     spec1_errors_fast_25_45(sess,1:281) = nanmean(spec1_errors_fast_bc(25:45,:));
%     spec1_errors_slow_25_45(sess,1:281) = nanmean(spec1_errors_slow_bc(25:45,:));
%     
%     spec2_correct_fast_25_45(sess,1:281) = nanmean(spec2_correct_fast_bc(25:45,:));
%     spec2_correct_slow_25_45(sess,1:281) = nanmean(spec2_correct_slow_bc(25:45,:));
%     spec2_errors_fast_25_45(sess,1:281) = nanmean(spec2_errors_fast_bc(25:45,:));
%     spec2_errors_slow_25_45(sess,1:281) = nanmean(spec2_errors_slow_bc(25:45,:));
%     
    coh_correct_fast_25_45(sess,1:281) = nanmean(coh_correct_fast_bc(25:45,:));
    coh_correct_slow_25_45(sess,1:281) = nanmean(coh_correct_slow_bc(25:45,:));
%     coh_errors_fast_25_45(sess,1:281) = nanmean(coh_errors_fast_bc(25:45,:));
%     coh_errors_slow_25_45(sess,1:281) = nanmean(coh_errors_slow_bc(25:45,:));
%     
    %MID/HIGH GAMMA: 40-100 Hz
%     spec1_correct_fast_40_100(sess,1:281) = nanmean(spec1_correct_fast_bc(40:100,:));
%     spec1_correct_slow_40_100(sess,1:281) = nanmean(spec1_correct_slow_bc(40:100,:));
%     spec1_errors_fast_40_100(sess,1:281) = nanmean(spec1_errors_fast_bc(40:100,:));
%     spec1_errors_slow_40_100(sess,1:281) = nanmean(spec1_errors_slow_bc(40:100,:));
%     
%     spec2_correct_fast_40_100(sess,1:281) = nanmean(spec2_correct_fast_bc(40:100,:));
%     spec2_correct_slow_40_100(sess,1:281) = nanmean(spec2_correct_slow_bc(40:100,:));
%     spec2_errors_fast_40_100(sess,1:281) = nanmean(spec2_errors_fast_bc(40:100,:));
%     spec2_errors_slow_40_100(sess,1:281) = nanmean(spec2_errors_slow_bc(40:100,:));
%     
    coh_correct_fast_40_100(sess,1:281) = nanmean(coh_correct_fast_bc(40:100,:));
    coh_correct_slow_40_100(sess,1:281) = nanmean(coh_correct_slow_bc(40:100,:));
%     coh_errors_fast_40_100(sess,1:281) = nanmean(coh_errors_fast_bc(40:100,:));
%     coh_errors_slow_40_100(sess,1:281) = nanmean(coh_errors_slow_bc(40:100,:));
%     
    
    clear spec1_correct_fast spec1_correct_slow spec1_errors_fast spec1_errors_slow ...
        spec2_correct_fast spec2_correct_slow spec2_errors_fast spec2_errors_slow ...
        coh_correct_fast coh_correct_slow coh_errors_fast coh_errors_slow ...
        spec1_correct_fast_base spec1_correct_slow_base spec1_errors_fast_base spec1_errors_slow_base ...
        spec2_correct_fast_base spec2_correct_slow_base spec2_errors_fast_base spec2_errors_slow_base ...
        coh_correct_fast_base coh_correct_slow_base coh_errors_fast_base coh_errors_slow_base ...
        spec1_correct_fast_bc spec1_correct_slow_bc spec1_errors_fast_bc spec1_errors_slow_bc ...
        spec2_correct_fast_bc spec2_correct_fast_bc spec1_errors_fast_bc spec2_errors_slow_bc ...
        coh_correct_fast_bc coh_correct_slow_bc coh_errors_fast_bc coh_errors_slow_bc
end


if plotFlag == 1
    
    %==============
    % Spectra Plot (only signal 1 for now)
    figure
    set(gcf,'color','white')
    orient landscape
    
    subplot(3,1,1)
    plot(1:size(coh_correct_fast_1_20,2),mean(coh_correct_fast_1_20),'r',1:size(coh_correct_slow_1_20,2),mean(coh_correct_slow_1_20),'b',1:size(coh_errors_fast_1_20,2),mean(coh_errors_fast_1_20),'--r',1:size(coh_errors_slow_1_20,2),mean(coh_errors_slow_1_20),'--b','linewidth',2)
    legend('Correct-Fast','Correct-Slow','Errors-Fast','Errors-Slow')
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('1 - 20 Hz','fontsize',14,'fontweight','bold')
    
    subplot(3,1,2)
    plot(1:size(coh_correct_fast_25_45,2),mean(coh_correct_fast_25_45),'r',1:size(coh_correct_slow_25_45,2),mean(coh_correct_slow_25_45),'b',1:size(coh_errors_fast_25_45,2),mean(coh_errors_fast_25_45),'--r',1:size(coh_errors_slow_25_45,2),mean(coh_errors_slow_25_45),'--b','linewidth',2)
    legend('Correct-Fast','Correct-Slow','Errors-Fast','Errors-Slow')
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('25 - 45 Hz','fontsize',14,'fontweight','bold')
    
    subplot(3,1,3)
    plot(1:size(coh_correct_fast_40_100,2),mean(coh_correct_fast_40_100),'r',1:size(coh_correct_slow_40_100,2),mean(coh_correct_slow_40_100),'b',1:size(coh_errors_fast_40_100,2),mean(coh_errors_fast_40_100),'--r',1:size(coh_errors_slow_40_100,2),mean(coh_errors_slow_40_100),'--b','linewidth',2)
    legend('Correct-Fast','Correct-Slow','Errors-Fast','Errors-Slow')
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('40 - 100 Hz','fontsize',14,'fontweight','bold')
    
    [ax,h3] = suplabel('Specra','t');
    set(h3,'FontSize',12,'FontWeight','bold')

    
    
    %=================
    % Coherence plot
    figure
    set(gcf,'color','white')
    orient landscape
    
    subplot(3,1,1)
    plot(1:size(coh_correct_fast_1_20,2),mean(coh_correct_fast_1_20),'r',1:size(coh_correct_slow_1_20,2),mean(coh_correct_slow_1_20),'b',1:size(coh_errors_fast_1_20,2),mean(coh_errors_fast_1_20),'--r',1:size(coh_errors_slow_1_20,2),mean(coh_errors_slow_1_20),'--b','linewidth',2)
    legend('Correct-Fast','Correct-Slow','Errors-Fast','Errors-Slow')
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('1 - 20 Hz','fontsize',14,'fontweight','bold')
    
    subplot(3,1,2)
    plot(1:size(coh_correct_fast_25_45,2),mean(coh_correct_fast_25_45),'r',1:size(coh_correct_slow_25_45,2),mean(coh_correct_slow_25_45),'b',1:size(coh_errors_fast_25_45,2),mean(coh_errors_fast_25_45),'--r',1:size(coh_errors_slow_25_45,2),mean(coh_errors_slow_25_45),'--b','linewidth',2)
    legend('Correct-Fast','Correct-Slow','Errors-Fast','Errors-Slow')
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('25 - 45 Hz','fontsize',14,'fontweight','bold')
    
    subplot(3,1,3)
    plot(1:size(coh_correct_fast_40_100,2),mean(coh_correct_fast_40_100),'r',1:size(coh_correct_slow_40_100,2),mean(coh_correct_slow_40_100),'b',1:size(coh_errors_fast_40_100,2),mean(coh_errors_fast_40_100),'--r',1:size(coh_errors_slow_40_100,2),mean(coh_errors_slow_40_100),'--b','linewidth',2)
    legend('Correct-Fast','Correct-Slow','Errors-Fast','Errors-Slow')
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('40 - 100 Hz','fontsize',14,'fontweight','bold')

    
    [ax,h3] = suplabel('Coherence','t');
    set(h3,'FontSize',12,'FontWeight','bold')
end
