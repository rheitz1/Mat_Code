% Code to run versions of the models presented in Purcell, Heitz, Cohen, 
% Logan, Schall, & Palmeri.  Neurally Constrained Modeling of
% Perceptual Decision Making.  Psychological Review.  In Press.
% 
% This code operates on the 'Pooled' data set only.  Default is 1000
% simulated trials of the Gated Race Model (parameters from Table 2).
% 
% Plots (1) Observed and Predicted RTs (2) Average model inputs (3) Average
% from a sample of model trajectories
% 
% IMPORTANT: This code cannot operate without the data files that should be
% located in the folder \Data in the current directory.
% 
% In addition, the following files are necssary for this code to run:
% mod_spikedensityfunct.m
% model.m
% GetModelInput.m
% PlotModelOutputPublic.m
% 
% Code written by: Braden Purcell (braden.a.purcell@vanderbilt.edu)
% Date: April 5, 2010
% 
% We regret that we cannot support this code in any way.

   

clear all; close all;

%%%%%%%%
%OPTIONS
%%%%%%%%

    %Specify parameters (default are best-fitting parameters for Gated Race Model, see Table 2) 
        N=22;%sample size
        theta=17.18;%threshold
        tballistic=15.03;%post-decision time
        k=0.0003;%leakage
        g=0.5782;%gate
        beta=0;%lateral inhibition (0 for race, 0 for diffusion, >0 for competitive)
        u=0;%feed-forward inhibition (0 for race, 1 for diffusion, 0 for competitive)

    %simulation options
        nSims = 1000;%5000 used for all simulations in paper
        diff_start = 200;%200

%%%%%%%%%
%%%%%%%%%
    
    
%default seed
rand('twister',5489)
randn('state',1) 
    
%load Pooled dataset
GetModelInput

%Loop through easy and hard conditions (2=easy, 3=hard)
for easy_hard=[2 3]
     
     %random sample groups of trials before starting simulations
     %sample size = N, number of simulations = nSims, Tin=target in RF,
     %Din=distractor in RF
            %randomly sample cells in the population with replacement
                random_cell_samples_Tin = zeros(N,nSims);
                for i = 1:N
                    random_cell_samples_Tin(i,:) = randsample(length(cells_to_use),nSims,true);
                end
                %use the same cells for Target in RF and Distractor in RF
                random_cell_samples_Din=random_cell_samples_Tin;
              
            %replace each cell number with a T-in or D-in trial for that cell
                %Target in RF
                random_Tin_samples = zeros(size(random_cell_samples_Tin));
                for cell = 1:length(cells_to_use)
                    ki = find(random_cell_samples_Tin==cell);
                        if easy_hard==2
                            T_in_list = randsample(nonzeros(T_in_EC(:,cell)),length(ki),true);
                        elseif easy_hard==3
                            T_in_list = randsample(nonzeros(T_in_HC(:,cell)),length(ki),true);
                        end
                    random_Tin_samples(ki) = T_in_list;
                end
                %Distractor in RF
                random_Din_samples = zeros(size(random_cell_samples_Tin));
                for cell = 1:length(cells_to_use)
                    ki = find(random_cell_samples_Din==cell);
                        if easy_hard==2
                            D_in_list = randsample(nonzeros(D_in_EC(:,cell)),length(ki),true);
                        elseif easy_hard==3
                            D_in_list = randsample(nonzeros(D_in_HC(:,cell)),length(ki),true);
                        end
                    random_Din_samples(ki) = D_in_list;
                end
   
         %initialize variables to generate SDFs for model input
                time_index = -500:1000;
                SDF_in_matrix=zeros(nSims,length(time_index));
                SDF_out_matrix=zeros(nSims,length(time_index));
                Plot_Time = [-500 1000];
                Spikes_Tin = zeros(N,col);
                Spikes_Din = zeros(N,col);
                Target_Tin = zeros(N,1);
                Target_Din = zeros(N,1);
                TrialStart_Tin = zeros(N,1);
                TrialStart_Din = zeros(N,1);
                maxSDFactivity_reciprocal_Tin = zeros(N,1);
                maxSDFactivity_reciprocal_Din = zeros(N,1);
                RTobs_vector_in = zeros(N,nSims);
                RTobs_vector_out = zeros(N,nSims);
     
        %begin generating SDFs for model input 
            for n = 1:nSims
                %initialize
                    cell_vector_Tin = random_cell_samples_Tin(:,n);
                    cell_vector_Din = random_cell_samples_Din(:,n);
                    Tin_trials = random_Tin_samples(:,n);
                    Din_trials = random_Din_samples(:,n);
                    
                %get data from each simulation
                    for i = 1:N
                        %save spike data for current simulation in trial x spikes matrix
                            Spikes_Tin(i,:) = Spikes(Tin_trials(i),:,cell_vector_Tin(i));
                            Spikes_Din(i,:) = Spikes(Din_trials(i),:,cell_vector_Din(i));
                        %save RTs
                            RTobs_vector_in(i,n) = RTvector(Tin_trials(i),cell_vector_Tin(i));
                            RTobs_vector_out(i,n) = RTvector(Din_trials(i),cell_vector_Din(i));
                        %save Target_
                            Target_Tin(i) = Target(Tin_trials(i),cell_vector_Tin(i));%align on target onset
                            Target_Din(i) = Target(Din_trials(i),cell_vector_Din(i));%align on target onset
                        %save TrialStart_
                            TrialStart_Tin(i) = TrialStart(Tin_trials(i),cell_vector_Tin(i));
                            TrialStart_Din(i) = TrialStart(Din_trials(i),cell_vector_Din(i));
                        %save max activity for each cell
                            maxSDFactivity_reciprocal_Tin(i) = 1/maxSDFactivity(cell_vector_Tin(i));
                            maxSDFactivity_reciprocal_Din(i) = 1/maxSDFactivity(cell_vector_Din(i));
                    end
                %get SDFs
                    [SDF_in] = mod_spikedensityfunct(Spikes_Tin, Target_Tin, Plot_Time, [1:N], TrialStart_Tin,maxSDFactivity_reciprocal_Tin,RTobs_vector_in,0,0,1);
                    [SDF_out] = mod_spikedensityfunct(Spikes_Din, Target_Din, Plot_Time, [1:N], TrialStart_Din,maxSDFactivity_reciprocal_Din,RTobs_vector_out,0,0,1);
                %save in matrix
                    SDF_in_matrix(n,:)=SDF_in;
                    SDF_out_matrix(n,:)=SDF_out;
            end%simulation loop
    
    %Model
        %generate Gaussian noise vectors (SD=0.2)
            noiseT=randn([nSims,length(Plot_Time(1):Plot_Time(2))])*0.2;
            noiseD=randn([nSims,length(Plot_Time(1):Plot_Time(2))])*0.2;  

        %initialize for model runs
            Tin_SDF = zeros(1,length(time_index));
            Din_SDF = zeros(1,length(time_index));
            traj_matrix_T = zeros(nSims,length(time_index));
            traj_matrix_D = zeros(nSims,length(time_index));
            RTpred=zeros(1,nSims);
            correct_vector=zeros(1,nSims);
            no_response=0;
            correct_response=0;
            error_response=0;
            
        %run model
            for n = 1:nSims
                %get trajectories
                    Tinput = SDF_in_matrix(n,:);
                    Dinput = SDF_out_matrix(n,:);
                    Tinput(1:diff_start) = 0;%remove input prior to diff_start
                    Dinput(1:diff_start) = 0;
                %run model
                     [RT,response,Tunit,Dunit]=model(Tinput,Dinput,diff_start,time_index,theta,tballistic,k,g,beta,noiseT(n,:),noiseD(n,:),u);
                %save trajectories and RT
                    RTpred(n)=RT;
                    correct_vector(n)=response;
                    traj_matrix_T(n,1:length(Tunit))=Tunit;
                    traj_matrix_D(n,:)=Dunit;
            end%simulation loop
            
       
    %Get RT distributions
        %initialize
                RTobs_correct=[];
        %get RTs for each cell used
            for cell = 1:length(cells_to_use)
                if easy_hard==2
                    trials_temp=[nonzeros(T_in_EC(:,cell));nonzeros(D_in_EC(:,cell))];
                elseif easy_hard==3
                    trials_temp=[nonzeros(T_in_HC(:,cell));nonzeros(D_in_HC(:,cell))];
                end
                    RTobs_correct_temp = RTvector(trials_temp,cell);
                    RTobs_correct = [RTobs_correct;RTobs_correct_temp];
            end

        %Get predicted correct trial RT distribution
            RTpred_correct=RTpred(correct_vector==1);
            traj_matrix_T=traj_matrix_T(correct_vector==1,:);
            traj_matrix_D=traj_matrix_D(correct_vector==1,:);

        %sort
            [RTpred_sorted,index]=sort(RTpred_correct);
            traj_matrix_T=traj_matrix_T(index,:);
            traj_matrix_D=traj_matrix_D(index,:);    

    %Get CDFs
        %observed
            RTobs_hist=hist(RTobs_correct,-500:1000);
            RTobs_cdf=cumsum(RTobs_hist)/length(RTobs_correct);
        %predicted
            RTpred_hist=hist(RTpred_correct,-500:1000);
            RTpred_cdf=cumsum(RTpred_hist)/length(RTpred_correct);%note that we're plotting the cdf without consideration for errors
        %save cdf
            if easy_hard==2
                temp_RTpred_cdf.easy=RTpred_cdf;
                temp_RTobs_cdf.easy=RTobs_cdf;
            elseif easy_hard==3
                temp_RTpred_cdf.hard=RTpred_cdf;
                temp_RTobs_cdf.hard=RTobs_cdf;
           end
    
end%easy_hard loop

%rename
RTpred_cdf=temp_RTpred_cdf;clear temp_RTpred_cdf
RTobs_cdf=temp_RTobs_cdf;clear temp_RTpred_cdf


%%%
%PLOTS
%%%
%(1) Observed/Predicted CDFs for easy and hard condition
%(2) Average model input
%(3) Average sample of 10 trajectories (sampled at median)
PlotModelOutputPublic

             