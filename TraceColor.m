function [x_coords,y_coords,corruptedVid] = TraceColor(video, minR, maxR, minG, maxG, minB, maxB)
%TRACECOLOR Traces top left hand point of a particular color in the video
movie_size = size(video);
x_coords = zeros(1,movie_size(4));
y_coords = zeros(1,movie_size(4));
corruptedVid = video;

for i=1:movie_size(4)
    colorSpots = video(:,:,1,i) > minR & video(:,:,1,i) < maxR & video(:,:,2,i) > minG & video(:,:,2,i) < maxG & video(:,:,3,i) > minB & video(:,:,3,i) < maxB;
    [y,x] = ind2sub(movie_size(1:2), find(colorSpots, 1));
    
    if isempty(x)
%         "no color"
%         i
        continue
    end
    
    % note: if the color is not found an Error will happen here
    x_coords(i) = x;
    y_coords(i) = y;
    
%     if x <= 1 || y <= 1
%         "invalid coordinate"
%         i
%         continue
%     end
    
    % update a video copy for visual validation
    corruptedVid(y,x,1,i) = 0;
    corruptedVid(y+1,x,3,i) = 0;
    corruptedVid(y-1,x,1,i) = 0;
    corruptedVid(y,x-1,3,i) = 0;
    corruptedVid(y+1,x-1,1,i) = 0;
    corruptedVid(y-1,x-1,3,i) = 0;
    corruptedVid(y,x+1,1,i) = 0;
    corruptedVid(y+1,x+1,3,i) = 0;
    corruptedVid(y-1,x+1,1,i) = 0;
end
end

