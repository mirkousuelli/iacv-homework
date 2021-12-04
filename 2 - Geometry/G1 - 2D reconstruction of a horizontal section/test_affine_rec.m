%% Affine rectification from fitted vanishing points
% perform an affine rectification of an image. Vanishing points are estimated 
% from families of parallel lines.Then the line at infinity is fitted to the 
% vanishing points. The homography that maps the line at infinity to its
% canonical form: (0: 0: 1) rectify the image up to an affinity transformation.

%load the image
clc;
clear;
close all;
img = imread('../../img/villa_image.png');
img = im2double(img);
%img = flipdim(img ,1);
%img = padarray(img, [500 500], 0,'post');
%img = imresize(img, 0.3);
figure; imshow(img);

% interactively select f families of segments that are images of 3D parallel lines

f = 2; % number of families of parallel lines
numSegmentsPerFamily = 2;
parallelLines = cell(f,1); % store parallel lines
fprintf(['Draw ', num2str(f) , ' families of parallel segments\n']);
col = 'rgbm';
for i = 1:f
    count = 1;
    parallelLines{i} = nan(numSegmentsPerFamily,3);
    while(count <=numSegmentsPerFamily)
        figure(gcf);
        title(['Draw ', num2str(numSegmentsPerFamily),' segments: step ',num2str(count) ]);
        segment1 = drawline('Color',col(i));
        parallelLines{i}(count, :) = segToLine(segment1.Position);
        count = count +1;
    end
    fprintf('Press enter to continue\n');
    pause
end

%%% compute the vanishing points
V = nan(2,f);
for i =1:f
    A = parallelLines{i}(:,1:2);
    B = -parallelLines{i}(:,3);
    V(:,i) = A\B;
end

% compute the image of the line at infinity
imLinfty = cross([V(1,1) V(2,1) 1], [V(1,2) V(2,2) 1]);%= fitline(V);
imLinfty = imLinfty./(imLinfty(3));

figure;
hold all;
for i = 1:f
    plot(V(1,i),V(2,i),'o','Color',col(i),'MarkerSize',20,'MarkerFaceColor',col(i));
end
hold all;
imshow(img);

% build the rectification matrix

H = [eye(2),zeros(2,1); imLinfty(:)'];
% we can check that H^-T* imLinfty is the line at infinity in its canonical
% form:
%fprintf('The vanishing line is mapped to:\n');
%disp(inv(H)'.*imLinfty); % moved in its canonical position

%%% rectify the image and show the result

tform = projective2d(H');
J = imwarp(img,tform);
[J,rect] = imcrop(J);

figure;
figure; imshow(J);
imwrite(J,'../../img/affined_img.png');


function [l] = segToLine(pts)
% convert the endpoints of a line segment to a line in homogeneous
% coordinates.
%
% pts are the endpoits of the segment: [x1 y1;
%                                       x2 y2]

% convert endpoints to cartesian coordinates
a = [pts(1,:)';1];
b = [pts(2,:)';1];
l = cross(a,b);
l = l./norm(l);
end
