function saida=gera_prbs_ed_rx_LDPC(x,dim)
% Programa para gerar PRBS do Energy Dispersal
% x e' o numero do TPS
% tps=Number of TPS MPEG2
% gera_prbs_ed: seqb=GeraPRBS(N)
% ---------Para o dispersor de energia
% Gera uma sequencia binaria pseudo-aleatoria de maximo
% comprimento com N bits. O polinomio gerador e':
% p(X)= X^11 + X^2 + 1
% clear
% x=0


persistent seqbt1;
%inicialização da variável seqbt1
if isempty(seqbt1)
    seqbt1=zeros(1,dim-8+15);
end
s1=zeros(1,dim);
s=zeros(1,dim/8);

if x==0 %para Npac=0,determina o valor dos primeiros 15  
    N=dim-8;
    seqb=ones(1,N+15);           
    seqb(1:15)=[0 0 0 0 0 0 0 1 0 1 0 1 0 0 1];
else
    N=dim;
    seqb=ones(1,N+15);
    seqb(1:15)=seqbt1(1:15);
end


for k=16:N+15
    if seqb(k-14)==seqb(k-15)
        seqb(k)=0;
        s1(k-15)=0;
    else
        seqb(k)=1;
        s1(k-15)=1;
    end;
end;


if x==0
    s1=[zeros(1,8) s1(1:dim-8)];
end

sa=reshape(s1,8,dim/8);

d=[2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0];


for i=1:dim/8                                      
    s(i)=sum(sa(:,i)'.*d)';
end
%s=reshape(s',1,dim/8);
s=de2bi(s,'left-msb');
saida=reshape(s',dim,1);
%saida=s';
% saida=s1';

%All Sinc Byte need to be transmitted
saida(1:8)=0;


seqbt1(1:15)=seqb(dim-8+15-14:dim-8+15);