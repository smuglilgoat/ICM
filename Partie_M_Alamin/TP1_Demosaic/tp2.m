fileName = 'Demosaic_5.tif';
rgbImage = imread(fileName);
whos rgbImage
imshow(rgbImage,[])
title("RAW RGB Image")

Image_CFA = bayer(rgbImage);
whos Image_CFA
imshow(Image_CFA,[])
imwrite(Image_CFA,"RAW_CFA_Image.png")
title("RAW CFA Image")

% Image_CFA = imgaussfilt(Image_CFA, 1);

Output_RGB = bilinear(Image_CFA);
whos Output_RGB
imshow(Output_RGB,[])
imwrite(Output_RGB,"Demosaic_RGB_Image.jpg")
title("Demosaic RGB Image")
% 
% Output_RGB = taint(Image_CFA);
% whos Output_RGB
% imshow(Output_RGB,[])
% imwrite(Output_RGB,"Demosaic_RGB_Image.jpg")
% title("Demosaic RGB Image")

% Output_RGB = edge(Image_CFA);
% whos Output_RGB
% imshow(Output_RGB,[])
% imwrite(Output_RGB,"Demosaic_RGB_Image.jpg")
% title("Demosaic RGB Image")

function Image_CFA = bayer(input_RGB)
    [rows, columns, numberOfColorChannels] = size(input_RGB);
    r = input_RGB(:, :, 1);
    g = input_RGB(:, :, 2);
    b = input_RGB(:, :, 3);
    outputImage = zeros(rows, columns); % Initialize
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
%             outputImage(row, col) = input_RGB(row, col, 2);
%             outputImage(row, col + 1) = input_RGB(row, col, 1);
%             outputImage(row + 1, col) = input_RGB(row, col, 3);
%             outputImage(row + 1, col + 1) = input_RGB(row, col, 2);
            outputImage(row, col) = g(row, col);
            outputImage(row, col + 1) =  r(row, col + 1);
            outputImage(row + 1, col) = b(row + 1, col);
            outputImage(row + 1, col + 1) = g(row + 1, col + 1);

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

function Output_RGB = taint(Image_CFA)
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
    % Green Interpolation
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
           % Green Pixel
            outputImage(row, col, 2) = modifiedCFA(row + 1, col + 1);
            
            % Red Pixel
            outputImage(row, col + 1, 1) = modifiedCFA(row + 1, col + 2);
            outputImage(row, col + 1, 2) = (modifiedCFA(row, col + 2) + modifiedCFA(row + 2, col + 2) + modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 1, col + 3)) / 4; 
            
            % Blue Pixel
            outputImage(row + 1, col, 2) = (modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 3, col + 1) + modifiedCFA(row + 2, col) + modifiedCFA(row + 2, col + 2)) / 4; 
            outputImage(row + 1, col, 3) = modifiedCFA(row + 2, col + 1);
            
            % Green Pixel
            outputImage(row + 1, col + 1, 2) = modifiedCFA(row + 2, col + 2);
        end
    end
    modifiedCFA = zeros(rows, columns, 3);
    modifiedCFA = outputImage;
    firstRow = outputImage(2, :, :);
    modifiedCFA = [firstRow; modifiedCFA];
    firstCol = modifiedCFA(:, 2, :);
    modifiedCFA = [firstCol modifiedCFA];
    lastRow = modifiedCFA(rows - 1, :, :);
    modifiedCFA = [modifiedCFA; lastRow];
    lastCol = modifiedCFA(:, columns - 1, :);
    modifiedCFA = [modifiedCFA lastCol];
    % Blue/Red Interpolation
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
            % Green Pixel
            outputImage(row, col, 1) = modifiedCFA(row + 1, col + 1, 2) / 2 + (modifiedCFA(row + 1, col, 1)/modifiedCFA(row + 1, col, 2) + modifiedCFA(row + 1, col + 2, 1)/modifiedCFA(row + 1, col + 2, 2));
            outputImage(row, col, 3) = modifiedCFA(row + 1, col + 1, 2) / 2 + (modifiedCFA(row, col + 1, 3) / modifiedCFA(row, col + 1, 2) + modifiedCFA(row + 2, col + 1, 3) / modifiedCFA(row + 2, col + 1, 2));
            
            % Red Pixel
            outputImage(row, col + 1, 3) = modifiedCFA(row + 1, col + 2, 2) / 4 + (modifiedCFA(row, col + 1, 3) / modifiedCFA(row, col + 1, 2) + modifiedCFA(row, col + 3, 3) / modifiedCFA(row, col + 3, 2) + modifiedCFA(row + 2, col + 1, 3)/modifiedCFA(row + 2, col + 1, 2) + modifiedCFA(row + 2, col + 3, 3)/modifiedCFA(row + 2, col + 3, 2));
            
            % Blue Pixel
            outputImage(row + 1, col, 1) = modifiedCFA(row + 2, col + 1, 2) / 4 + (modifiedCFA(row + 1, col, 1) / modifiedCFA(row + 1, col, 2) + modifiedCFA(row + 1, col + 2, 1) / modifiedCFA(row + 1, col + 2, 2) + modifiedCFA(row + 3, col, 1)/modifiedCFA(row + 3, col, 2) + modifiedCFA(row + 3, col + 2, 1)/modifiedCFA(row + 3, col + 2, 2));
            
            % Green Pixel
            outputImage(row + 1, col + 1, 1) = modifiedCFA(row + 2, col + 2, 2) / 2 + (modifiedCFA(row + 1, col + 2, 1) / modifiedCFA(row + 1, col + 2, 2) + modifiedCFA(row + 3, col + 2, 1) / modifiedCFA(row + 3, col + 2, 2));
            outputImage(row + 1, col + 1, 3) = modifiedCFA(row + 2, col + 2, 2) / 2 + (modifiedCFA(row + 2, col + 1, 3) / modifiedCFA(row + 2, col + 1, 2) + modifiedCFA(row + 2, col + 3, 3) / modifiedCFA(row + 2, col + 3, 2));
        end
    end
    Output_RGB = uint8(outputImage);
end

function Output_RGB = edge(Image_CFA)
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
    deltaH = 0;
    deltaV = 0;
    % Green Interpolation
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
            % Green Pixel
            outputImage(row, col, 2) = modifiedCFA(row + 1, col + 1);
            
            % Red Pixel
            outputImage(row, col + 1, 1) = modifiedCFA(row + 1, col + 2);
            deltaH = abs(modifiedCFA(row + 1, col + 1) - modifiedCFA(row + 1, col + 3));
            deltaV = abs(modifiedCFA(row, col + 2) - modifiedCFA(row + 2, col + 2));
            if deltaH < deltaV
                outputImage(row, col + 1, 2) = (modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 1, col + 3)) / 2;
            elseif deltaH > deltaV
                outputImage(row, col + 1, 2) = (modifiedCFA(row, col + 2) + modifiedCFA(row + 2, col + 2)) / 2;
            else
                outputImage(row, col + 1, 2) = (modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 1, col + 3) + modifiedCFA(row, col + 2) + modifiedCFA(row + 2, col + 2)) / 4;
            end
            % Blue Pixel
            outputImage(row + 1, col, 3) = modifiedCFA(row + 2, col + 1);
            deltaH = abs(modifiedCFA(row + 2, col) - modifiedCFA(row + 2, col + 2));
            deltaV = abs(modifiedCFA(row + 1, col + 1) - modifiedCFA(row + 3, col + 1));
            if deltaH < deltaV
                outputImage(row + 1, col, 2) = (modifiedCFA(row + 2, col) + modifiedCFA(row + 2, col + 2)) / 2;
            elseif deltaH > deltaV
                outputImage(row + 1, col, 2) = (modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 3, col + 1)) / 2;
            else
                outputImage(row + 1, col, 2) = (modifiedCFA(row + 2, col) + modifiedCFA(row + 2, col + 2) + modifiedCFA(row + 1, col + 1) + modifiedCFA(row + 3, col + 1)) / 4;
            end
            
            % Green Pixel
            outputImage(row + 1, col + 1, 2) = modifiedCFA(row + 2, col + 2);
        end
    end
    modifiedCFA = zeros(rows, columns, 3);
    modifiedCFA = outputImage;
    firstRow = outputImage(2, :, :);
    modifiedCFA = [firstRow; modifiedCFA];
    firstCol = modifiedCFA(:, 2, :);
    modifiedCFA = [firstCol modifiedCFA];
    lastRow = modifiedCFA(rows - 1, :, :);
    modifiedCFA = [modifiedCFA; lastRow];
    lastCol = modifiedCFA(:, columns - 1, :);
    modifiedCFA = [modifiedCFA lastCol];
    % Blue/Red Interpolation
    for col = 1 : 2 : columns - 1
        for row = 1 : 2 : rows - 1
            % Green Pixel
            outputImage(row, col, 1) = modifiedCFA(row + 1, col + 1, 2) / 2 + (modifiedCFA(row + 1, col, 1) / modifiedCFA(row + 1, col, 2) + modifiedCFA(row + 1, col + 2, 1) / modifiedCFA(row + 1, col + 2, 2));
            outputImage(row, col, 3) = modifiedCFA(row + 1, col + 1, 2) / 2 + (modifiedCFA(row, col + 1, 3) / modifiedCFA(row, col + 1, 2) + modifiedCFA(row + 2, col + 1, 3) / modifiedCFA(row + 2, col + 1, 2));
            
            % Red Pixel
            outputImage(row, col + 1, 3) = modifiedCFA(row + 1, col + 2, 2) / 4 + (modifiedCFA(row, col + 1, 3) / modifiedCFA(row, col + 1, 2) + modifiedCFA(row, col + 3, 3) / modifiedCFA(row, col + 3, 2) + modifiedCFA(row + 2, col + 1, 3)/modifiedCFA(row + 2, col + 1, 2) + modifiedCFA(row + 2, col + 3, 3)/modifiedCFA(row + 2, col + 3, 2));
            
            % Blue Pixel
            outputImage(row + 1, col, 1) = modifiedCFA(row + 2, col + 1, 2) / 4 + (modifiedCFA(row + 1, col, 1) / modifiedCFA(row + 1, col, 2) + modifiedCFA(row + 1, col + 2, 1) / modifiedCFA(row + 1, col + 2, 2) + modifiedCFA(row + 3, col, 1)/modifiedCFA(row + 3, col, 2) + modifiedCFA(row + 3, col + 2, 1)/modifiedCFA(row + 3, col + 2, 2));
            
            % Green Pixel
            outputImage(row + 1, col + 1, 1) = modifiedCFA(row + 2, col + 2, 2) / 2 + (modifiedCFA(row + 1, col + 2, 1) / modifiedCFA(row + 1, col + 2, 2) + modifiedCFA(row + 3, col + 2, 1) / modifiedCFA(row + 3, col + 2, 2));
            outputImage(row + 1, col + 1, 3) = modifiedCFA(row + 2, col + 2, 2) / 2 + (modifiedCFA(row + 2, col + 1, 3) / modifiedCFA(row + 2, col + 1, 2) + modifiedCFA(row + 2, col + 3, 3) / modifiedCFA(row + 2, col + 3, 2));
        end
    end
    Output_RGB = uint8(outputImage);
end