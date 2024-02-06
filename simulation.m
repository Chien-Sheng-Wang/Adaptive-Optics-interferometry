clc,clear,close all

%%
 n=1;
for i=1:21
    for  j=1:21
        frequence=round(2.68+(n-1)*(4.82-2.68)/440,3); %  the decimal point more than 3 cannot be resolved, Unit:Hz 
        Ts=1/10;  % frame rate of SLM 
        t=0:Ts:1000-Ts; % lowering than 1000 is unable to reslove phase correctly
        x=cos(2*pi*frequence*t+pi/3);
        X(i,j,:)=x;
        n=n+1;
    end
end
figure(),imagesc3D(X)

%%
signal=squeeze(sum(X,[1 2]));
figure(),plot(t,signal)
xlabel('Time (seconds)')
ylabel('Amplitude')

y=fft(signal);
z=fftshift(y);
Fs=1/Ts;
f=(0:length(y)-1)*Fs/length(y);
fshift=(-0.5*length(y):0.5*length(y)-1)/length(y)*Fs;
%figure(),plot(fshift,abs(y))
figure(),plot(fshift,abs(z))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('shift FFT')
axis([2 5 0 inf])

tol = max(abs(z))*0.1;
z(abs(z) < tol) = 0;
theta=angle(z);
figure(),stem(fshift,theta/pi)
xlabel("Frequency (Hz)")
ylabel("Phase / \pi")
grid
axis([2 5 -inf inf])

