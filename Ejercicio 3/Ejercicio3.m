%% Start

%%% Ejercicio 3
%%%% Desarrollar un sistema de visión artificial que permita hacer seguimiento visual por
%%%% color de un objeto. El sistema debe ser capaz de detectar el objeto (en el caso de
%%%% que se encuentre presente) en cada fotograma. El objeto puede moverse
%%%% libremente, pudiendo cambiar su escala y la perspectiva con la que se ve el mismo.

%% Si hay que hacer un clear o close
clear all;
close all;

%% Definir los parametros

using_video = true;
video_path = 'lapiz.avi';
sequence_dir_path = 'images';

%% Si utilizas un video -> hay que transformarlo en una secuencia de imágenes

if using_video == true
    try
        v = VideoReader(video_path);
    catch ERR
        causeException = MException('Video:fileNotFound', "[ERROR] Can't read the video, check video_path parameter");
        ERR = addCause(ERR,causeException);
        rethrow(ERR);
    end

    mkdir(sequence_dir_path);
    
    i = 1;
    while hasFrame(v)
        image = readFrame(v);
        image_path = fullfile(sequence_dir_path, append(int2str(i), '.jpg'));
        disp(image_path + " created !")
        imwrite(image, image_path)
        i = i+1;
    end

end

%% Leer la secuacia de imagenes

dir_full_path = fullfile(sequence_dir_path, '*.jpg');
only_dir_path = fullfile(sequence_dir_path);
all_images = dir(dir_full_path);

if length(all_images) == 0
    causeException = MException('Video:fileNotFound', "[ERROR] Images sequence not found !");
    throw(causeException);
end

for i=1:numel(all_images)
    image_name = [only_dir_path '/' int2str(i) '.jpg'];
    disp(image_name)
    original_image = imread(fullfile(image_name));
    
    % Step 1
    gaussian_image = gaussian_filter(original_image, 2);

    % Step 2
    hsv_image = convert_hsv(gaussian_image);

    % Step 3
    mask = segmentation_hsv_filter(hsv_image);
    masked_image = original_image;
    masked_image(repmat(~mask,[1 1 3])) = 0;


    % Step 4
    mask_noise_reduced = noise_reduction(mask);

    % Step 5
    biggest_bounding_box = get_biggest_region(mask_noise_reduced);

    % Show image
    imshow(original_image);
    hold on;

    % Step 6
    draw_bounding_box(biggest_bounding_box);

    % Step 7
    pause(0.033)

end

close all;

%% color_tracking function

% Step 1
function gaussian_image = gaussian_filter(image, sigma)
    gaussian_image = imgaussfilt(image, sigma);
end

% Step 2
function hsv_image = convert_hsv(image)
    hsv_image = rgb2hsv(image);
end

% Step 3
function mask = segmentation_hsv_filter(hsv)
    H_min = 41 / 255;
    H_max = 127 / 255;

    S_min = 47 / 255;
    S_max = 255 / 255;

    V_min = 12 / 255;
    V_max = 255 / 255;

    mask = (hsv(:,:,1) >= H_min ) & (hsv(:,:,1) <= H_max) & (hsv(:,:,2) >= S_min) & (hsv(:,:,2) <= S_max) & (hsv(:,:,3) >= V_min) & (hsv(:,:,3) <= V_max);
end

% Step 4
function noise_reducted_image = noise_reduction(image)
    SE = strel('rectangle',[3 3]);
    image = imerode(image, SE);
    image = imerode(image, SE);
    image = imdilate(image, SE);
    image = imdilate(image, SE);

    noise_reducted_image = image;
end

% Step 5
function biggest_bounding_box = get_biggest_region(image)
    bounding_boxes = regionprops(image, 'Boundingbox', 'Area');
    [~, area_max_index] = max([bounding_boxes.Area]);

    biggest_bounding_box = bounding_boxes(area_max_index);
end

% Step 6
function draw_bounding_box(bounding_box)
    if bounding_box.BoundingBox(1) ~= 0 || bounding_box.BoundingBox(2) ~= 0 || bounding_box.BoundingBox(3) ~= 0 || bounding_box.BoundingBox(4) ~= 0
        rectangle('Position', [bounding_box.BoundingBox(1), bounding_box.BoundingBox(2), bounding_box.BoundingBox(3), bounding_box.BoundingBox(4)], 'LineWidth', 3, 'EdgeColor', 'g');
        plot(bounding_box.BoundingBox(1) + (bounding_box.BoundingBox(3) / 2), bounding_box.BoundingBox(2) + (bounding_box.BoundingBox(4) / 2), '.r', 'MarkerSize', 7);
    end
end