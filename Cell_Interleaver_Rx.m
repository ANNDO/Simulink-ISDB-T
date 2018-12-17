function [out]=Cell_Interleaver_Rx()
%Função que gera os coeficientes do Cell Interleaver
persistent count

% if isempty(P)
%     P=zeros(10,1);
% end

if isempty(count)
count=1;
end

Ncell=4992;
Nd=ceil(log2(Ncell));
S=zeros(2^Nd,Nd);%matriz que forma o vetor Lo 
indexS=zeros(1,Ncell);%vetor de indíces de saída do entrelaçador
P=zeros(10,1);
S(3,1)=1;   
auxvec1=ones(2^Nd,1);
% auxvec2=[2^12 2^11 2^10 2^9 2^8 2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0];
auxvec2=[2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12];
S([2:2:2^Nd],Nd)=auxvec1([2:2:2^Nd],1);%alternância entre bits 0's e 1's
for i=4:2^Nd
    S(i,1:Nd-2)=S(i-1,2:Nd-1);
    S(i,12)=mod(length(find([S(i-1,1) S(i-1,2) S(i-1,5) S(i-1,7)])),2);%definição do penúltimo bit (xor dos bits:0,1,4 e6)
   
end
S=auxvec2*S'+1;
indexS=find(S<=Ncell);
indexS=(S(indexS));
%índice dos valores de S que se encontram do range 1<=index<=Ncell(Descarte de valores maiores que a dimensão da entrada)  
%Observação:Não há necessidade de caulcualr P(r), pois ,como o simulador não
%possui time interleaver, só o sistema só possui P(0)=0;
%Isso resulta em Lr(q)=[Lo(q)+0] mod Ncell=Lo(q);


a=0:Nd-1;
a=bi2de(de2bi(a,'right-msb',Nd),'left-msb');% conversão de binário para decimal do bit-reversed de a
indice=find(a<=Ncell);
P=a(indice);


%out=mod(indexS+P(count),Ncell)+1;
out=mod(indexS+0,Ncell+1);
%disp(out(1));

count=count+1;
if count==10
    count=1;
end

end