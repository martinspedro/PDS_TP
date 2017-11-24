clear all;
close all;
clc


%%
params.nBlocks=16;

params.Width=800;
params.Width8=params.Width/8;


% cand = randi([0 20],params.Width8);
cand=spiral(params.Width8);
cand2=(cand >16);

selected= select_spiral(cand2, params);

figure
surf(1:params.Width8,1:params.Width8,cand(:,:)*1)
cand2=uint32(cand2);
figure
surf(1:params.Width8,1:params.Width8,cand2(:,:))


for i=1: size(selected,1)
   cand2(selected(i,1), selected(i,2)) = 5;
end

figure
surf(1:params.Width8,1:params.Width8,cand2(:,:)*1)

