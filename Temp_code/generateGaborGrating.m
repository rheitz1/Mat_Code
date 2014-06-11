warning off
clear m img
color = 'w';

whichScreen = 0;
window = Screen(whichScreen,'OpenWindow',[],[10 10 800 600],16);
white = WhiteIndex(window);
black = BlackIndex(window);
gray = (white+black)/2;
red = [255 0 0];
inc = white-gray;
Screen(window,'FillRect',gray);



freq = .05;
imgsize = 50;
angle = 20;
pixelScale = 300;

[x,y] = meshgrid(-imgsize:imgsize,-imgsize:imgsize);

%convert angle to radians
angle_rad = (pi/180) * angle;

x = x * cos(angle_rad)*pixelScale; % compute proportion of X for given orientation
y = y * sin(angle_rad)*pixelScale; % compute proportion of Y for given orientation
xy = x + y;                      % sum X and Y components
%m = XYt * freq * 2*pi;  

% left portion is 2-d gaussian.  right portion is grating of frequency freq
m = exp(-((x/imgsize).^2)-((y/imgsize).^2)).*sin(xy*freq*2*pi);
%h = exp(-((x/imgsize).^2)-((y/imgsize).^2)).*sin(y*freq*2*pi);


switch color
   case 'r'
       img = zeros([size(m) 3]);
       %  img(:,:,3) = repmat(gray,size(m));
       %  img(:,:,2) = repmat(gray,size(m));
       img(:,:,1) = black+inc*m;
       img(:,:,2) = black;
       img(:,:,3) = black;
   case 'g'
       img = zeros([size(m) 3]);
       img(:,:,1) = black;
       img(:,:,2) = black+inc*m;
       img(:,:,3) = black;
   case 'w'
       img = black+inc*m;
end

Screen(window,'PutImage',img);
Ask(window,'Push Enter to quit.',black,gray,'GetString');
Screen(window,'Close')