name = multi_layer_net_cifar10;
name.layers{end} = struct('type', 'softmax') ;
predict = zeros(1,size(imdb.images.data,4));
known = imdb.images.labels(:,:);
for i=1:size(imdb.images.data,4)
    Original=imdb.images.data(:,:,:,i);
    res = vl_simplenn(name,Original);
    scores = squeeze(gather(res(end).x));
    [~,ind] = max(scores)
    predict(i) = ind-1;
end
C = confusionmat(known,predict);
imagesc(double(C))