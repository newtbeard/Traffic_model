%sanity check
format compact
totalCombo = sum(sum(comboTrip))
comboAttr  = sum(comboTrip(111,:))
comboPro   = sum(comboTrip(:,111))
cHA        = sum(comboHigh(111,:))
cLA        = sum(comboLow(111,:))
cHP        = sum(comboHigh(:,111))
cLP        = sum(comboLow(:,111))
feP        = sum(tripfe(:,111))
attrH      = sum(attractionHigh(111,:))
attrL      = sum(attractionLow(111,:))
pL         = sum(productionLow(111,:))
pH         = sum(productionHigh(111,:))