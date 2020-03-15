


imdsTrain = imageDatastore('train');
classNames = ["foreground" "background"];
labels = [255 0];
pxdsTrain = pixelLabelDatastore('trainlabels',classNames,labels)
pximdsTrain = pixelLabelImageDatastore(imdsTrain,pxdsTrain);

inputSize=[128 128 1];
filterSize=3;
numFilters=32;
numClasses=numel(classNames);

tbl = countEachLabel(pximdsTrain);
numberPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / numberPixels;
classWeights = 1 ./ frequency;
layers = [
    imageInputLayer([128 128 1],"Name","imageinput","Normalization","zscore")
    
    convolution2dLayer([3 3],8,"Name","conv_1","Padding",[1 1 1 1])
    reluLayer("Name","relu_1")
    batchNormalizationLayer("Name","batchnorm_1")
    maxPooling2dLayer([2 2],"Name","maxpool_1","Padding","same","Stride",[2 2])
   
    
    convolution2dLayer([3 3],16,"Name","conv_2","Padding",[1 1 1 1])
    reluLayer("Name","relu_2")
    batchNormalizationLayer("Name","batchnorm_2")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Padding","same","Stride",[2 2])
  
    convolution2dLayer([3 3],32,"Name","conv_3","Padding",[1 1 1 1])
    reluLayer("Name","relu_3")
    batchNormalizationLayer("Name","batchnorm_3")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Padding","same","Stride",[2 2])
    
    transposedConv2dLayer([3 3],32,"Name","transposed-conv","Cropping","same","Stride",[2 2])
    transposedConv2dLayer([3 3],16,"Name","transposed-conv","Cropping","same","Stride",[2 2])
    transposedConv2dLayer([3 3],8,"Name","transposed-conv","Cropping","same","Stride",[2 2])
    
    convolution2dLayer(1,numClasses)
    
    softmaxLayer("Name","softmax")
    
    pixelClassificationLayer('Classes',classNames,'ClassWeights',classWeights)];









miniBatchSize = 10;

options = trainingOptions('sgdm', ...
     'ExecutionEnvironment', 'gpu',...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 10, ... 
    'InitialLearnRate', 0.01,...
    'Plots','training-progress');


warwicknet=trainNetwork(pximdsTrain,layers,options);%with adam and batches after relu

%% Supporting functions

