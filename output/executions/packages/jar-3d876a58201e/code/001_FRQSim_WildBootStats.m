% Final set of simulation results for JAR review - Tabulate size for tests
% using bootstrap critical values calculated in FRQSim_FinalBoot

% Load results
load FRQSim_FINAL_BOOT ;

% Size 
bootsizefirm = mean(abs(b - ones(nSim,1)*bTest3')./sefirm > cvfirm);  
bootsizestate = mean(abs(b - ones(nSim,1)*bTest3')./sestate > cvstate);
bootsizesic1 = mean(abs(b - ones(nSim,1)*bTest3')./sesic1 > cvsic1); 
bootsizesic2 = mean(abs(b - ones(nSim,1)*bTest3')./sesic2 > cvsic2);  
bootsizesize = mean(abs(b - ones(nSim,1)*bTest3')./sesize > cvsize);
bootsizeT8 = mean(abs(b - ones(nSim,1)*bTest3')./seT8 > cvT8); 
bootsizeT6 = mean(abs(b - ones(nSim,1)*bTest3')./seT6 > cvT6); 
bootsizeT4 = mean(abs(b - ones(nSim,1)*bTest3')./seT4 > cvT4); 
bootsizeT2 = mean(abs(b - ones(nSim,1)*bTest3')./seT2 > cvT2); 
bootsizeSxTstate = mean(abs(bSxT - ones(nSim,1)*bTest3')./seSxTstate > cvSxTstate);  
bootsizeSIC1xTsic1 = mean(abs(bSIC1xT - ones(nSim,1)*bTest3')./seSIC1xTsic1 > cvSIC1xTsic1);  
bootsizeSIC2xTsic1 = mean(abs(bSIC2xT - ones(nSim,1)*bTest3')./seSIC2xTsic1 > cvSIC2xTsic1);  
bootsizeSIC2xTsic2 = mean(abs(bSIC2xT - ones(nSim,1)*bTest3')./seSIC2xTsic2 > cvSIC2xTsic2);  
bootsizeSIZExTsize = mean(abs(bSIZExT - ones(nSim,1)*bTest3')./seSIZExTsize > cvSIZExTsize);  
bootsizeFxT8 = mean(abs(bFxT8 - ones(nSim,1)*bTest3')./seFxT8 > cvFxT8);  
bootsizeFxT6 = mean(abs(bFxT6 - ones(nSim,1)*bTest3')./seFxT6 > cvFxT6);  
bootsizeFxT4 = mean(abs(bFxT4 - ones(nSim,1)*bTest3')./seFxT4 > cvFxT4);   
bootsizeFxT2 = mean(abs(bFxT2 - ones(nSim,1)*bTest3')./seFxT2 > cvFxT2);   

BOOTSIZE = [bootsizefirm ; bootsizestate ; bootsizesic1 ; bootsizesic2 ; bootsizesize ; bootsizeT8 ; ...
    bootsizeT6 ; bootsizeT4 ; bootsizeT2 ; bootsizeSxTstate ; bootsizeSIC1xTsic1 ; bootsizeSIC2xTsic1 ; ...
    bootsizeSIC2xTsic2 ; bootsizeSIZExTsize ; bootsizeFxT8 ; bootsizeFxT6 ; bootsizeFxT4 ; ...
    bootsizeFxT2];

