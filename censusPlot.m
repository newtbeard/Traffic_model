function cenMat = censusPlot(TAZ2k)
censusData = csvread('./TAZ.csv',1,0);
aa =  censusData(:,1);
bb =  censusData(:,2);
%total means of transportation field
cc =  censusData(:,4);
% cc =  censusData(:,3);
cenMat = zeros(3399);
for ii = 1:length(cc)
    a = find(TAZ2k == aa(ii));
    b = find(TAZ2k == bb(ii));
    density = length(a)+ length(b);
    if density == 0, density = 1;end
    for jj = length(a)
        for kk = length(b)
            cenMat(a,b) = cc(ii)/density;
        end
    end

end

end
