
good = load('/Users/Benjamin/Documents/BIOIM/MRI/lab_bioimaging/imT1.mat');
good = good.imT1; 
t1 = [50,100,300,500,800,2000,4000,6000];
x = T1test(log(good),t1); 
imagesc(x); 
