function forec = fgXYoTRPCA(ImData,Channel)

[vidHeight,vidWidth,nFrame] = size(ImData);

Data_xt = zeros(nFrame,vidWidth,vidHeight);
Data_yt = zeros(nFrame,vidHeight,vidWidth);

tic

forec = zeros(vidHeight, vidWidth, nFrame);   
forec = uint8(forec);

%% X-T slices
clear img;
maskX = zeros(vidHeight, vidWidth, nFrame);   
for y = 1 : vidHeight
    img(:, :) = ImData(y, :, :);
    xt = img;
    img2 = permute(img, [2, 1]);
    figure(1); clf;
    subplot(1,3,1);
    imshow(img2);
    title(['X-T slice ','y=',num2str(y)],'fontsize',12); 
     
    outtext = ['results\Img\' Channel '\xot\raw\', num2str(y),'.png'];
    imwrite(img2,outtext); 
    
 
    Data_xt(:,:,y) = permute(xt, [2, 1]);
    [A, E] = inexact_alm_rpca(xt); %RPCA-PCP
    maskX(y, :, :) = E;   
    tmp =  permute(E, [2, 1]);
    X_f = uint8(mat2gray(tmp)*255); 
    
    subplot(1,3,2);
    imshow(X_f);
    title('FG','fontsize',12); 
    
    outtext = ['results\Img\' Channel '\xot\fg\', num2str(y),'.png'];
    imwrite(X_f,outtext);  
    
    tmp =  permute(A, [2, 1]);
    X_b = uint8(mat2gray(tmp)*255); 
    
    subplot(1,3,3);
    imshow(X_b);
    title('BG','fontsize',12); 
    drawnow; 
    
    outtext = ['results\Img\' Channel '\xot\bg\', num2str(y),'.png'];
    imwrite(X_b,outtext); 
end



%% Y-T slices
   
clear img;
maskY = zeros(vidHeight, vidWidth, nFrame);
for x = 1 : vidWidth
    img(:, :) = ImData(:, x, :);
    yt = img;  
    figure(1); clf;
    subplot(1,3,1);
    imshow(img);
    title(['Y-T slice ','x=',num2str(x)],'fontsize',12); 
    
    outtext = ['results\Img\' Channel '\yot\raw\', num2str(x),'.png'];
    imwrite(img,outtext); 
    
    Data_yt(:,:,x) = permute(yt, [2, 1]);
    [A, E] = inexact_alm_rpca(yt);
    maskY(:, x, :) = E;
    Y_f = uint8(mat2gray(E)*255); 
    
    subplot(1,3,2);
    imshow(Y_f);
    title('FG','fontsize',12); 
    
    outtext = ['results\Img\' Channel '\yot\fg\', num2str(x),'.png'];
    imwrite(Y_f,outtext); 
    
    Y_b = uint8(mat2gray(A)*255); 
    
    subplot(1,3,3);
    imshow(Y_b);
    title('BG','fontsize',12); 
    drawnow; 
    
    outtext = ['results\Img\' Channel '\yot\bg\', num2str(x),'.png'];
    imwrite(Y_b,outtext); 
end


%% using a very smple method to binarize foreground 
%mask = sqrt(maskX .^ 2 + maskY .^ 2 + maskXY .^ 2);
mask = sqrt(maskX .^ 2 + maskY .^ 2);
th1 = floor(vidHeight * vidWidth / 1500);
thglobal = 20;% can be tuned
minObjectPixelNumber = min(thglobal,th1);

for i = 1 : nFrame
    temp = mask(:, :, i);
    
    imgg(:, :) = ImData(:, :, i);
    imggshow = uint8(mat2gray(imgg)*255); 
   
    figure(1); clf;
    subplot(2,2,1);
    imshow(imggshow);
    title('frame','fontsize',12); 
    outtext = ['results\Img\' Channel '\res\raw\', num2str(i),'.png'];
    imwrite(imggshow,outtext); 
    
    subplot(2,2,2);
    immm = uint8(mat2gray(temp)*255); 
    imshow(immm);
    title('FGsignal','fontsize',12); 
    outtext = ['results\Img\' Channel '\res\mask1\', num2str(i),'.png'];
    imwrite(immm,outtext); 
    
    his = hist(temp, 255)';
    data = sum(his);
    data = data ./ max(data);
    [mu, sigma] = normfit(data);
    threshold = mu + 1.5*sigma;
    temp(temp < threshold) = 0;
    temp(temp >= threshold) = 1;
    
    
    cc = bwconncomp(temp);      
    for j = 1 : cc.NumObjects
       if (size(cc.PixelIdxList{j}, 1) < minObjectPixelNumber)
            temp(cc.PixelIdxList{j}) = 0; 
       end
    end  
    
    subplot(2,2,3);
    immm = uint8(mat2gray(temp)*255); 
    imshow(immm);
    title('pass1: FGmask','fontsize',12); 
    
    outtext = ['results\Img\' Channel '\res\mask2\', num2str(i),'.png'];
    imwrite(immm,outtext); 
       
    subplot(2,2,4);
    forec(:,:,i) = uint8((imgg.*temp)*255);
    imshow(forec(:,:,i));
    title('pass1: FGsignal','fontsize',12); 
    
    outtext = ['results\Img\' Channel '\res\fore\', num2str(i),'.png'];
    imwrite(forec(:,:,i),outtext); 
end
end