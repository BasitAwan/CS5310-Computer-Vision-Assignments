%%
clearvars; close all; clc;

data_dir = '../data/CIFAR10/cifar-10-batches-mat/';

files_list = { 'data_batch_1', 'data_batch_2', 'data_batch_3', 'data_batch_4', 'data_batch_5', 'test_batch', 'batches.meta'};

imdb.images = [];
images_ = zeros(32, 32, 3, 60000);
labels_ = zeros(1, 60000);

data_mean_ = double(zeros(32,32,3));

for ii = 1:numel(files_list)-1
    file_path = [data_dir files_list{ii} '.mat'];
    load(file_path);
    for jj = 1:size(data,1)
        im_ = reshape( data(jj,:), [32,32,3] );
        im_ = imrotate(im_, -90);
        data_mean_ = data_mean_ + double(im_);
        labels_(1, (ii-1)*10000+jj) = labels(jj);
        images_(:,:,:, (ii-1)*10000+jj) = uint8(im_);
    end
end

data_mean = data_mean_ ./ 60000;

set_ = zeros(1,50000) + 1;
set_(1, end+1:end+10000) = 3;
%%

images.data = single(double(images_) - double(repmat(data_mean, 1,1,1,60000)));
images.data_mean = single(data_mean);
images.labels = double(labels_);
images.set = double(set_);

meta.sets = {'train', 'val', 'test'};
meta.classes = {0;1;2;3;4;5;6;7;8;9};
save('../data/CIFAR10/imdb.mat', 'images', 'meta');