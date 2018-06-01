clear;clc;

% ѡ��ͼƬ����ȡ��ַ 
[filenames,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.gif','All Image Files';'*.*','All Files' },'MultiSelect','on');
dir = fullfile(pathname,filenames);

% ��ȡͼƬ����ת����double��
im_org = imread(dir);
im_org = im2double(im_org);

% ��ֵ�˲���ȥ���������
im_org = imfilter(im_org,fspecial('average',[5,5]));

% ��Ƭ���ţ����߲�����2000����
r=size(im_org,1);
c=size(im_org,2);
size_thresh=2000;
if r>size_thresh
    im_org=imresize(im_org,size_thresh/r);
end
if c>size_thresh
    im_org=imresize(im_org,size_thresh/c);
end

% ��ֵ����ȡ��
thresh = 1 * graythresh(im_org);
im_bw = ~ im2bw(im_org,thresh);

% �߽�����
im_bw_clear = imclearborder(bwareaopen(im_bw,10));

% ����
bwc=imdilate(im_bw_clear,strel('disk',10));

% Ч��ͼ���չʾ
subplot(2,2,1),imshow(im_org),title('ԭͼ');
subplot(2,2,2),imshow(im_bw),title('��ֵ��');
subplot(2,2,3),imshow(im_bw_clear),title('�߽�����');
subplot(2,2,4),imshow(bwc),title('����'); 

% ͳ��
region = regionprops(bwc,'Area');
area_amount = length(region);
areas = zeros(area_amount,1);
for i=1:area_amount
    areas(i) = region(i).Area;
end

% areas�������򣬴Ӹߵ��������ж�ӲƤ������ֵ
areas = sort(areas,'descend');


% ��ǰͳ�Ƶ�Ӳ�ң�1->һԪӲ�� 2->��ëӲ�� 3->һëӲ��
current_coin = 1;
% Ӳ�Ҽ�����������ֵͳ�ƣ�������
coin_cnt = zeros(1,3);

% Ӳ�ҷ���ı仯������,����仯����������������ж�����һ��Ӳ��
rate_next_class = 0.1;
% ��ǰͳ�Ƶ�������������ں���һ��������ͼ����бȶԣ�ȷ��Ӳ������
current_area = areas(1);
% �����С�м�ֵ������ȡ������
mid_area = areas(fix(area_amount/2));

for i=1:area_amount
    % ���������ͼ��������������ͼ����λֵ��20%�����϶����ӵ㣬����Ӳ�ң������з���
    if areas(i) < 0.2*mid_area
        continue
    end
    if abs(areas(i)-current_area)/current_area < 0.1
        coin_cnt(current_coin) = coin_cnt(current_coin) + 1;
    else
        current_coin = current_coin+1;
        coin_cnt(current_coin) = coin_cnt(current_coin) + 1;
    end
    % ���µ�ǰ���ֵ
    current_area = areas(i);
end

coin_cnt