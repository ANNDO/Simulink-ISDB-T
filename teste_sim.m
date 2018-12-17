%SCRIPT PARA RODAR UMA CONFIGURAÇÃO DO SIMULADOR

clc;
delete(gcp);
parpool
load_system('modulador_1layer_ISDBT');  

savefile='C:\Mestrado\Projeto_Matlab_M_QAM_LDPC\Simulacoes_ISDBT\64QAM\Viterbi 64QAM Noise Var FEC 3_4.mat';%<--ATENÇÃO NO NOME/DIRETÓRIO
BER_Vit_GI1_FEC0=ones(150,3);%<--ATENÇÃO NO NOME
SNR=10:.5:14.5;%<--ATENÇÃO NO RANGE

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
    load_system('modulador_1layer_ISDBT_BICM');
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
set_param('modulador_1layer_ISDBT/Config Simulador','Modo',2,'Gi',1,'Modulation',2,'T_I',0,'fec',0);%<--ATENÇÃO NOS VALORES
for k=1:length(SNR);
    SNR(k)
    set_param('modulador_1layer_ISDBT/Config Simulador','SNR',num2str(SNR(k)));
    sim('modulador_1layer_ISDBT');
    BER_Vit_GI1_FEC0(k,:)=ber_vit(1,:);%<--ATENÇÃO NOS NOMES
    if BER_Vit_GI1_FEC0(k,1)<1e-7
        BER_Vit_GI1_FEC0(k+1:length(SNR),:)=0;
        break
    end     
end
Tempo_Sim = toc
save(savefile);%<--ATENÇÃO NO NOME
fig=Plot_BER(SNR,BER_Vit_GI1_FEC0,'64QAM Viterbi FEC 1/2');
saveas(fig,'C:\Mestrado\Projeto_Matlab_M_QAM_LDPC\Simulacoes_ISDBT\64QAM\Viterbi 64QAM Noise Var FEC 1_2');





%SCRIPT PARA RODAR MÚLTIPLAS CONFIGURAÇÕES DO SIMULADOR

% clc;
% savefile=['C:\Leonardo\Projeto_Matlab_Leonardo\Resultados_Sim_Rayleigh_Flat_Fading\16QAM\ber_values_BER_Vit_GI1_FEC0.mat';...
%     'C:\Leonardo\Projeto_Matlab_Leonardo\Resultados_Sim_Rayleigh_Flat_Fading\16QAM\ber_values_BER_Vit_GI2_FEC0.mat';...
%     'C:\Leonardo\Projeto_Matlab_Leonardo\Resultados_Sim_Rayleigh_Flat_Fading\16QAM\ber_values_BER_Vit_GI3_FEC0.mat'];
% load_system('modulador_1layer_ISDBT');   
% varname=['BER_Vit_GI1_FEC0';'BER_Vit_GI2_FEC0';'BER_Vit_GI3_FEC0'];
% varSNR=[25:.2:50;25:.2:50;25:.2:50];%<--ATENÇÃO NO RANGE
% dim=size(varSNR);
% ber_values=ones(dim(2),3);
% aux=0;
% tic
% for j=1:3    
% set_param('modulador_1layer_ISDBT/Config Simulador','Modo',2,'Gi',j,'Modulation',1,'T_I',0,'fec',0);%<--ATENÇÃO NOS VALORES
%     for k=1:dim(2);
%         j
%         varSNR(aux+1,k)
%         set_param('modulador_1layer_ISDBT/Config Simulador','SNR',num2str(varSNR(aux+1,k)));
%         sim('modulador_1layer_ISDBT');
%         ber_values(aux+1+k,:)=ber_vit(1,:);
%         mystr=[varname(aux+1,:),'(',num2str(k),',:)=[',num2str(ber_values(aux+k,:)),'];'];
%         evalin('base',mystr);
%         if ber_values(aux+k,1)<1e-5
%             mystr=[varname(aux+1,:),'(',num2str(k+1),':',num2str(dim(2)),',:)=[',num2str(0),'];'];
%             evalin('base',mystr);
%             break
%         end
%         
%     end
% save(savefile(aux+1,:));%<--ATENÇÃO NO NOME
% aux=aux+1
% end
% toc

%set_param('modulador_1layer_ISDBT_Rotacionado/Error Rate Calculation2','stop',0)