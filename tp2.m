fileName = 'Demosaic_1.bmp';
rgbImage = imread(fileName);
whos rgbImage
imshow(rgbImage,[])
title("RAW RGB Image")

Image_CFA = bayer(rgbImage);
whos Image_CFA
imshow(Image_CFA,[])
title("RAW CFA Image")

function Image_CFA = bayer(input_RGB)
    [rows, columns, numberOfColorChannels] = size(input_RGB);
    outputImage = zeros(rows, columns); % Initialize
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
            outputImage(row, col) = input_RGB(row, col, 2);
            outputImage(row, col + 1) = input_RGB(row, col, 1);
            outputImage(row + 1, col) = input_RGB(row, col, 3);
            outputImage(row + 1, col + 1) = input_RGB(row, col, 2);
        end
    end
    Image_CFA = outputImage;
end