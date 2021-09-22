function fWatershedComparison( iInputImg, iGTImg, IsShowImages )
%FWATERSHEDCOMPARÝSON Summary of this function goes here
%   To select best watershed algorithm

WATERSHED_LINE_EXIST = true;
WATERSHED_LINE_NOT_EXIST = false;

dGTClassLabels = fGT2ClassLabel(iGTImg);
dAllSegCnt = []; dAllGoodness1 = []; dAllPSNR = []; dAllTime = []; dAllMoransI = []; dAllVar = []; dAllEvRes1 = []; dAllEvRes2 = [];

fShowImage(iInputImg,'Original Image',true);
fShowImage(iGTImg,'GT Image',true);

% Get gradient magnitude image
dGradMagImg = fGetGradMagIm(iInputImg,'Sobel');
fShowImage(dGradMagImg,'Grad Mag Image',IsShowImages);
%SaveAllFigures('Watershed Common');

% Rainfalling Watershed
for RELATIVE_DROWNING_THRESHOLD=0:0.01:0.15
    [dLabels_RF_Without_WL,dSegCnt_RF,dTime_RF] = fRainfallingWatershed(dGradMagImg,RELATIVE_DROWNING_THRESHOLD,8);
    dSimpleImg_RF = fSimplifyImage(iInputImg,dLabels_RF_Without_WL);
    fShowImage(dSimpleImg_RF,['RF Simplified Image with rdt: ' num2str(RELATIVE_DROWNING_THRESHOLD)],IsShowImages);
    dSegmentedImg_RF = fGetSegmentedImg(iInputImg,dLabels_RF_Without_WL,WATERSHED_LINE_NOT_EXIST);
    fShowImage(dSegmentedImg_RF,['RF Segmented Image with rdt: ' num2str(RELATIVE_DROWNING_THRESHOLD)],IsShowImages);
    [dGoodness_RF,dPSNR_RF] = fFindSegmentationAccuracy(iInputImg,dSimpleImg_RF,dLabels_RF_Without_WL);
    [dVar_RF,dMoransI_RF] = fFindVariance_MoransI_New(iInputImg,dLabels_RF_Without_WL,WATERSHED_LINE_NOT_EXIST);
    [dEvRes1_RF,dEvRes2_RF,dSegErrImg_RF] = fSegDiscrepEval(dGTClassLabels,dLabels_RF_Without_WL);
    fShowImage(dSegErrImg_RF,['RF Seg. Error Image with rdt: ' num2str(RELATIVE_DROWNING_THRESHOLD)],IsShowImages);
    
    dAllSegCnt = [dAllSegCnt;dSegCnt_RF];
    dAllGoodness1 = [dAllGoodness1;dGoodness_RF];
    dAllPSNR = [dAllPSNR;dPSNR_RF];
    dAllTime = [dAllTime;dTime_RF]; 
    dAllMoransI = [dAllMoransI,dMoransI_RF]; 
    dAllVar = [dAllVar,dVar_RF];
    dAllEvRes1 = [dAllEvRes1;dEvRes1_RF];
    dAllEvRes2 = [dAllEvRes2;dEvRes2_RF];
end
[dAllNormalizedMoransI,dAllNormalizedVar,dAllGoodness2] = fGetGoodness2(dAllMoransI,dAllVar);
%SaveAllFigures('RF Watershed');

% Vincent-Soille Watershed with Watershed Lines
[dLabels_VS_With_WL,dSegCnt_VS,dTime_VS] = fVincentSoilleWatershed(dGradMagImg,8);
dSimpleImg_VS = fSimplifyImage(iInputImg,dLabels_VS_With_WL);
fShowImage(dSimpleImg_VS,['Vincent-Soille Simplified Image with Seg Cnt: ' num2str(dSegCnt_VS)],IsShowImages);
dSegmentedImg_VS = fGetSegmentedImg(iInputImg,dLabels_VS_With_WL,WATERSHED_LINE_EXIST);
fShowImage(dSegmentedImg_VS,['Vincent-Soille Segmented Image with Seg Cnt: ' num2str(dSegCnt_VS)],IsShowImages);
[dGoodness_VS,dPSNR_VS] = fFindSegmentationAccuracy(iInputImg,dSimpleImg_VS,dLabels_VS_With_WL);
[dVar_VS,dMoransI_VS] = fFindVariance_MoransI_New(iInputImg,dLabels_VS_With_WL,WATERSHED_LINE_EXIST);
[dEvRes1_VS,dEvRes2_VS,dSegErrImg_VS] = fSegDiscrepEval(dGTClassLabels,dLabels_VS_With_WL);
fShowImage(dSegErrImg_VS,'VS Seg. Error Image',IsShowImages);

dAllSegCnt = [dAllSegCnt, dSegCnt_VS*ones(16,1)];
dAllGoodness1 = [dAllGoodness1, dGoodness_VS*ones(16,1)];
dAllPSNR = [dAllPSNR, dPSNR_VS*ones(16,1)];
dAllTime = [dAllTime, dTime_VS*ones(16,1)];
dAllEvRes1 = [dAllEvRes1, dEvRes1_VS*ones(16,1)];
dAllEvRes2 = [dAllEvRes2, dEvRes2_VS*ones(16,1)];

%SaveAllFigures('VS Watershed');

figure,plot(0:0.01:0.15,dAllSegCnt,'-s'); xlabel('rdt','fontsize',16); ylabel('Segment Count','fontsize',16);
h = legend('RF','VS',2);
figure,plot(0:0.01:0.15,dAllGoodness1,'-s'); xlabel('rdt','fontsize',16); ylabel('Goodness1','fontsize',16);
h = legend('RF','VS',2);
figure,plot(0:0.01:0.15,dAllPSNR,'-s'); xlabel('rdt','fontsize',16); ylabel('PSNR (dB)','fontsize',16);
h = legend('RF','VS',2);
figure,plot(0:0.01:0.15,dAllTime,'-s'); xlabel('rdt','fontsize',16); ylabel('Time (sec)','fontsize',16);
h = legend('RF','VS',2);
figure,plot(0:0.01:0.15,dAllEvRes1,'-s'); xlabel('rdt','fontsize',16); ylabel('Ev1','fontsize',16);
h = legend('RF','VS',2);
figure,plot(0:0.01:0.15,dAllEvRes2,'-s'); xlabel('rdt','fontsize',16); ylabel('Ev2','fontsize',16);
h = legend('RF','VS',2);

figure,plot(0:0.01:0.15,dAllGoodness2,'-s'); xlabel('rdt','fontsize',16); ylabel('RF - Goodness2','fontsize',16);

end

