%get model input
    %Pooled data set information
        cells_to_use=[1,6,7,10:14,22,24,29,1,2,4,1,2,3,5,6,7,1:4];
        mletter_list={'F','F','F','F','F','F','F','F','F','F','F','L','L','L','MM','MM','MM','MM','MM','MM','MC','MC','MC','MC'};
        num_trls_all=768;
        numTE=171;
        numTH=193;
        numDE=349;
        numDH=304;
        col=2000;

    %initialize
        counter=1;
        Spikes_temp=zeros(num_trls_all,col,length(cells_to_use));
        RTvector_temp=zeros(num_trls_all,length(cells_to_use));
        Target_temp=zeros(num_trls_all,length(cells_to_use));
        Saccade_temp=zeros(num_trls_all,length(cells_to_use));
        TrialStart_temp=zeros(num_trls_all,length(cells_to_use));
        T_in_EC_temp=zeros(numTE,length(cells_to_use));
        T_in_HC_temp=zeros(numTH,length(cells_to_use));
        D_in_EC_temp=zeros(numDE,length(cells_to_use));
        D_in_HC_temp=zeros(numDH,length(cells_to_use));
        maxSDFactivity_temp=zeros(1,length(cells_to_use));
        
    for cell=cells_to_use  
        %load data
        mletter=char(mletter_list(counter));
        load(['Data/CELL_',mletter,num2str(cell),'.mat'])
        
        %sort
        Spikes_temp(:,:,counter)=Spikes;
        RTvector_temp(:,counter)=RTvector;
        Target_temp(:,counter)=Target;
        Saccade_temp(:,counter)=Saccade;
        TrialStart_temp(:,counter)=TrialStart;
        T_in_EC_temp(:,counter)=T_in_EC;
        T_in_HC_temp(:,counter)=T_in_HC;
        D_in_EC_temp(:,counter)=D_in_EC;
        D_in_HC_temp(:,counter)=D_in_HC;
        maxSDFactivity_temp(counter)=maxSDFactivity;
        counter=counter+1;
    end


%rename
        Spikes=Spikes_temp;
        RTvector=RTvector_temp;
        Target=Target_temp;
        Saccade=Saccade_temp;
        TrialStart=TrialStart_temp;
        T_in_EC=T_in_EC_temp;
        T_in_HC=T_in_HC_temp;
        D_in_EC=D_in_EC_temp;
        D_in_HC=D_in_HC_temp;
        maxSDFactivity=maxSDFactivity_temp;


clear T_in_EE T_in_HE D_in_EE D_in_DE Spikes_temp RTvector_temp Target_temp Saccade_temp TrialStart_temp T_in_EC_temp T_in_HC_temp D_in_EC_temp D_in_HC_temp maxSDFactivity_temp
