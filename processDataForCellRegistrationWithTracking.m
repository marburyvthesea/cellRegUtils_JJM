directory = '/Users/johnmarshall/Documents/Analysis/MiniscopeMovies/YiwenData/233_sessions_to_align/';

% Initialize new cell arrays to store signalsForSort, A_reshaped_full, cellsForSort, X_coordinates_persession, and Y_coordinates_persession
signalsForSort_cell_array = cell(1, numel(tracking_files));
A_reshaped_full_cell_array = cell(1, numel(C_cell_array));
cellsForSort_cell_array = cell(1, numel(C_cell_array));
X_coordinates_persession = cell(1, numel(tracking_files));
Y_coordinates_persession = cell(1, numel(tracking_files));

% process data for Signal Sorter
% ciapkg.demo.cmdLinePipeline
ciapkg.loadBatchFxns();

% Iterate over the loaded data
for file_idx = 1:numel(tracking_files)
    % Extract variables from the tracking_files structure
    csvFileName = tracking_files(file_idx).name;
    outMatFileName = tracking_files(file_idx).out_mat_name;
    
    C = C_cell_array{file_idx};
    A = A_cell_array{file_idx};
    
    options = options_cell_array{file_idx};
    
    d1 = options.d1;
    d2 = options.d2;
    
    % Read the CSV file
    import_opts = detectImportOptions(fullfile(directory, csvFileName));
    import_opts.VariableNamesLine = 1; % Set variable names line

    dataCSV = readtable(fullfile(directory, csvFileName), import_opts);
   
    % Iterate over neurons
    num_neurons = size(A, 2);
    cellsForSort = zeros(options.d1, options.d2, num_neurons); % Initialize the result matrix
    X_coordinates_cell = cell(1, length(C));
    Y_coordinates_cell = cell(1, length(C));

    for neuron_idx = 1:num_neurons
        % Extract the column and convert it to a full matrix
        A_dense = full(A(:, neuron_idx));
        
        % Reshape the full matrix
        A_reshaped_full = reshape(A_dense, [options.d1, options.d2]);
        
        % Append the result to the 3D matrix
        cellsForSort(:, :, neuron_idx) = A_reshaped_full;

        % Extract X and Y coordinates from the CSV file
        X_coordinates_cell = dataCSV.X_coor(2:end);
        Y_coordinates_cell = dataCSV.Y_coor(2:end);
    end

    % Store signalsForSort, A_reshaped_full, cellsForSort, X_coordinates, and Y_coordinates in new cell arrays
    signalsForSort = C;
    
    % Store signalsForSort, A_reshaped_full, and cellsForSort in new cell arrays
    signalsForSort_cell_array{file_idx} = signalsForSort;
    A_reshaped_full_cell_array{file_idx} = A_reshaped_full;
    cellsForSort_cell_array{file_idx} = cellsForSort;
    X_coordinates_persession{file_idx} = X_coordinates_cell;
    Y_coordinates_persession{file_idx} = Y_coordinates_cell;
end

% Save the new cell arrays if needed
save('processed_results.mat', 'signalsForSort_cell_array', 'A_cell_array', 'A_reshaped_full_cell_array', 'X_coordinates_persession', 'Y_coordinates_persession');