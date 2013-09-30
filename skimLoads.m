function A = loadThatSkim(file)
%file = './Skim_Impedence/20 TDistr_Penalty.mtx';  %Sample File  - remeber
%to include the correct Path
oFile = fopen(file);
k = 1; 
TAZs = 3399;  %magic Number- fixed amount of TAZs
A = zeros(TAZs,TAZs);
%For the skims loaded this is where the data starts and ends
firstLine = 354;
lastLine  = 1159412;
%Skim is broken apart into rows
row = 1;
column = 1;
while ~feof(oFile);
    if k < firstLine
        k = k+1; 
        ele = fgetl(oFile);
        continue; 
    end
    if column > TAZs,
        row = row + 1; 
        k = k + 2;  %skips the header row in the file        
        column = 1; %restart the column counter
    end
    ele = fgetl(oFile); %gets a line form the file
    a = str2num(ele); %converts the string to some of those numbers
    startCol = column;
    column = column + length(a);
    A(row,[startCol:column-1]) = a; %place into 1 large matrix for the children
    k = k+1;
end
    