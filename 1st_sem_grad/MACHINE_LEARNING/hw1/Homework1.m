
clc; clear;
T = readtable('data.txt',...
    'Delimiter',' ','ReadVariableNames',false);
  % problem 1 
Purple =  -(6/10)*log2(6/10) -  (4/10)*log2(4/10);
Yellow =  -(6/10)*log2(6/10) -  (4/10)*log2(4/10);
Small =   -(6/10)*log2(6/10) -  (4/10)*log2(4/10);
Large =   -(6/10)*log2(6/10) -  (4/10)*log2(4/10);
Dip =     -(4/12)*log2(4/12) -  (8/12)*log2(8/12);
Stretch = -(8/8)*log2(8/8);% -  (0)*log2(0);
Adult =   -(8/8)*log2(8/8);% -  (0)*log2(0);
Child =   -(4/12)*log2(4/12) -  (8/12)*log2(8/12);

totalE = -(12/20)*log2(12/20) - (8/20)*log2(8/20);

%expected Entropy

eeColor = Purple *(1/2) + Yellow *(1/2);
igColor = totalE - eeColor;
eeSize  = Small*(1/2) + Large*(1/2); 
igSize  = totalE - eeSize; 
eeAction= Dip*(12/20) + Stretch*(8/20);
igAction= totalE - eeAction;
eeAge   = Adult + Child*(12/20);
igAge   = totalE - eeAge;

%entropy given 'dips' as the first decision
% gain = (H(dips), H(Expected of Attribute)) 
gain_dips_color = 0.9183 -...
    6/12*(-2/6*log2(2/6) - 4/6*log2(4/6))...
  + 6/12*(-2/6*log2(2/6) - 4/6*log2(4/6));
gain_dips_age = 0.9183 -...
    8/12*(0             - 8/8*log2(8/8))...
  + 4/12*(-4/4*log2(4/4)- 0);
gain_dips_size = 0.9183 - ...
    6/12*(-2/6*log2(2/6) - 4/6*log2(4/6))...
  + 6/12*(-2/6*log2(2/6) - 4/6*log2(4/6));
%% Prolem2
% %GIVEN THE FIRST TWELVE EXAMPLES
% T1 = T(1:12,:); 
% %AGE
% entropyAdult = -1*log2(5/5);
% entropyChild = -3/7*log2(3/7) - 4/7*log2(4/7);
% gainAge = 0.9183 - (5/12*0 + 7/12*0.9852);
% %ACTION
% entropyDip = -3/7*log2(3/7)-4/7*log2(4/7);
% entropyStretch = -1*log2(1);
% gainAction = 0.9183 - (7/12*0.9852 + 5/12*0);
% %COLOR
% entropyYellow = -6/9*log2(6/9) - 3/9*log2(6/9);
% entropyPurple = -1*log2(1);
% gainColor = 0.9183 - (9/12*0.585 + 3/12*0);
% %SIZE
% entropyLarge = -3/5*log2(3/5) - 2/5*log2(2/5);
% entropySmall = -5/7*log2(5/7) - 2/7*log2(2/7);
% gainSize = 0.9183 - (5/12*0.9710 + 7/12*0.8631);
% %No divide Total
% totalEntropy = -8/12*log2(8/12) - 4/12*log2(4/12);
% %split on color if purple, true
% sortrows(T1,2);
% T2 = T1(1:10,:);
% %AGE
% color_entropyAdult = -2/2*log2(2/2) - 0;
% color_entropyChild = -2/6*log2(2/6) - 4/6*log2(4/6);
% gain_c_entropyAge = 0.9710 - (0 + 8/10*0.9183); 
% %SIZE
% color_entropySmall = -3/5*log2(3/5) - 2/5*log2(2/5);
% color_entropyLarge = -3/5*log2(3/5) - 2/5*log2(2/5);
% gain_c_entropySize = 0.9710 - (5/10*0.9710 + 5/10*0.9710); 
% %ACTION
% color_entropyDip = -2/6*log2(2/6) - 4/6*log2(4/6);
% color_entropyStretch = -4/4*log2(4/4) - 0;
% gain_c_entropyAction = 0.9710 - (6/10*0.9183 + 4/10*0);
% 
% color_totalEntropy = -6/10*log2(6/10) - 4/10*log2(4/10);
% %split on action ->highest entropy
% Temp3 = sortrows(T2,4);
% T3 = Temp3(1:6,:);
% %AGE
% ca_entropyAdult = -2/2*log2(2/2) - 0;
% ca_entropyChild = -0 -4/4*log2(4/4);
% gain_ca_AGE = 0.9183 - (0+0*(4/4)); 
% %Size
% ca_entropyLarge = -1/3*log2(1/3) - 2/3*log2(2/3);
% ca_entropySmall = -1/3*log2(1/3) - 2/3*log2(2/3);
% gain_ca_SIZE = 0.9183 - ( 3/6*0.9183 + 3/6*0.9183);  
% ca_totalEntropy = -2/6*log2(2/6) - 4/6*log2(4/6);
% 
% %part 2
% x = [1,-1,2]; y = [1,-1,-2];
% scatter(x,y);
% w = 1/sqrt((1-4)^2+(1-0)^2) +...
% 	 	1/sqrt((1-4)^2+(-1-0)^2) +...
% 	 	1/sqrt((-1-4)^2+(-1-0)^2) +...
% 	 	1/sqrt((2-4)^2+(-2-0)^2);
