%====================
% Trigonomotry functions to estimate angle for SC chamber based on observed AP/DV values co-referenced with
% atlas coordinates.  
%
% All values in centimeter
%
% RPH

%RA: enter values in the below two lines:

measured_AP = -1.45;   %what is the AP value where you want to place chamber? 
measured_DV = 3.7;   %what is the DV value where you want to place chamber?











use_atlas_values = 1; %if 1, assume stereotax is 0,0 and use raw atlas values

%================================
% DO NOT ALTER

if ~use_atlas_values
    stereotax_ZERO_DV = 1;  %zeroed values
    stereotax_ZERO_AP = 3.8;%zeroed values
else
    stereotax_ZERO_DV = 0;
    stereotax_ZERO_AP = 0;
end

SC_DV = 1.4 + stereotax_ZERO_DV; %SC is 14mm above inter-aural 0
SC_AP = 0.3 + stereotax_ZERO_AP;  %SC is 3 mm anterior to inter-aural 0.

height = measured_DV - SC_DV;


length = measured_AP - SC_AP;

angle = 90 - rad2deg(atan2(height,length))