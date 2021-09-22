function dSegmentedImg = fGetSegmentedImg( gInputImg, gLabels, loIsExistWatershedLines )
%FGETSEGMENTEDIMG Summary of this function goes here
%   gInputImg can be multi-spectral
%   dSegmentedImg is the double size of gInputImg

dBandCnt = size(gInputImg,3);
dSegmentedImg = double(gInputImg);
dLabels = double(gLabels);

% Normalize the output image and upsample output and labels
dSegmentedImg = dSegmentedImg / (max(dSegmentedImg(:)));
dSegmentedImg = fUpsample(dSegmentedImg);
dLabels = fUpsample(dLabels);

% Get boundaries
loBoundaries = fGetBoundaries(dLabels,loIsExistWatershedLines);

for dBandNo=1:1:(dBandCnt-1)
    dCurBand = dSegmentedImg(:,:,dBandNo);
    dCurBand(loBoundaries == 1) = 0;
    dSegmentedImg(:,:,dBandNo) = dCurBand;
end

dCurBand = dSegmentedImg(:,:,dBandCnt);
dCurBand(loBoundaries == 1) = 1;
dSegmentedImg(:,:,dBandCnt) = dCurBand;

end

