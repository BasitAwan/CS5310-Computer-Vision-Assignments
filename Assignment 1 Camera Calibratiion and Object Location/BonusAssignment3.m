load BluePoints %Image points loaded from set of data I already marked
A = BluePoints; 
t1 = A(:,1);t2 = A(:,2);A(:,1) = t2;A(:,2) = t1;
BluePoints = A; %Swapping y axis and x axis as matlab does not follow image convention
worldPoints = [0,0,0;0,0,25.6;73.76,0,0;73.76,0,32;0,64.8,64;0,119.7,64;-61.16,70.4,64;
                -61.16,125.31,64;-61.16,175.21,64]
imagePoints=BluePoints
A = [worldPoints(1,1), worldPoints(1,2),worldPoints(1,3), 1, 0,0,0,0,(-imagePoints(1,1))*worldPoints(1,1),(-imagePoints(1,1))*worldPoints(1,2),(-imagePoints(1,1))*worldPoints(1,3),(-imagePoints(1,1));
    0,0,0,0,worldPoints(1,1), worldPoints(1,2),worldPoints(1,3), 1, (-imagePoints(1,2))*worldPoints(1,1),(-imagePoints(1,2))*worldPoints(1,2),(-imagePoints(1,2))*worldPoints(1,3),(-imagePoints(1,2))];
for i=  2:9
    A = [A;worldPoints(i,1), worldPoints(i,2),worldPoints(i,3), 1, 0,0,0,0,(-imagePoints(i,1))*worldPoints(i,1),(-imagePoints(i,1))*worldPoints(i,2),(-imagePoints(i,1))*worldPoints(i,3),(-imagePoints(i,1));
        0,0,0,0,worldPoints(i,1), worldPoints(i,2),worldPoints(i,3), 1, (-imagePoints(i,2))*worldPoints(i,1),(-imagePoints(i,2))*worldPoints(i,2),(-imagePoints(i,2))*worldPoints(i,3),(-imagePoints(i,2))];
end
[U,S,V] = svd(A);
P= V(:,end);
P= [P(1:4,:)';P(5:8,:)';P(9:12,:)'];
Center = null(P);
Center = Center/Center(4)