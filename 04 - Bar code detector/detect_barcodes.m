%% Start

%%% Ejercicio 4
%%%% Desarrollar un programa en Matlab/Octave que permita detectar códigos de barras
%%%% utilizando rutinas básicas de procesamiento de imagen. Para probar el algoritmo se
%%%% proporciona un pequeño conjunto de imágenes junto con el enunciado (sección de
%%%% recursos de moodle). Igualmente, el alumno podrá capturar sus propias imágenes y
%%%% comprobar la efectividad del método desarrollado.

%% Si hay que hacer un clear o close
clear all;
close all;

%% Ejecucion del algoritmo
    
barCodeDetector(imread('barcodeimages/barcode1.jpg'), "vertical")
barCodeDetector(imread('barcodeimages/barcode2.jpg'), "horizontal")
barCodeDetector(imread('barcodeimages/barcode3.jpg'), "horizontal")
barCodeDetector(imread('barcodeimages/barcode4.jpg'), "horizontal")
barCodeDetector(imread('barcodeimages/barcode5.jpg'), "horizontal")
barCodeDetector(imread('barcodeimages/barcode6.jpg'), "horizontal")
 
 
%% Algoritmo

function barCodeDetector(image, rotation)

    show_for_debug = false;
    kernel_median = [4 4];
    tresh_binary = 200;

    % Step 1
    reduced_image = imresize(image, 1/4);

    % Step 2
    gray_image = rgb2gray(reduced_image);
    
    if (show_for_debug == true)
        disp("Gray image")
        imshow(gray_image)
        waitforbuttonpress;
    end

    % Step 3
    [Gx,Gy] = imgradientxy(gray_image); % using sobel
    gradient_result = abs(Gx - Gy);

    if (show_for_debug == true)
        disp("Gradients images")
        subplot(1,3,1), imshow(Gx)
        subplot(1,3,2), imshow(Gy)
        subplot(1,3,3), imshow(gradient_result)
        waitforbuttonpress;
    end

    % Step 4
    median_result = medfilt2(gradient_result, kernel_median);
    
    if (show_for_debug == true)
        disp("Gradient median result")
        subplot(1,1,1),
        imshow(median_result)
        waitforbuttonpress;
    end

    % Step 5
    binary_image = median_result > tresh_binary;

    if (show_for_debug == true)
        disp("Binary result")
        imshow(binary_image)
        waitforbuttonpress;
    end

    % Step 6
    if (rotation ==  "horizontal")
        SE = strel('rectangle', [7 21]);
    else
        SE = strel('rectangle', [29 7]);
    end

    morf = imclose(binary_image, SE);

    if (show_for_debug == true)
        disp("Morf")
        imshow(morf)
        waitforbuttonpress;
    end

    % Step 7
    SE = strel('square', 3);

    noise_reduced_image = imerode(morf, SE);
    noise_reduced_image = imerode(noise_reduced_image, SE);
    noise_reduced_image = imerode(noise_reduced_image, SE);
    noise_reduced_image = imerode(noise_reduced_image, SE);

    noise_reduced_image = imdilate(noise_reduced_image, SE);
    noise_reduced_image = imdilate(noise_reduced_image, SE);
    noise_reduced_image = imdilate(noise_reduced_image, SE);
    noise_reduced_image = imdilate(noise_reduced_image, SE);

    if (show_for_debug == true)
        disp("Noise reduction")
        imshow(noise_reduced_image)
        waitforbuttonpress;
    end

    % Step 8
    bounding_boxes = regionprops(noise_reduced_image, 'BoundingBox', 'Area');
    [~, area_max_index] = max([bounding_boxes.Area]);

    biggest_bounding_box = bounding_boxes(area_max_index);

    disp("Result")
    imshow(reduced_image);
    hold on;

    rectangle('Position', [biggest_bounding_box.BoundingBox(1), ...
        biggest_bounding_box.BoundingBox(2), ...
        biggest_bounding_box.BoundingBox(3), ...
        biggest_bounding_box.BoundingBox(4)], 'LineWidth', 3, 'EdgeColor', 'g')

    waitforbuttonpress;
    close all;
end

