% Tristan Ursell
% Feb 2013
% Adaptive colormap
%
% rgbslide(mat_in,...)
% slide_map = rgbslide(...);
%
% This function creates, on the fly, an active / adaptive colormap for the
% data given by the matrix 'mat_in', and can be used in combination with
% image generation in a figure. This can be very useful for coloring
% data according to its absolute value.  For instance, if your data ranges
% from -rand to rand and you want the positive values in that image to be
% zero=black --> positive number=red, and the negative values to be
% zero=black --> negative numbers=blue -- the colormap would have to
% actively adjust itself to the image data -- that is what this function
% does.  Try out the examples.
%
% Another nice thing is that if you use zero_color = [0 0 0]; (i.e. black)
% then the colormap is guaranteed to be linear luminosity in each
% direction (unlike most other colormaps, e.g. 'jet').
%
% This function has a number of options:
%
% 'zero_val' is the value that will map to the color 'zero_color',
% the default is 0.
%
% 'low_val' is the value to which 'low_color' corresponds, if no value is
% specified then 'low_val' will be min(mat_in(:)).
%
% 'high_val' is the value to which 'high_color' corresponds, if no value is
% specified then 'high_val' will be max(mat_in(:)).
%
% 'zero_color' is a 1 x 3 color vector specifying the color of the value
% 'zero_val', the default is black (0 0 0).
%
% 'low_color' is a 1 x 3 color vector specifying the color of the lowest
% value in the map, the default is blue (0 0.25 1).
%
% 'high_color' is a 1 x 3 color vector specifying the color of the highest
% value in the map, the default is red (1 0.25 0).
%
% The term 'equal' may be invoked to keep the colormapping around
% 'zero_val' constrained to equal slope on each side, or no argument will
% allow the slopes to vary independently so as to maximize the color
% contrast on either side of 'zero_val'.
%
% 'res' sets the resolution of the colormap, such that the output
% 'slide_map' will be res x 3 in size.
%
% SEE ALSO: colormap, stretchlim
%
% EXAMPLES:
%
% dx=500;
% Xpos=ones(dx,1)*(1:dx);
% Ypos=Xpos';
%
% Im1=cos(4*pi*Xpos/dx).*cos(6*pi*Ypos/dx)+5*((Xpos-dx/2).^2/dx^2+(Ypos-dx/2).^2/dx^2);
%
% figure;
% imagesc(Im1)
% axis equal tight
% rgbslide(Im1);
% colorbar
%
% figure;
% imagesc(Im1)
% axis equal tight
% rgbslide(Im1,'equal');
% colorbar
%
% figure;
% imagesc(Im1)
% axis equal tight
% rgbslide(Im1,'zero_color',[1 1 1]);
% colorbar
%
% figure;
% imagesc(Im1)
% axis equal tight
% rgbslide(Im1,'zero_val',1);
% colorbar
%
% figure;
% imagesc(Im1)
% axis equal tight
% rgbslide(Im1,'high_color',[0 1 0.25],'low_color',[1 0 0.8]);
% colorbar
%
% figure;
% imagesc(Im1)
% axis equal tight
% rgbslide(Im1,'low_val',-1/2,'high_val',2);
% colorbar
%
% figure;
% imagesc(Im1)
% axis equal tight
% colormap(jet)
% colorbar
%

function slide_map=rgbslide(mat_in,varargin)

%parse inputs
p1=find(strcmp('zero_val',varargin));
p2=find(strcmp('low_color',varargin));
p3=find(strcmp('zero_color',varargin));
p4=find(strcmp('high_color',varargin));
p5=find(strcmp('low_val',varargin));
p6=find(strcmp('high_val',varargin));
p7=find(strcmp('res',varargin));
p8=find(strcmp('equal',varargin));

%handle input value limits
if ~isempty(p1)
    zero_val=double(varargin{p1+1});
else
    zero_val=0.0; %default
end

if ~isempty(p5)
    low_val=double(varargin{p5+1});
else
    low_val=double(min(mat_in(:)));
end

if ~isempty(p6)
    high_val=double(varargin{p6+1});
else
    high_val=double(max(mat_in(:)));
end

if low_val>high_val
    error('The high input limit must be greater than the low input limit.')
end

%set saturation colors
if ~isempty(p2)
    low_color=varargin{p2+1};
else
    low_color=[0 0.25 1]; %bright blue - default
end
if ~isempty(p3)
    zero_color=varargin{p3+1};
else
    zero_color=[0 0 0]; %black - default
end
if ~isempty(p4)
    high_color=varargin{p4+1};
else
    high_color=[1 0.25 0]; %red-orange - default
end

%color resolution
if ~isempty(p7)
    res=varargin{p7+1};
    if res<4
        res=256;
        disp('Colormap resolution set to 256.')
    end
else
    res=256;
end

%find the min and max values of the input matrix
mat_min=double(min(mat_in(:)));
mat_max=double(max(mat_in(:)));

%*****************
%*** CASES *******
%*****************

%apply 'equal' constraint
if ~isempty(p8)
    d_left=abs(low_val-zero_val);
    d_right=abs(high_val-zero_val);
    if d_right>d_left
        low_val=zero_val-d_right;
    else
        high_val=zero_val+d_left;
    end
end

%input
if mat_min==mat_max
    vec_in = mat_min;
    res=1;
else
    vec_in = linspace(mat_min,mat_max,res);
end

%create intensity values for low channel
b_low=-zero_val/(low_val-zero_val);
m_low=1/(low_val-zero_val);

int_low=m_low.*vec_in+b_low;
int_low(vec_in>=zero_val)=0;
int_low(vec_in<=low_val)=1;

%create intensity values for high channel
b_high=-zero_val/(high_val-zero_val);
m_high=1/(high_val-zero_val);

int_high=m_high.*vec_in+b_high;
int_high(vec_in<=zero_val)=0;
int_high(vec_in>=high_val)=1;

%clean up output
int_low(int_low<0)=0;
int_low(int_low>1)=1;

int_high(int_high<0)=0;
int_high(int_high>1)=1;

%create zero color int vector
int_zero=1-int_high-int_low;

%{
%test figure
figure;
hold on
plot(vec_in,int_low,'color',low_color)
plot(vec_in,int_zero,'color',zero_color)
plot(vec_in,int_high,'color',high_color)
box on
%}

%create colormap
slide_map=int_low'*low_color + int_zero'*zero_color + int_high'*high_color;

%apply active colormap to current figure
colormap(slide_map)

















