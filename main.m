clc
close all
I=imread('Test1.png');
I=double(I)/255;
subplot(2,3,1)
imshow(I)
title('ԭʼͼ��')
for i=2:6
    F=imkmeans(I,i);
    subplot(2,3,i);
    imshow(F,[]);
    title(['�������=',num2str(i)])
end