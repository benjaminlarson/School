% Create a set of calibration images.
images = imageSet(fullfile(toolboxdir('vision'), 'visiondemos', ...
    'calibration', 'fishEye'));
imageFileNames = images.ImageLocation;

% Detect calibration pattern.
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% Generate world coordinates of the corners of the squares.
squareSize = 29; % millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera.
[params, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints);

figure; showExtrinsics(params, 'CameraCentric');
figure; showExtrinsics(params, 'PatternCentric');

figure; showReprojectionErrors(params);

principalPoint = params.PrincipalPoint;
principalPointError = estimationErrors.IntrinsicsErrors.PrincipalPointError;

figure; imshow(imageFileNames{1}, 'InitialMagnification', 60); hold on;
plot(principalPoint(1), principalPoint(2), 'g+');
helperPlotEllipse(principalPoint, 1.96 * principalPointError, 'g');
legend('Estimated principal point', '95% confidence region');
title('Principal Point Uncertainty')
hold off;

% Get translation vectors and corresponding errors.
vectors = params.TranslationVectors;
errors = 1.96 * estimationErrors.ExtrinsicsErrors.TranslationVectorsError;

% Plot camera location.
figure;
hold on;
helperPlotCameraAxes();

% Plot an ellipsoid showing 95% confidence volume of uncertainty of
% location of each checkerboard origin.

labelOffset = 10;
for i = 1:params.NumPatterns
    ellipsoid(vectors(i,1), vectors(i,3), vectors(i,2), ...
        errors(i,1), errors(i,3), errors(i,3), 5)

    text(vectors(i,1) + labelOffset, vectors(i,3) + labelOffset, ...
        vectors(i,2) + labelOffset, num2str(i), ...
        'fontsize', 12, 'Color', 'r');
end
colormap('hot');
hold off;