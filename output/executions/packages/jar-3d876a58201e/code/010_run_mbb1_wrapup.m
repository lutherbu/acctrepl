cd('@@ACCTREPL_WORK@@/Datasheet and ReplicationFiles');
run('@@ACCTREPL_WORK@@/Datasheet and ReplicationFiles/FRQSim_MBB1_WrapUp.m');
writematrix([Bsize_firm; Bsize_state; Bsize_sic1; Bsize_sic2; Bsize_size], '@@ACCTREPL_WORK@@/outputs/MBB1_WrapUp.csv');
