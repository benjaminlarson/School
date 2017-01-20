function [ Gain ] = findGain( entropy1, entropy2, totalE )
%find information gain given binary entropy
%this is based on a binary tree

%total entropy of system - entropy of reduced set 
Gain = totalE - (entropy1 + entropy2);
end

