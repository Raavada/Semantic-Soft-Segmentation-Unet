%Reading image 
img=imread('gn.jpg');
img=imresize(img,[512,512])  % Resizing image
load('sep_128_gn')  % High level semantic features from Uner 
%simp = preprocessFeatures(sep_128_g5, img); 
%imshow(simp)  
% Semantic Soft Segmentation
sss = SemanticSoftSegmentation(imresize(double(img),0.5)/255, imresize(sep_128_gn,0.5)/255);
imshow(visualizeSoftSegments(sss))
