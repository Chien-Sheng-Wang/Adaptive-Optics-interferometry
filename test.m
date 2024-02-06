clc,clear,close all

Ts=1/150;  % frame rate of SLM
t=0:Ts:1000-Ts;
n=1;
for i=1:21
    for  j=1:21
        frequence=round(2.68+(n-1)*(4.82-2.68)/440,3); % Unit:Hz
        %  frequence=round(20+(n-1)*(480-20)/440,4); % Unit:Hz
        x=cos(2*pi*frequence*t- pi/4);
        X(i,j,:)=x;
        n=n+1;
    end
end
%figure(),imagesc3D(X)

% n=3;
% frequence=round(2.68+(n-1)*(4.82-2.68)/440,3); % Unit:Hz
% Ts=1/1500;  % frame rate of SLM
% t=0:Ts:1000-Ts;
% x=cos(2*pi*frequence*t- pi/4);


%%
signal=squeeze(sum(X,[1 2]));
figure(),plot(t,signal)
xlabel('Time (seconds)')
ylabel('Amplitude')


y=fft(signal);
z=fftshift(y);
Fs=1/Ts;
f=(0:length(y)-1)*Fs/length(y);
fshift=(-0.5*length(y):0.5*length(y)-1)*Fs/length(y);
figure(),plot(fshift,abs(z),"LineWidth",3)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('shift FFT')
axis([2 5 0 inf])

tol = max(abs(z))*0.3;
z(abs(z) < tol) = 0;

theta=angle(z);
figure(),stem(fshift,theta/pi)
xlabel("Frequency (Hz)")
ylabel("Phase / \pi")
grid
axis([2 5 -inf inf])


% y = fft(x);
% z = fftshift(y);
% Fs=1/Ts;
% ly = length(y);
% f = (-ly/2:ly/2-1)/ly*Fs;
% figure()
% stem(f,abs(z))
% title("Double-Sided Amplitude Spectrum of x(t)")
% xlabel("Frequency (Hz)")
% ylabel("|y|")
% grid
% axis([0 10 0 inf])
%
% tol = 1e-6;
% z(abs(z) < tol) = 0;
%
% theta = angle(z);
% figure()
% stem(f,theta/pi)
% title("Phase Spectrum of x(t)")
% xlabel("Frequency (Hz)")
% ylabel("Phase/\pi")
% grid
% axis([0 10 -inf inf])
