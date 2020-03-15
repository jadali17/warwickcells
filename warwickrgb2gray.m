
%%Applying filter to training datasetl
imds= imageDatastore('test', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
h = waitbar(0,'Please wait...');
for i = 1:85
    [image,info]=readimage(imds,i);    
    newimage=rgb2gray(image)
    imwrite(newimage,info.Filename);
    waitbar(i/85)
end
