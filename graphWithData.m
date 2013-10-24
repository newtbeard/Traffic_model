% clc; clear all;
fe =@(x,beta) exp(-beta*(x-1)); %friction exponential
numNodes = 3399;
nodePos = zeros(numNodes,2);
c = 0;
%change this eventually
% for i = 1:sqrt(numNodes)
%     for j = 1:sqrt(numNodes)
%         c = c+1;
%         nodePos(c,:) = [i,j];          
%     end
% end

%approx distro of population  - From DVRPC
if ~exist('file','var')
    file = './210 IMP (Car Car).mtx';
    [productionLow,productionHigh,attractionLow,attractionHigh,origTaz,TAZ2k,pL_w2h,pH_w2h,aL_w2h,aH_w2h] = loadZoneData();
    % tic
    A = loadThatSkim(file); %this is the impedance matrix\
    % time = toc
    % %limiting the size of these crazy ass Matrices so we can see if it works
    % %at all
    A = A(1:numNodes,1:numNodes);
    productionLow = productionLow(1:numNodes);
    productionHigh = productionHigh(1:numNodes);
    attractionLow = attractionLow(1:numNodes);
    attractionHigh = attractionHigh(1:numNodes);
    % %end trimming
end
%Initialize some of thos old fashioned trip tables.
tripfeLow = A*0;
tripfeHigh = tripfeLow;
w2hLow = A*0;
w2hHigh = w2hLow;
%Trip Generation Calculation
%checks to see if the census data is loaded
if ~exist('cenMat','var')
    cenMat = censusPlot(TAZ2k);
end
%Beta parameter to be cycled through
beta = 0:0.05:0.5;
%error vectors for each beta
err = zeros(size(beta));    errNCC = err;   errMLCC = err;
%trip table to show trips for Main line to CC and NCC for each beta
tripTable = zeros(2,length(beta));
for kk =1:length(beta)
    tic
    for i=1:numNodes
        %declaration  of denominator values
        denfeLow  = 0;
        denfeHigh = 0;    
        denw2hHigh  = 0;
        denw2hLow   = 0;
        for j=1:numNodes        
                tripfeHigh(i,j) = attractionHigh(j)*fe(A(i,j),beta(kk));
                tripfeLow(i,j)  = attractionLow(j) *fe(A(i,j),beta(kk));
                w2hLow(i,j)     = aL_w2h(j)        *fe(A(i,j),beta(kk));
                w2hHigh(i,j)    = aH_w2h(j)        *fe(A(i,j),beta(kk));                
                %add atractions and function to denominator for all j
                denfeHigh   = tripfeHigh(i,j) + denfeHigh;      
                denw2hHigh  = w2hHigh(i,j)    + denw2hHigh;                                
                denfeLow    = tripfeLow(i,j)  + denfeLow;    
                denw2hLow   = w2hLow(i,j)     + denw2hLow;
                
        end    
        
        %%%%%% Prevent division by zero for zones with no action
        if denfeLow ~= 0;
            tripfeLow(i,:) = tripfeLow(i,:)*productionLow(i);
            tripfeLow(i,:) = tripfeLow(i,:)/denfeLow;                        
        else
            tripfeLow(i,:)  = 0;           
        end
        if denw2hLow ~= 0
            w2hLow(i,:)  = w2hLow(i,:)*pL_w2h(i);
            w2hLow(i,:)  = w2hLow(i,:)/denw2hLow;
        else
            w2hLow(i,:) = 0; 
        end
        if denfeHigh ~= 0;
            tripfeHigh(i,:) = tripfeHigh(i,:)*productionHigh(i);
            tripfeHigh(i,:) = tripfeHigh(i,:)/denfeHigh;         
        else
            tripfeHigh(i,:) = 0;            
        end
        if denw2hHigh ~= 0
            w2hHigh(i,:)  = w2hHigh(i,:)*pH_w2h(i);
            w2hHigh(i,:)  = w2hHigh(i,:)/denw2hHigh;
        else
            w2hHigh(i,:)  = 0;            
        end
        %%%%% prevention end

    end
    toc
    kk
    % Write the files Matrices to csv   ~110mb a piece
    % writeMatrices(tripfeLow,tripfeHigh,beta);
    tripfe = tripfeHigh+tripfeLow;
    w2hTrip = w2hHigh+w2hLow;
    totalTrips = tripfe+w2hTrip;
    %RMSE    
    tripTable(1,kk) = sum(sum(totalTrips(335:379,1:143)));
    tripTable(2,kk) = sum(sum(totalTrips(1244:1295,1:143)));
    err(kk) = sqrt(sum(sum((totalTrips-cenMat).^2)))/length(totalTrips)^2;
    errNCC(kk) = sqrt(sum(sum((totalTrips(335:379,1:143)-cenMat(335:379,1:143)).^2)))...
        /(size(totalTrips(335:379,1:143),1)*size(totalTrips(335:379,1:143),2));
    errMLCC(kk) = sqrt(sum(sum((totalTrips(1244:1295,1:143)-cenMat(1244:1295,1:143)).^2)))...
                /(size(totalTrips(1244:1295,1:143),1)*size(totalTrips(1244:1295,1:143),2));    
    if(beta(kk))==0.35, DVRPC35=totalTrips;end
end
figure(1)
plot(beta,err, '->',beta, errNCC,'-o', beta, errMLCC,'-+')
legend('Total Error', 'North Philly to CC Trips','Main Line to CC trips');
title('Root Mean Square Error - Gravity Model');
tripTable = [[sum(sum(cenMat(335:379,1:143))),sum(sum(cenMat(1244:1295,1:143)))]' tripTable]; 
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

% wgPlot(tripfc,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);

