function mask = getForeground(ImData)


[vidHeight,vidWidth,nchannel,nFrame] = size(ImData);


mask = zeros(vidHeight,vidWidth,nchannel,nFrame);

%%  Pass 1: foreground candidate detection by RPCA-PCP on XOT and YOT slices

if exist('results\Img\pass1R.mat','file') 
    load('results\Img\pass1R.mat','foreR');
else
    ImDataR = reshape(ImData(:,:,1,:),vidHeight,vidWidth,nFrame);
    ImDataR1 = im2double(ImDataR);
    foreR = fgXYoTRPCA(ImDataR1,'r');
    save('results\Img\pass1R.mat','foreR');
end


if exist('results\Img\pass1G.mat','file') 
    load('results\Img\pass1G.mat','foreG');
else
    ImDataG = reshape(ImData(:,:,2,:),vidHeight,vidWidth,nFrame);
    ImDataG1 = im2double(ImDataG);
    foreG = fgXYoTRPCA(ImDataG1,'g');
    save('results\Img\pass1G.mat','foreG');
end


if exist('results\Img\pass1B.mat','file') 
    load('results\Img\pass1B.mat','foreB');
else
    ImDataB = reshape(ImData(:,:,3,:),vidHeight,vidWidth,nFrame);
    ImDataB1 = im2double(ImDataB);
    foreB = fgXYoTRPCA(ImDataB1,'b');
    save('results\Img\pass1B.mat','foreB');
end


%% Pass 2: foreground mask extraction via MCFL
rho = 1.1;%can be tuned
m = vidHeight*vidWidth;
lam1 = 1/sqrt(m);
lam2 = rho*lam1;
Phi = speye(m);% sparse(eye(m));
options.stopc = 1e-6;%can be tuned
 
for i = 1 : nFrame
    
    oriImage = ImData(:,:,:,i);    
    figure(1); clf;    
    subplot(3,3,1);
    imshow(oriImage);
    title(['Frames #',num2str(i)],'fontsize',12);   
    outtext = ['results\Img\rgb\raw\', num2str(i),'.png'];
    imwrite(oriImage,outtext); 

    
    foreiR = foreR (:,:,i);
    subplot(3,3,2);
    imshow(foreiR);
    title('Pass1: Fg R','fontsize',12);   
    
    foreiG = foreG (:,:,i);
    subplot(3,3,3);
    imshow(foreiG);
    title('Pass1: Fg G','fontsize',12);   
     
    foreiB = foreB (:,:,i);
    subplot(3,3,4);
    imshow(foreiB);
    title('Pass1: Fg B','fontsize',12);   
    
    foremask = foreiR;
    foremask(foreiR >0) = 1;
    foremask(foreiG >0) = 1;
    foremask(foreiB >0) = 1;
    rgbMask = cat(3, foremask, foremask, foremask);
    subplot(3,3,5);
    imshow(rgbMask*255);
    title('Pass1: Fg mask','fontsize',12);   
    
    forecandirgb = oriImage.*rgbMask;
    subplot(3,3,7);
    imshow(forecandirgb);
    title('Pass2 (input): Fg signal','fontsize',12);   
    outtext = ['results\Img\rgb\fore\', num2str(i),'.png'];
    imwrite(forecandirgb,outtext); 
    
    forecandirgb1 = reshape(forecandirgb,vidHeight*vidWidth,nchannel);
    Ri = double(forecandirgb1);
    Xres = MCFL(Phi, Ri, lam1, lam2, vidHeight,vidWidth, options);
    
    oUputmp =  reshape(Xres,vidHeight,vidWidth,nchannel);
    oUput = zeros(vidHeight,vidWidth,nchannel);
    oUput(abs(oUputmp)>0)=1;
    subplot(3,3,8);
    imshow(oUput);
    title('Pass2 (output): Fg mask','fontsize',12);   
    drawnow;
    
    mask(:,:,:,i) = oUput;
    outtext = ['results\Img\rgb\mask\', num2str(i),'.png'];
    imwrite(oUput,outtext); 
    
end
   
end

