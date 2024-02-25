
%%TIME DOMAIM%%
%%ZAINAB JARADAT%%
%%1201766%%

training_files_male = dir ('D:\AllMatlab\R2021a\bin\win64\New Folder\Training\Male\*.wav')
testing_files_male = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Testing\Male\*.wav')
training_files_female = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Training\Female\*.wav')
testing_files_female = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Testing\Female\*.wav')
% """""""""" Training """""""""

% read the 'male' training files and calculate the energy of them.
data_male = [];
for i = 1:length(training_files_male)
    file_path = strcat(training_files_male(i).folder, '\', training_files_male(i).name);
    [y, fs] = audioread(file_path); % read the audio file
    energy_male = sum(y.^2); % calculate the energy
    data_male = [data_male energy_male]; % append the energy with all other energies
end

energy_male = mean(data_male); % calculate the average energy
fprintf('The energy of male is \n');
disp(energy_male);

% read the 'female' training files and calculate the energy of them.
data_female = [];
for i = 1:length(training_files_female)
    file_path = strcat(training_files_female(i).folder, '\', training_files_female(i).name);
    [y, fs] = audioread(file_path); % read the audio file
    energy_female = sum(y.^2); % calculate the energy
    data_female = [data_female energy_female]; % append the energy with all other energies
end

energy_female = mean(data_female); % calculate the average energy
fprintf('The energy of female is \n');
disp(energy_female);


% read the 'male' tesing files and calculate the energy of them.
for i = 1:length(testing_files_male)
file_path=strcat (training_files_male(i).folder, '\', training_files_male(i).name); 
[y,fs] = audioread (file_path); % read the audio file

male_energy=sum (y.^2); % test if the energy of this file is closer to male or female average energies
    if (abs (male_energy-energy_male) < abs (male_energy-energy_female))
        fprintf('Test file [Male] #%d classified as Male, E=%d\n',i,male_energy);
    else
        fprintf('Test file [Male] #%d classified as Female E=%d\n',i,male_energy);
    end
end

% read the 'female' testing files and calculate the energy of them.
for i = 1:length(testing_files_female)
    file_path = strcat(testing_files_female(i).folder, '\', testing_files_female(i).name); 
    [y, fs] = audioread(file_path); % read the audio file

    male_energy = sum(y.^2); % calculate the energy

    % Test if the energy of this file is closer to male or female average energies
    if (abs(male_energy - energy_male) < abs(male_energy - energy_female))
        fprintf('Test file [Female] #%d classified as Male, E=%d\n', i, male_energy);
    else
        fprintf('Test file [Female] #%d classified as Female E=%d\n', i, male_energy);
    end
end

