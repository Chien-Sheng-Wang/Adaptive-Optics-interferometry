clc,clear,close all

%%
n=1;
reference=rand(21,21);
reference(reference<0.5)=0;
reference(reference>0.5)=1;

pseudoPhase=rand(21,21)*pi;
figure(),imagesc(pseudoPhase),colorbar

for i=1:21
    for  j=1:21
        frequence(i,j)=round(2.68+(n-1)*(4.82-2.68)/440,3); %  the decimal point more than 3 cannot be resolved, Unit:Hz
        Ts=1/10;  % frame rate of SLM
        t=0:Ts:1000-Ts; % lowering than 1000 is unable to reslove phase correctly
        % x=cos(2*pi*frequence*t+pi/3);
        x=pi*cos(frequence(i,j)*t+pi/3*n);
        X(i,j,:)=x;
        n=n+1;
    end
end
for m=1:size(X,3)
    X(:,:,m)= (X(:,:,m)+pseudoPhase).*reference;
end
for m=1:size(X,3)
    Li =  exp(1i*X(:,:,m));
    Y(:,:,m)= abs(fftshift(fft2(Li))).^2;
end
for m=1:size(Y,3)
    Z(:,:,m)= abs(fftshift(fft2(Y(:,:,m))));
end

figure(),imagesc3D(X),colorbar
%figure(),imagesc3D(Y)
figure(),imagesc3D(Z)

%%
signal=squeeze(sum(Z,[1 2]));
%signal=squeeze(Z(11,11,:));
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
axis([0 5 0 inf])

tol = max(abs(z))*0.1;
z(abs(z) < tol) = 0;
theta=angle(z);
figure(),stem(fshift,theta/pi)
xlabel("Frequency (Hz)")
ylabel("Phase / \pi")
grid
axis([0 5 -inf inf])

for i=1:21
    for j=1:21
        phaseMap(i,j)= theta(round(frequence(i,j)*1000,3)+5000)/pi;
    end
end
figure(),imagesc(phaseMap),colorbar