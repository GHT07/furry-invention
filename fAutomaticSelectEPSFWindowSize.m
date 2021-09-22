function dOptimumEPSFWindowSize = fAutomaticSelectEPSFWindowSize(iInputImg)

% Result vectors
dAllMoransI = []; dAllVar = [];

for EPSF_WINDOW_SIZE=3:2:15
    [dEPSFOutput,dTime_EPSF] = fEdgePreservedSmoothingFilter(iInputImg,EPSF_WINDOW_SIZE,10,1);
    [dGradMagImg_EPSF,dTime_GradMag] = fGetGradMagIm(dEPSFOutput,'Sobel');
    [dLabels_EPSF_With_WL,dSegCnt_EPSF,dSegTime_EPSF] = fVincentSoilleWatershed(dGradMagImg_EPSF,8);
    [dVar_EPSF,dMoransI_EPSF] = fFindVariance_MoransI_New(iInputImg,dLabels_EPSF_With_WL,true);
    
    dAllMoransI = [dAllMoransI,dMoransI_EPSF];
    dAllVar = [dAllVar,dVar_EPSF];
end

[dAllNormalizedMoransI,dAllNormalizedVar,dAllGoodness2] = fGetGoodness2(dAllMoransI,dAllVar);

[dMinVal dMinIndex] = min(dAllGoodness2);
dOptimumEPSFWindowSize = (2*dMinIndex) + 1;

end
