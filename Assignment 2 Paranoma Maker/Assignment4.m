I1 = imread('image1.jpg');
I1=imresize(I1,0.2);
I2 = imread('image2.jpg');
I2=imresize(I2,0.2);
image1 = imageStitch(I1,I2);
figure()
imshow(image1);
I3 = imread('image0.jpg');
I3=imresize(I3,0.2);
image1 = imageStitch(I3,image1);
figure()
imshow(image1);