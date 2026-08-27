function histogram_equalization_app()
% HISTOGRAM_EQUALIZATION_APP
% MATLAB version of the Histogram Equalization project.
%
% Run in MATLAB Command Window:
%   histogram_equalization_app

    % -----------------------------
    % Application state
    % -----------------------------
    originalImage = [];
    equalizedImage = [];

    % -----------------------------
    % Colors
    % -----------------------------
    bg = [16 24 39] / 255;
    sidebar = [23 32 51] / 255;
    card = [30 41 59] / 255;
    blue = [37 99 235] / 255;
    green = [22 163 74] / 255;
    purple = [124 58 237] / 255;
    grayButton = [71 85 105] / 255;
    white = [1 1 1];
    gray = [148 163 184] / 255;
    border = [51 65 85] / 255;

    % -----------------------------
    % Main window
    % -----------------------------
    fig = uifigure( ...
        'Name', 'Histogram Equalization - Digital Image Processing', ...
        'Position', [100 80 1200 700], ...
        'Color', bg);

    mainGrid = uigridlayout(fig, [1 2]);
    mainGrid.ColumnWidth = {260, '1x'};
    mainGrid.ColumnSpacing = 0;
    mainGrid.RowSpacing = 0;
    mainGrid.Padding = [0 0 0 0];

    % =========================================================
    % SIDEBAR
    % =========================================================
    side = uipanel(mainGrid, ...
        'BackgroundColor', sidebar, ...
        'BorderType', 'none');

    sideGrid = uigridlayout(side, [13 1]);
    sideGrid.RowHeight = {35, 20, 20, 1, 25, 42, 42, 42, 42, 42, 25, 120, '1x'};
    sideGrid.Padding = [15 15 15 15];
    sideGrid.RowSpacing = 6;

    uilabel(sideGrid, 'Text', 'IMAGE', 'FontSize', 22, 'FontWeight', 'bold', 'FontColor', blue);
    uilabel(sideGrid, 'Text', 'PROCESSING STUDIO', 'FontSize', 10, 'FontWeight', 'bold', 'FontColor', white);
    uilabel(sideGrid, 'Text', 'Digital Image Processing', 'FontSize', 8, 'FontColor', gray);

    uipanel(sideGrid, 'BackgroundColor', border, 'BorderType', 'none');

    uilabel(sideGrid, 'Text', 'OPERATIONS', 'FontSize', 9, 'FontWeight', 'bold', 'FontColor', gray);

    uibutton(sideGrid, 'Text', 'Upload Image', ...
        'ButtonPushedFcn', @uploadImage, ...
        'FontSize', 10, 'FontWeight', 'bold', ...
        'BackgroundColor', blue, 'FontColor', white);

    uibutton(sideGrid, 'Text', 'Equalize Histogram', ...
        'ButtonPushedFcn', @equalizeImage, ...
        'FontSize', 10, 'FontWeight', 'bold', ...
        'BackgroundColor', green, 'FontColor', white);

    uibutton(sideGrid, 'Text', 'Save Equalized Image', ...
        'ButtonPushedFcn', @saveImage, ...
        'FontSize', 10, 'FontWeight', 'bold', ...
        'BackgroundColor', grayButton, 'FontColor', white);

    uibutton(sideGrid, 'Text', 'Save Full Output', ...
        'ButtonPushedFcn', @saveFullOutput, ...
        'FontSize', 10, 'FontWeight', 'bold', ...
        'BackgroundColor', purple, 'FontColor', white);

    uibutton(sideGrid, 'Text', 'Reset', ...
        'ButtonPushedFcn', @resetApp, ...
        'FontSize', 10, 'FontWeight', 'bold', ...
        'BackgroundColor', border, 'FontColor', white);

    uilabel(sideGrid, 'Text', 'IMAGE INFORMATION', 'FontSize', 9, 'FontWeight', 'bold', 'FontColor', gray);

    infoLabel = uilabel(sideGrid, ...
        'Text', 'No image selected', ...
        'FontSize', 9, ...
        'FontColor', gray, ...
        'BackgroundColor', card, ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'top');

    uilabel(sideGrid, ...
        'Text', sprintf('Histogram Equalization\nMATLAB Version 1.0'), ...
        'FontSize', 8, ...
        'FontColor', [100 116 139]/255, ...
        'VerticalAlignment', 'bottom');

    % =========================================================
    % MAIN DISPLAY AREA
    % =========================================================
    mainGrid2 = uigridlayout(mainGrid, [3 1]);
    mainGrid2.RowHeight = {50, 30, '1x'};
    mainGrid2.Padding = [15 15 15 15];
    mainGrid2.RowSpacing = 8;
    mainGrid2.BackgroundColor = bg;

    % Title Box
    titleGrid = uigridlayout(mainGrid2, [2 1]);
    titleGrid.RowHeight = {28, 18};
    titleGrid.Padding = [0 0 0 0];
    titleGrid.RowSpacing = 0;
    uilabel(titleGrid, 'Text', 'Histogram Equalization', 'FontSize', 20, 'FontWeight', 'bold', 'FontColor', white);
    uilabel(titleGrid, 'Text', 'Improve image contrast by redistributing pixel intensities', 'FontSize', 9, 'FontColor', gray);

    % Status Label
    statusLabel = uilabel(mainGrid2, ...
        'Text', ' Ready — upload an image to begin', ...
        'FontSize', 9, ...
        'FontColor', gray, ...
        'BackgroundColor', card);

    % 2x2 DISPLAY GRID
    displayGrid = uigridlayout(mainGrid2, [2 2]);
    displayGrid.RowHeight = {'1x', '1x'};
    displayGrid.ColumnWidth = {'1x', '1x'};
    displayGrid.RowSpacing = 15;
    displayGrid.ColumnSpacing = 15;
    displayGrid.Padding = [0 0 0 0];

    % 1. Original Image View
    originalImageUI = uiimage(displayGrid);
    originalImageUI.ScaleMethod = 'fit';
    originalImageUI.BackgroundColor = card;

    % 2. Original Histogram Plot
    originalHistAx = uiaxes(displayGrid);
    styleAxes(originalHistAx, card, 'Original Histogram + CDF');

    % 3. Equalized Image View
    equalizedImageUI = uiimage(displayGrid);
    equalizedImageUI.ScaleMethod = 'fit';
    equalizedImageUI.BackgroundColor = card;

    % 4. Equalized Histogram Plot
    equalizedHistAx = uiaxes(displayGrid);
    styleAxes(equalizedHistAx, card, 'Equalized Histogram + CDF');

    % =========================================================
    % HELPER FUNCTIONS
    % =========================================================

    function rgbImg = toRGB(img)
        if isempty(img)
            rgbImg = [];
        elseif ismatrix(img)
            rgbImg = cat(3, img, img, img);
        else
            rgbImg = img;
        end
    end

    function styleAxes(ax, background, plotTitle)
        ax.Color = background;
        ax.XColor = [203 213 225]/255;
        ax.YColor = [203 213 225]/255;
        ax.GridColor = [148 163 184]/255;
        ax.GridAlpha = 0.2;
        ax.FontSize = 8;
        ax.Box = 'on';
        title(ax, plotTitle, 'Color', white, 'FontSize', 9, 'FontWeight', 'bold');
        xlabel(ax, 'Intensity', 'Color', gray);
        ylabel(ax, 'Frequency', 'Color', gray);
        xlim(ax, [0 255]);
        grid(ax, 'on');
    end

    function uploadImage(~, ~)
        [file, path] = uigetfile( ...
            {'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'; ...
             '*.*', 'All Files'}, 'Select an Image');

        if isequal(file, 0), return; end

        try
            fullName = fullfile(path, file);
            img = imread(fullName);

            % Convert to uint8 format if necessary
            if ~isa(img, 'uint8')
                img = im2uint8(mat2gray(img));
            end

            % KEEP ORIGINAL AS IS (NO RGB2GRAY CONVERSION)
            originalImage = img;
            equalizedImage = [];

            % Show Original Image
            originalImageUI.ImageSource = toRGB(originalImage);
            equalizedImageUI.ImageSource = []; % Clear previous

            plotHistogram(originalImage, originalHistAx, 'Original Histogram + CDF');
            cla(equalizedHistAx);
            styleAxes(equalizedHistAx, card, 'Equalized Histogram + CDF');

            [h, w, c] = size(originalImage);
            if c == 3
                modeStr = 'RGB Color';
            else
                modeStr = '8-bit Grayscale';
            end

            infoLabel.Text = sprintf( ...
                'File:\n%s\n\nDimensions:\n%d x %d\n\nMode:\n%s\n\nTotal Pixels:\n%d', ...
                file, w, h, modeStr, h*w);

            statusLabel.Text = ' ✓ Image uploaded successfully';
        catch ME
            uialert(fig, ME.message, 'Error');
        end
    end

    function equalizeImage(~, ~)
        if isempty(originalImage)
            uialert(fig, 'Please upload an image first.', 'No Image');
            return;
        end

        try
            statusLabel.Text = ' Processing histogram equalization...';
            drawnow;

            if size(originalImage, 3) == 3
                % Process Color Image (Equalize Value channel in HSV)
                hsv = rgb2hsv(originalImage);
                vChannel = uint8(hsv(:,:,3) * 255);
                vEqualized = applyEq(vChannel);
                hsv(:,:,3) = double(vEqualized) / 255;
                equalizedImage = hsv2rgb(hsv);
                equalizedImage = im2uint8(equalizedImage);
            else
                % Process Grayscale Image
                equalizedImage = applyEq(originalImage);
            end

            % Display Equalized Result
            equalizedImageUI.ImageSource = toRGB(equalizedImage);
            plotHistogram(equalizedImage, equalizedHistAx, 'Equalized Histogram + CDF');

            statusLabel.Text = ' ✓ Histogram equalization completed';
        catch ME
            uialert(fig, ME.message, 'Processing Error');
            statusLabel.Text = ' Processing failed';
        end
    end

    function eqImg = applyEq(imgChannel)
        pixels = imgChannel(:);
        histogramValues = accumarray(double(pixels) + 1, 1, [256 1]);

        cdf = cumsum(histogramValues);
        firstNonZero = find(cdf > 0, 1, 'first');
        if isempty(firstNonZero)
            eqImg = imgChannel;
            return;
        end
        cdfMin = cdf(firstNonZero);

        totalPixels = numel(pixels);
        denominator = totalPixels - cdfMin;

        if denominator == 0
            eqImg = imgChannel;
        else
            lookupTable = ((cdf - cdfMin) ./ denominator) * 255;
            lookupTable = uint8(max(0, min(255, lookupTable)));
            eqImg = reshape(lookupTable(double(pixels) + 1), size(imgChannel));
        end
    end

    function plotHistogram(img, ax, plotTitle)
        cla(ax);
        styleAxes(ax, card, plotTitle);

        if isempty(img)
            return;
        end

        if size(img, 3) == 3
            grayImg = rgb2gray(img);
        else
            grayImg = img;
        end

        values = grayImg(:);
        h = accumarray(double(values) + 1, 1, [256 1]);
        cdf = cumsum(h);

        if cdf(end) == 0
            return;
        end

        cdfNormalized = cdf / cdf(end);
        cdfScaled = cdfNormalized * max(h);

        hold(ax, 'on');

        bar(ax, 0:255, h, 1.0, ...
            'FaceColor', [0.85 0.15 0.15], ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.80);

        plot(ax, 0:255, cdfScaled, ...
            'Color', [1 1 1], ...
            'LineWidth', 1.5);

        hold(ax, 'off');
    end

    function saveImage(~, ~)
        if isempty(equalizedImage)
            uialert(fig, 'Please equalize the image first.', 'No Result');
            return;
        end

        [file, path] = uiputfile({'*.png', 'PNG Image'; '*.jpg', 'JPEG Image'}, ...
            'Save Equalized Image', 'equalized_image.png');

        if isequal(file, 0), return; end

        try
            imwrite(equalizedImage, fullfile(path, file));
            statusLabel.Text = ' ✓ Equalized image saved';
            uialert(fig, 'Equalized image saved successfully!', 'Saved');
        catch ME
            uialert(fig, ME.message, 'Save Error');
        end
    end

    function saveFullOutput(~, ~)
        if isempty(originalImage) || isempty(equalizedImage)
            uialert(fig, 'Please upload and equalize an image first.', 'Incomplete');
            return;
        end

        [file, path] = uiputfile({'*.png', 'PNG Image'; '*.jpg', 'JPEG Image'}, ...
            'Save Complete Output', 'histogram_equalization_output.png');

        if isequal(file, 0), return; end

        try
            outFig = figure('Visible', 'off', 'Color', 'white', 'Position', [100 100 1400 900]);
            tiledlayout(outFig, 2, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

            ax1 = nexttile; imshow(originalImage, 'Parent', ax1); title(ax1, 'Before Equalization');
            ax2 = nexttile; drawOutputHistogram(ax2, originalImage);
            ax3 = nexttile; imshow(equalizedImage, 'Parent', ax3); title(ax3, 'After Equalization');
            ax4 = nexttile; drawOutputHistogram(ax4, equalizedImage);

            sgtitle(outFig, 'Histogram Equalization Result', 'FontSize', 16, 'FontWeight', 'bold');
            exportgraphics(outFig, fullfile(path, file), 'Resolution', 150);
            close(outFig);

            statusLabel.Text = ' ✓ Complete output saved successfully';
            uialert(fig, 'Output saved successfully!', 'Saved');
        catch ME
            if exist('outFig', 'var') && isvalid(outFig), close(outFig); end
            uialert(fig, ME.message, 'Save Error');
        end
    end

    function drawOutputHistogram(ax, img)
        if size(img, 3) == 3
            grayImg = rgb2gray(img);
        else
            grayImg = img;
        end
        values = grayImg(:);
        h = accumarray(double(values) + 1, 1, [256 1]);
        cdf = cumsum(h);
        cdfScaled = (cdf / cdf(end)) * max(h);

        bar(ax, 0:255, h, 1.0, 'FaceColor', [0.85 0.15 0.15], 'EdgeColor', 'none');
        hold(ax, 'on');
        plot(ax, 0:255, cdfScaled, 'Color', [0 0 0], 'LineWidth', 2);
        hold(ax, 'off');
        title(ax, 'Histogram and CDF');
        xlim(ax, [0 255]); grid(ax, 'on');
    end

    function resetApp(~, ~)
        originalImage = [];
        equalizedImage = [];

        originalImageUI.ImageSource = [];
        equalizedImageUI.ImageSource = [];

        cla(originalHistAx);
        styleAxes(originalHistAx, card, 'Original Histogram + CDF');

        cla(equalizedHistAx);
        styleAxes(equalizedHistAx, card, 'Equalized Histogram + CDF');

        infoLabel.Text = 'No image selected';
        statusLabel.Text = ' Ready — upload an image to begin';
    end
end