
clc 
clear

nSim=1000;

load('SizePt2_1000X2000_bsize3_17Obs_sim_1000.mat')

Bsize_t2    = mean(abs(b-ones(nSim,1)*bTest3')./se_t2 > bcv_t2)
Bsize_t4    = mean(abs(b-ones(nSim,1)*bTest3')./se_t4 > bcv_t4)
Bsize_t6    = mean(abs(b-ones(nSim,1)*bTest3')./se_t6 > bcv_t6)
Bsize_t8    = mean(abs(b-ones(nSim,1)*bTest3')./se_t8 > bcv_t8)

 
 disp([ '8 year time block & firm, year                   & ' num2str(Bsize_t8(1,1),'%12.2f') ' & '  num2str(Bsize_t8(1,2),'%12.2f') ' & ' ...
     num2str(Bsize_t8(1,3),'%12.2f') ' & '  num2str(Bsize_t8(1,4),'%12.2f') ' & '  num2str(Bsize_t8(1,5),'%12.2f') ' & ' ...
     num2str(Bsize_t8(1,6),'%12.2f') ' & '  num2str(Bsize_t8(1,7),'%12.2f') ' & '  num2str(Bsize_t8(1,8),'%12.2f') ' & '  num2str(Bsize_t8(1,9),'%12.2f') '\\ '])
 
 disp([ '6 year time block & firm, year           & ' num2str(Bsize_t6(1,1),'%12.2f') ' & '  num2str(Bsize_t6(1,2),'%12.2f') ' & ' ...
     num2str(Bsize_t6(1,3),'%12.2f') ' & '  num2str(Bsize_t6(1,4),'%12.2f') ' & '  num2str(Bsize_t6(1,5),'%12.2f') ' & ' ...
     num2str(Bsize_t6(1,6),'%12.2f') ' & '  num2str(Bsize_t6(1,7),'%12.2f') ' & '  num2str(Bsize_t6(1,8),'%12.2f') ' & '  num2str(Bsize_t6(1,9),'%12.2f') '\\ '])
 
 disp([ '4 year time block & firm, year           & ' num2str(Bsize_t4(1,1),'%12.2f') ' & '  num2str(Bsize_t4(1,2),'%12.2f') ' & ' ...
     num2str(Bsize_t4(1,3),'%12.2f') ' & '  num2str(Bsize_t4(1,4),'%12.2f') ' & '  num2str(Bsize_t4(1,5),'%12.2f') ' & ' ...
     num2str(Bsize_t4(1,6),'%12.2f') ' & '  num2str(Bsize_t4(1,7),'%12.2f') ' & '  num2str(Bsize_t4(1,8),'%12.2f') ' & '  num2str(Bsize_t4(1,9),'%12.2f') '\\ '])
 
  disp([ '2 year time block & firm, year          & ' num2str(Bsize_t2(1,1),'%12.2f') ' & '  num2str(Bsize_t2(1,2),'%12.2f') ' & ' ...
     num2str(Bsize_t2(1,3),'%12.2f') ' & '  num2str(Bsize_t2(1,4),'%12.2f') ' & '  num2str(Bsize_t2(1,5),'%12.2f') ' & ' ...
     num2str(Bsize_t2(1,6),'%12.2f') ' & '  num2str(Bsize_t2(1,7),'%12.2f') ' & '  num2str(Bsize_t2(1,8),'%12.2f') ' & '  num2str(Bsize_t2(1,9),'%12.2f') '\\ '])