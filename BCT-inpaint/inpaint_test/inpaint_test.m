% images
im = double(imread('birds.png')); 
% birds.png'));
immask = double(imread('birds_mask.png'));
% immask = 1.0 - immask/3.0;
% mask
%mask = getMask(im,immask);
mask = 1.0 - immask(:,:,1)/255.0;
immask = im;

% inpaint
tic;
imr = inpaintBCT(immask,'orderD',mask,'guidanceC',[4 25 2 3]);
toc

% show result
figure; 
rect = get(gcf,'OuterPosition');
rect(1) = rect(1)-round(rect(3)/2);
rect(3) = 2*rect(3);
set(gcf,'OuterPosition',rect);
clear rect
subplot(1,2,1), subimage(uint8(im)), axis off, axis image, title('original')
subplot(1,2,2), subimage(uint8(imr)), axis off, axis image, title('inpainted')