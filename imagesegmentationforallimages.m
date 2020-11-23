
clear all;
close all;

srcfile=dir('E:\NON_ROI\*.jpg');

for i=1:length(srcfile)
    filename=strcat('E:\NON_ROI\',srcfile(i).name);
    I=imread(filename);
    %figure, imshow(I);
    %%
     %crop the sides
S=segmentImage1(I);
    %figure, imshow(S);
    maskedImage = I;
    maskedImage(repmat(~S,[1 1 3])) = 0; %replicating maasked image with orginal image
    %%
    hsvImage = rgb2hsv(maskedImage);
hChannel = hsvImage(:, :, 1);
sChannel = hsvImage(:, :, 2);
vChannel = hsvImage(:, :, 3);
h=imhist(vChannel);
h1=h(2:255,:);
[r,c]=max(h1);
a=c/256;
%meanV = 1.5*mean2(vChannel);
newV =(vChannel - a);
 newHSVImage = cat(3, hChannel, sChannel, newV);% concatinating three channels
 newRGBImage = hsv2rgb(newHSVImage);
 %%

  % subplot(1,5,3) ,imshow(maskedImage);
  %conversion to binary
BW = im2bw(newRGBImage,0); %converson to binary
% subplot(1,5,4), imshow(BW)
BWao = bwareaopen(BW,3000);
%%
nhood = true(10);
closeBWao = imclose(BWao,nhood);
% imshow(closeBWao)
%%
roughMask = imfill(closeBWao,'holes');
%imshow(roughMask);
    %% 
    newimage=I;
newimage(repmat(~roughMask,[1 1 3]))=0;
k=imresize(newimage,[227 227]);
    newsegmentedimages=strcat('E:\EDATA_SEG\NON_ROI227x227\','NONROI_',srcfile(i).name); % need to make a folder in source directory on which we need to save our images and mantion it on matlab
    imwrite(k,newsegmentedimages);
end
    