clc,clear,close all

%%
reference=ones(21,21);
reference(:,1:11)=0;
%reference(1:2:21,1:2:21)=0;

pseudoPhase=rand(21,21)*2*pi;
figure(),imagesc(pseudoPhase),colorbar

itereationNumber=2;
phaseMap=zeros(21,21);

n=1;
for i=1:21
    for  j=1:21
        frequence(i,j)=round(2.68+(n-1)*(4.82-2.68)/440,3); %  the decimal point more than 3 cannot be resolved, Unit:Hz
        Ts=1/10;  % frame rate of SLM
        t=0:Ts:1000-Ts; % lowering than 1000 is unable to reslove phase correctly
        phase=2*pi*frequence(i,j)*t;
        SLMdisplay(i,j,:)=mod(phase,2*pi);
        n=n+1;
    end
end

for iteration=1:itereationNumber
    if iteration>1
        reference=~reference;
    end

for k=1:size(SLMdisplay,3)
    updatedSLM(:,:,k)= SLMdisplay(:,:,k).*reference-phaseMap;
    realPhase(:,:,k)=updatedSLM(:,:,k)+pseudoPhase;
    % if iteration==1
    % realPhase(:,:,k)=updatedSLM(:,:,k)+pseudoPhase.*reference;
    % else
    %     realPhase(:,:,k)=updatedSLM(:,:,k)+pseudoPhase;
    % end

    %spatialFFT(:,:,k)= abs(fftshift(fft2(Li(:,:,k)))).^2;
end
     updatedSLM=mod(updatedSLM+2*pi,2*pi);
    realPhase=mod(realPhase+2*pi,2*pi);
    Li =  exp(1i*realPhase);
% 

%figure(),imagesc3D(abs(Li))
%figure(),imagesc3D(spatialFFT)
% figure(),imagesc(phaseMap)
figure(),imagesc3D(updatedSLM),colorbar
 figure(),imagesc3D(realPhase),colorbar

%%
%signal=squeeze( spatialFFT(11,11,:));
signal=squeeze(abs(sum(Li,[1 2])).^2);
% figure(),plot(t,signal)
% xlabel('Time (seconds)')
% ylabel('Amplitude')

y=fft(signal);
y(1,1)=0;
z=fftshift(y);
Fs=1/Ts;
%f=(0:length(y)-1)*Fs/length(y);
 fshift=(-0.5*length(y):0.5*length(y)-1)/length(y)*Fs;
% figure(),plot(fshift,abs(z))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('shift FFT')
% axis([0 5 0 inf])

tol = max(abs(z))*0.1;
z(abs(z) < tol) = 0;
theta=angle(z);
% figure(),stem(fshift,theta/pi)
% xlabel("Frequency (Hz)")
% ylabel("Phase / \pi")
% grid
% axis([0 5 -inf inf])

for i=1:21
    for j=1:21
        phaseMap(i,j)= theta(frequence(i,j)/Fs*length(y)+length(y)/2+1)+phaseMap(i,j);
    end
end
phaseMap=mod(phaseMap+2*pi,2*pi);

%figure(),imagesc(phaseMap),colorbar
%figure(),imagesc(-phaseMap),colorbar
end


descrepancy=(pseudoPhase-phaseMap);
descrepancy=round(descrepancy,3);
descrepancy=mod(descrepancy,2*pi);
descrepancy=round(descrepancy,3);

figure(),imagesc(phaseMap),colorbar
figure(),imagesc(descrepancy),colorbar


%figure(),imagesc(/pi),colorbar
%figure(),imagesc((phaseMap+pi/2)/pi),colorbar
% figure(),imagesc(test),colorbar