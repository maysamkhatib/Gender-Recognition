clear all
close all
clc

% Read a random audio file from the PathName with format .wav
PathName = 'C:\Users\HP\OneDrive\Documents\121-2\DSP\Project'; 
List  = dir(fullfile(PathName, '*.wav'));
Index = randi(length(List), 1);
File  = fullfile(PathName, List(Index).name);
[audio,fs]= audioread(File);
fileInfo = audioinfo(File);

% Play the audio
sound(audio, fs);

% plot the audio
t = 0:seconds(1/fs):seconds(fileInfo.Duration);
t = t(1:end-1);
figure
plot(t, audio, 'r')
title('Audio Signal Plot')
% xlim(seconds([0 0.02]))
ylabel('Amplitude');
xlabel('Time');

% Calculate the autocorrelation using xcorr() function and plot it
twomsec = fs/500; % 2 msec frame = the maximum speach at 500 Hz 
shortFrame = fs/50; % 20 msec short frame = the maximum speach at 50 Hz 
correlationResult = xcorr(audio, shortFrame, 'normalized');
% determine the period of the plot to be the same as the correlation result
t2 = (-shortFrame:shortFrame)/fs;
figure
plot(t2, correlationResult,'k');
title('The Autocorrelation Plot');
xlabel('Delay (sec)');
ylabel('Correlation Coefficient');

% take the positive area of the correlation result
correlationResult = correlationResult(shortFrame + 1 : (2*shortFrame) + 1);
[correlationResultMax, tx] = max(correlationResult(twomsec:shortFrame));

% find the speaker voice frequency
voiceFreq = fs/(twomsec+tx-1);

% Determine the gender based on the speaker voice's frequency
if (voiceFreq >= 165) && (voiceFreq <= 255)
    disp('The Gender is: Female, with frequency:')
elseif (voiceFreq >= 85) && (voiceFreq <= 155 )
    disp('The Gender is: Male, with frequency:')
elseif (voiceFreq >= 255) && (voiceFreq <= 400)
    disp('The Gender Cannot be Recognized because the speaker is a child with frequency:')
else
    disp('The Gender Cannot be Recognized! The frequency is:')
end
disp(voiceFreq)
disp('First Max Peak:')
disp(correlationResultMax)