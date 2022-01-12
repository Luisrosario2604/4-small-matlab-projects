%% Change video to image sequence

sequence_directory_name = 'images';     % Configurable
video_name = 'lapiz.avi';               % Configurable

% Cree una carpeta de trabajo temporal para almacenar la secuencia de imágenes.
workingDir = './';
mkdir(workingDir)
mkdir(workingDir, sequence_directory_name)

% Crear un VideoReader
shuttleVideo = VideoReader(video_name);


% Crear la secuencia de imágenes
ii = 1;

while hasFrame(shuttleVideo)
   img = readFrame(shuttleVideo);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(workingDir,'images',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end

%% Read image sequence
% Should JPEG files named like this : (img1.jpg, img2.jpg, etc.) 

hThresholds = [0.24, 0.44];             % Configurable
sThresholds = [0.8, 1.0];               % Configurable
vThresholds = [20, 125];                % Configurable


workingDir = './';
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

for ii = 1:length(imageNames)
   original_image = imread(fullfile(workingDir,'images',imageNames{ii}));
   binary_image = color_tracking(original_image);
   imshow(binary_image);

   %h = binary_image(:,:,1);
   %s = binary_image(:,:,2);
   %v = binary_image(:,:,3);
end



%% color_tracking function
function binary_image = color_tracking(original_image)
    gaussian_image = imgaussfilt(original_image, 2); % Step 1 (Gaussian)
    hsv = rgb2hsv(gaussian_image); % Step 2 (HSV)

    H_rank = [29 / 180, 88 / 180];
    S_rank = [43 / 255, 255 / 255];
    V_rank = [126 / 255, 255 / 255];

    %hsv(:,:,1) = (hsv(:,:,1) * 180 > (H_rank(1))) & (hsv(:,:,1) * 180 < (H_rank(2)));
    %hsv(:,:,2) = (hsv(:,:,2) * 255 > (S_rank(1))) & (hsv(:,:,2) * 255 < (S_rank(2)));
    %hsv(:,:,3) = (hsv(:,:,3) * 255 > (V_rank(1))) & (hsv(:,:,3) * 255 < (V_rank(2)));

    %copy = hsv;

    relevanceMask = rgb2gray(original_image)>0;
    mask = (29 / 180 < hsv(:,:,1)) & (43 / 255 < hsv(:,:,2)) & (126 / 255 < hsv(:,:,3)) & (88 / 180 > hsv(:,:,1)) & (43 / 255 > hsv(:,:,2)) & (126 / 255 > hsv(:,:,3));

    res = sum(mask(:)) / sum(relevanceMask(:));


    % We return to the RGB format:
    %mask = hsv2rgb(hsv);
    binary_image = res;

end