function [ H ] = hausdorffDist2(a,b)
% This function computes the hausdorff distance between the two vectors
% Coded by Hemanth Manjunatha on Apr 3, 2016
% Note: The hausdorff distance is not symmetrical 
D = pdist2(a,b);
hab = max(min(D,[],2));% Directed from a to b
hba = max(min(D));% Directed from b to a
H = max([hab,hba]);
end