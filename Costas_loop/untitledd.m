% Fs = 100e6; % Sampling Frequency
% 
% Fc = 200e3; % Cutoff Frequency
% 
% N = 100; % Filter Order
% 
% Wn = Fc / (Fs/2); % Normalized cutoff frequency
% 
% h = fir1(N, Wn);
% 
% scale_factor = 32768;
% 
% h_fixed = round(h * scale_factor);
% 
% filename = 'costas_fir_coef.coe';
% 
% fileID = fopen(filename, 'w');
% 
% fprintf(fileID, 'radix=10;\n');
% 
% fprintf(fileID, 'coefdata=\n');
% 
% for i = 1:length(h_fixed)
% 
% if i == length(h_fixed)
% 
% fprintf(fileID, '%d;\n', h_fixed(i));
% 
% else
% 
% fprintf(fileID, '%d,\n', h_fixed(i));
% 
% end
% 
% end
% 
% fclose(fileID);
% 
% disp(['Success! File saved as: ', filename]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 100e6;       % Sampling Frequency 
Fc = 200e3;        % Cutoff Frequency (200 kHz-ൽ നിന്നും 50 kHz ആക്കി കുറച്ചു)
N = 150;          % Filter Order (100-ൽ നിന്നും 150 ആക്കി)
Wn = Fc / (Fs/2); % Normalized cutoff frequency
h = fir1(N, Wn, blackman(N+1));        

scale_factor = 32768;                   
h_fixed = round(h * scale_factor);     
filename = 'costas_fir_coef.coe';
fileID = fopen(filename, 'w');
fprintf(fileID, 'radix=10;\n');
fprintf(fileID, 'coefdata=\n');
for i = 1:length(h_fixed)
    if i == length(h_fixed)
        fprintf(fileID, '%d;\n', h_fixed(i)); 
    else
        fprintf(fileID, '%d,\n', h_fixed(i)); 
    end
end
fclose(fileID);
disp(['Success! Better Filter File saved as: ', filename]);