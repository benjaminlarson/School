clc;
clear;
filename = '/Users/Benjamin/Documents/MACHINE_LEARNING/hw1/badges-train.txt';
delimiter = ' ';

%% Format string for each line of text:
%   column1: text (%s)
%	column2: text (%s)
%   column3: text (%s)
%	column4: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
data = table(dataArray{1:end-1}, 'VariableNames', {'label','name','name2','name3'});
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

%create attributes 
Attributes(1:size(data,1),1:4) = 0;
%more vowels than consanants?
for i = 1:size(data,1) 
  NumVowels = 0;
  x = data.name(i); 
  NumVowels = length(regexpi(x{1},'a|e|i|o|u'));
  x = data.name2(i);
  NumVowels = NumVowels + length(regexpi(x{1},'a|e|i|o|u'));
  x = data.name3(i);
  NumVowels = NumVowels + length(regexpi(x{1},'a|e|i|o|u'));
  total = length(data.name{i})+length(data.name2{i})+length(data.name3{i}); 
  if(NumVowels < (total-NumVowels))
    Attributes(i,1) = false; 
  else 
    Attributes(i,1) = true;
  end
end

%Total number of characters in name odd? 
for i = 1:size(data,1)
  total = length(data.name{i})+length(data.name2{i})+length(data.name3{i});
  if(mod(total,2) == 1)
    Attributes(i,2) = false; 
  else 
    Attributes(i,2) = true;
  end
end

% Number of vowels in name odd? 
for i = 1:size(data,1) 
  NumVowels = 0;
  x = data.name(i); 
  NumVowels = length(regexpi(x{1},'a|e|i|o|u'));
  x = data.name2(i);
  NumVowels = NumVowels + length(regexpi(x{1},'a|e|i|o|u'));
  x = data.name3(i);
  NumVowels = NumVowels + length(regexpi(x{1},'a|e|i|o|u')); 
  if(mod(NumVowels,2) == 1 )
    Attributes(i,3) = false; 
  else 
    Attributes(i,3) = true;
  end
end

% number of vowels in first 2 letters of name greater than consonants? 
for i = 1:size(data,1) 
  NumVowels = 0;
  x = data.name(i); 
  NumVowels = length(regexpi(x{1}(1:2),'a|e|i|o|u'));
  x = data.name2(i);
  NumVowels = NumVowels + length(regexpi(x{1}(1:2),'a|e|i|o|u'));
  x = data.name3(i);
  if(~strcmp(x{1},''))
    NumVowels = NumVowels + length(regexpi(x{1}(1:2),'a|e|i|o|u'));
  end
  total = length(data.name{i}(1:2))+length(data.name2{i}(1:2));
  if(~strcmp(data.name3{i},''))
    total = total + length(data.name3{i}(1:2)); 
  end
  if(NumVowels < (total-NumVowels))
    Attributes(i,4) = false; 
  else 
    Attributes(i,4) = true;
  end
end



