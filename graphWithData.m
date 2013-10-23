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
    [productionLow,productionHigh,attractionLow,attractionHigh,origTaz,TAZ2k] = loadZoneData();
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
comboLow = A*0;
comboHigh = comboLow;
%Trip Generation Calculation
%checks to see if the census data is loaded
if ~exist('cenMat','var')
    cenMat = censusPlot(TAZ2k);
end
%Beta parameter to be cycled through
beta = 0:0.05:0.5;
err = zeros(size(beta));    errNCC = err;   errMLCC = err;
Cerr = err;                 CerrNCC = err;  CerrMLCC = err;

for kk =1:length(beta)
    tic
    for i=1:numNodes
        %declaration  of denominator values
        denfeLow  = 0;
        denfeHigh = 0;    
        denCHigh  = 0;
        denCLow   = 0;
        for j=1:numNodes        
                tripfeHigh(i,j) = attractionHigh(j)*fe(A(i,j),beta(kk));
                tripfeLow(i,j)  = attractionLow(j) *fe(A(i,j),beta(kk));
                comboLow(i,j)   = attractionLow(j) *fe(A(i,j),beta(kk))*A(i,j);
                comboHigh(i,j)  = attractionHigh(j)*fe(A(i,j),beta(kk))*A(i,j);                
                %add atractions and function to denominator for all j
                denfeHigh = tripfeHigh(i,j) + denfeHigh;      
                denCHigh  = comboHigh(i,j)  + denCHigh;                                
                denfeLow  = tripfeLow(i,j) + denfeLow;    
                denCLow   = comboLow(i,j)  + denCLow;
                
        end    
        if denfeLow ~= 0;
            tripfeLow(i,:) = tripfeLow(i,:)*productionLow(i);
            tripfeLow(i,:) = tripfeLow(i,:)/denfeLow;
            comboLow(i,:)  = comboLow(i,:)*productionLow(i);
            comboLow(i,:)  = comboLow(i,:)/denCLow;            
        else
            tripfeLow(i,:)  = 0;
            comboLow(i,:) = 0;
        end
        if denfeHigh ~= 0;
            tripfeHigh(i,:) = tripfeHigh(i,:)*productionHigh(i);
            tripfeHigh(i,:) = tripfeHigh(i,:)/denfeHigh; 
            comboHigh(i,:)  = comboHigh(i,:)*productionHigh(i);
            comboHigh(i,:)  = comboHigh(i,:)/denCHigh;
        else
            tripfeHigh(i,:) = 0;
            comboHigh(i,:)  = 0;            
        end

    end
    toc
    kk
    % Write the files Matrices to csv   ~110mb a piece
    % writeMatrices(tripfeLow,tripfeHigh,beta);
    tripfe = tripfeHigh+tripfeLow;
    comboTrip = comboHigh+comboLow;
    %RMSE
    %Friction Factor
    err(kk) = sqrt(sum(sum((tripfe-cenMat).^2)))/length(tripfe)^2;
    errNCC(kk) = sqrt(sum(sum((tripfe(335:379,1:143)-cenMat(335:379,1:143)).^2)))...
        /(size(tripfe(335:379,1:143),1)*size(tripfe(335:379,1:143),2));
    errMLCC(kk) = sqrt(sum(sum((tripfe(1244:1295,1:143)-cenMat(1244:1295,1:143)).^2)))...
                /(size(tripfe(1244:1295,1:143),1)*size(tripfe(1244:1295,1:143),2));
    %combo Model
    Cerr(kk) = sqrt(sum(sum((comboTrip-cenMat).^2)))/length(comboTrip)^2;
    CerrNCC(kk) = sqrt(sum(sum((comboTrip(335:379,1:143)-cenMat(335:379,1:143)).^2)))...
        /(size(tripfe(335:379,1:143),1)*size(tripfe(335:379,1:143),2));
    CerrMLCC(kk) = sqrt(sum(sum((comboTrip(1244:1295,1:143)-cenMat(1244:1295,1:143)).^2)))...
                /(size(tripfe(1244:1295,1:143),1)*size(tripfe(1244:1295,1:143),2));
    if(beta(kk))==0.35, DVRPC35=tripfe;end
end
figure(1)
plot(beta,err, '->',beta, errNCC,'-o', beta, errMLCC,'-+')
legend('Total Error', 'North Philly to CC Trips','Main Line to CC trips');
title('Root Mean Square Error - Gravity Model');
figure(2)
plot(beta,Cerr, '->',beta, CerrNCC,'-o', beta, CerrMLCC,'-+')
legend('Total Error', 'North Philly to CC Trips','Main Line to CC trips');
title('Root Mean Square Error - Combo Model');

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

