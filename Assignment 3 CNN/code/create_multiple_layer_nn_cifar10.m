function [net, opts] = create_multiple_layer_nn_cifar10()
% In this function we'll create a multilayer neural network with following
% architecture
% InputLayer(28x28x1)-->ConvolutionalLayer(5x5x20)-->MaxPooling(2x2)
% -->ConvolutionalLayer(5x5x50)-->MaxPooling(2x2)-->FullyConnected-->RELU NonLinearity
% -->Classifier(10-classes)


% Lets start defining the network
opts.networkType = 'simplenn' ;

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;
opts.weightDecay = 0.0005;

% First Conv Layer -->ConvolutionalLayer(5x5x20)
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,3,20, 'single'), zeros(1, 20, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;

                       
% First Pool Layer -->MaxPooling(2x2)
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
                       
% Second Conv Layer -->ConvolutionalLayer(5x5x50)
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,20,50, 'single'), zeros(1, 50, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;

                       
% Second Pool Layer -->MaxPooling(2x2)
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;

% First Fully Connected Layer-->FullyConnected                   
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,50,500, 'single'),  zeros(1,500,'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;

% First ReLU Layer -->RELU NonLinearity                     
net.layers{end+1} = struct('type', 'relu') ;

% Classifier Layer -->Classifier(10-classes)                     
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(1,1,500,10, 'single'), zeros(1,10,'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
                       
% Loss Function                     
net.layers{end+1} = struct('type', 'softmax') ;

% Training Parameters
% Meta parameters
net.meta.inputSize = [32 32 1] ;
net.meta.trainOpts.learningRate = 0.00005;
net.meta.trainOpts.numEpochs = 50 ;
net.meta.trainOpts.batchSize = 100 ;

% Fill in defaul values
net = vl_simplenn_tidy(net) ;
end