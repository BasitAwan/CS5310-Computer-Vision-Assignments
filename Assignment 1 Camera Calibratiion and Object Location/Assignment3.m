load imagePoints %Image points loaded from set of data I already marked
A = imagePoints; 
t1 = A(:,1);t2 = A(:,2);A(:,1) = t2;A(:,2) = t1;
imagePoints = A; %Swapping y axis and x axis as matlab does not follow image convention

worldPoints = [0,1,2,3,4,4,4,4,4,0,0,0,0,1,2,3,4,4,4,4,4,4,4,4,4,4,4,0,0,0,0,1,2,3;
                0,0,0,0,0,1,2,3,4,0,0,0,0,0,0,0,0,1,2,3,4,0,0,0,4,4,4,1,2,3,4,4,4,4;
                0,0,0,0,0,0,0,0,0,1,2,3,4,4,4,4,4,4,4,4,4,1,2,3,1,2,3,4,4,4,4,4,4,4];
            %WorldPoints I manually entered
            
worldPoints=worldPoints'; % made both points in a similar form

worldPoints = worldPoints *(66/4); %converting worldpoint cordinate to mm

%Converting the points into A, as discuessed in class
A = [worldPoints(1,1), worldPoints(1,2),worldPoints(1,3), 1, 0,0,0,0,(-imagePoints(1,1))*worldPoints(1,1),(-imagePoints(1,1))*worldPoints(1,2),(-imagePoints(1,1))*worldPoints(1,3),(-imagePoints(1,1));
    0,0,0,0,worldPoints(1,1), worldPoints(1,2),worldPoints(1,3), 1, (-imagePoints(1,2))*worldPoints(1,1),(-imagePoints(1,2))*worldPoints(1,2),(-imagePoints(1,2))*worldPoints(1,3),(-imagePoints(1,2))];
for i=  2:34
    A = [A;worldPoints(i,1), worldPoints(i,2),worldPoints(i,3), 1, 0,0,0,0,(-imagePoints(i,1))*worldPoints(i,1),(-imagePoints(i,1))*worldPoints(i,2),(-imagePoints(i,1))*worldPoints(i,3),(-imagePoints(i,1));
        0,0,0,0,worldPoints(i,1), worldPoints(i,2),worldPoints(i,3), 1, (-imagePoints(i,2))*worldPoints(i,1),(-imagePoints(i,2))*worldPoints(i,2),(-imagePoints(i,2))*worldPoints(i,3),(-imagePoints(i,2))];
end

%Found the NULL vector through SVD, by finding the last column of V
[U,S,V] = svd(A);
P= V(:,end);
P= [P(1:4,:)';P(5:8,:)';P(9:12,:)'];
worldPoints = worldPoints'; %Converting the worldPoints into column vectors form.
worldPoints = [worldPoints;ones(1,34)]; %converting world points into P3 space
imagePoint1 = P*worldPoints;
c = imagePoint1;
c(1,:) = c(1,:)./c(3,:);
c(2,:) = c(2,:)./c(3,:);
c(3,:) = c(3,:)./c(3,:);
imagePoint1 = c;
imagePoints = imagePoints';%Converting the imagePoints into column vectors form.
imagePoints = [imagePoints;ones(1,34)];%converting imagepoints into P3 space
Error=norm(imagePoint1-imagePoints,2)/34

figure()
myImage = imread('cube.jpg');
imshow(myImage);
hold on;
plot(imagePoints(2,:), imagePoints(1,:), 'r.', 'LineWidth', 2, 'MarkerSize', 15);
plot(imagePoint1(2,:), imagePoint1(1,:), 'b.', 'LineWidth', 2, 'MarkerSize', 15);


%part c
c = null(P);

c = c/c(4,1); %normalize c

[K, R] = rq(P(1:3,1:3))
if det(R)<0 
    R = -R
    K= -K
end
figure()
 plot3(worldPoints(1,:), worldPoints(2,:),worldPoints(3,:), 'r.', 'LineWidth', 2, 'MarkerSize', 15);
 hold on;
 cam = [0,0,0;1,1,1;1,-1,1; 0,0,0;-1,1,1;1,1,1;0,0,0;-1,-1,1;-1,1,1;-1,-1,1;1,-1,1];
 cam = -cam*20; %Made the opening in the opposite direction so the opening faces the cube. 
 Cam = (R'*cam')+c(1:3,:);
 plot3(Cam(1,:),Cam(2,:),Cam(3,:));


%part d
K= K/K(3,3);
m_x = 5184/22.3;
m_y = 3456/14.9;

f1 = abs(K(1,1))/m_x;
f2 = abs(K(2,2))/m_y;
f= (f1+f2)/2

u = [K(:,1)];
v = [K(:,2)];
CosTheta = dot(u,v)/(norm(u)*norm(v));
AngleBetweenAxis = acosd(CosTheta); %calculating the angle between x axis and y axis

%part e
figure()
myImage = imread('cube.jpg');
imshow(myImage);
hold on;
plot(K(2,3),K(1,3),'g*' ,'LineWidth', 2, 'MarkerSize', 15);
[y1,x1,~] = size(myImage)
plot(x1/2,y1/2,'r*' ,'LineWidth', 2, 'MarkerSize', 15);

%part f
X_inf = P(1:3,1); %Found point at infinity along the x-axis
d = X_inf; %normalized it, should probably make a function for next assignment
d(1,:) = d(1,:)./d(3,:);d(2,:) = d(2,:)./d(3,:);d(3,:) = d(3,:)./d(3,:);X_inf = d;
Y_inf = P(1:3,2);%Found point at infinity along the y-axis
d = Y_inf;%Normalized it
d(1,:) = d(1,:)./d(3,:);d(2,:) = d(2,:)./d(3,:);d(3,:) = d(3,:)./d(3,:);
Y_inf = d;
origin = P(1:3,4);%Found the origin
d = origin; %normalized it
d(1,:) = d(1,:)./d(3,:);d(2,:) = d(2,:)./d(3,:);d(3,:) = d(3,:)./d(3,:);origin = d;

figure()%generated new figure to show horizon line
myImage = imread('cube.jpg');
imshow(myImage);
hold on;
%made the horizon line first
plot([X_inf(2),Y_inf(2)],[X_inf(1),Y_inf(1)],'g' ,'LineWidth', 2, 'MarkerSize', 15); 
%made a line between origin and point at infinity along yaxis
plot([origin(2),Y_inf(2)],[origin(1),Y_inf(1)],'b' ,'LineWidth', 2, 'MarkerSize', 15);
%made a line between origin and point at infinity along yaxis
plot([X_inf(2),origin(2)],[X_inf(1),origin(1)],'b' ,'LineWidth', 2, 'MarkerSize', 15);

%part g
l = cross(X_inf, Y_inf); %got line from cross product along horizon
d = l; %normalized it
d(1,:) = d(1,:)./d(3,:);d(2,:) = d(2,:)./d(3,:);d(3,:) = d(3,:)./d(3,:);l = d;
n = K'*(l); %got normal with respect to the plane
u = n;
v = [1; 0; 0] ; %normal with respect to the camera
tilt = atan2d(norm(cross(u,v)),dot(u,v)); %found angle from both normals

PlaneEquation = [K(1,:),0;K(2,:),0;K(3,:),0]'*l;

%part h
 Principal3d = [0;0;f]; %principal point is f on z axis in canonical view 
 Principal3d = (R'*Principal3d) + c(1:3,:) % transforming the point as in the general view.
 

%part i
[M,I] = max(imagePoints');
maximum = I(2);
[M,I] = min(imagePoints');
minimum = I(2);
maximumRay = inv(K)*imagePoints(:,maximum);
minimumRay = inv(K)*imagePoints(:,minimum);
u = maximumRay;
v = minimumRay;
CosTheta = dot(u,v)/(norm(u)*norm(v));
AngleBetweenRays = asind(CosTheta)











