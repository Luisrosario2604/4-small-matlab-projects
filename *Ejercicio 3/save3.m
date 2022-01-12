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

workingDir = './';
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

for ii = 1:length(imageNames)
   original_image = imread(fullfile(workingDir,'images',imageNames{ii}));
   [binary_image, BB] = color_tracking(original_image);

   %if BB ~= 0
   %    imshow(binary_image);
   %    hold on;
   %    rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',2) ;
   %end
   if BB(1) == 0 && BB(2) == 0 && BB(3) == 0 && BB(4) == 0
        imshow(binary_image);
        disp("NONONO");
   else
        imshow(binary_image);
        hold on;
        rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',2) ;
        disp(BB);
   end
   pause(0.03)

end



 %% color_tracking function
function [binary_image, BB] = color_tracking(original_image)
    gaussian_image = imgaussfilt(original_image, 2); % Step 1 (Gaussian)

    [BW,maskedRGBImage] = createMask(gaussian_image);  % Step 2 and 3 (HSV detection)
    
    SE = strel('rectangle',[3 3]);  % Step 4 Noise reduction
    BW = imerode(BW,SE);
    BW = imerode(BW,SE);

    BW = imdilate(BW,SE);
    BW = imdilate(BW,SE);

    %box = regionprops(BW,'FilledArea'); % Step 5
    %box = regionprops(BW, 'Area');
    %box = max( [box.Area] );
    %disp(stats);
    
    binary_image = BW;
    
    box = regionprops(BW,'Boundingbox');
    BB = [0 0 0 0];
    for k = 1 : length(box)
        BB = box(k).BoundingBox;   
        %BB = max([box.BoundingBox]);
    end

end

%% HSV automatic generated function
function [BW,maskedRGBImage] = createMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 29-Dec-2021
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.282;
channel1Max = 0.408;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.218;
channel2Max = 0.482;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.310;
channel3Max = 0.645;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end