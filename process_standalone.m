clear;clc;

% 选择图片，获取地址 
[filenames,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.gif','All Image Files';'*.*','All Files' },'MultiSelect','on');
dir = fullfile(pathname,filenames);

% 读取图片，并转换成double型
im_org = imread(dir);
im_org = im2double(im_org);

% 均值滤波，去除部分噪点
im_org = imfilter(im_org,fspecial('average',[5,5]));

% 照片缩放，最大边不超过2000像素
r=size(im_org,1);
c=size(im_org,2);
size_thresh=2000;
if r>size_thresh
    im_org=imresize(im_org,size_thresh/r);
end
if c>size_thresh
    im_org=imresize(im_org,size_thresh/c);
end

% 二值化并取反
thresh = 1 * graythresh(im_org);
im_bw = ~ im2bw(im_org,thresh);

% 边界抑制
im_bw_clear = imclearborder(bwareaopen(im_bw,10));

% 膨胀
bwc=imdilate(im_bw_clear,strel('disk',10));

% 效果图逐个展示
subplot(2,2,1),imshow(im_org),title('原图');
subplot(2,2,2),imshow(im_bw),title('二值化');
subplot(2,2,3),imshow(im_bw_clear),title('边界抑制');
subplot(2,2,4),imshow(bwc),title('膨胀'); 

% 统计
region = regionprops(bwc,'Area');
area_amount = length(region);
areas = zeros(area_amount,1);
for i=1:area_amount
    areas(i) = region(i).Area;
end

% areas降序排序，从高到低依次判断硬皮所属面值
areas = sort(areas,'descend');


% 当前统计的硬币：1->一元硬币 2->五毛硬币 3->一毛硬币
current_coin = 1;
% 硬币计数器，按面值统计，共三种
coin_cnt = zeros(1,3);

% 硬币分类的变化率依据,面积变化超过这个比例，则判定是下一种硬币
rate_next_class = 0.1;
% 当前统计的区域面积，用于和下一个待分类图像进行比对，确定硬币类型
current_area = areas(1);
% 面积大小中间值，尽量取面积大的
mid_area = areas(fix(area_amount/2));

for i=1:area_amount
    % 如果待分类图像的面积低于所有图像中位值的20%，就认定是杂点，不是硬币，不进行分类
    if areas(i) < 0.2*mid_area
        continue
    end
    if abs(areas(i)-current_area)/current_area < 0.1
        coin_cnt(current_coin) = coin_cnt(current_coin) + 1;
    else
        current_coin = current_coin+1;
        coin_cnt(current_coin) = coin_cnt(current_coin) + 1;
    end
    % 更新当前面积值
    current_area = areas(i);
end

coin_cnt