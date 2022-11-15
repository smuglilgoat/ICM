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
    modifiedCFA = Image_CFA;
    firstRow = Image_CFA(2, :);
    modifiedCFA = [firstRow; modifiedCFA];
    firstCol = Image_CFA(:, 2);
    modifiedCFA = [[ 0; firstCol] modifiedCFA];
    lastRow = Image_CFA(rows - 1, :);
    modifiedCFA = [modifiedCFA; [0 lastRow]];
    lastCol = Image_CFA(:, columns - 1);
    modifiedCFA = [modifiedCFA [0; lastCol; 0]];
    outputImage = zeros(rows, columns, 3); % Initialize
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
            % Green Pixel
            outputImage(row, col, 1) = (modifiedCFA(row + 1, col) + modifiedCFA(row + 1, col + 2)) / 2;
            outputImage(row, col, 2) = modifiedCFA(row + 1, col + 1);
            outputImage(row, col, 3) = (modifiedCFA(row, col + 1) + modifiedCFA(row + 2, col + 1)) / 2;
            
            % Red Pixel
            outputImage(row, col + 1, 1) = modifiedCFA(row + 1, col + 2);
            outputImage(row, col + 1, 2) = (modifiedCFA(row, col + 2) + modifiedCFA(row + 2, col + 2) + modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 1, col + 3)) / 4; 
            outputImage(row, col + 1, 3) = (modifiedCFA(row, col + 1) + modifiedCFA(row, col + 3) + modifiedCFA(row + 2, col + 1) + modifiedCFA(row + 2, col + 3)) / 4;
            
            % Blue Pixel
            outputImage(row + 1, col, 1) = (modifiedCFA(row + 1, col) + modifiedCFA(row + 1, col + 2) + modifiedCFA(row + 3, col) + modifiedCFA(row + 3, col + 2)) / 4;
            outputImage(row + 1, col, 2) = (modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 3, col + 1) + modifiedCFA(row + 2, col) + modifiedCFA(row + 2, col + 2)) / 4; 
            outputImage(row + 1, col, 3) = modifiedCFA(row + 2, col + 1);
            
            % Green Pixel
            outputImage(row + 1, col + 1, 1) = (modifiedCFA(row + 2, col + 1) + modifiedCFA(row + 2, col + 3)) / 2;
            outputImage(row + 1, col + 1, 2) = modifiedCFA(row + 2, col + 2);
            outputImage(row + 1, col + 1, 3) = (modifiedCFA(row + 1, col + 2) + modifiedCFA(row + 3, col + 2)) / 2;
        end
    end
    Output_RGB = uint8(outputImage);
end