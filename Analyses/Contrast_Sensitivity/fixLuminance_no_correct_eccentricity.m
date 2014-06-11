%fix luminance values
%RPH
%11/30/07

%if we are using low luminance range and 8 degree luminance

%some of the low range luminance values were not appearing on the screen;
%others were too low for our photometer to pick up.  thus, we will set them
%to NaN until that is corrected

%Values are averages across screen locations (different screen locations
%sometimes yield different luminance values.  In theory, we could build in
%a correction for each screen location, but we will not have enough trials

%Note:
%We should not have any files with high contrast range (140) and 10
%degree eccentricity because Geoff primarily used 10 degree.
if Target_(:,4) == 91 & Target_(:,12) == 8
    Target_(find(Target_(:,3) == 101),13) = NaN;
    Target_(find(Target_(:,3) == 110),13) = NaN;
    Target_(find(Target_(:,3) == 119),13) = NaN;
    Target_(find(Target_(:,3) == 128),13) = NaN;
    Target_(find(Target_(:,3) == 137),13) = NaN;
    Target_(find(Target_(:,3) == 146),13) = NaN;
    Target_(find(Target_(:,3) == 155),13) = .08;
    Target_(find(Target_(:,3) == 164),13) = .25;
    Target_(find(Target_(:,3) == 173),13) = .52;
    Target_(find(Target_(:,3) == 182),13) = .89;
    Target_(find(Target_(:,3) == 191),13) = 1.44;

    %if we are using low luminance range but 10 degree eccentricity
elseif Target_(:,4) == 91 & Target_(:,12) == 10
    Target_(find(Target_(:,3) == 101),13) = NaN;
    Target_(find(Target_(:,3) == 110),13) = NaN;
    Target_(find(Target_(:,3) == 119),13) = NaN;
    Target_(find(Target_(:,3) == 128),13) = NaN;
    Target_(find(Target_(:,3) == 137),13) = NaN;
    Target_(find(Target_(:,3) == 146),13) = NaN;
    Target_(find(Target_(:,3) == 155),13) = .08;
    Target_(find(Target_(:,3) == 164),13) = .25;
    Target_(find(Target_(:,3) == 173),13) = .52;
    Target_(find(Target_(:,3) == 182),13) = .89;
    Target_(find(Target_(:,3) == 191),13) = 1.44;

elseif Target_(:,4) == 140 & Target_(:,12) == 10
    Target_(find(Target_(:,3) == 140),13) = NaN;
    Target_(find(Target_(:,3) == 150),13) = .04;
    Target_(find(Target_(:,3) == 160),13) = .20;
    Target_(find(Target_(:,3) == 170),13) = .52;
    Target_(find(Target_(:,3) == 180),13) = .99;
    Target_(find(Target_(:,3) == 190),13) = 1.7;
    Target_(find(Target_(:,3) == 200),13) = 2.6;
    Target_(find(Target_(:,3) == 210),13) = 3.6;
    Target_(find(Target_(:,3) == 220),13) = 5.0;
    Target_(find(Target_(:,3) == 230),13) = 6.5;
    Target_(find(Target_(:,3) == 240),13) = 8.1;
    
    
    %% TEMPORARY FIX - did not recrod luminance values for these 
    %% eccentricities so am temporarily using the average between 
    %% eccentricities 8 and 10 to estimate.
elseif Target_(:,4) == 91 & Target_(:,12) == 9
    Target_(find(Target_(:,3) == 101),13) = NaN;
    Target_(find(Target_(:,3) == 110),13) = NaN;
    Target_(find(Target_(:,3) == 119),13) = NaN;
    Target_(find(Target_(:,3) == 128),13) = NaN;
    Target_(find(Target_(:,3) == 137),13) = NaN;
    Target_(find(Target_(:,3) == 146),13) = NaN;
    Target_(find(Target_(:,3) == 155),13) = .08;
    Target_(find(Target_(:,3) == 164),13) = .25;
    Target_(find(Target_(:,3) == 173),13) = .52;
    Target_(find(Target_(:,3) == 182),13) =  .89;
    Target_(find(Target_(:,3) == 191),13) = 1.44;
    
end