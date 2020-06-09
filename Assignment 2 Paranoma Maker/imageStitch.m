function final = imageStitch(image1,image2)
Corners1 = cornerFinder(image1);
Corners2 = cornerFinder(image2);
temp= sortrows(Corners1,2,'descend');
Corners1 = temp(1:30,:);
temp= sortrows(Corners2,2);
start =1;
for start=1:100
    if temp(start)~=1
        break;
    end
end
Corners2 = temp(min(start,71):min(start+29,100),:);
figure()
I1=image1;
imshow(I1);
hold on;
plot(Corners1(:,2), Corners1(:,1), 'r.', 'LineWidth', 2, 'MarkerSize', 15);
figure()

I2=image2;
imshow(I2);
hold on;
plot(Corners2(:,2), Corners2(:,1), 'b.', 'LineWidth', 2, 'MarkerSize', 15);
I1 = image1;
I1 = rgb2gray(I1);
I2 = image2;
I2 = rgb2gray(I2);
costMat = zeros(30);
grid=8;
for i = 1:30
    for j = 1:30
        x = Corners1(i,1);
        y = Corners1(i,2);
        if(x==1||y==1)
            costMat(i,j)=999999999999999999;
            continue;
        end
        STX = max(x-grid,1);
        EDX = x+grid;
        STY = max(y-grid,1);
        EDY = y+grid;
        f_patch = double(I1(STX:EDX,STY:EDY));
        x = Corners2(j,1);
        y = Corners2(j,2);
        STX = max(x-grid,1);
        EDX = x+grid;
        STY = max(y-grid,1);
        EDY = y+grid;
        s_patch = double(I2(STX:EDX,STY:EDY));
        if(x==1||y==1)
            costMat(i,j)=0;
            continue;
        end
        costMat(i,j) = norm(f_patch-s_patch,2);
    end
end
[matches,cost]=munkres(costMat);
tempCorners = Corners1;
for i=1:30
     Corners1(i,:) = tempCorners(matches(i),:);
end
[H,inliers] = ransacfithomography(Corners1', Corners2', 0.01);
H=inv(H);
I1 = image1;
I2 = image2;

Left1 = H*[1;1;1];
Left1 = Left1./Left1(3);
Left2 = H*[454;1;1];
Left2 = Left2./Left2(3);
right1 = H*[454;807;1];
right1 = right1./right1(3);
right2 = H*[1;807;1];
right2 = right2./right2(3);

corners = [1,1;1,size(I1,2);size(I1,1),1;size(I1,1),size(I1,2);
    Left1(1),Left1(2);Left2(1),Left2(2);right1(1),right1(2);right2(1),right2(2)];
dim = max(corners);
final = zeros(round(dim(1)),round(dim(2)),3);
final= uint8(final);
final(1:size(I1,1),1:round(size(I1,2)*0.7),1:3)= I1(:,1:round(size(I1,2)*0.7),:);
H = inv(H);
for i= 1:size(final,1)
    for j=1:size(final,2)
        if final(i,j)==0
            new = H*[i;j;1];
            new = new./new(3);
            new= round(new);
            if (new(1)<1 || new(2)<1 || new(1)>size(I2,1) || new(2)>size(I2,2))
                continue;
            end
            final(i,j,:) = I2(new(1),new(2),:);
        end
    end
end



        
        
        
        