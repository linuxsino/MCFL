% % **************************************************************************************************************
% % This is a code for 'Multi-Channel Fused Lasso for Motion Detection'
% % If you happen to use this source code, please cite our papers:
% %
% % 'Multi-Channel Fused Lasso for Motion Detection in Dynamic Video Scenarios'
% % submitted to IEEE Transactions on Industrial Informatics
% %
% % **************************************************************************************************************

clear all;
addpath(genpath('./'));

%frame_idx=[
%    2300,2500;
%    2500,2700;
%    2700,2900;
%    2900,3000;
%    ];

frame_idx=[
    1,50;
    ];%% can be tuned

load('data\Campus','ImData');%

num_task = size(frame_idx,1);
ImData0 = ImData;
for task = 1:num_task  
    frame_st = frame_idx(task,1); frame_ed = frame_idx(task,2);
    ImData = ImData0(:,:,:,frame_st:frame_ed);  
    fgmask = getForeground(ImData); 
 end



