function [dNormalizedMoransI dNormalizedVar dAllGoodness2] = fGetGoodness2( dAllMoransI, dAllVar )
%FGETGOODNESS2 Checked
%   Detailed explanation goes here

dBandCnt = size(dAllMoransI,1);
dNormalizedMoransI = zeros(size(dAllMoransI));
dNormalizedVar = zeros(size(dAllMoransI));

for dBandNo=1:1:dBandCnt
	dCurrentBandAllMoransI = dAllMoransI(dBandNo,:);
	dCurrentBandAllVar = dAllVar(dBandNo,:);
	
	dNormalizedMoransI(dBandNo,:) = (dCurrentBandAllMoransI - min(dCurrentBandAllMoransI))./(max(dCurrentBandAllMoransI) - min(dCurrentBandAllMoransI));
	dNormalizedVar(dBandNo,:) = (dCurrentBandAllVar - min(dCurrentBandAllVar))./(max(dCurrentBandAllVar) - min(dCurrentBandAllVar));
end

dAllGoodness2 = dNormalizedMoransI + dNormalizedVar;
dAllGoodness2 = sum(dAllGoodness2,1)/dBandCnt;
dAllGoodness2 = dAllGoodness2';

end

