%% MAIN
clear all; clc; close all;

path_in = "images/";
path_out = "blur/";
th = 2800;

blurrer(path_in,path_out)

blurdetection(path_out,th)


%% FUNCIONES PARA CREAR IMAGENES DESENFOCADAS Y DETECTAR SI ESTAN ENFOCADAS.

function blurdetection(path_in,th)
    if (isfolder(path_in) == 1)
           
        files = dir(fullfile(path_in,'*.jpg'));
        
        for i=1:length(files)

                act_img = fullfile(files(i).folder,files(i).name);

                img = im2double(rgb2gray(imread(act_img)));

                % Convolution image using Laplacian Filter.
                lap = fspecial("laplacian",0);
                img_filt = imadjust(conv2(img, lap, 'same')).*255;
                
                % Get variance of image.
                var_img_filt = var(img_filt(:));
                sprintf("%f", var_img_filt)

                %(menor varianza implica mayor desenfoque)
                %varianza img laplaciana < umbral -> Enfocada.
                if var_img_filt < th
                    text = ["Enfocada"];
                else
                    text = ["Desenfocada"];
                end
                position = [50 50]; 
                img_text = insertText(img, position, text,'FontSize',50, ...
                    'TextColor','red');
                
                figure(1)
                imshow(img_text)
                waitforbuttonpress;
        end
    end
    close all
end


function blurrer(path_in,path_out)
    if (isfolder(path_in) == 1) && (isfolder(path_out) == 1)
           
        files = dir(fullfile(path_in,'*.jpg')); %imagefiles = dir('*.bmp');
        size_filters = [3,15,21];
        
        for i=1:length(files)
            for f=1:length(size_filters)

                filter = size_filters(f);
                act_img = fullfile(files(i).folder,files(i).name);

                img = im2double(imread(act_img));

                kernel = ones(filter)/(filter^2);
                img_blur = convn(img,kernel,'same');

                [filepath,name,ext] = fileparts(act_img);
                save_path = path_out + "/" + name + "_" + filter + ext;
                imwrite(img_blur,save_path)
            end
        end
    end
end


%Otra forma para desenfocar imagenes pero que no me ha
%funcionado bien. 
%img_blur = imgaussfilt3(img,filter);
%img_blur = imgaussfilt3(img,'FilterSize',filter);

%  files = dir(fullfile(path_in,'*.jpg'),fullfile(path_in,'*.png'), ...
%             fullfile(path_in,'*.jpge'),fullfile(path_in,'*.bpm'));