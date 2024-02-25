%%all system with GUI


function niceGUI
       % Create a figure and axes
    f = figure('Visible','off', 'Color', [0.96 0.96 0.86]);
    ax = axes('Units','normalized', 'Position', [0.1 0.3 0.8 0.6]);

    % Create push buttons with increased width and height
    btn1 = uicontrol('Style', 'pushbutton', 'String', 'Record',...
        'Units', 'normalized', 'Position', [0.1 0.05 0.1 0.1],...
        'Callback', @recordCallback, 'BackgroundColor', [1 0 1],...
        'ForegroundColor', 'white' , 'FontName', 'Arial', 'FontSize', 10);

    btn2 = uicontrol('Style', 'pushbutton', 'String', 'Display Time Domain',...
        'Units', 'normalized', 'Position', [0.2 0.05 0.1 0.1],...
        'Callback', @timeDomainCallback, 'BackgroundColor', [1 0 1],...
        'ForegroundColor', 'white','FontName', 'Arial', 'FontSize', 10);

    btn3 = uicontrol('Style', 'pushbutton', 'String', 'Display Frequency Domain',...
        'Units', 'normalized', 'Position', [0.3 0.05 0.1 0.1],...
        'Callback', @freqDomainCallback, 'BackgroundColor', [1 0 1],...
        'ForegroundColor', 'white','FontName', 'Arial', 'FontSize', 10);

    btn4 = uicontrol('Style', 'pushbutton', 'String', 'Calculate ZCR',...
        'Units', 'normalized', 'Position', [0.4 0.05 0.1 0.1],...
        'Callback', @zcrCallback, 'BackgroundColor', [1 0 1],...
        'ForegroundColor', 'white','FontName', 'Arial', 'FontSize', 10);

    btn5 = uicontrol('Style', 'pushbutton', 'String', 'Display Accuracy',...
        'Units', 'normalized', 'Position', [0.5 0.05 0.1 0.1],...
        'Callback', @accuracyCallback, 'BackgroundColor', [1 0 1],...
        'ForegroundColor', 'white','FontName', 'Arial', 'FontSize', 10);
    % Move the GUI to the center of the screen
    movegui(f,'center')

    % Make the GUI visible
    f.Visible = 'on';

    % Function for feature extraction
    function features = extractAudioFeatures(signal, fs)
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

    % Callback functions
    function recordCallback(~,~)
        % Set the duration of the recording in seconds
        duration = 5;
        recObj = audiorecorder;
        disp('Recording started.');
        % Record audio for the specified duration
        recordblocking(recObj, duration);
        disp('Recording ended.');
        y = getaudiodata(recObj);
        % Save the audio data in the workspace
        assignin('base', 'recordedAudio', y);

        % Extract features
        test_features = extractAudioFeatures(y, 44100);

        % Get the male and female features from the workspace
        male_features = evalin('base', 'male_features');
        female_features = evalin('base', 'female_features');

        % Classify gender
        gender = classifyGender(test_features, mean(male_features), mean(female_features));

        % Display result below the axis
        text(0.5, -0.1, ['Gender: ', gender], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 10, 'Color', [1 0 1]);
    end 

    function timeDomainCallback(~,~)
        % Get the recorded audio data from the workspace
        y = evalin('base', 'recordedAudio');
        % Create a time vector based on the length of the audio
        t = (1:length(y))/44100;
        % Plot the audio data in the time domain
        plot(t, y);
        title('Time Domain Representation');
        xlabel('Time (s)');
        ylabel('Amplitude');
    end

    function freqDomainCallback(~,~)
        % Get the recorded audio data from the workspace
        y = evalin('base', 'recordedAudio');
        % Compute the Fourier transform of the audio signal
        Y = fft(y);
        % Compute the two-sided spectrum
        P2 = abs(Y/length(y));
        % Compute the single-sided spectrum
        P1 = P2(1:length(y)/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        % Define the frequency domain f
        f = 44100*(0:(length(y)/2))/length(y);
        % Plot the single-sided amplitude spectrum
        plot(f,P1);
        title('Frequency Domain Representation');
        xlabel('Frequency (Hz)');
        ylabel('|P1(f)|');
    end

    function zcrCallback(~,~)
        % Get the recorded audio data from the workspace
        y = evalin('base', 'recordedAudio');
        % Calculate the zero-crossing rate
        zcr = sum(abs(diff(y > 0))) / length(y);
        % Display the zero-crossing rate
        disp(['Zero-Crossing Rate: ', num2str(zcr)]);
    end

    function accuracyCallback(~,~)
        % Get the accuracy values from the workspace
        accuracy_male = evalin('base', 'accuracy_male');
        accuracy_female = evalin('base', 'accuracy_female');
        % Display the accuracy values
        disp(['Accuracy Male: ', num2str(accuracy_male), '%']);
        disp(['Accuracy Female: ', num2str(accuracy_female), '%']);
    end

end
