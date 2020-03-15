imdsTest = imageDatastore('test');
classNames = ["foreground" "background"];
labels = [255 0];
pxdsTest = pixelLabelDatastore('testlabels',classNames,labels)
pximdsTest = pixelLabelImageDatastore(imdsTest,pxdsTest);

pxdsPred = semanticseg(imdsTest,warwicknet,'WriteLocation',tempdir);

metrics = evaluateSemanticSegmentation(pxdsPred,pxdsTest);
imdsTestlabelstmp = imageDatastore('testlabels');

diceaverage=0;
cellstestlabel={};
cellssegmented={};
for k=1:60
    C1=readimage(pxdsPred,k);
    CTemp=C1;
    newimagecat=zeros(size(CTemp));
    c=1;
    for i= 1:128
        for j=1:128
            if CTemp(i,j) == 'background'
            newimagecat(i,j)=0;
            else
            newimagecat(i,j)=1;
            end
        end
    end
    newimagecat=logical(newimagecat);
    cellssegmented{k}=newimagecat(:,:);
end
for k= 1:60

z1=readimage(imdsTestlabelstmp,k);
z1=logical(z1);
cellstestlabel{k}=z1(:,:);
end
temp=zeros(1);
for k = 1:60
tempdice(k)=dice(cellstestlabel{k},cellssegmented{k});
end
diceaverage=sum(tempdice)/60;
 for k = 1:60
temphaus(k)=HausdorffDist(cellstestlabel{k},cellssegmented{k});
 end
hausdorffaverage=sum(temphaus)/60;
% subplot(2,2,1)
% 
% imshow(cellssegmented{32});
% title('Segmented image')
% subplot(2,2,2)
% 
% imshow(cellstestlabel{32});
% title('Real segmentation')
% subplot(2,2,3)
% imshow(y);
% title('Actual image')