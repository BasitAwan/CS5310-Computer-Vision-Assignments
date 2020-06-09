function [net, opts] = create_single_layer_nn()
% In this function we'll create a single layer neural network with 100
% nodes in hidden layer and a softmax layer as the output.

% Lets start defining the network
opts.networkType = 'simplenn' ;

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;

% Our first and only hidden layer
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(28,28,1,100, 'single'), zeros(1, 100, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
% Our ourput layer
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(1,1,100,10, 'single'), zeros(1,10,'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
% Loss layer
net.layers{end+1} = struct('type', 'softmaxloss') ;

% Training Parameters
% Meta parameters
net.meta.inputSize = [28 28 1] ;
net.meta.trainOpts.learningRate = 0.0001 ;
net.meta.trainOpts.numEpochs = 10;
net.meta.trainOpts.batchSize = 100 ;

% Fill in defaul values
net = vl_simplenn_tidy(net) ;

end