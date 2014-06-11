%fix luminance values
%RPH
%11/30/07

%For this analysis, I (mostly) disregard gunned luminance values and focus
%instead on finding the lower bound of stimuli that *I* could visibly see
%when dark adapted.  Then, I used the previous gunned luminance values to
%find natural groupings.  Appears that low contrast can be between 0 and
%.32, medium up to 2, and high thereafter.  This has the advantage of
%including more data, while grouping your 170's and 173s together in the
%same category.
%Also, no correction is made for eccentricity, as this may not actually
%matter.  This will also help to include more data, particularly those
%files that had the eccentricity changed mid-session.


%first set all values to NaN
Target_(:,13) = NaN;

%set critical values in each of three groups to categorical numbers
Target_(find(Target_(:,3) >= 140 & Target_(:,3) < 160),13) = 1;
Target_(find(Target_(:,3) >= 160 & Target_(:,3) < 190),13) = 2;
Target_(find(Target_(:,3) >= 190),13) = 3;