cd('@@ACCTREPL_WORK@@/Datasheet and ReplicationFiles');
run('@@ACCTREPL_WORK@@/Datasheet and ReplicationFiles/FRQSim_WildBootStats.m');
writematrix(BOOTSIZE, '@@ACCTREPL_WORK@@/outputs/BOOTSIZE.csv');
