﻿[y, fs] = audioread('Testing/Male/Zero3.wav');
plot(y);
f = abs(fft(y));
index_f = 1:length(f); % from 1 to number of samples in y
index_f = index_f ./ length (f); % index will be from 0:1/length (f):1 index f = index f * fs;
index_f = index_f * fs;
figure;
plot (index_f, f);