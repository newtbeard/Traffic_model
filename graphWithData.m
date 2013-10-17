% % clc; clear all;
% 
% ff =@(x) x^-2; %friction function
fe =@(x,beta) exp(-beta*(x-1)); %friction exponential
% fc =@(x) x^(1/2)*exp(-x);
% numNodes = 3399;
% nodePos = zeros(numNodes,2);
% c = 0;
% %change this eventually
% for i = 1:sqrt(numNodes)
%     for j = 1:sqrt(numNodes)
%         c = c+1;
%         nodePos(c,:) = [i,j];          
%     end
% end
% 
% %approx distro of population  - From DVRPC
% 
% file = './210 IMP (Car Car).mtx';
% [productionLow,productionHigh,attractionLow,attractionHigh,origTaz,TAZ2k] = loadZoneData();
% % tic
% A = loadThatSkim(file); %this is the impedance matrix\
% % time = toc
% % %limiting the size of these crazy ass Matrices so we can see if it works
% % %at all
% A = A(1:numNodes,1:numNodes);
% productionLow = productionLow(1:numNodes);
% productionHigh = productionHigh(1:numNodes);
% attractionLow = attractionLow(1:numNodes);
% attractionHigh = attractionHigh(1:numNodes);
% % %end trimming
% 
% %Initialize some of thos old fashioned trip tables.
% tripfeLow = A*0;
% tripfeHigh = tripff;
% %Trip Generation Calculation
hold on
%checks to see if the census data is loaded
if ~exist('cenMat','var')
    cenMat = censusPlot(TAZ2k);
end
beta = 0:0.1:1;
for kk =1:length(beta)
for i=1:numNodes
    denfeLow = 0;
    denfeHigh = 0;    
    for j=1:numNodes        
            tripfeHigh(i,j) = attractionHigh(j)*fe(A(i,j),beta(kk));
            tripfeLow(i,j) = attractionLow(j)*fe(A(i,j),beta(kk));
            if tripfe(i,j) > 0
                denfeHigh = tripfeHigh(i,j) + denfe;              
                denfeLow  = tripfeHigh(i,j) + denfe;    
            end
    end    
    if denfeLow == 0;
        denfeLow = 1;
    end
    if denfeHigh == 0;
        denfeHigh = 1;
    end
    
    tripfeLow(i,:) = tripfeLow(i,:)*productionLow(i);
    tripfeLow(i,:) = tripfeLow(i,:)/denfeLow;
    tripfeHigh(i,:) = tripfeHigh(i,:)*productionHigh(i);
    tripfeHigh(i,:) = tripfeHigh(i,:)/denfeHigh; 
    
end
% Write the files Matrices to csv   ~110mb a piece
% writeMatrices(tripfeLow,tripfeHigh,beta);

%RMSE
err = sqrt(sum(sum(abs(tripfeHigh+tripfeLow-cenMat).^2)))/length(tripfe);
plot(beta,err)
end
% figure(1)
% % gplot(A,nodePos,'-O')
% figure(2)
% title('Impedance Distribution')
% wgPlot(A,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
% %xlabel('Impedance'); ylabel('# of Attaractions'); 
% figure(1)
% title('Impedance Distribution - Difference of Upper and Lower Triangles')
% wgPlot(upper(A)-lower(A)',nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
% figure(3)
% title('Inverse Square Trip Distribution')
% wgPlot(tripff,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
% figure(4)
% title('Decaying Exponenetial Trip Distribution')
% wgPlot(tripfe,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
% figure(6)
% title('Combined Fiunctional Trip Distribution')
% wgPlot(tripfc,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);