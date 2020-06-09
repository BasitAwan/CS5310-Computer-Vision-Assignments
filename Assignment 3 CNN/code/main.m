%% Introduction
% This is the starter code for Assignment#06 titled "Classification using CNN" of
% course CS436 being offered at LUMS in summer 2017.
% 
% The code is provided at it is and may contain errors/bugs. 
% Please contact sohaib@lums.edu.pk for suggestion/issues/bug-reports.

% Goals:
%   The goal of this assignment is to code and/or get familiar and/or
%   compare Convolutional Neural Network using MNIST Hand-written-digits
%   and CIFAR-10 datasets and MATCONVNET library.

%% Setup
clearvars; close all; clc; warning off all;
compile = 0;

% Path of DL Library
% We are going to use MATCONVNET-a matlab based library for Deep Learning, 
% developed by VLFEAT and is available at http://www.vlfeat.org/matconvnet/
matconvnet_dir = '../matconvnet-1.0-beta24/';
addpath(genpath(matconvnet_dir));
run([matconvnet_dir '/matlab/vl_setupnn']);

if compile
    % Lets compile MATCONVNET
    vl_compilenn;
    run([matconvnet_dir '/matlab/vl_setupnn']);

    % At this point MatConvNet should start compiling.
    % If all goes well, you are ready to use the library.
    % If not, you can try debugging the problem by running the 
    % compilation script again in verbose mode:
    % vl_compilenn('verbose', 1);
    % Increase the verbosity level to 2 to get even more information.

    % At this point the library is ready to use.
    % You can test it by using the command (using MATLAB R2014a or later):
    vl_testnn;
    % After this command, a line similar to the following should appear at the
    % matlab command terminal
    % Totals:
    %   1673 Passed, 0 Failed, 0 Incomplete.
    %   139.3606 seconds testing time.
    %
    % If all tests are passed then its great, in some cases 1-2 errors may fail,
    % that is fine too. If more than 2 tests fail there is some issue with your
    % machine setup and you have to debug and recompile the matconvnet.
    %
    % For Linux users; if you are facing libstdc++.so.* issue please check the
    % following linkfor a solution: https://github.com/vlfeat/matconvnet/issues/770
    % 
end
%% Setup Datasets

% Path of our dataset directory
data_dir = '../data';
%--------------------------------------------------------------------------
% Lets select and load the dataseet we are going to use.
% THE FOLLOWINNG VARIABLE CAN TAKE TWO VALUES; 'mnist' or 'CIFAR10' 
dataset = 'CIFAR10'; %'mnist'; %
data_path = [data_dir '/' dataset '/imdb.mat'];
%--------------------------------------------------------------------------
imdb = load(data_path);

%% 0. Warm Up: Visualize dataset
WarmUp = 0;
if WarmUp
    % Get random indices
    im_idx = randi(size(imdb.images.data,4), 100, 1);

    % Lets plot randomly chosen images
    figure('Name', 'Visualize Dataset');
    for ii = 1:size(im_idx)
        im_ = imdb.images.data(:,:,:,ii);
        subplot(10, 10, ii); imagesc(double(im_)); axis equal;
    end
end
% MNIST data deletion
% imdb1= imdb;
% imdb1.images.data = imdb.images.data(:,:,:,1:5000);
% imdb1.images.data(:,:,:,5001:15000) = imdb.images.data(:,:,:,60001:70000);
% imdb1.images.labels = imdb.images.labels(:,1:5000);
% imdb1.images.labels(:,5001:15000)= imdb.images.labels(:,60001:70000);
% imdb1.images.set = imdb.images.set(:,1:5000);
% imdb1.images.set(:,5001:15000)= imdb.images.set(:,60001:70000);
% imdb = imdb1;
%CIFAR10 data deletion
% imdb1= imdb;
% imdb1.images.data = imdb.images.data(:,:,:,1:5000);
% imdb1.images.data(:,:,:,5001:15000) = imdb.images.data(:,:,:,50001:60000);
% imdb1.images.labels = imdb.images.labels(:,1:5000);
% imdb1.images.labels(:,5001:15000)= imdb.images.labels(:,50001:60000);
% imdb1.images.set = imdb.images.set(:,1:5000);
% imdb1.images.set(:,5001:15000)= imdb.images.set(:,50001:60000);
% imdb = imdb1;

% %% 1. Training a Single Layer Network on MNIST
% if strcmp(dataset, 'mnist')
%     % Lets create a single layer neural network with 100 hidden layers and
%     % a softmax function at the end.
%     [single_layer_net, opts] = create_single_layer_nn();
%     [single_layer_net, info] = cnn_train(single_layer_net, imdb, getBatch(opts), 'expDir', [data_dir '/' dataset '/SingleLayer'], single_layer_net.meta.trainOpts, struct(), 'val', find(imdb.images.set == 3)) ;
% end
    
% %code to display all hundred weights
% figure('Name', 'Visualize Weights1');
% a=single_layer_net.layers{1, 1}.weights{1, 1}  ;
% for ii = 1:100
%     subplot(10, 10, ii); imagesc(a(:,:,:,ii)); axis equal;
% end
% %code to display five hundred weights
% figure('Name', 'Visualize Weights1_20');
% a=single_layer_net.layers{1, 1}.weights{1, 1}  ;
% for ii = 1:25
%     subplot(5, 5, ii); imagesc(a(:,:,:,38+ii)); axis equal;
% end


%% 2. Training a Multi-Layer Network on MNIST
if strcmp(dataset, 'mnist')
    % Lets create a multi-layer CNN with following architecture
    % InputLayer(28x28x1)-->ConvolutionalLayer(5x5x20)-->MaxPooling(2x2)
    % -->ConvolutionalLayer(5x5x50)-->MaxPooling(2x2)-->FullyConnected-->RELU
    % NonLinearity -->Classifier(10-classes)
    [multi_layer_net_mnist, opts] = create_multiple_layer_nn();
    [multi_layer_net_mnist, info] = cnn_train(multi_layer_net_mnist, imdb, getBatch(opts), 'expDir', [data_dir '/' dataset '/MultiLayer'], multi_layer_net_mnist.meta.trainOpts, struct(), 'val', find(imdb.images.set == 3)) ;
end
% figure('Name', 'Visualize Weights2');
% a=multi_layer_net_mnist.layers{1, 1}.weights{1, 1}  ;
% for ii = 1:20
%     im_ = imdb.images.data(:,:,:,ii);
%     subplot(5, 4, ii); imagesc(a(:,:,:,ii)); axis equal;
% end
%% 3. Training a Multi-Layer Network on CIFAR-10
if strcmp(dataset, 'CIFAR10')
    % Lets create a multi-layer CNN with following architecture
    % InputLayer(28x28x1)-->ConvolutionalLayer(5x5x20)-->MaxPooling(2x2)
    % -->ConvolutionalLayer(5x5x50)-->MaxPooling(2x2)-->FullyConnected-->RELU NonLinearity
    % -->Classifier(10-classes)
    [multi_layer_net_cifar10, opts] = create_multiple_layer_nn_cifar10();
    [multi_layer_net_cifar10, info] = cnn_train(multi_layer_net_cifar10, imdb, getBatch(opts), 'expDir', [data_dir '/' dataset '/MultiLayer'], multi_layer_net_cifar10.meta.trainOpts, struct(), 'val', find(imdb.images.set == 3)) ;
end

figure('Name', 'Visualize Weights3');
a=multi_layer_net_cifar10.layers{1, 1}.weights{1, 1}  ;
for ii = 1:20
    im_ = imdb.images.data(:,:,:,ii);
    subplot(4, 5, ii); imagesc(double(a(:,:,:,ii))); axis equal;
end

% --------------------------------------------------------------------
function fn = getBatch(opts)
% --------------------------------------------------------------------
    switch lower(opts.networkType)
      case 'simplenn'
        fn = @(x,y) getSimpleNNBatch(x,y) ;
      case 'dagnn'
        bopts = struct('numGpus', numel(opts.train.gpus)) ;
        fn = @(x,y) getDagNNBatch(bopts,x,y) ;
    end
end

% --------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% --------------------------------------------------------------------
    images = imdb.images.data(:,:,:,batch) ;
    labels = imdb.images.labels(1,batch) ;
end










