function [video1,video2,video3] = AlignVideos(video1, start1, video2, start2, video3, start3)
%ALIGNVIDEOS Aligns 3 movies to start at a particular frame and end at the
%same frame

video1(:,:,:,1:start1-1) = [];
video2(:,:,:,1:start2-1) = [];
video3(:,:,:,1:start3-1) = [];
size1 = size(video1);
size2 = size(video2);
size3 = size(video3);
lastFrame = min([size1(4) size2(4) size3(4)]);
video1(:,:,:,lastFrame+1:size1(4)) = [];
video2(:,:,:,lastFrame+1:size2(4)) = [];
video3(:,:,:,lastFrame+1:size3(4)) = [];

end

