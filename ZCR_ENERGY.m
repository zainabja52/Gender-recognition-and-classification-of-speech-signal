%%all system without GUI

training_files_male = dir ('D:\AllMatlab\R2021a\bin\win64\New Folder\Training\Male\*.wav')
testing_files_male = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Testing\Male\*.wav')
training_files_female = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Training\Female\*.wav')
testing_files_female = dir('D:\AllMatlab\R2021a\bin\win64\New Folder\Testing\Female\*.wav')

% Read training data and extract features
male_features = zeros(length(training_files_male), 5);
female_features = zeros(length(training_files_female), 5);
% Read testing data and classify gender
correct_male = 0;
correct_female = 0;

for i = 1:length(training_files_male)
    % Read audio file
    file_path = fullfile(training_files_male(i).folder, training_files_male(i).name);
    [y, fs] = audioread(file_path);

    % Extract features
    male_features(i, :) = extractFeatures(y, fs);
end

for i = 1:length(training_files_female)
    % Read audio file
    file_path = fullfile(training_files_female(i).folder, training_files_female(i).name);
    [y, fs] = audioread(file_path);

    % Extract features
    female_features(i, :) = extractFeatures(y, fs);
end

for i = 1:length(testing_files_male)
    % Read audio file
    file_path = fullfile(testing_files_male(i).folder, testing_files_male(i).name);
    [y, fs] = audioread(file_path);

    % Extract features
    test_features = extractFeatures(y, fs);

    % Classify gender
    gender = classifyGender(test_features, mean(male_features), mean(female_features));

    % Display result
    fprintf('Test file [male] #%d classified as %s\n', i, gender);

    % Update correct count
    if strcmp(gender, 'male')
        correct_male = correct_male + 1;
    end
end

for i = 1:length(testing_files_female)
    % Read audio file
    file_path = fullfile(testing_files_female(i).folder, testing_files_female(i).name);
    [y, fs] = audioread(file_path);

    % Extract features
    test_features = extractFeatures(y, fs);

    % Classify gender
    gender = classifyGender(test_features, mean(male_features), mean(female_features));

    % Display result
    fprintf('Test file [female] #%d classified as %s\n', i, gender);

    % Update correct count
    if strcmp(gender, 'female')
        correct_female = correct_female + 1;
    end
end

% Calculate accuracy
accuracy_male = (correct_male / length(testing_files_male)) * 100;
accuracy_female = (correct_female / length(testing_files_female)) * 100;

fprintf('Accuracy Male = %0.2f%%\n', accuracy_male);
fprintf('Accuracy Female = %0.2f%%\n', accuracy_female);

% Function for feature extraction
function features = extractFeatures(signal, fs)
    % Divide the signal into 3 parts
    part1 = signal(1:floor(end/3));
    part2 = signal(floor(end/3):floor(end*2/3));
    part3 = signal(floor(end*2/3):end);

    % Calculate ZCR for each part
    ZCR = [mean(abs(diff(sign(part1))))./2, mean(abs(diff(sign(part2))))./2, mean(abs(diff(sign(part3))))./2];

    % Calculate energy
    energy = sum(signal.^2);

    % Calculate Power Spectral Density (PSD)
    [pxx, ~] = pwelch(signal, [], [], [], fs);
    psd = mean(pxx);

    features = [ZCR, energy, psd];
end

% Function for gender classification
function gender = classifyGender(test_features, male_features, female_features)
    % Use cosine distance for classification
    distance_male = pdist([test_features; male_features], 'cosine');
    distance_female = pdist([test_features; female_features], 'cosine');

    if distance_male < distance_female
        gender = 'male';
    else
        gender = 'female';
    end
end

