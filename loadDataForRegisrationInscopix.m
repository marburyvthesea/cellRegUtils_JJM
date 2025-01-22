%%
% Define the base directory containing the subfolders
baseDir = '/Users/johnmarshall/Documents/Analysis/miniscope_lineartrack/m3_forAlignment_2/';

% Get a list of all subfolders following the "cellimages_day*" naming pattern
subfolders = dir(fullfile(baseDir, 'cellimages_day*'));

pathToDirectoryWithTrackingFiles='/Users/johnmarshall/Documents/Analysis/miniscope_lineartrack/m3_AlignedToTracking/';
aligned_to_tracking_files = ['ell_traces_Mouse3day2cellTracesAlignedToTracking.csv';
    'ell_traces_Mouse3day3cellTracesAlignedToTracking.csv';
    'ell_traces_Mouse3day4cellTracesAlignedToTracking.csv';
    'ell_traces_Mouse3day7cellTracesAlignedToTracking.csv'];

% Loop through each subfolder
for k = 1:numel(subfolders)
    % get the indicies of accepted neurons 
    %
    fileName = aligned_to_tracking_files(k,:); 
    fileData = readtable(strcat(pathToDirectoryWithTrackingFiles, fileName), 'VariableNamesLine', 1);
    firstRow = fileData{1, 2:end};
    numericArray = firstRow(~isnan(firstRow));
    numericArrayIndexCorrected = numericArray+1;

    % Get the full path of the current folder
    folderPath = fullfile(baseDir, subfolders(k).name);
    %folderPath = fullfile(baseDir, 'Day2');

    % Get a list of all image files in the current folder
    imageFiles = dir(fullfile(folderPath, '*.tiff'));
    %
    numImages = length(numericArrayIndexCorrected); % Total number of images
    
    % Read the first image to determine the dimensions
    firstImage = imread(fullfile(folderPath, imageFiles(1).name));
    [height, width] = size(firstImage);
    
    % Preallocate a 3D array for the images
    imageStack = zeros(height, width, numImages, 'like', firstImage);
    
    % Load all images into the 3D array
    for i = 1:length(numericArrayIndexCorrected)
        imageIdx = numericArrayIndexCorrected(1, i); 
        % Read the image
        currentImage = imread(fullfile(folderPath, imageFiles(imageIdx).name));
        
        % Store the image in the 3D array
        imageStack(:, :, i) = currentImage;
    end
    
    % Dynamically assign the 3D array to a variable named after the folder
    variableName = matlab.lang.makeValidName(subfolders(k).name); % Ensure the variable name is valid
    assignin('base', variableName, imageStack); % Assign to the base workspace
    
    % Display confirmation
    fprintf('Loaded %d images from %s into variable "%s".\n', numImages, subfolders(k).name, variableName);
end

%%
% reshape for cell reg

originalMatrix_1 = cellimages_day2;
reshapedMatrix_1 = permute(originalMatrix_1, [3, 1, 2]);

originalMatrix_2 = cellimages_day3;
reshapedMatrix_2 = permute(originalMatrix_2, [3, 1, 2]);

originalMatrix_3 = cellimages_day4;
reshapedMatrix_3 = permute(originalMatrix_3, [3, 1, 2]);

originalMatrix_4 = cellimages_day7;
reshapedMatrix_4 = permute(originalMatrix_4, [3, 1, 2]);



%%
% Initialize the cell array
cellsForSort_cell_array = containers.Map();

% Get all variables in the base workspace
vars = evalin('base', 'whos');

% Filter variables to include only those corresponding to the dynamically named arrays
for i = 1:numel(vars)
    if startsWith(vars(i).name, 'cellimages_day') % Check variable name pattern
        % Retrieve the array from the base workspace
        arrayData = evalin('base', vars(i).name);
        
        % Dynamically assign the array to the cell array with its name as the key
        cellsForSort_cell_array(vars(i).name) = arrayData;
    end
end

% Display confirmation
disp('Combined arrays into cellsForSort_cell_array.');

