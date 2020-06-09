multi_layer_net_cifar10.layers{end} = struct('type', 'softmax') ;
accurate =0;
for i=50001:51000
    Original=imdb.images.data(:,:,:,i);
    transform = [0,-1,2;1,0,2;0,0,1];
    tform= maketform('affine',transform');
    Rotated = imtransform(Original,tform,'XData',[1 size(Original,2)],'YData',[1 size(Original,1)]);
    cropped = zeros(32,32,3);
    cropped = Rotated(1:32,1:32,:);
    res = vl_simplenn(multi_layer_net_cifar10,cropped);
    scores = squeeze(gather(res(end).x));
    [~,ind1] = max(scores);
    res = vl_simplenn(multi_layer_net_cifar10,Original);
    scores = squeeze(gather(res(end).x));
    [~,ind2] = max(scores);
    if ind1 == ind2
        accurate = accurate +1;
    end
end
accuracy = (accurate/1000)*100;