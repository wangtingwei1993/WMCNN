close all;
clear all;
clc;clear;
%% set parameters
up_scale = 2;
wtype = 'bior1.1';
model_l = 'model/L.mat';
model_h = 'model/H.mat';
model_v = 'model/V.mat';
model_d = 'model/D.mat';


image = imread('Samples/Grass.jpg');

%% work on illuminance only
if size(image,3)>1
    image = rgb2ycbcr(image);
    im_Y = image(:, :, 1);
end

im_gnd = im2double(modcrop(im_Y, up_scale));

%% bicubic interpolation
im_low = imresize(im_gnd, 1/up_scale, 'bicubic');
im_bic = imresize(im_low, up_scale, 'bicubic');

%% SRCNN
cA = SRCNN(model_l, im_low);
cH = SRCNN(model_h, im_low);
cV = SRCNN(model_v, im_low);
cD = SRCNN(model_d, im_low);

im_h = idwt2(cA, cH, cV, cD, wtype);

if up_scale == 4
    cA = SRCNN(model_l, im_h);
    cH = SRCNN(model_h, im_h);
    cV = SRCNN(model_v, im_h);
    cD = SRCNN(model_d, im_h);
    im_h = idwt2(cA, cH, cV, cD, wtype);
end

im_h = shave(uint8(im_h * 255), [up_scale, up_scale]);
im_gnd = shave(uint8(im_gnd * 255), [up_scale, up_scale]);
im_bic = shave(uint8(im_bic * 255), [up_scale, up_scale]);

%% compute PSNR
psnr_bic = compute_psnr(im_gnd, im_bic);
psnr_srcnn = compute_psnr(im_gnd, im_h);

%% show results
fprintf('PSNR for Bicubic Interpolation: %f dB\n', psnr_bic);
fprintf('PSNR for SRCNN Reconstruction: %f dB\n', psnr_srcnn);

figure, imshow(im_bic); title('Bicubic Interpolation');
figure, imshow(im_h); title('WMCNN Reconstruction');

% image(:, :, 2) = imresize(imresize(image(:, :, 2), 1/up_scale, 'bicubic'), up_scale, 'bicubic');
% image(:, :, 3) = imresize(imresize(image(:, :, 3), 1/up_scale, 'bicubic'), up_scale, 'bicubic');
% image = shave(image, [up_scale, up_scale]);
% image(:, :, 1)=im_h;
% im_H = ycbcr2rgb(image);
% image(:, :, 1)=im_bic;
% im_B = ycbcr2rgb(image);
% imwrite(im_B, ['Bicubic Interpolation' '.bmp']);
% imwrite(im_H, ['reconstruced' '.bmp']);
% imwrite(im_gt, ['gt_image' '.bmp']);
