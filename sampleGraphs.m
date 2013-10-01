%%%Graphs that I like  - Nate Wagenhoffer
%%%For Use in the 10/2 Presentation to Temple Math Modeling
%%%Will anyone even try to read the 3rd line of the comments
figure(1);
words = sprintf('Edges with Greater than 138 Trips - Gravity Model \n Convention Center and One Liberty Place are great attractors');
title(words);
wgPlot(tripff>138,nodePos,'vertexWeight',productionHigh,'vertexMetaData',...
attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
figure(2)
title('Decaying Exponenetial Trip Distribution  - DVRPC Approximation')
wgPlot(tripfe,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
figure(3);
words = sprintf('Edges with Greater than 220 Trips - Decaying Exp. \n Society Hill South, Hyatt at the Bellevue, One Liberty Place, and Five Penn Center');
title(words);
wgPlot(tripfe>220,nodePos,'vertexWeight',productionHigh,'vertexMetaData',...
attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);
figure(4)
words = sprintf('Combined Fiunctional Trip Distribution f(x)=x^{1/2}e^{-x}','interpreter','latex');
title(words)
wgPlot(tripfc,nodePos,'vertexWeight',productionHigh,'vertexMetaData',attractionHigh,'edgeWidth',0.002,'edgeColorMap',jet,'vertexColorMap',cool);