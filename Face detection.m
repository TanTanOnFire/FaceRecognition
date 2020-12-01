
close all;
% read the image 

ph='pic_0028.jpg';
img=imread(ph);
subplot(1,4,1);
imshow(ph);
im2 = rgb2ycbcr(img) ;
y=im2(:,:,1);
cb=im2(:,:,2);
cr=im2(:,:,3);

%create a facemask based on the color of simpson's face

skinmask=(y>140 & cb>35 & cb<83 & cr>130 & cr<170) ;

hold on
se = strel('disk',15);

%close algorithm using morphology 

closeBW = imclose(skinmask,se);
%imshow(closeBW)
se = strel('disk',3);
afterOpening = imopen(closeBW,se);
subplot(1,4,2);
imshow(afterOpening,[]);
% Label the image
labeledImage = logical(afterOpening);

measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
numberToExtract=length(measurements);
[labeledImage, numberOfBlobs] = bwlabel(afterOpening);
blobMeasurements = regionprops(labeledImage, 'area');
%%%%%%%%%%%%function
allAreas = [blobMeasurements.Area];
  if numberToExtract > 0
    % For positive numbers, sort in order of largest to smallest.
    % Sort them.
    [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
  elseif numberToExtract < 0
    % For negative numbers, sort in order of smallest to largest.
    % Sort them.
    [sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
    % Need to negate numberToExtract so we can use it in sortIndexes later.
    numberToExtract = -numberToExtract;
  else
    % numberToExtract = 0.  Shouldn't happen.  Return no blobs.
    binaryImage = false(size(binaryImage));
    return;
  end
  % Extract the "numberToExtract" largest blob(a)s using ismember().
  biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
  % Convert from integer labeled image into binary (logical) image.
  binaryImage = biggestBlob > 0;
  %%%max
 max=0;
 sw=1;
 z=cell(1,length(measurements));
 for k = 1 : length(measurements)
   thisBB = measurements(k).BoundingBox;
   if(thisBB(3)*thisBB(4)>max)
      max=(thisBB(3)*thisBB(4));
      sw=k;
      z{sw}=[thisBB(1) thisBB(2) thisBB(3) thisBB(4)];
   end
 rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','g','LineWidth',2 )
 end
 
 %errosion
se = strel('disk',15);
% erodedBW = bwmorph(afterOpening,'remove');
 erodedBW=imerode(afterOpening,se);
 subplot(1,4,3);
 imshow(erodedBW);
 %dilate
 se = strel('disk',30);
 dilateBW = imdilate(erodedBW,se);
 subplot(1,4,4);
 imshow(dilateBW);
  labeledImage = bwlabel(dilateBW);
  measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
   numberToExtract=length(measurements);
  [labeledImage, numberOfBlobs] = bwlabel(dilateBW);
   blobMeasurements = regionprops(labeledImage, 'area');
 %%%%%%%%%%%%function
 allAreas = [blobMeasurements.Area];
   if numberToExtract > 0
     % For positive numbers, sort in order of largest to smallest.
     % Sort them.
     [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
   elseif numberToExtract < 0
     % For negative numbers, sort in order of smallest to largest.
     % Sort them.
     [sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
     % Need to negate numberToExtract so we can use it in sortIndexes later.
     numberToExtract = -numberToExtract;
   else
     % numberToExtract = 0.  Shouldn't happen.  Return no blobs.
     binaryImage = false(size(binaryImage));
     return;
   end
   % Extract the "numberToExtract" largest blob(a)s using ismember().
   biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
   % Convert from integer labeled image into binary (logical) image.
   binaryImage = biggestBlob > 0;
   %%%max
  max=0;
  for k = 1 : length(measurements)
    thisBB = measurements(k).BoundingBox;
    if(thisBB(3)*thisBB(4)>max)
       max=(thisBB(3)*thisBB(4));
       sw=k;
       z{sw}=[thisBB(1) thisBB(2) thisBB(3) thisBB(4)];
    end
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
   'EdgeColor','g','LineWidth',2 )   
  end
figure, imshow(ph);
rectangle('position', z{sw},'EdgeColor','r','LineWidth',2);



