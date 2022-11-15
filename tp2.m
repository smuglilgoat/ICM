fileName = 'Demosaic_5.tif';
rgbImage = imread(fileName);
whos rgbImage
imshow(rgbImage,[])
title("RAW RGB Image")

Image_CFA = bayer(rgbImage);
whos Image_CFA
imshow(Image_CFA,[])
title("RAW CFA Image")

Output_RGB = bilinear(Image_CFA);
whos Output_RGB
imshow(Output_RGB,[])
title("Demosaic RGB Image")

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

function Output_RGB = bilinear(Image_CFA)
    [rows, columns] = size(Image_CFA);
    firstRow = Image_CFA(1, :);
    firstCol = Image_CFA(:, 1);
    lastRow = Image_CFA(rows, :);
    lastCol = Image_CFA(:, col);
    outputImage = zeros(rows, columns, 3); % Initialize
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
            outputImage(row, col) = Image_CFA(row, col);
            outputImage(row, col + 1) = Image_CFA(row, col);
            outputImage(row + 1, col) = Image_CFA(row, col);
            outputImage(row + 1, col + 1) = Image_CFA(row, col);
        end
    end
    Output_RGB = outputImage;
end