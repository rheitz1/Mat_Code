varlist = who;

%find indices of cell names
CellMarker = strmatch('DSP',varlist);
ADMarker = strmatch('AD',varlist);

%create a list of target cells to analyze
for a = 1:length(CellMarker)
    CellName_temp(a,1) = varlist(CellMarker(a));
end

%create a list of AD channels to analyze
for a = 1:length(ADMarker)
    Names_AD(a,1) = varlist(ADMarker(a));
end

%remove hash cells (end with "i")
m = 1;
for j = 1:length(CellName_temp)
    if isempty(strfind(cell2mat(CellName_temp(j)),'i') > 0)
        CellNames(m,1) = CellName_temp(j);
        m = m + 1;
    end
end



clear a m j varlist CellMarker ADMarker CellName_temp