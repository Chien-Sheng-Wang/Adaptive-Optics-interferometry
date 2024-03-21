
clc,clear,close all
% %Initialize ScanImage
% hSI = scanimage.SI;
% hSI.hRoiManager.scanType = 'Line'; % Set scan type to Line Scan
% 
% % Define your scan path (arbitrary line scanning)
% % Example: Create a stimulus group with desired ROIs
% stimGroup = hSI.hStimulusGroups.add('MyStimGroup');
% stimGroup.addROI([x1, y1]); % Define ROI 1
% stimGroup.addROI([x2, y2]); % Define ROI 2
% % ... Add more ROIs as needed
% 
% % Configure galvo mirrors (Analog Galvo)
% % Set up your galvo hardware according to your system
% % Example: Set the galvo voltage for each ROI
% hSI.hScan2D.resonantAngularRange = 20; % Set resonant angular range
% hSI.hScan2D.mirrorAngleMultiplierX = 1; % Adjust as needed
% hSI.hScan2D.mirrorAngleMultiplierY = 1; % Adjust as needed
% 
% % Start scanning
% hSI.start();
% 
% % Acquire pixel data in real time
% while hSI.acqState == 2 % While scanning
%     % Access pixel data for each ROI
%     for i = 1:numel(stimGroup.rois)
%         pixelData = hSI.hDisplay.stripeData{stimGroup.rois(i).stripeIndices(1)};
%         % Process pixelData as needed
%         % ...
%     end
% end
% 
% % Stop scanning
% hSI.stop();


%%
% % Initialize ScanImage
% %hSI = scanimage.SI;
% 
% % Set up DAQ session (replace with your specific DAQ configuration)
% s = daq.createSession('ni');
% s.addAnalogInputChannel('Dev1', 0, 'Voltage');
% 
% % Define SLM update parameters
% slmUpdateInterval = 0.1; % Set the desired update interval (in seconds)
% 
% % Initialize scan mirror position (replace with your actual position)
% % Example: Set the scan mirror to a specific angle (e.g., 0 degrees)
% desiredMirrorAngle = 0; % Set the desired static angle
% 
% % Main loop
% while true
%     % Acquire data from DAQ
%     data = s.inputSingleScan();
% 
%     % Update SLM display (replace with your SLM control code)
%     % Example: Set SLM phase pattern based on acquired data
%     % slm.setPhasePattern(data);
% 
%     % Keep the scan mirror in the desired static position
%     % Example: Set the scan mirror angle
%     % scanMirror.setPosition(desiredMirrorAngle);
% 
%     % Pause for the specified interval
%     pause(slmUpdateInterval);
% end
%%
% % Set up the scanning mirror (Mirrorcle Resonant Scanner)
% mirrorName = 'MyMirror'; % Replace with your mirror name
% mirrorConfig = scanimage();
% mirrorConfig.set('staticDuringFocus', true); % Set the mirror to be static during focus

% Static Scan Mirror Example
% Replace the placeholders with your actual hardware parameters


%%
% % Initialize ScanImage
% hSI = scanimage;
% 
% % Set up the scan mirror (e.g., galvanometric scanners)
% mirrorX = hSI.hRoiManager.scanAngularRangeX; % Get the X-axis scan range
% mirrorY = hSI.hRoiManager.scanAngularRangeY; % Get the Y-axis scan range
% 
% % Set static position (centered)
% staticPositionX = 0; % In degrees
% staticPositionY = 0; % In degrees
% 
% % Apply static position to the scan mirror
% hSI.hRoiManager.scanAngularRangeX = staticPositionX;
% hSI.hRoiManager.scanAngularRangeY = staticPositionY;
% 
% % Acquire an image (you can replace this with your actual imaging code)
% hSI.startGrab();
% hSI.waitForScannerStart();
% hSI.waitForScannerEnd();
% 
% % Restore original scan mirror settings (optional)
% hSI.hRoiManager.scanAngularRangeX = mirrorX;
% hSI.hRoiManager.scanAngularRangeY = mirrorY;
% 
% % Clean up
% hSI.delete();
% 
% disp('Static scan mirror acquired.');
%%
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Set the mirror position
% hSI.hScan2D.mroiCenterXY = mirror_position;
% 
% % Start scanning
% hSI.start();
%%
% 
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Stop scanning if it's already running
% if hSI.scanning
%     hSI.abort();
% end
% 
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Set the mirror position
% hSI.hRoiManager.scanZoomFactor = 1; % set scan zoom factor
% hSI.hRoiManager.scanShift = mirror_position; % set scan shift
% 
% % Start scanning
% hSI.start();

%%
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Set the mirror position
% hSI.hRoiManager.scanZoomFactor = 1; % set scan zoom factor
% hSI.hRoiManager.scanShift = mirror_position; % set scan shift
% 
% % Start scanning
% hSI.start();

%%
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Set the mirror position
% hSI.hRoiManager.scanZoomFactor = 1; % set scan zoom factor
% hSI.hRoiManager.scanShift = mirror_position; % set scan shift
% 
% % Start scanning
% hSI.start();

%%
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Set the mirror position
% hSI.hRoiManager.scanShift = mirror_position; % set scan shift
% 
% % Start scanning
% hSI.start();

%%
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Set the mirror position by adjusting the position of the ROI
% hSI.hRoiManager.requestedXYShift = mirror_position;
% 
% % Start scanning
% hSI.start();

%%
% % Initialize the ScanImage API
% hSI = scanimage.SI;
% 
% % Define mirror position
% mirror_position = [0, 0]; % [x, y] position in arbitrary units
% 
% % Create a new ROI
% roi = scanimage.Roi();
% roi.polygon = [0, 0; 1, 0; 1, 1; 0, 1]; % Define ROI as a rectangle, you can adjust this as needed
% 
% % Set the mirror position by moving the ROI
% hSI.hRoiManager.add(roi); % Add the ROI to the RoiManager
% hSI.hRoiManager.selectedROI = roi; % Select the ROI
% hSI.hRoiManager.selectedROI.centerXY = mirror_position; % Move the ROI to the desired position
% 
% % Start scanning
% hSI.start();

%%
% % Initialize the ScanImage API
hSI = scanimage;

% Define mirror position
mirror_position = [0, 0]; % [x, y] position in arbitrary units

% Create a new ROI
roi = scanimage.components.Roi();
roi.scanfields = [1 1]; % set the size of the ROI

% Set the mirror position by moving the ROI
roi.centerXY = mirror_position; % Move the ROI to the desired position

% Add the ROI to the RoiManager
hSI.hRoiManager.add(roi);

% Start scanning
hSI.start();


%%
Initialize ScanImage
hSI = scanimage;

Set up the scan mirror (assuming galvanometric scanners)
mirrorDevice = 'Galvo'; % Replace with the actual device name

Set static position (e.g., center)
staticVoltageX = 0; % Replace with desired voltage for X-axis
staticVoltageY = 0; % Replace with desired voltage for Y-axis

Set scan parameters
hSI.hScan2D.mirrorDevName = mirrorDevice;
hSI.hScan2D.voltsPerOpticalDegreeX = 1; % Adjust as needed
hSI.hScan2D.voltsPerOpticalDegreeY = 1; % Adjust as needed

Set static position
hSI.hScan2D.centerXVolts = staticVoltageX;
hSI.hScan2D.centerYVolts = staticVoltageY;

Start imaging
hSI.start();
