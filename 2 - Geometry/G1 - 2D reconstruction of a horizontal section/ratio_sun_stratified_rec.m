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
img_gray = rgb2gray(img);
% interactively select f families of segments that are images of 3D parallel lines
lines = findLines(img_gray);

% CONSTRUCTION LINES
idx = [32];%, 26];
label = ['r'];%, 'n']
fig = figure();
imshow(img), hold on;
for k = 1:length(idx)
    xy = [lines(idx(k)).point1; lines(idx(k)).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',1,'Color', 'red');
    text(xy(:,1),xy(:,2), label(k), 'FontSize', 20, 'Color', 'red'); 
end
%line_n = cross([lines(idx(1)).point1 1]', [lines(idx(1)).point2 1]');
%line_n = line_n / line_n(3);
line_r = cross([lines(idx(1)).point1 1]', [lines(idx(1)).point2 1]');
line_r = line_r / line_r(3);

% PARALLEL LINES
idx = [8, 12, 16, 18];
label = ['a', 'b', 'c', 'd']
f = 2; % number of families of parallel lines
numSegmentsPerFamily = 2;
parallelLines = cell(f,1); % store parallel lines

line_a = cross([lines(idx(1)).point1 1]', [lines(idx(1)).point2 1]');
line_a = line_a / line_a(3);
line_b = cross([lines(idx(2)).point1 1]', [lines(idx(2)).point2 1]');
line_b = line_b / line_b(3);
line_c = cross([lines(idx(3)).point1 1]', [lines(idx(3)).point2 1]');
line_c = line_c / line_c(3);
line_d = cross([lines(idx(4)).point1 1]', [lines(idx(4)).point2 1]');
line_d = line_d / line_d(3);

parallelLines{1}(1,:) = line_a;
parallelLines{1}(2,:) = line_d;
parallelLines{2}(1,:) = line_b;
parallelLines{2}(2,:) = line_c;

for k = 1:length(idx)
    xy = [lines(idx(k)).point1; lines(idx(k)).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',1,'Color', 'green');
    text(xy(:,1),xy(:,2), label(k), 'FontSize', 20, 'Color', 'green');
end

% POINTS (CORNER DETECTION)
A = [226 334 1]';
B = [272 534 1]';
E = [731 551 1]';
G = [821 364 1]';
P = [507 313 1]';

Q = [507 328 1]';

% LINES FROM CORNER POINTS
line_s = cross(B, E);
line_s = line_s / line_s(3);
line_t = cross(G, E);
line_t = line_t / line_t(3);
line_u = cross(P, Q);
line_u = line_u / line_u(3);

% POINTS FROM INTERSECTED LINES
C = cross(line_r, line_s);
C = C / C(3);
D = cross(line_u, line_s);
D = D / D(3);
%F = cross(line_t, line_n);
%F = F / F(3);

% PERPENDICULAR LINES FOR METRIC RECTIFICATION

plot(A(1), A(2),'.b','MarkerSize',12);
text(A(1), A(2), 'A', 'FontSize', 24, 'Color', 'b');
plot(B(1), B(2),'.b','MarkerSize',12);
text(B(1), B(2), 'B', 'FontSize', 24, 'Color', 'b');
plot(C(1), C(2),'.b','MarkerSize',12);
text(C(1), C(2), 'C', 'FontSize', 24, 'Color', 'b');
plot(D(1), D(2),'.b','MarkerSize',12);
text(D(1), D(2), 'D', 'FontSize', 24, 'Color', 'b');
plot(E(1), E(2),'.b','MarkerSize',12);
text(E(1), E(2), 'E', 'FontSize', 24, 'Color', 'b');
%plot(F(1), F(2),'.b','MarkerSize',12);
%text(F(1), F(2), 'F', 'FontSize', 24, 'Color', 'b');
plot(G(1), G(2),'.b','MarkerSize',12);
text(G(1), G(2), 'G', 'FontSize', 24, 'Color', 'b');

% PERPENDICULARS
%s
line_be = [[B(1) B(2)]; [E(1) E(2)]];
plot(line_be(:,1),line_be(:,2),'LineWidth',1,'Color', 'yellow');
text(line_be(:,1),line_be(:,2), 's', 'FontSize', 20, 'Color', 'yellow');
line_be = cross(B, E);
line_be = line_be / line_be(3);

%t
line_ge = [[G(1) G(2)]; [E(1) E(2)]];
plot(line_ge(:,1),line_ge(:,2),'LineWidth',1,'Color', 'yellow');
text(line_ge(:,1),line_ge(:,2), 't', 'FontSize', 20, 'Color', 'yellow');
line_ge = cross(G, E);
line_ge = line_ge / line_ge(3);


% ################################### SUN RATIO
dist_short_shadow = sqrt((B(1) - C(1))^2 + (B(2) - C(2))^2);
SUN_RATIO = 3.9;
dist_extended_shadow = SUN_RATIO * dist_short_shadow;

v = [C(1)-B(1) C(2)-B(2)]';
u = v ./ norm(v);
N = B(1:2) + dist_extended_shadow * u;
N = [N(1) N(2) 1]';

plot(N(1), N(2),'.b','MarkerSize',12);
text(N(1), N(2), 'N', 'FontSize', 24, 'Color', 'b');

M = cross(line_b, line_c);
M = M / M(3);
plot(M(1), M(2),'.b','MarkerSize',12);
text(M(1), M(2), 'M', 'FontSize', 24, 'Color', 'b');

line_nm = [[N(1) N(2)]; [M(1) M(2)]];
plot(line_nm(:,1),line_nm(:,2),'LineWidth',1,'Color', 'red');
text(line_nm(:,1),line_nm(:,2), 'l', 'FontSize', 20, 'Color', 'red');
line_nm = cross(N, M);
line_nm = line_nm / line_nm(3);

L = cross(line_a, line_nm);
L = L / L(3);
plot(L(1), L(2),'.b','MarkerSize',12);
text(L(1), L(2), 'L', 'FontSize', 24, 'Color', 'b');

line_an = [[A(1) A(2)]; [N(1) N(2)]];
plot(line_an(:,1),line_an(:,2),'LineWidth',1,'Color', 'yellow');
text(line_an(:,1),line_an(:,2), 't', 'FontSize', 20, 'Color', 'yellow');
line_an = cross(A, N);
line_an = line_an / line_an(3);

line_bl = [[B(1) B(2)]; [L(1) L(2)]];
plot(line_bl(:,1),line_bl(:,2),'LineWidth',1,'Color', 'yellow');
text(line_bl(:,1),line_bl(:,2), 't', 'FontSize', 20, 'Color', 'yellow');
line_bl = cross(B, L);
line_bl = line_bl / line_bl(3);

% ###################################

hold off;
pause;

%% compute the vanishing points
V = nan(2,f);
for i =1:f
    X = parallelLines{i}(:,1:2);
    Y = -parallelLines{i}(:,3);
    V(:,i) = X\Y;
end

%% compute the image of the line at infinity
imLinfty = cross([V(1,1) V(2,1) 1], [V(1,2) V(2,2) 1]);%= fitline(V);
imLinfty = imLinfty./(imLinfty(3));

%figure;
%hold all;
%for i = 1:f
%    plot(V(1,i),V(2,i),'o','Color','green','MarkerSize',20,'MarkerFaceColor','green');
%end
%hold all;
%figure; imshow(img);

%% build the rectification matrix

H = [eye(2),zeros(2,1); imLinfty(:)'];
% we can check that H^-T* imLinfty is the line at infinity in its canonical
% form:
%fprintf('The vanishing line is mapped to:\n');
%disp(inv(H)'*imLinfty'); % moved in its canonical position

%% rectify the image and show the result

tform = projective2d(H');

disp('Affine matrix:');
disp(tform.T);

J = imwarp(img,tform);
J = imcrop(J,[4351 8805 3237 2141]);

%imwrite(J,'../../img/affined_img.png');

%% projectivity on points

[A(1),A(2)] = transformPointsForward(tform,A(1),A(2));
[B(1),B(2)] = transformPointsForward(tform,B(1),B(2));
[C(1),C(2)] = transformPointsForward(tform,C(1),C(2));
[D(1),D(2)] = transformPointsForward(tform,D(1),D(2));
[E(1),E(2)] = transformPointsForward(tform,E(1),E(2));
%[F(1),F(2)] = transformPointsForward(tform,F(1),F(2));
[G(1),G(2)] = transformPointsForward(tform,G(1),G(2));
[L(1),L(2)] = transformPointsForward(tform,L(1),L(2));
[N(1),N(2)] = transformPointsForward(tform,N(1),N(2));

figure; imshow(J), hold on;
% POINTS
plot(A(1), A(2),'.b','MarkerSize',12);
text(A(1), A(2), 'A', 'FontSize', 24, 'Color', 'b');
plot(B(1), B(2),'.b','MarkerSize',12);
text(B(1), B(2), 'B', 'FontSize', 24, 'Color', 'b');
plot(C(1), C(2),'.b','MarkerSize',12);
text(C(1), C(2), 'C', 'FontSize', 24, 'Color', 'b');
plot(D(1), D(2),'.b','MarkerSize',12);
text(D(1), D(2), 'D', 'FontSize', 24, 'Color', 'b');
plot(E(1), E(2),'.b','MarkerSize',12);
text(E(1), E(2), 'E', 'FontSize', 24, 'Color', 'b');
%plot(F(1), F(2),'.b','MarkerSize',12);
%text(F(1), F(2), 'F', 'FontSize', 24, 'Color', 'b');
plot(G(1), G(2),'.b','MarkerSize',12);
text(G(1), G(2), 'G', 'FontSize', 24, 'Color', 'b');
plot(L(1), L(2),'.b','MarkerSize',12);
text(L(1), L(2), 'L', 'FontSize', 24, 'Color', 'b');
plot(N(1), N(2),'.b','MarkerSize',12);
text(N(1), N(2), 'N', 'FontSize', 24, 'Color', 'b');

% LINES

line_ab = [[A(1) A(2)]; [B(1) B(2)]];
plot(line_ab(:,1),line_ab(:,2),'LineWidth',1,'Color', 'yellow');
text(line_ab(:,1),line_ab(:,2), 'ab', 'FontSize', 20, 'Color', 'yellow');
line_ab = cross(A, B);
line_ab = line_ab / line_ab(3);

%s
line_be = [[B(1) B(2)]; [E(1) E(2)]];
plot(line_be(:,1),line_be(:,2),'LineWidth',1,'Color', 'yellow');
text(line_be(:,1),line_be(:,2), 'be', 'FontSize', 20, 'Color', 'yellow');
line_be = cross(B, E);
line_be = line_be / line_be(3);

%t
line_ge = [[G(1) G(2)]; [E(1) E(2)]];
plot(line_ge(:,1),line_ge(:,2),'LineWidth',1,'Color', 'yellow');
text(line_ge(:,1),line_ge(:,2), 'ge', 'FontSize', 20, 'Color', 'yellow');
line_ge = cross(G, E);
line_ge = line_ge / line_ge(3);

line_an = [[A(1) A(2)]; [N(1) N(2)]];
plot(line_an(:,1),line_an(:,2),'LineWidth',1,'Color', 'yellow');
text(line_an(:,1),line_an(:,2), 'an', 'FontSize', 20, 'Color', 'yellow');
line_an = cross(A, N);
line_an = line_an / line_an(3);

line_bl = [[B(1) B(2)]; [L(1) L(2)]];
plot(line_bl(:,1),line_bl(:,2),'LineWidth',1,'Color', 'yellow');
text(line_bl(:,1),line_bl(:,2), 'bl', 'FontSize', 20, 'Color', 'yellow');
line_bl = cross(B, L);
line_bl = line_bl / line_bl(3);

hold off;
pause;

%% RECTIFICATION
constr = zeros(2,3);
constr(1,:) = [line_an(1)*line_bl(1),line_an(1)*line_bl(2)+line_an(2)*line_bl(1), line_an(2)*line_bl(2)];
constr(2,:) = [line_be(1)*line_ge(1),line_be(1)*line_ge(2)+line_be(2)*line_ge(1), line_be(2)*line_ge(2)];

% solve the system

%S = [x(1) x(2); x(2) 1];
[~,~,v] = svd(constr);
s = v(:,end); %[s11,s12,s22];
S = [s(1),s(2); s(2),s(3)];

% compute the rectifying homography

% image of circular points
imDCCP = [S,zeros(2,1); zeros(1,3)]; % the image of the circular points
[U,DD,V] = svd(S);
constr = U*sqrt(DD)*V';

H = eye(3);
H(1,1) = constr(1,1);
H(1,2) = constr(1,2);
H(2,1) = constr(2,1);
H(2,2) = constr(2,2);

Hrect = inv(H);
Cinfty = [eye(2),zeros(2,1);zeros(1,3)];

tform = projective2d(Hrect');
J = imwarp(J,tform);

disp('Metric matrix:');
disp(tform.T);

J = imcrop(J,[0 648 3969 3789]);

[A(1),A(2)] = transformPointsForward(tform,A(1),A(2));
[B(1),B(2)] = transformPointsForward(tform,B(1),B(2));
[C(1),C(2)] = transformPointsForward(tform,C(1),C(2));
[D(1),D(2)] = transformPointsForward(tform,D(1),D(2));
[E(1),E(2)] = transformPointsForward(tform,E(1),E(2));
%[F(1),F(2)] = transformPointsForward(tform,F(1),F(2));
[G(1),G(2)] = transformPointsForward(tform,G(1),G(2));

A(1) = A(1) + 673;
B(1) = B(1) + 673;
C(1) = C(1) + 673;
D(1) = D(1) + 673;
E(1) = E(1) + 673;
%F(1) = F(1) + 673;
G(1) = G(1) + 673;

A(2) = A(2) + 376;
B(2) = B(2) + 376;
C(2) = C(2) + 376;
D(2) = D(2) + 376;
E(2) = E(2) + 376;
%F(2) = F(2) + 376;
G(2) = G(2) + 376;

figure; imshow(J), hold on;

% POINTS
if 2 == 2
    plot(A(1), A(2),'.b','MarkerSize',12);
    text(A(1), A(2), 'A', 'FontSize', 24, 'Color', 'b');
    plot(B(1), B(2),'.b','MarkerSize',12);
    text(B(1), B(2), 'B', 'FontSize', 24, 'Color', 'b');
    plot(C(1), C(2),'.b','MarkerSize',12);
    text(C(1), C(2), 'C', 'FontSize', 24, 'Color', 'b');
    plot(D(1), D(2),'.b','MarkerSize',12);
    text(D(1), D(2), 'D', 'FontSize', 24, 'Color', 'b');
    plot(E(1), E(2),'.b','MarkerSize',12);
    text(E(1), E(2), 'E', 'FontSize', 24, 'Color', 'b');
    %plot(F(1), F(2),'.b','MarkerSize',12);
    %text(F(1), F(2), 'F', 'FontSize', 24, 'Color', 'b');
    plot(G(1), G(2),'.b','MarkerSize',12);
    text(G(1), G(2), 'G', 'FontSize', 24, 'Color', 'b');
end

% LINES
facade_2 = [[A(1) A(2)]; [B(1) B(2)]];
plot(facade_2(:,1),facade_2(:,2),'LineWidth',3,'Color', 'red');
text(facade_2(:,1),facade_2(:,2), '2', 'FontSize', 20, 'Color', 'red');

facade_3 = [[B(1) B(2)]; [E(1) E(2)]];
plot(facade_3(:,1),facade_3(:,2),'LineWidth',3,'Color', 'red');
text(facade_3(:,1),facade_3(:,2), '3', 'FontSize', 20, 'Color', 'red');

facade_4 = [[E(1) E(2)]; [G(1) G(2)]];
plot(facade_4(:,1),facade_4(:,2),'LineWidth',3,'Color', 'red');
text(facade_4(:,1),facade_4(:,2), '4', 'FontSize', 20, 'Color', 'red');
hold off;
 
%normalized coordinates
norm_factor = max((size(img)));
norm_matrix = diag([1/norm_factor, 1/norm_factor, 1]);

D_n = (D' * norm_matrix)';
E_n = (E' * norm_matrix)';
G_n = (G' * norm_matrix)';

half_f3 = sqrt((D_n(1)-E_n(1))^2 + (D_n(2)-E_n(2))^2);
f4 = sqrt((G_n(1)-E_n(1))^2 + (G_n(2)-E_n(2))^2);

ratio = f4 / (half_f3 * 2);

disp('Ratio facade_2/facade_3:');
disp(ratio);