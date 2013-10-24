function [productionLow,productionHigh,attractionLow,attractionHigh,origTaz,TAZ2k,pL_w2h,pH_w2h,aL_w2h,aH_w2h] = loadZoneData()
%OutPuts
%--- High Productions 
%--- Low  Productions 
%--- High Attractions 
%--- Low  Attractions     ----  for each of the 3399 TAZs
%only have certain outputs from here not the whole datastructure
%this will free up a ton of memory
zoneData = csvread('./ZonePA.csv',1,0);
productionLow  = zoneData(1:end,2);  %AM
productionHigh = zoneData(1:end,3);  %AM
pL_w2h         = zoneData(1:end,4);
pH_w2h         = zoneData(1:end,5);
attractionLow  = zoneData(1:end, 6); %AM
attractionHigh = zoneData(1:end, 7); %AM
aL_w2h         = zoneData(1:end, 8); 
aH_w2h         = zoneData(1:end, 9); 
%the sum of the production = the sum of attractions to one decimal;
%impressive yes!?!?

%DOnt know if these are necessary but may need these values at some point.
zoneAttr = csvread('./Zone Data.csv',1,0);
popUnder35k    = zoneAttr(1:end, 3);
popOver35k     = zoneAttr(1:end, 4);
origTaz        = zoneAttr(1:end, 1);
TAZ2k          = zoneAttr(1:end, 7); %Attribute value to match up with the 2000 census enumeration
employment     = zoneAttr(1:end, 8);

end
