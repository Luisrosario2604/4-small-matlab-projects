%% Start

%%% Ejercicio 2
%%%% Javier se ha comprado un disco NAS para que su familia pueda subir todas las fotos
%%%% que van haciendo de su hija Ana con sus móviles. Javier quiere tener todas las fotos
%%%% posibles de su hija, pero no con cualquier calidad. Le gustaría poder eliminar todas
%%%% aquellas fotos que estén desenfocadas de su biblioteca. Nuestro objetivo en este
%%%% primer problema es ayudar a Javier a automatizar esta tarea.

%% Si hay que hacer un clear o close
clear all;
close all;

%% Definir los parametros

image_dir_path = "images_originals/";
output_dir_path = "images_blurred/";

image_dir_to_detect_path = "all_images/";
threshold = 200;

%% Ejecutar la function blurrer

% solo funciona con jpg, si no hay que cambiar la primera variable de la
% funcion
blurrer(image_dir_path, output_dir_path)

%% Ejecutar la function blurdetection

% solo funciona con jpg, si no hay que cambiar la primera variable de la
% funcion
blurdetection(image_dir_to_detect_path, threshold)

%% Funciones blurrer y blurdetection

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% blurrer = funcion para desenfocar las imagenes

function blurrer(image_dir_path, output_dir_path)
    
    extention_original_images = '*.jpg';

    if (isfolder(image_dir_path) ~= 1)
        disp("[ERROR] Original images directory path does not exist")
        return;
    end

    if (isfolder(output_dir_path) ~= 1)
        disp("[ERROR] Original images directory path does not exist")
        return;
    end

    dir_full_path = fullfile(image_dir_path, extention_original_images);
    all_images = dir(dir_full_path); 

    for i=1:length(all_images)
        kernel_1 = ones(3) / (3 ^ 2);
        kernel_2 = ones(15) / (15 ^ 2);
        kernel_3 = ones(21) / (21 ^ 2);

        full_path_img = fullfile(all_images(i).folder, all_images(i).name);
        image = im2double(imread(full_path_img));

        img_blur_1 = convn(image, kernel_1, 'same');
        img_blur_2 = convn(image, kernel_2, 'same');
        img_blur_3 = convn(image, kernel_3, 'same');

        [path, name, ext] = fileparts(full_path_img);
        
        imwrite(img_blur_1, output_dir_path + name + "_3" + ext)
        imwrite(img_blur_2, output_dir_path + name + "_15" + ext)
        imwrite(img_blur_3, output_dir_path + name + "_21" + ext)
    end

    disp("Done !")
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% blurdetection = funcion para detectar el blur o no

function blurdetection(image_dir_to_detect_path, threshold)
    
    extention_original_images = '*.jpg';

    if (isfolder(image_dir_to_detect_path) ~= 1)
        disp("[ERROR] Original images directory path does not exist")
        return;
    end

     dir_full_path = fullfile(image_dir_to_detect_path, extention_original_images);
     all_images = dir(dir_full_path);

     for i=1:length(all_images)
         full_path_img = fullfile(all_images(i).folder, all_images(i).name);

         laplacian = fspecial("laplacian");
         image_laplacian = imfilter(im2double(rgb2gray(imread(full_path_img))), laplacian, 'replicate', 'conv').*255;
         variance_of_image = var(image_laplacian(:));
         
         if variance_of_image < threshold
             disp("Image name : " + all_images(i).name + " Variace = " + variance_of_image + ", Out of focus")
             result = insertText(imread(full_path_img), [20 10], "Out of focus", 'FontSize', 15, 'TextColor', 'white', 'BoxColor', 'black', 'BoxOpacity', 1);
         else
             disp("Image name : " + all_images(i).name + " Variace = " + variance_of_image + ", Focused")
             result = insertText(imread(full_path_img), [20 10], "Focused", 'FontSize', 15, 'TextColor', 'white', 'BoxColor', 'black', 'BoxOpacity', 1);
         end
         
         result = insertText(result, [20 40], all_images(i).name, 'FontSize', 15, 'TextColor', 'white', 'BoxColor', 'black', 'BoxOpacity', 1);  
         figure(1)
         imshow(result)
         waitforbuttonpress;
     end
     close all;
end