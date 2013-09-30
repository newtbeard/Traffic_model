clc; clear all;

ff =@(x) x^-2; %friction function
fe =@(x) exp(-.35*(x-1)); %friction exponential
numNodes = 100;
nodePos = rand(numNodes,2)*1000;
%approx distro of population  - From DVRPC
file = './210 IMP (Car Car).mtx';
[productionLow,productionHigh,attractionLow,attractionHigh] = loadZoneData();
A = loadThatSkim(file); %this is the impedance matrix
%limiting the size of these crazy ass Matrices so we can see if it works
%at all
A = A(1:100,1:100);
productionLow = productionLow(1:100);
productionHigh = productionHigh(1:100);
attractionLow = attractionLow(1:100);
attractionHigh = attractionHigh(1:100);
%end trimming

%Initialize some of thos old fashioned trip tables.
tripff = A*0;
tripfe = tripff;
%Trip Generation Calculation
for i=1:length(A(:,1))
    den = 0;
    denfe = 0;
    for j=1:length(A(1,:))        
        %if A(i,j) == 1  % there is a connection, else shortcircuit loop
        %I do not think we need the short circuit loop as the matrix may be
        % all nonzero
            tripff(i,j) = attractionHigh(j)*ff(A(i,j));
            tripfe(i,j) = attractionHigh(j)*fe(A(i,j));
            denfe = tripfe(i,j) + denfe;  
            den = tripff(i,j) + den;  
        %end
    end    
    tripff(i,:) = tripff(i,:)*productionHigh;
    tripff(i,:) = tripff(i,:)/den;
    tripfe(i,:) = tripfe(i,:)*productionHigh;
    tripfe(i,:) = tripfe(i,:)/denfe;
end

% figure(1)
% gplot(A,nodePos,'-O')
figure(2)
title('Impedance Distribution')
wgPlot(A,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',2,'edgeColorMap',jet,'vertexColorMap',cool);
%xlabel('Impedance'); ylabel('# of Attaractions'); 
figure(3)
title('Inverse Square Trip Distribution')
wgPlot(tripff,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',2,'edgeColorMap',jet,'vertexColorMap',cool);
figure(4)
title('Decaying Exponenetial Trip Distribution')
wgPlot(tripfe,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',2,'edgeColorMap',jet,'vertexColorMap',cool);