function [ dSimpleIm, dSegVals ] = fSimplifyImage( gInputImg, gLabels )
%FSIMPLIFYIMAGE Checked 26.08
% dInputImg can be multi-spectral
% dSimpleIm has same dimensions with gInputImg

dInputImg = double(gInputImg);
dLabels = double(gLabels);

dBandCnt = size(dInputImg,3);
dSimpleIm = dInputImg;
dSegCnt = max(dLabels(:));
dSegVals = zeros(dSegCnt,dBandCnt,'double');

structRegionStats = regionprops(dLabels,'PixelList','Area');

% Simplify Image
for dSegNo=1:1:dSegCnt
    dPixelList = structRegionStats(dSegNo).PixelList;
    dArea = structRegionStats(dSegNo).Area;
    
    % Find avg color in a segment
    dTotalColor = zeros(1,dBandCnt,'double');
    for dPixNo=1:1:dArea
        dPixX = dPixelList(dPixNo,2);
        dPixY = dPixelList(dPixNo,1);
        
        for dBandNo=1:1:dBandCnt
            dTotalColor(dBandNo) = dTotalColor(dBandNo) + dInputImg(dPixX,dPixY,dBandNo);
        end
    end
    dAvgColor = dTotalColor/dArea;
    
    % Assing avg color to all pixels in the corresponding segment
    for dPixNo=1:1:dArea
        dPixX = dPixelList(dPixNo,2);
        dPixY = dPixelList(dPixNo,1);
        
        for dBandNo=1:1:dBandCnt
            dSimpleIm(dPixX,dPixY,dBandNo) = dAvgColor(dBandNo);
        end
    end
    
    dSegVals(dSegNo,:) = dAvgColor;
end

end

