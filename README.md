# Note

16/10/23 Code Upload.

# Content

1. [Abstract](#Abstract)
2. [Model](#Model)
3. [Results](#Data)
4. [How to start](#How-to-start)
5. [Citation](#Citation)

# Abstract

Motion detection is a fundamental step in analyzing video sequences. Structured and fused sparsity has been used in previous works to normalize the foreground signal due to the foreground’s spatial and temporal coherence. As far as we are aware, no previous works have studied the group prior to multi-channels (such as the RGB) to the foreground signals. However, a multi-channel signal is the correct representation of a pixel. Under the condition that one pixel is equal (similar) to its neighboring pixels, it’s reasonable that the three channels of RGB should also be identical (similar). This work investigates the smoothness of multi-channel signals by proposing a novel regularizer named the Multi-Channel Fused Lasso (MCFL). Specifically, we introduce a two-channel structure to implement motion detection. First, low-rank matrix decomposition is performed on the video footage along different planes. Low-rank background and sparse foreground (rough foreground candidate for the second pass) are segmented from the video sequence. Further, MCFL regularization is used for sparse signal recovery to improve the performance of the foreground mask. The proposed method is validated on different challenging videos. Sufficient experimental results show that our method is effective in a variety of challenging scenarios. ***Compared with the current best sparsely-based method, the performance of F-Measure improves by 0.4, 0.4, and 0.1 respectively on the I2R, BMC, and CDnet2014 datasets. Our approach is also competitive compared to the deep learning models.***

# Model

<img src="/imgs/image-20231016134541497.png" alt="image-20231016134541497"/>

# Results

# I2R dataset

<img src="/imgs/image-20231016134114919.png" alt="image-20231016134114919"/>

<img src="/imgs/image-20231016134149628.png" alt="image-20231016134149628" width="30%" height="30%" />

## BMC dataset

<img src="/imgs/image-20231016134245624.png" alt="image-20231016134245624" width="50%" height="50%"/>

<img src="/imgs/image-20231016134309288.png" alt="image-20231016134309288"/>

## CDnet 2014 dataset

<img src="/imgs/image-20231016134355450.png" alt="image-20231016134355450"/>

<img src="/imgs/image-20231016134430098.png" alt="image-20231016134430098"/>

# How to start

To run the code, just simply run ***MCFL_demo.m***.

**Please note** that the first-pass results of "Campus" are given. Please remove 'pass1R.mat', 'pass1G.mat', and 'pass1B.mat' from \results\Img\, if you want to run the whole system.

# Citation

This is a code for 'Multi-Channel Fused Lasso for Motion Detection'. 
If you happen to use this source code, please cite our papers:
```
'Multi-Channel Fused Lasso for Motion Detection in Dynamic Video Scenarios' submitted to IEEE Transactions on Industrial Informatics.
```
