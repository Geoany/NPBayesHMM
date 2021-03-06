function [Psi, logQ] = RestrictedGibbsScan_Merge( Psi, data_struct, hyperparams, model, TargetPsi )

featIDs = Psi.activeFeatIDs;
objIDs = find( sum( Psi.F(:, featIDs ) , 2 ) > 0 )';

logQ = struct( 'z', 0, 'TS', 0,'theta', 0, 'F', 0, 'all', 0 );

if ~exist( 'TargetPsi', 'var' )
    TargetPsi = [];
end

[Psi.stateSeq, logQ.z] = sampleStateSeq_RGS( Psi.F, Psi.stateSeq, Psi.TS, Psi.theta, data_struct, model, objIDs, TargetPsi );
[Psi.TS, logQ.TS] = sampleTransParams_RGS( Psi.F, Psi.stateSeq, Psi.TS, hyperparams, model, objIDs, TargetPsi);
[Psi.theta, logQ.theta] = sampleTheta_RGS( Psi.F, Psi.stateSeq, Psi.theta, data_struct, model, featIDs , TargetPsi);

logQ.all = logQ.F + logQ.theta + logQ.TS + logQ.z;

