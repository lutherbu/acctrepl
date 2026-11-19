% Final set of simulation results for JAR review - Tabulate size and power 
% for all the estimators calculated in FRQSim_FinalTWFirmXYear.m
clear;

% Load results
load FRQSim_FINAL_FIRMTIME ;

% Size 
sizefirmtime = mean(abs(b - ones(nSim,1)*bTest3')./sefirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1));
sizeSxTfirmtime = mean(abs(bSxT - ones(nSim,1)*bTest3')./seSxTfirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1));
sizeSIC1xTfirmtime = mean(abs(bSIC1xT - ones(nSim,1)*bTest3')./seSIC1xTfirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1)); 
sizeSIC2xTfirmtime = mean(abs(bSIC2xT - ones(nSim,1)*bTest3')./seSIC2xTfirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1)); 

SIZEFirmXYear = [sizefirmtime ; sizeSxTfirmtime ; ...
    sizeSIC1xTfirmtime ; sizeSIC2xTfirmtime];


% Percentiles for size adjustment of all estimators
cvfirmtime = prctile(abs(b - ones(nSim,1)*bTest3')./sefirmtime,95);
cvSxTfirmtime = prctile(abs(bSxT - ones(nSim,1)*bTest3')./seSxTfirmtime,95);
cvSIC1xTfirmtime = prctile(abs(bSIC1xT - ones(nSim,1)*bTest3')./seSIC1xTfirmtime,95); 
cvSIC2xTfirmtime = prctile(abs(bSIC2xT - ones(nSim,1)*bTest3')./seSIC2xTfirmtime,95); 

% Look at power against alternatives measured in number of true OLS standard
% errors from true coefficient value

kse = -4:.1:4;
indSize = kse == 0;
nse = numel(kse);

s = std(b);

pfirmtime = zeros(nse,kx);  
pSxTfirmtime = zeros(nse,kx);  
pSIC1xTfirmtime = zeros(nse,kx);  
pSIC2xTfirmtime = zeros(nse,kx);  

sapfirmtime = zeros(nse,kx);  
sapSxTfirmtime = zeros(nse,kx);  
sapSIC1xTfirmtime = zeros(nse,kx);  
sapSIC2xTfirmtime = zeros(nse,kx);  

for jj = 1:nse
    balt = bTest3' + kse(jj)*s;
    
    pfirmtime(jj,:) = mean(abs(b - ones(nSim,1)*balt)./sefirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1));
    pSxTfirmtime(jj,:) = mean(abs(bSxT - ones(nSim,1)*balt)./seSxTfirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1));
    pSIC1xTfirmtime(jj,:) = mean(abs(bSIC1xT - ones(nSim,1)*balt)./seSIC1xTfirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1));
    pSIC2xTfirmtime(jj,:) = mean(abs(bSIC2xT - ones(nSim,1)*balt)./seSIC2xTfirmtime > tinv(.975,min(max(t_ind),max(f_ind))-1));

    sapfirmtime(jj,:) = mean(abs(b - ones(nSim,1)*balt)./sefirmtime > ones(nSim,1)*cvfirmtime);
    sapSxTfirmtime(jj,:) = mean(abs(bSxT - ones(nSim,1)*balt)./seSxTfirmtime > ones(nSim,1)*cvSxTfirmtime);
    sapSIC1xTfirmtime(jj,:) = mean(abs(bSIC1xT - ones(nSim,1)*balt)./seSIC1xTfirmtime > ones(nSim,1)*cvSIC1xTfirmtime);
    sapSIC2xTfirmtime(jj,:) = mean(abs(bSIC2xT - ones(nSim,1)*balt)./seSIC2xTfirmtime > ones(nSim,1)*cvSIC2xTfirmtime);
end

save FRQSim_FINAL_FIRMTIME2 ;
