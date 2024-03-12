clc,clear,close all
addpath('C:\Program Files\Meadowlark Optics\Blink OverDrive Plus\SDK','-begin')

% Load the DLL
% Blink_C_wrapper.dll, Blink_SDK.dll, ImageGen.dll, FreeImage.dll and wdapi1021.dll
% should all be located in the same directory as the program referencing the
% library
if ~libisloaded('Blink_C_wrapper')
    loadlibrary('Blink_C_wrapper.dll', 'Blink_C_wrapper.h');
end

% This loads the image generation functions
if ~libisloaded('ImageGen')
    loadlibrary('ImageGen.dll', 'ImageGen.h');
end


% Basic parameters for calling Create_SDK
bit_depth = 12; %bit depth = 8 for small 512, 12 for 1920
num_boards_found = libpointer('uint32Ptr', 0);
constructed_okay = libpointer('int32Ptr', 0);
is_nematic_type = 1;
RAM_write_enable = 1;
use_GPU = 1;
max_transients = 10000;
wait_For_Trigger = 0; % This feature is user-settable; use 1 for 'on' or 0 for 'off'
timeout_ms = 5000;

%Both pulse options can be false, but only one can be true. You either generate a pulse when the new image begins loading to the SLM
%or every 1.184 ms on SLM refresh boundaries, or if both are false no output pulse is generated.
OutputPulseImageFlip = 0;
OutputPulseImageRefresh = 0; %only supported on 1920x1152, FW rev 1.8.


% - This regional LUT file is only used with Overdrive Plus, otherwise it should always be a null string
reg_lut = libpointer('string');

% Call the constructor
buttons=calllib('Blink_C_wrapper', 'Create_SDK', bit_depth, num_boards_found, constructed_okay, is_nematic_type, RAM_write_enable, use_GPU, max_transients, reg_lut);


[file,path] = uigetfile('*.xlsx*','select camera image');
Table = readtable(fullfile(path,file));

% constructed okay return of 0 is success, nonzero integer is an error
if constructed_okay.value ~= 0
    disp('Blink SDK was not successfully constructed');
    disp(calllib('Blink_C_wrapper', 'Get_last_error_message'));
    calllib('Blink_C_wrapper', 'Delete_SDK');
else
    board_number = 1;
    disp('Blink SDK was successfully constructed');
    fprintf('Found %u SLM controller(s)\n', num_boards_found.value);

    height = calllib('Blink_C_wrapper', 'Get_image_height', board_number);
    width = calllib('Blink_C_wrapper', 'Get_image_width', board_number);

    %allocate arrays for our images
    Image = libpointer('uint8Ptr', zeros(width*height,1));
    WFC = libpointer('uint8Ptr', zeros(width*height,1));

    %***you should replace *bit_linear.LUT with your custom LUT file***
    %but for now open a generic LUT that linearly maps input graylevels to output voltages
    %***Using *bit_linear.LUT does NOT give a linear phase response***
    if width == 512
        lut_file = 'C:\\Program Files\\Meadowlark Optics\\Blink OverDrive Plus\\LUT Files\\8bit_linear.LUT';
    else
        lut_file = 'C:\\Program Files\\Meadowlark Optics\\Blink OverDrive Plus\\LUT Files\\12bit_linear.LUT';
    end
    calllib('Blink_C_wrapper', 'Load_LUT_file', board_number, lut_file);


    % Generate a blank wavefront correction image, you should load your
    % custom wavefront correction that was shipped with your SLM.
    % PixelValue = 0;
    % calllib('ImageGen', 'Generate_Solid', WFC, width, height, PixelValue);
    % WFC = reshape(WFC.Value, [width,height]);

    % Start the SLM with a blank image
    calllib('Blink_C_wrapper', 'Write_image', board_number, WFC, width*height, wait_For_Trigger, OutputPulseImageFlip, OutputPulseImageRefresh, timeout_ms);
    calllib('Blink_C_wrapper', 'ImageWriteComplete', board_number, timeout_ms);

    % % Generate a fresnel lens
    % CenterX = width/2;
    % CenterY = height/2;
    % Radius = height/2;
    % Power = 1;
    % cylindrical = true;
    % horizontal = false;
    % calllib('ImageGen', 'Generate_FresnelLens', ImageOne, width, height, CenterX, CenterY, Radius, Power, cylindrical, horizontal);
    % ImageOne = reshape(ImageOne.Value, [width,height]);
    % ImageOne = rot90(mod(ImageOne + WFC, 256));

    %void Generate_Zernike(unsigned char* Array, int width, int height, int CenterX, int CenterY, int Radius, double Piston, double TiltX, double TiltY, double Power, double AstigX, double AstigY, double ComaX, double ComaY, double PrimarySpherical, double
    % TrefoilX, double TrefoilY, double SecondaryAstigX, double SecondaryAstigY, double SecondaryComaX, double SecondaryComaY, double SecondarySpherical, double TetrafoilX, double TetrafoilY, double TertiarySpherical, double QuaternarySpherical); This function will fill an array to define an image of user defined dimensions using Zernike polynomials. The Zernikes center is defined by center x and center y. The radius defines the number of pixels over which one wave of phase change should occur.
    Range=1;
    StepSize=1;
    iteration=1;

    for n=-Range:StepSize:Range

        pupilimg=uint8(zeros(height,width));
        pupilMask=uint8(zeros(height,width));
        for pupilnumber=1:size(Table,1)
            %             Generate a zernike
            CenterX=Table.CxP(pupilnumber);
            CenterY=Table.CyP(pupilnumber);
            Radius=Table.Rp(pupilnumber);
            unitNumber=ceil((2*Radius).^2/4); %square area size
            n=1;
            for i=1:ceil(sqrt(unitNumber))
                for  j=1:ceil(sqrt(unitNumber)/2)
                    frequence(i,j,pupilnumber)=round(300+(n-1)*(600-300)/unitNumber,3); %  the decimal point more than 3 cannot be resolved, Unit:Hz
                    % Ts=1/800;  % frame rate of SLM
                    % t=0:Ts:1000-Ts; % lowering than 1000 is unable to reslove phase correctly
                    % phase=2*pi*frequence(i,j)*t;
                    pupilimg(ceil(CenterY-Radius+2*(i-1)):ceil(CenterY-Radius+2*(i-1))+1,ceil(CenterX+2*(j-1)):ceil(CenterX+2*(j-1))+1,:)=mod(2*pi*frequence(i,j,pupilnumber)*iteration,255).*[1 1;1 1];
                    n=n+1;
                end
            end
            %create a pupil mask
            pupilMask=uint8(poly2mask(CenterX+Radius*cos(0:0.1:2*pi),CenterY+Radius*sin(0:0.1:2*pi),height,width))+pupilMask;
            pupilimg=pupilimg.*pupilMask;
            

            %sum_non_zero = sum(pupilMask(:) ~= 0);
            % modulatedNumber=sum_non_zero/2/4;
        end
        

        %write image returns on DMA complete, ImageWriteComplete returns when the hardware
        %image buffer is ready to receive the next image. Breaking this into two functions is
        %useful for external triggers. It is safe to apply a trigger when Write_image is complete
        %and it is safe to write a new image when ImageWriteComplete returns
        calllib('Blink_C_wrapper', 'Write_image', board_number, pupilimg, width*height, wait_For_Trigger, OutputPulseImageFlip, OutputPulseImageRefresh, timeout_ms);
        calllib('Blink_C_wrapper', 'ImageWriteComplete', board_number, timeout_ms);
        pause(1.0) % This is in seconds - IF USING EXTERNAL TRIGGERS, SET THIS TO 0
        %figure(),imshow(pupilMask.*255)
        figure(),imshow(pupilimg)
        iteration=iteration+10;
    end


end


% Always call Delete_SDK before exiting
calllib('Blink_C_wrapper', 'Delete_SDK');


%destruct
if libisloaded('Blink_C_wrapper')
    unloadlibrary('Blink_C_wrapper');
end

if libisloaded('ImageGen')
    unloadlibrary('ImageGen');
end