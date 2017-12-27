clear;close all;
clc;clear;
%% settings
folder = '/home/tingweiwang/PycharmProjects/DataSet/RemoteImage/RSSCN7/val/';
Savepath_L = 'data/test1.h5';
Savepath_H = 'data/test2.h5';
Savepath_V = 'data/test3.h5';
Savepath_D = 'data/test4.h5';

size_input = 400;
scale = 2;
%scale = 4;
wtype = 'bior1.1';

%% initialization
data = zeros(size_input/2, size_input/2, 1, 1);
label_L = zeros(size_input/2, size_input/2, 1, 1);
label_H = zeros(size_input/2, size_input/2, 1, 1);
label_V = zeros(size_input/2, size_input/2, 1, 1);
label_D = zeros(size_input/2, size_input/2, 1, 1);
count = 0;

%% generate data
filepaths = dir(fullfile(folder,'*.jpg'));

for i = 1 : length(filepaths)
    fprintf('Image No.: %d \n', i);
    count=count+1;
    image = imread(fullfile(folder,filepaths(i).name));
    
    im_ycbcr = rgb2ycbcr(image);
    im_y = modcrop(im2double(im_ycbcr(:, :, 1)), scale);
    
    im_input = imresize(im_y, 1/scale, 'bicubic');
    data(:, :, 1, count) = im_input;
    
    im_gt_Y = im_y;    
    [label_l,label_h, label_v, label_d] = dwt2(im_gt_Y, wtype);
    label_L(:, :, 1, count) = label_l;
    label_H(:, :, 1, count) = label_h;
    label_V(:, :, 1, count) = label_v;
    label_D(:, :, 1, count) = label_d;
end

%% shuffle the images
order = randperm(count);
data = data(:, :, 1, order);
label_L = label_L(:, :, 1, order);
label_H = label_H(:, :, 1, order);
label_V = label_V(:, :, 1, order);
label_D = label_D(:, :, 1, order);

%% writing to HDF5
chunksz = 2;
created_flag = false;
totalct = 0;

for batchno = 1:floor(count/chunksz)
    fprintf('Batch No.: %d \n', batchno);
    last_read=(batchno-1)*chunksz;
    batchdata = data(:,:,1,last_read+1:last_read+chunksz);
    
    batchlabs_L = label_L(:,:,1,last_read+1:last_read+chunksz);
    batchlabs_H = label_H(:,:,1,last_read+1:last_read+chunksz);
    batchlabs_V = label_V(:,:,1,last_read+1:last_read+chunksz);
    batchlabs_D = label_D(:,:,1,last_read+1:last_read+chunksz);
    startloc = struct('dat',[1,1,1,totalct+1], 'lab', [1,1,1,totalct+1]);
    
    curr_dat_sz_L = store2hdf5(Savepath_L, batchdata, batchlabs_L, ~created_flag, startloc, chunksz);
    
    curr_dat_sz_H = store2hdf5(Savepath_H, batchdata, batchlabs_H, ~created_flag, startloc, chunksz);
    
    curr_dat_sz_V = store2hdf5(Savepath_V, batchdata, batchlabs_V, ~created_flag, startloc, chunksz);
    
    curr_dat_sz_D = store2hdf5(Savepath_D, batchdata, batchlabs_D, ~created_flag, startloc, chunksz);
    
    
    created_flag = true;
    totalct = curr_dat_sz_L(end);
end
h5disp(Savepath_L);
h5disp(Savepath_H);
h5disp(Savepath_V);
h5disp(Savepath_D);
