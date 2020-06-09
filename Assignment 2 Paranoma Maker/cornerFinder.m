function Corners = cornerFinder(imageName)

I= imread(imageName);
I=imresize(I,0.2);
A = rgb2gray(I);
%generating derivative of gaussian filter
sigma=1;
max_len= round(sqrt(-2*sigma^.2*log(0.1)));
[y,x]=meshgrid(-max_len:max_len,-max_len:max_len);
g= exp(-(x.^2 + y.^2)./2*sigma.^2);
dx= (-x./sigma^2).*g;
dy= (-y./sigma^2).*g;
%applying filter on A
Ix = conv2(A,dx,'same');
Iy = conv2(A,dy,'same');
Corners = [];
grid = 8;
eigenMat = zeros(size(I,1),size(I,2));
for i=grid+1:size(Ix,1)-grid
    for j=grid+1:size(Ix,2)-grid
        STX = i-grid;
        EDX = i+grid;
        STY = j-grid;
        EDY = j+grid;
        XMat = Ix(STX:EDX,STY:EDY);
        YMat = Iy(STX:EDX,STY:EDY);
        Covar = [sum(sum(XMat.^2)),sum(sum(XMat.*YMat));
                    sum(sum(XMat.*YMat)),sum(sum(YMat.^2))];
        Covar = Covar/(grid*2)^2;
        eigenVals = eig(Covar);
        if eigenVals(1)>5000
             eigenMat(i,j)= eigenVals(1);
        end
            
                
    end
end 
grid = grid*5;
for i = 1:100
    [~,ind]=max(eigenMat(:));
    [row,col]= ind2sub(size(eigenMat),ind);
    eigenMat(max(1,row-grid):row+grid,max(1,col-grid):col+grid) = 0;
    Corners = [Corners;row,col];
    end

end


