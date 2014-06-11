% Neural network toolbox example. 
% working through example at: http://www.znu.ac.ir/data/members/fazli_saeid/ANN/matlab4.pdf
%
% RPH

% net = network;
% net.numInputs = 1; %single input layer
% net.inputs{1}.size = 2; %two neurons in the input layer
% net.numLayers = 2; %2 layer network (input layer assumed, so 1 output and 1 hidden layer)
% net.layers{1}.size = 3; %hidden layer with 3 neurons
% net.layers{2}.size = 1; %output layer with 1 neuron
% 
% net.inputConnect(1) = 1; %connect the input layer to the network
% net.layerConnect(2,1) = 1; %connect to i the layer j; thus, connect input layer 1 to hidden layer 2
% net.outputConnect(2) = 1; %connect the output layer to the network
% net.targetConnect(2) = 1; %specify the target layer as the output layer
% 
% % Transfer functions
% net.layers{1}.transferFcn = 'logsig'; % hidden layer will use sigmoid transfer function
% net.layers{2}.transferFcn = 'purelin'; % output layer will use linear transfer fucntion
% 
% % Handle biases
% net.biasConnect = [ 1 ; 1];
% 
% % Initialize weights and biases 
% net = init(net); %default
% 
% % Initialization routine
% net.initFcn = 'initlay'; %default initialization function
% net.layers{1}.initFcn = 'initnw'; %Use Nguyen-Widrow initialisation function
% net.layers{2}.initFcn = 'initnw'; %Use Nguyen-Widrow initialisation function
% 
% % Training function
% net.trainFcn = 'traingdm'; %Gradient descent with momentum
% net.trainParam.lr = 0.1; %learning rate
% net.trainParam.mc = 0.9; %momentum term
% train(net)



p = -2:.1:2;
t = sin(pi*p/2);
net = feedforwardnet;
net1 = configure(net,p,t); %configure feed-forward network with example inputs and target states