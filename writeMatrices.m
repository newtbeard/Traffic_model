function writeMatrices(L,H,beta)
fileH = fprintf('TripsHigh%d.txt',beta*10)
fileL = fprintf('TripsLow%d.txt',beta*10)
dlmwrite(fileH,H);
dlmwrite(fileL,L);