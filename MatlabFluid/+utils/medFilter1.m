function Out = medFilter1(In, WinSiz)
% The median filter is a nonlinear digital filtering technique, often used to 
% remove noise with Laplacian distrinution. The main idea of the median filter
% is to run through the signal entry by entry, replacing each entry with the 
% median of neighboring entries. The pattern of neighbors is called the "window", 
% which slides, entry by entry, over the entire signal.
% Example Usage
% t = 1:1/100:2;
% x1 = sin (2*pi*5*t);
% plot(t, x1); title ('Original Signal');
% x2 = x1;
% 
% x2 (1, 10) = 20; %corrupting the Signal with salt and pepper noise
% x2 (1, 27) = 15;
% x2 (1, 53) = 25;
% x2 (1, 67) = 15;
% x2 (1, 87) = 12;
% x2 (1, 95) = 7;
% 
% figure
% plot(t, x2); title ('Signal with Corrupted Noise');
% 
% y = medFilter (x2, 5); % Applying media filter
% figure;
% plot(t, y); title ('Filtered Signal');

In=In(:);

len1 = mod (WinSiz, 2);
if isequal (len1, 0)
    error ('Cannot use even number for WinSiz for this filter. Choose odd number for WinSiz');
end
Siz_In = length(In);
temp = zeros (1, WinSiz);
index = ceil (WinSiz / 2);
% Pad = zeros (1, WinSiz - 1);
% New_In = [In Pad];
for i = 1:(Siz_In - (WinSiz - 1))  
    for j = 1:WinSiz
        temp(1, j) = In((i + j - 1));
    end
    temp = sort (temp);
    Out(1, i) = temp (1, index);
end
for i = (Siz_In - (WinSiz - 2)):Siz_In
    Out(i) = In (i);
end
