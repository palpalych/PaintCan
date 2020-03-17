function [commonColorRanges] = ExtractCommonColors(movie)
%EXTRACTCOMMONCOLORS Return what colors within a +5 or -5 range are used
%across all frames in the movie
movie_size = size(movie);

% Extract all the colors in the first frame
seenThisFrame = java.util.HashSet;
for j=1:movie_size(1)
    for k=1:movie_size(2)
        seenThisFrame.add(strcat(num2str(movie(j,k,1,1)),',',num2str(movie(j,k,2,1)),',',num2str(movie(j,k,3,1))));
    end
end
seenFirstFrame = str2num(seenThisFrame.toArray());

% Go through the rest of the frames, we're doing this backwards because the
% last frame and the first frame tend to have the most differences, so
% doing so quickly reduces the number of colors we're checking against.
% Additionally only look at every 3rd frame since we expect adjacent frames
% to any particular frame to be similar
for index=-movie_size(4):3:-2
    i = -index;
    toRemove = [];
    sizeOfSeen = size(seenFirstFrame);
    for j=1:sizeOfSeen(1)
        matches = movie(:,:,1,i) < seenFirstFrame(j,1)+5 & movie(:,:,1,i) > seenFirstFrame(j,1)-5 & movie(:,:,2,i) < seenFirstFrame(j,2)+5 & movie(:,:,2,i) > seenFirstFrame(j,2)-5 & movie(:,:,3,i) < seenFirstFrame(j,3)+5 & movie(:,:,3,i) > seenFirstFrame(j,3)-5;
        if max(max(matches)) == 0
            toRemove = [toRemove j];
        end
    end
    for j=-length(toRemove):-1
        seenFirstFrame(-j,:) = [];
    end
end

% clump the colors together
commonColorRanges = seenFirstFrame;
i = 1;
while true
    toRemove = [];
    sizeOfSeen = size(commonColorRanges);
    
    if i+1 >= sizeOfSeen(1)
        break
    end
    
    for j=i+1:sizeOfSeen(1)
        if commonColorRanges(i,1) < commonColorRanges(j,1)+5 && commonColorRanges(i,1) > commonColorRanges(j,1)-5 && ...
           commonColorRanges(i,2) < commonColorRanges(j,2)+5 && commonColorRanges(i,2) > commonColorRanges(j,2)-5 && ...
           commonColorRanges(i,3) < commonColorRanges(j,3)+5 && commonColorRanges(i,3) > commonColorRanges(j,3)-5
            toRemove = [toRemove j];
        end
    end
    
    for j=-length(toRemove):-1
        commonColorRanges(-j,:) = [];
    end
    
    i = i + 1;
end

commonColorRanges = sortrows(commonColorRanges);

end

