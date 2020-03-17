%% Start with a clean slate
clear all; close all; clc

%% Video 1
load('cam1_1.mat');
load('cam2_1.mat');
load('cam3_1.mat');

% First, try to get a grasp of what we're looking at
%movie_size = size(vidFrames1_1);

% We're dealing with a 4-d data set that is 480 640 3 226 in size
% We know it's a video, so most like 480x640 pixels, 226 measurements, and
% the 3 is for the RGB values. What does a random frame look like?
%image(vidFrames1_1(:,:,:,200))

% What does the overall video look like?
%implay(vidFrames1_1)

% the cams have different number of frames, manually cut the data to start
% at the same time - I used the frame before I see first downward movement
[vidFrames1_1,vidFrames2_1,vidFrames3_1] = AlignVideos(vidFrames1_1,11,vidFrames2_1,20,vidFrames3_1,11);

% the flashlight isn't the only thing that's white so I had more
% success tracking the bright yellow of the pain can
[cam1_x,cam1_y,cam1_corrupt] = TraceColor(vidFrames1_1, 250, 256, 240, 250, 200, 210);
[cam2_x,cam2_y,cam2_corrupt] = TraceColor(vidFrames2_1, 160, 200, 175, 220, 60, 120);

% cam 3 was very difficult due to the turning of the can and  blur in 
% frames 227 and 228. ExtractCommonColors helped find a good color that
% appears across all frames, it takes a while to run though
% commonColorRanges = ExtractCommonColors(vidFrames3_1);
[cam3_x,cam3_y,cam3_corrupt] = TraceColor(vidFrames3_1, 185, 200, 185, 205, 130, 150);

% sanity check visually the tracking
% implay(cam1_corrupt)

A = [cam1_x;cam1_y;cam2_x;cam2_y;cam3_x;cam3_y];
movie_size = size(A);

% normalize data
A = A./(movie_size(2)-1);
mean_A = mean(A,2);
A = A - mean_A;

[u,s,v] = svd(A);
figure(1)
PlotApproximations(A,u,s,v,mean_A);

figure(2)
sig=diag(s);
subplot(1,2,1), plot(sig,'ko','Linewidth',[1.5])
subplot(1,2,2), semilogy(sig,'ko','Linewidth',[1.5])

%% Video 2
load('cam1_2.mat');
load('cam2_2.mat');
load('cam3_2.mat');

[vidFrames1_2,vidFrames2_2,vidFrames3_2] = AlignVideos(vidFrames1_2,13,vidFrames2_2,38,vidFrames3_2,18);

[cam1_x,cam1_y,cam1_corrupt] = TraceColor(vidFrames1_2, 215, 240, 190, 210, 140, 160);
[cam2_x,cam2_y,cam2_corrupt] = TraceColor(vidFrames2_2, 200, 240, 230, 256, 160, 190);
[cam3_x,cam3_y,cam3_corrupt] = TraceColor(vidFrames3_2, 230, 256, 230, 256, 180, 210);

A = [cam1_x;cam1_y;cam2_x;cam2_y;cam3_x;cam3_y];
movie_size = size(A);

% normalize data
A = A./(movie_size(2)-1);
mean_A = mean(A,2);
A = A - mean_A;

[u,s,v] = svd(A);
figure(3)
PlotApproximations(A,u,s,v,mean_A);

figure(4)
sig=diag(s);
subplot(1,2,1), plot(sig,'ko','Linewidth',[1.5])
subplot(1,2,2), semilogy(sig,'ko','Linewidth',[1.5])

%% Video 3
load('cam1_3.mat');
load('cam2_3.mat');
load('cam3_3.mat');

[vidFrames1_3,vidFrames2_3,vidFrames3_3] = AlignVideos(vidFrames1_3,20,vidFrames2_3,8,vidFrames3_3,12);

[cam1_x,cam1_y,cam1_corrupt] = TraceColor(vidFrames1_3, 215, 235, 140, 160, 135, 160);
[cam2_x,cam2_y,cam2_corrupt] = TraceColor(vidFrames2_3, 200, 240, 230, 256, 160, 190);
[cam3_x,cam3_y,cam3_corrupt] = TraceColor(vidFrames3_3, 230, 256, 231, 256, 180, 210);

A = [cam1_x;cam1_y;cam2_x;cam2_y;cam3_x;cam3_y];
movie_size = size(A);

% normalize data
A = A./(movie_size(2)-1);
mean_A = mean(A,2);
A = A - mean_A;

[u,s,v] = svd(A);
figure(5)
PlotApproximations(A,u,s,v,mean_A);

figure(6)
sig=diag(s);
subplot(1,2,1), plot(sig,'ko','Linewidth',[1.5])
subplot(1,2,2), semilogy(sig,'ko','Linewidth',[1.5])

%% Video 4
load('cam1_4.mat');
load('cam2_4.mat');
load('cam3_4.mat');

[vidFrames1_4,vidFrames2_4,vidFrames3_4] = AlignVideos(vidFrames1_4,15,vidFrames2_4,21,vidFrames3_4,14);

% this video is long enough with enough sides of the can seen that no
% matter what color I picked, there would be some frames without the color,
% so using color that tracks the most and fixing the untagged frames
[cam2_x,cam2_y,cam2_corrupt] = TraceColor(vidFrames2_4, 200, 240, 220, 256, 150, 185);
cam2_x(14) = 364; cam2_y(14) = 275;

[cam3_x,cam3_y,cam3_corrupt] = TraceColor(vidFrames3_4, 190, 220, 190, 220, 140, 160);
cam3_x(168) = cam3_x(167); cam3_y(168) = cam3_y(167);
cam3_x(242) = 330; cam3_y(242) = 207;
cam3_x(243) = 330; cam3_y(243) = 207;

% cam 1 was especially difficult, so I'm blanking out areas that never have
% the can, and then fixing up several frames
corrupt_cam1 = vidFrames1_4;
corrupt_cam1(:,470:640,:,:) = 0;
corrupt_cam1(:,1:320,:,:) = 0;
corrupt_cam1(400:480,:,:,:) = 0;
corrupt_cam1(1:230,:,:,:) = 0;
[cam1_x,cam1_y,cam1_corrupt] = TraceColor(corrupt_cam1, 190, 230, 190, 220, 140, 180);
cam1_x(10) = 396; cam1_y(10) = 396;
cam1_x(11) = 396; cam1_y(11) = 396;

A = [cam1_x;cam1_y;cam2_x;cam2_y;cam3_x;cam3_y];
movie_size = size(A);

% normalize data
A = A./(movie_size(2)-1);
mean_A = mean(A,2);
A = A - mean_A;

[u,s,v] = svd(A);
figure(7)
PlotApproximations(A,u,s,v,mean_A);

figure(8)
sig=diag(s);
subplot(1,2,1), plot(sig,'ko','Linewidth',[1.5])
subplot(1,2,2), semilogy(sig,'ko','Linewidth',[1.5])