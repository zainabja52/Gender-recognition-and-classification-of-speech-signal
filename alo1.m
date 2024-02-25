
recObj = audiorecorder (44100, 24, 1); % record at Fs=44khz, 24 bits per sample 
fprintf('Start speaking\n');
for i=1:10
recordblocking (recObj, 2); % record 2 seconds
fprintf('Audio ended\n');

y = getaudiodata (recObj);
y = y - mean (y);
file_name=sprintf('Testing/Male/Zero%d.wav', i);
audiowrite (file_name, y, recObj. SampleRate);

figure
plot (y);
end