function [productionLow,productionHigh,attractionLow,attractionHigh] = loadZoneData()
%OutPuts
%--- High Productions 
%--- Low  Productions 
%--- High Attractions 
%--- Low  Attractions     ----  for each of the 3399 TAZs
%only have certain outputs from here not the whole datastructure
%this will free up a ton of memory


%I don't know what is necessary yet, but so far I like these values 
zoneData = xlsread('./Zone Data.xls','Zone_P&A');
productionLow  = zoneData(4:end,3);  %AM
productionHigh = zoneData(4:end,4);  %AM
attractionLow  = zoneData(4:end, 7); %AM
attractionHigh = zoneData(4:end, 8); %AM
%the sum of the production = the sum of attractions to one decimal;
%impressive yes!?!?

%DOnt know if these are necessary but may need these values at some point.
zoneAttr = xlsread('./Zone Data.xls','Zone_Attributes');
popUnder35k    = zoneAttr(4:end, 36);
popOver35k     = zoneAttr(4:end, 37);
employment     = zoneAttr(4:end, 100);
end
