function [ dLabels, dSegCnt, dProcTime ] = fVincentSoilleWatershed( gInputImg, dNeighSize )
%FVINCENTSOILLEWATERSHED Checked
%   Detailed explanation goes here

tic;

dInputImg = double(gInputImg);
dLabels = watershed_old(dInputImg,dNeighSize);
dSegCnt = max(dLabels(:));

dProcTime=toc;

end

