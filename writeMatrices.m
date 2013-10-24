function writeMatrices(L,H,beta)
<<<<<<< HEAD
%file size is approx 110mb
=======
>>>>>>> 10ec0f02fc36743d46a0d43cc930378e9d8306fe
fileH = fprintf('TripsHigh%d.txt',beta*10)
fileL = fprintf('TripsLow%d.txt',beta*10)
dlmwrite(fileH,H);
dlmwrite(fileL,L);