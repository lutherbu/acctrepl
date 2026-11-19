clear
clc

load('FRQSim_FINAL_PART2_GAUSS.mat')
% Only keep the OLS estimators with fixed effects at firm, year level
clearvars -except b  

kx=9;
nSim=1000;
kse = -4:1:4;
indSize = kse == 0;
nse = numel(kse);

s = std(b); % To obtain the standard error of the OLS estimator of ?0,FRQ from the model using only firm and time fixed effects obtained from the simulation

% which variable do you want? (FRQ*VALUE is number 4)
Vk=1;

load('SizePt3_1000X2000_bsize3_17Obs_sim_1000.mat')

Pow_F_StxY=zeros(kx,nse);
Pow_F_S1xY=zeros(kx,nse);

for jj = 1:nse

balt = bTest3' + kse(jj)*s;
Pow_F_StxY(:,jj)    = mean(abs(bFMSxT-ones(nSim,1)*balt)./se_state > bcv_state);
Pow_F_S1xY(:,jj)    = mean(abs(bFsc1xT-ones(nSim,1)*balt)./se_sic1 > bcv_sic1);
end


load('SizePt4_1000X2000_bsize3_17Obs_sim_1000.mat')
% Rows are variables and columns k's
Pow_t2xF_Y=zeros(kx,nse);
Pow_t4xF_Y=zeros(kx,nse);
Pow_t6xF_Y=zeros(kx,nse);
Pow_t8xF_Y=zeros(kx,nse);

for jj = 1:nse

balt = bTest3' + kse(jj)*s;
        
Pow_t2xF_Y(:,jj)    = mean(abs(bFt2xT-ones(nSim,1)*balt)./se_t2xT > bcv_t2xT);
Pow_t4xF_Y(:,jj)    = mean(abs(bFt4xT-ones(nSim,1)*balt)./se_t4xT > bcv_t4xT);
Pow_t6xF_Y(:,jj)    = mean(abs(bFt6xT-ones(nSim,1)*balt)./se_t6xT > bcv_t6xT);
Pow_t8xF_Y(:,jj)    = mean(abs(bFt8xT-ones(nSim,1)*balt)./se_t8xT > bcv_t8xT);

end

load('SizePt2_1000X2000_bsize3_17Obs_sim_1000.mat')
Pow_t8_FY=zeros(kx,nse);

for jj = 1:nse

balt = bTest3' + kse(jj)*s;
        
Pow_t8_FY(:,jj)    = mean(abs(b-ones(nSim,1)*balt)./se_t8 > bcv_t8);

end

% which variable do you want?
disp('\\')
 disp('& &  \multicolumn{9}{C{9cm}}{Moving Blocks Bootstrap} \\\cline{3-11}')
disp('\\')

Specs=cell(5,1);
Specs{1,1} ='8 year time block & firm, year                     ';
Specs{2,1} ='8 year time block & firm x 8 year time block, year ';
Specs{3,1} ='6 year time block & firm x 6 year time block, year ';
Specs{4,1} ='4 year time block & firm x 4 year time block, year ';
Specs{5,1} ='2 year time block & firm x 2 year time block, year ';

fmtbeta=strcat('%s ', repmat(' & %s',1,9),'   \\\\ \n');



