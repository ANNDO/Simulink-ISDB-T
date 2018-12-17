%SCRIPT PARA RODAR UMA CONFIGURAÇÃO DO SIMULADOR

clc;
delete(gcp);
load_system('modulador_1layer_ISDBT');  
parpool

Vec_BER=ones(150,3);%<--ATENÇÃO NO NOME
SNR=[7.5:.5:11,11.25];%<--ATENÇÃO NO RANGE
savefile='C:\Mestrado\Projeto_Matlab_M_QAM_LDPC\Simulacoes_ISDBT\16QAM\RS 16QAM Noise Var FEC 3_4TestePool.mat';%<--ATENÇÃO NO NOME/DIRETÓRIO


% 3) Need to switch all workers to a separate tempdir in case 
% any code is generated for instance for StateFlow, or any other 
% file artifacts are  created by the model.
spmd
    % Setup tempdir and cd into it
    CurrDir = pwd;
    addpath(CurrDir);
    tmpDir = tempname;
    mkdir(tmpDir);
    cd(tmpDir);
    % Load the model on the worker
    load_system('modulador_1layer_ISDBT');
end

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Valores para 'Modulation'          %
% QPSK         0                     %
% 16QAM        1                     %
% 64QAM        2                     % 
% 256QAM       3                     %
% 512QAM       4                     %
% 1024QAM      5                     %
% 2048QAM      6                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Valores para 'fec'                 %
% 1/2          0                     %
% 2/3          1                     %
% 3/4          2                     % 
% 4/5          3                     %
% 7/8          4                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





tic    

parfor k=1:length(SNR);
    set_param('modulador_1layer_ISDBT/Config Simulador','Modo',2,'Gi',1,'Modulation',1,'T_I',0,'fec',2);%<--ATENÇÃO NOS VALORES
    SNR(k)
    set_param('modulador_1layer_ISDBT/Config Simulador','SNR',num2str(SNR(k)));
    sim('modulador_1layer_ISDBT');
    ber_rs=evalin('base','ber_rs');
    Vec_BER(k,:)=ber_rs(1,:);%<--ATENÇÃO NOS NOMES
%     if BER_Vit_GI1_FEC0(k,1)<1e-7
%         BER_Vit_GI1_FEC0(k+1:length(SNR),:)=0;
%         break
%     end     
end
Tempo_Sim = toc
save(savefile);%<--ATENÇÃO NO NOME
fig=Plot_BER(SNR,Vec_BER,'16QAM RS FEC 3/4');
saveas(fig,'C:\Mestrado\Projeto_Matlab_M_QAM_LDPC\Simulacoes_ISDBT\16QAM\RS 16QAM Noise Var FEC 3_4TestePool');

close_system ('modulador_1layer_ISDBT',0);


spmd
cd(CurrDir);
rmdir(tmpDir,'s');
rmpath(CurrDir);
close_system('modulador_1layer_ISDBT',0)
end



