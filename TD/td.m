img = imread('0404_GY89137_parasite(9).jpg');
gray = rgb2gray(img);
bw1 = imbinarize(gray);
BW = imcomplement(bw1);
L = bwlabel(BW);

CC = bwconncomp(BW)

% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% BW(CC.PixelIdxList{idx}) = 0;

numPixels = cellfun(@numel,CC.PixelIdxList);
for idx  = 1:size(numPixels)
    if numPixels{idx} < 100
        BW(CC.PixelIdxList{idx}) = 0;
    end
end

figure
imshow(BW)

numPixels
