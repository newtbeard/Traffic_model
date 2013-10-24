XI = log(tripfeHigh+tripfeLow);
hold on 
for i = 1:3399
    XI = log(cenMat);
    XI(:,i) = XI(:,i) - log(attractionHigh(i)+attractionLow(i));
	XI(i,:) = XI(i,:) - log(productionHigh(i)+productionLow(i));
    plot(A(i,:), log(cenMat(i,:)))
end
