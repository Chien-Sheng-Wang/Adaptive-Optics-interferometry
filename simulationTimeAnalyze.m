clc,clear,close all

%%
% reference=rand(21,21);
% reference(reference<0.5)=0;
% reference(reference>0.5)=1;
% 
% pseudoPhase=rand(21,21)*pi;
% figure(),imagesc(pseudoPhase),colorbar
% 
% n=1;
% for i=1:21
%     for  j=1:21
%         frequence(i,j)=round(2.68+(n-1)*(4.82-2.68)/440,3); %  the decimal point more than 3 cannot be resolved, Unit:Hz
%         Ts=1/10;  % frame rate of SLM
%         t=0:Ts:1000-Ts; % lowering than 1000 is unable to reslove phase correctly
%         % x=cos(2*pi*frequence*t+pi/3);
%         phase=2*pi*frequence(i,j)*t;
%         SLMdisplay(i,j,:)=phase;
%         n=n+1;
%     end
% end
% for k=1:size(SLMdisplay,3)
%     SLMdisplay(:,:,k)= (SLMdisplay(:,:,k)+pseudoPhase).*reference;
%     Li(:,:,k) =  exp(1i*SLMdisplay(:,:,k));
%      % Y(:,:,k)= abs(fftshift(fft2(Li(:,:,k)))).^2;
%      %  Z(:,:,k)= abs(fftshift(fft2(Y(:,:,k))));
% end
% 
% 
% 
% figure(),imagesc3D(SLMdisplay),colorbar
% %figure(),imagesc3D(abs(Li))
% 
% %figure(),imagesc3D(Y)
% %figure(),imagesc3D(Z)
% 
% %%
% %signal=squeeze(sum(Z,[1 2]));
% %signal=squeeze(Z(11,11,:));
% signal=squeeze(abs(sum(Li,[1 2])).^2);
% figure(),plot(t,signal)
% xlabel('Time (seconds)')
% ylabel('Amplitude')


% y=fft(signal);
% y(1,1)=0;
% z=fftshift(y);
% Fs=1/Ts;
% f=(0:length(y)-1)*Fs/length(y);
% fshift=(-0.5*length(y):0.5*length(y)-1)/length(y)*Fs;
% %figure(),plot(fshift,abs(y))
% figure(),plot(fshift,abs(z))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('shift FFT')
% axis([0 5 0 inf])
% 
% tol = max(abs(z))*0.1;
% z(abs(z) < tol) = 0;
% theta=angle(z);
% figure(),stem(fshift,theta/pi)
% xlabel("Frequency (Hz)")
% ylabel("Phase / \pi")
% grid
% axis([0 5 -inf inf])
% 
% for i=1:21
%     for j=1:21
%         phaseMap(i,j)= theta(frequence(i,j)*1000+5000+1);
%     end
% end
% figure(),imagesc(phaseMap),colorbar

reference = rand(21,21);
reference(reference<0.5) = 0;
reference(reference>=0.5) = 1;

pseudoPhase = rand(21,21)*2*pi;
%pseudoPhase = zeros(21,21);
figure(), imagesc(pseudoPhase), colorbar

n = 1;
for i = 1:21
    for j = 1:21
        frequency(i,j) = round(2.68 + (n-1)*(4.82-2.68)/440, 3); %  the decimal point more than 3 cannot be resolved, Unit:Hz
        Ts = 1/10;  % frame rate of SLM
        t = 0:Ts:1000-Ts; % lowering than 1000 is unable to resolve phase correctly
        % x = cos(2*pi*frequency*t + pi/3);
        phase = 2*pi*frequency(i,j)*t;
        SLMdisplay(i,j,:) = phase;
        n = n + 1;
    end
end

for k = 1:size(SLMdisplay,3)
    SLMdisplay(:,:,k)=SLMdisplay(:,:,k).*reference;
    realPhase(:,:,k) = SLMdisplay(:,:,k) +pseudoPhase;
    Li(:,:,k) =  exp(1i*realPhase(:,:,k));
end

figure(), imagesc3D(mod(SLMdisplay,2*pi)), colorbar
figure(), imagesc3D(mod(realPhase,2*pi)), colorbar

signal = squeeze(abs(sum(Li,[1 2])).^2);
[maxSignal, maxIndex] = max(signal);


figure(), plot(t,signal)
xlabel('Time (seconds)')
ylabel('Amplitude')

figure(),imagesc(mod(SLMdisplay(:,:,maxIndex),2*pi)),colorbar
figure(),imagesc(mod(realPhase(:,:,maxIndex),2*pi)),colorbar