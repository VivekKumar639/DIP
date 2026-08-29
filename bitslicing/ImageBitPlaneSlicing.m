function ImageBitPlaneSlicing
% ================================================================
%             IMAGE BIT PLANE SLICING
% ================================================================
% Digital Image Processing Project
%
% Features:
%   - Upload JPG, JPEG, PNG and BMP images
%   - Display original image
%   - Convert RGB image to grayscale
%   - Extract 8-bit planes from Bit 7 to Bit 0
%   - Display bit planes in 2 x 4 grid
%   - Save individual bit planes
%   - Clear / Reset application
%
% Actual Bit Plane Slicing Algorithm:
%
%   bit_plane = (image >> bit_position) & 1
%
% MATLAB implementation:
%
%   binaryPlane = bitand(bitshift(grayImage,-bitPosition),1);
%
% Binary output:
%
%   0 -> Black
%   1 -> White
% ================================================================


%% ================================================================
%  VARIABLES
% ================================================================

originalImage = [];
grayImage = [];
bitPlanes = cell(1,8);


%% ================================================================
% MAIN WINDOW
% ================================================================

fig = uifigure( ...
    'Name','Image Bit Plane Slicing', ...
    'Position',[50 40 1450 900], ...
    'Color',[0.94 0.94 0.94]);


%% ================================================================
% MAIN GRID
% ================================================================

mainGrid = uigridlayout(fig,[3 1]);

mainGrid.RowHeight = {70,240,'1x'};
mainGrid.ColumnWidth = {'1x'};

mainGrid.Padding = [12 12 12 12];
mainGrid.RowSpacing = 10;


%% ================================================================
% TITLE SECTION
% ================================================================

titlePanel = uipanel(mainGrid);

titlePanel.BorderType = 'none';
titlePanel.BackgroundColor = [0.12 0.15 0.20];

titleGrid = uigridlayout(titlePanel,[1 1]);
titleGrid.Padding = [5 5 5 5];

titleLabel = uilabel(titleGrid);

titleLabel.Text = 'IMAGE BIT PLANE SLICING';

titleLabel.FontSize = 25;
titleLabel.FontWeight = 'bold';

titleLabel.FontColor = [1 1 1];

titleLabel.HorizontalAlignment = 'center';


%% ================================================================
% TOP SECTION
% ================================================================

topPanel = uipanel(mainGrid);

topPanel.Title = 'Image Upload & Original Image';
topPanel.FontSize = 15;
topPanel.FontWeight = 'bold';


%% ================================================================
% TOP GRID
% ================================================================

topGrid = uigridlayout(topPanel,[1 2]);

topGrid.ColumnWidth = {340,'1x'};

topGrid.Padding = [10 10 10 10];
topGrid.ColumnSpacing = 15;


%% ================================================================
% CONTROL PANEL
% ================================================================

controlPanel = uipanel(topGrid);

controlPanel.Title = 'Controls';
controlPanel.FontSize = 13;
controlPanel.FontWeight = 'bold';


%% ================================================================
% CONTROL GRID
% ================================================================

controlGrid = uigridlayout(controlPanel,[6 1]);

% IMPORTANT:
% Fixed row heights ensure that Generate button is visible.

controlGrid.RowHeight = {42,32,32,42,42,30};

controlGrid.Padding = [12 10 12 10];

controlGrid.RowSpacing = 6;


%% ================================================================
% UPLOAD BUTTON
% ================================================================

uploadButton = uibutton(controlGrid,'push');

uploadButton.Text = 'Upload Image';

uploadButton.FontSize = 14;
uploadButton.FontWeight = 'bold';

uploadButton.ButtonPushedFcn = @uploadImage;


%% ================================================================
% FILE NAME LABEL
% ================================================================

fileLabel = uilabel(controlGrid);

fileLabel.Text = 'File: No image selected';

fileLabel.FontSize = 11;


%% ================================================================
% DIMENSIONS LABEL
% ================================================================

dimensionLabel = uilabel(controlGrid);

dimensionLabel.Text = 'Dimensions: -- x --';

dimensionLabel.FontSize = 11;


%% ================================================================
% GENERATE BUTTON
% ================================================================

generateButton = uibutton(controlGrid,'push');

generateButton.Text = 'Generate Bit Planes';

generateButton.FontSize = 13;
generateButton.FontWeight = 'bold';

% Initially disabled until an image is uploaded
generateButton.Enable = 'off';

generateButton.ButtonPushedFcn = @generateBitPlanes;


%% ================================================================
% RESET BUTTON
% ================================================================

resetButton = uibutton(controlGrid,'push');

resetButton.Text = 'Clear / Reset';

resetButton.FontSize = 13;

resetButton.ButtonPushedFcn = @resetApplication;


%% ================================================================
% STATUS LABEL
% ================================================================

statusLabel = uilabel(controlGrid);

statusLabel.Text = 'Status: Ready';

statusLabel.FontWeight = 'bold';

statusLabel.FontSize = 11;


%% ================================================================
% ORIGINAL IMAGE PANEL
% ================================================================

originalPanel = uipanel(topGrid);

originalPanel.Title = 'Original Image';

originalPanel.FontWeight = 'bold';
originalPanel.FontSize = 13;


%% ================================================================
% ORIGINAL IMAGE AXES
% ================================================================

originalAxes = uiaxes(originalPanel);

originalAxes.Position = [10 10 1020 155];

originalAxes.XTick = [];
originalAxes.YTick = [];

originalAxes.Box = 'on';

title(originalAxes,'Original Image');


%% ================================================================
% RESULT PANEL
% ================================================================

resultPanel = uipanel(mainGrid);

resultPanel.Title = '8-Bit Bit Plane Results';

resultPanel.FontSize = 15;
resultPanel.FontWeight = 'bold';


%% ================================================================
% RESULT GRID
% ================================================================

resultGrid = uigridlayout(resultPanel,[2 4]);

resultGrid.RowHeight = {'1x','1x'};

resultGrid.ColumnWidth = {'1x','1x','1x','1x'};

resultGrid.Padding = [8 8 8 8];

resultGrid.RowSpacing = 8;
resultGrid.ColumnSpacing = 8;


%% ================================================================
% CREATE 8 BIT PLANE PANELS
% ================================================================

planeAxes = gobjects(1,8);

saveButtons = gobjects(1,8);


for i = 1:8

    % ------------------------------------------------------------
    % Calculate bit number
    %
    % i = 1 -> Bit 7
    % i = 2 -> Bit 6
    % ...
    % i = 8 -> Bit 0
    % ------------------------------------------------------------

    bitNumber = 8 - i;


    % ------------------------------------------------------------
    % Create panel
    % ------------------------------------------------------------

    planePanel = uipanel(resultGrid);


    % Panel title

    if bitNumber == 7

        planePanel.Title = 'Bit Plane 7 (MSB)';

    elseif bitNumber == 0

        planePanel.Title = 'Bit Plane 0 (LSB)';

    else

        planePanel.Title = sprintf( ...
            'Bit Plane %d',bitNumber);

    end


    planePanel.FontWeight = 'bold';
    planePanel.FontSize = 11;


    % ------------------------------------------------------------
    % Grid inside each panel
    % ------------------------------------------------------------

    planeGrid = uigridlayout(planePanel,[2 1]);

    planeGrid.RowHeight = {'1x',28};

    planeGrid.Padding = [5 5 5 5];


    % ------------------------------------------------------------
    % Axes for displaying actual bit plane
    %
    % We use AXES + IMSHOW instead of UIIMAGE.
    % This avoids the placeholder-image problem.
    % ------------------------------------------------------------

    planeAxes(i) = uiaxes(planeGrid);

    planeAxes(i).XTick = [];
    planeAxes(i).YTick = [];

    planeAxes(i).Box = 'on';


    % ------------------------------------------------------------
    % Save button
    % ------------------------------------------------------------

    saveButtons(i) = uibutton(planeGrid,'push');

    saveButtons(i).Text = ...
        sprintf('Save Bit Plane %d',bitNumber);

    saveButtons(i).FontSize = 10;

    saveButtons(i).Enable = 'off';

    % Store bit number
    saveButtons(i).UserData = bitNumber;

    saveButtons(i).ButtonPushedFcn = @saveBitPlane;

end


%% ================================================================
% FUNCTION 1: UPLOAD IMAGE
% ================================================================

    function uploadImage(~,~)

        % --------------------------------------------------------
        % Open file selection dialog
        % --------------------------------------------------------

        [file,path] = uigetfile( ...
            { ...
            '*.jpg;*.jpeg;*.png;*.bmp', ...
            'Image Files (*.jpg, *.jpeg, *.png, *.bmp)' ...
            }, ...
            'Select an Image');


        % --------------------------------------------------------
        % User cancelled
        % --------------------------------------------------------

        if isequal(file,0)

            return;

        end


        try

            % ----------------------------------------------------
            % Complete file path
            % ----------------------------------------------------

            fullPath = fullfile(path,file);


            % ----------------------------------------------------
            % Read image
            % ----------------------------------------------------

            originalImage = imread(fullPath);


            % ----------------------------------------------------
            % Find image dimensions
            % ----------------------------------------------------

            [height,width,~] = size(originalImage);


            % ----------------------------------------------------
            % Display original image
            % ----------------------------------------------------

            cla(originalAxes);

            imshow(originalImage, ...
                'Parent',originalAxes);

            title(originalAxes,'Original Image');


            % ----------------------------------------------------
            % Display file name
            % ----------------------------------------------------

            fileLabel.Text = ...
                ['File: ' file];


            % ----------------------------------------------------
            % Display dimensions
            % ----------------------------------------------------

            dimensionLabel.Text = sprintf( ...
                'Dimensions: %d x %d', ...
                width,height);


            % ----------------------------------------------------
            % Update status
            % ----------------------------------------------------

            statusLabel.Text = ...
                'Status: Image uploaded successfully';


            % ----------------------------------------------------
            % Enable Generate button
            % ----------------------------------------------------

            generateButton.Enable = 'on';


            % ----------------------------------------------------
            % Clear previous bit planes
            % ----------------------------------------------------

            for k = 1:8

                cla(planeAxes(k));

                planeAxes(k).XTick = [];
                planeAxes(k).YTick = [];

                saveButtons(k).Enable = 'off';

                bitPlanes{k} = [];

            end


        catch ME

            % ----------------------------------------------------
            % Error message
            % ----------------------------------------------------

            uialert(fig, ...
                sprintf( ...
                'Unable to load the selected image.\n\n%s', ...
                ME.message), ...
                'Image Loading Error', ...
                'Icon','error');


            statusLabel.Text = ...
                'Status: Error loading image';

        end

    end


%% ================================================================
% FUNCTION 2: GENERATE BIT PLANES
% ================================================================

    function generateBitPlanes(~,~)

        % --------------------------------------------------------
        % Check whether image exists
        % --------------------------------------------------------

        if isempty(originalImage)

            uialert(fig, ...
                'Please upload an image first.', ...
                'No Image Selected', ...
                'Icon','warning');

            return;

        end


        try

            % ----------------------------------------------------
            % Update status
            % ----------------------------------------------------

            statusLabel.Text = ...
                'Status: Processing image...';

            drawnow;


            % ----------------------------------------------------
            % Create progress dialog
            % ----------------------------------------------------

            progress = uiprogressdlg(fig, ...
                'Title','Bit Plane Processing', ...
                'Message','Converting image to grayscale...', ...
                'Value',0);

            drawnow;


            % ====================================================
            % STEP 1: RGB TO GRAYSCALE
            % ====================================================

            if ndims(originalImage) == 3

                grayImage = rgb2gray(originalImage);

            else

                grayImage = originalImage;

            end


            % ----------------------------------------------------
            % Make sure grayscale image is uint8
            % ----------------------------------------------------

            if ~isa(grayImage,'uint8')

                grayImage = im2uint8(grayImage);

            end


            progress.Value = 0.15;

            progress.Message = ...
                'Grayscale conversion completed...';

            drawnow;


            % ====================================================
            % STEP 2: EXTRACT 8 BIT PLANES
            % ====================================================

            for i = 1:8

                % ------------------------------------------------
                % Bit position
                %
                % i = 1 -> 7
                % i = 2 -> 6
                % ...
                % i = 8 -> 0
                % ------------------------------------------------

                bitPosition = 8 - i;


                % =================================================
                % ACTUAL BIT PLANE SLICING
                % =================================================
                %
                % Mathematical operation:
                %
                %       (image >> bitPosition) & 1
                %
                % MATLAB:
                %
                %       bitand(
                %           bitshift(grayImage,-bitPosition),
                %           1
                %       )
                %
                % =================================================

                binaryPlane = bitand( ...
                    bitshift(grayImage,-bitPosition), ...
                    1);


                % ------------------------------------------------
                % Convert binary image to black and white
                %
                % 0 -> 0
                % 1 -> 255
                % ------------------------------------------------

                displayPlane = uint8(binaryPlane * 255);


                % ------------------------------------------------
                % Store bit plane
                % ------------------------------------------------

                bitPlanes{i} = displayPlane;


                % ------------------------------------------------
                % Display actual bit plane
                % ------------------------------------------------

                cla(planeAxes(i));

                imshow(displayPlane, ...
                    'Parent',planeAxes(i));


                % Remove axis numbers

                planeAxes(i).XTick = [];
                planeAxes(i).YTick = [];


                % ------------------------------------------------
                % Enable save button
                % ------------------------------------------------

                saveButtons(i).Enable = 'on';


                % ------------------------------------------------
                % Update progress
                % ------------------------------------------------

                progress.Value = ...
                    0.15 + (i/8)*0.85;


                progress.Message = sprintf( ...
                    'Generating Bit Plane %d...', ...
                    bitPosition);


                statusLabel.Text = sprintf( ...
                    'Status: Generating Bit Plane %d...', ...
                    bitPosition);


                drawnow;

            end


            % ====================================================
            % PROCESSING COMPLETE
            % ====================================================

            progress.Value = 1;

            progress.Message = ...
                'All bit planes generated successfully!';

            drawnow;

            pause(0.3);

            close(progress);


            statusLabel.Text = ...
                'Status: All 8 Bit Planes Generated Successfully';


        catch ME

            % ----------------------------------------------------
            % Close progress dialog if it exists
            % ----------------------------------------------------

            if exist('progress','var')

                try

                    close(progress);

                catch

                end

            end


            % ----------------------------------------------------
            % Show error
            % ----------------------------------------------------

            uialert(fig, ...
                sprintf( ...
                'Bit plane processing failed.\n\n%s', ...
                ME.message), ...
                'Processing Error', ...
                'Icon','error');


            statusLabel.Text = ...
                'Status: Processing Error';

        end

    end


%% ================================================================
% FUNCTION 3: SAVE BIT PLANE
% ================================================================

    function saveBitPlane(src,~)

        % --------------------------------------------------------
        % Get bit number
        % --------------------------------------------------------

        bitNumber = src.UserData;


        % --------------------------------------------------------
        % Convert bit number to cell index
        %
        % Bit 7 -> index 1
        % Bit 6 -> index 2
        % ...
        % Bit 0 -> index 8
        % --------------------------------------------------------

        index = 8 - bitNumber + 1;


        % --------------------------------------------------------
        % Check whether bit plane exists
        % --------------------------------------------------------

        if isempty(bitPlanes{index})

            uialert(fig, ...
                'Please generate the bit planes first.', ...
                'No Bit Plane', ...
                'Icon','warning');

            return;

        end


        % --------------------------------------------------------
        % Default file name
        % --------------------------------------------------------

        defaultName = sprintf( ...
            'Bit_Plane_%d.png', ...
            bitNumber);


        % --------------------------------------------------------
        % Save dialog
        % --------------------------------------------------------

        [file,path] = uiputfile( ...
            { ...
            '*.png','PNG Image (*.png)'; ...
            '*.jpg','JPEG Image (*.jpg)' ...
            }, ...
            sprintf('Save Bit Plane %d',bitNumber), ...
            defaultName);


        % User cancelled
        if isequal(file,0)

            return;

        end


        try

            % ----------------------------------------------------
            % Save image
            % ----------------------------------------------------

            outputPath = fullfile(path,file);

            imwrite( ...
                bitPlanes{index}, ...
                outputPath);


            % ----------------------------------------------------
            % Update status
            % ----------------------------------------------------

            statusLabel.Text = sprintf( ...
                'Status: Bit Plane %d saved successfully', ...
                bitNumber);


        catch ME

            uialert(fig, ...
                sprintf( ...
                'Unable to save the image.\n\n%s', ...
                ME.message), ...
                'Save Error', ...
                'Icon','error');

        end

    end


%% ================================================================
% FUNCTION 4: RESET APPLICATION
% ================================================================

    function resetApplication(~,~)

        % --------------------------------------------------------
        % Clear variables
        % --------------------------------------------------------

        originalImage = [];

        grayImage = [];

        bitPlanes = cell(1,8);


        % --------------------------------------------------------
        % Clear original image
        % --------------------------------------------------------

        cla(originalAxes);

        originalAxes.XTick = [];
        originalAxes.YTick = [];


        % --------------------------------------------------------
        % Clear all bit planes
        % --------------------------------------------------------

        for k = 1:8

            cla(planeAxes(k));

            planeAxes(k).XTick = [];
            planeAxes(k).YTick = [];

            saveButtons(k).Enable = 'off';

        end


        % --------------------------------------------------------
        % Reset labels
        % --------------------------------------------------------

        fileLabel.Text = ...
            'File: No image selected';

        dimensionLabel.Text = ...
            'Dimensions: -- x --';

        statusLabel.Text = ...
            'Status: Ready';


        % --------------------------------------------------------
        % Disable Generate button
        % --------------------------------------------------------

        generateButton.Enable = 'off';

    end

end