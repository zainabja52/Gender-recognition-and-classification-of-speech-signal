
%%SPECTRAL DOMAIM%%
%%ZAINAB JARADAT%%
%%1201766%%

training_files_male = dir ('D:\AllMatlab\R2021a\bin\win64\New Folder\Training\Male\*.wav')
testing_files_male = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Testing\Male\*.wav')
training_files_female = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Training\Female\*.wav')
testing_files_female = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Testing\Female\*.wav')

%%%%% Training Male %%%%%
data_male=[];
for i=1:length(training_files_male)
file_path = strcat (training_files_male(i). folder, '\',training_files_male(i).name);

[y, fs] = audioread(file_path);

ZCR_male1 = mean (abs(diff(sign(y(1:floor(end/3))))))./2;
ZCR_male2= mean (abs(diff(sign(y(floor(end/3): floor (end*2/3))))))./2; 
ZCR_male3 = mean (abs(diff(sign(y(floor(end*2/3): end)))))./2;

energy = sum (y.^2);
ZCR_male=[ZCR_male1 ZCR_male2 ZCR_male3 energy];
data_male = [data_male ;ZCR_male];
end

ZCR_male=mean(data_male);
fprintf('The ZCR of MALE is \n');
disp(ZCR_male);

%%%%%% Training Female %%%%%
data_female=[];
for i=1:length(training_files_female)
file_path = strcat (training_files_female(i). folder, '\',training_files_female(i).name);

[y, fs] = audioread(file_path);

ZCR_female1 = mean(abs(diff(sign(y(1:floor(end/3))))))./2;
ZCR_female2= mean(abs(diff(sign(y(floor(end/3): floor (end*2/3))))))./2; 
ZCR_female3 = mean(abs(diff(sign(y(floor(end*2/3): end)))))./2;

energy = sum (y.^2);
ZCR_female=[ZCR_female1 ZCR_female2 ZCR_female3 energy];
data_female = [data_female ;ZCR_female];
end

ZCR_female=mean(data_female);
fprintf('The ZCR of female is \n');
disp(ZCR_female);


%%%%% Testing Male %%%%%%
for i=1:length(testing_files_male)
file_path = strcat(testing_files_male(i). folder, '\',testing_files_male(i).name);

[y, fs] = audioread(file_path);
ZCR_male1 = mean(abs(diff(sign(y(1:floor(end/3))))))./2;
ZCR_male2= mean(abs(diff(sign(y(floor(end/3): floor (end*2/3))))))./2; 
ZCR_male3 = mean(abs(diff(sign(y(floor(end*2/3): end)))))./2;

ZCR_male=[ZCR_male1 ZCR_male2 ZCR_male3];

%append the ZCR for the 3 parts as a row vector 
y_ZCR = [ZCR_male1 ZCR_male2 ZCR_male3];
if (pdist([y_ZCR; ZCR_male],'euclidean') < pdist ([y_ZCR; ZCR_female],'euclidean'))
	fprintf('Test file [male] #%d classified as male \n',i);
else
	fprintf('Test file [male] #%d classified as female \n',i);
end
end


%%%%% Testing Female %%%%%%
for i=1:length(testing_files_female)
file_path = strcat(testing_files_female(i). folder, '\',testing_files_female(i).name);

[y, fs] = audioread(file_path);
ZCR_female1 = mean(abs(diff(sign(y(1:floor(end/3))))))./2;
ZCR_female2= msean(abs(diff(sign(y(floor(end/3): floor (end*2/3))))))./2; 
ZCR_female3 = mean(abs(diff(sign(y(floor(end*2/3): end)))))./2;

ZCR_female=[ZCR_female1 ZCR_female2 ZCR_female3];

%append the ZCR for the 3 parts as a row vector 
y_ZCR = [ZCR_female1 ZCR_female2 ZCR_female3];
if (pdist([y_ZCR; ZCR_female],'euclidean') < pdist ([y_ZCR; ZCR_female],'euclidean'))
	fprintf('Test file [female] #%d classified as male \n',i);
else
	fprintf('Test file [female] #%d classified as female \n',i);
end

end

