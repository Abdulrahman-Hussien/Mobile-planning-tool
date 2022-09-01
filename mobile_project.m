prompt_GOS = 'What is the needed GOS in percentage?';
GOS = input(prompt_GOS)/100;
if GOS<0 || GOS>1
    display('Please enter GOS between 0 to 100')
    prompt_GOS = 'What is the needed GOS in percentage?';
    GOS = input(prompt_GOS)/100;
end
prompt_cityA = 'What is the city area in Kilometer squared?';
cityA = input(prompt_cityA);
prompt_U_A = 'What is the average user density?';
U_A = input(prompt_U_A);
prompt_SIR = 'What is the SIR min in dB?';
SIR = input(prompt_SIR);
list = {'No sectorization','60 sectorization','120 sectorization'};
[indx,tf] = listdlg('SelectionMode','single','ListString',list);


S = 340;  % total number of channels
Fc = 900;  % in MHz
Ht = 20;   % base station height
Hr = 1.5;  % mobile station height
Au = 0.025; % traffic intensity per user
sensitivity_dbm = -95; %in dBm
sensitivity_watts = power (10, (sensitivity_dbm/10)) * 10^-3;
n = 4; % path loss exponent
cityA_m=cityA/10e6;

if indx == 1    %No Sectorization
    io=6;       %number of interferers
    n_sector=1; %number of sectors
elseif indx == 2%60 sectorization
    io=1;
    n_sector=6;
else            %120 sectorization
    io=2;           
    n_sector=3;
end

N= (1/3) * power((io*power(10,SIR/10)),(2/n)); %Cluster Size
N_cells=0;
j=0;
for i=0:1:floor(N)
    for k=0:floor(N)
        j=j+1;
        N1(j)=power(i,2)+(i*k)+power(k,2);
    end
end

N1(N1 < N) = [];
N_cells=min(N1);  % number of cells per cluster
C = floor(S / N);  % number of channels per cell
C_Sector = floor(C / n_sector); % number of channels per sector

syms A
eqn = ((A^C_Sector) / factorial(C_Sector)) == GOS * (sum(A.^([0:C_Sector]) ./ factorial([0:C_Sector])));
SOL = solve(eqn,A);
MA_total = double(SOL);

if length(MA_total) > 1
    for i= 1:length(MA_total)
        if isreal(MA_total(i))
            A_sector = MA_total(i);
        end
    end
end

A_cell= A_sector *n_sector;
N_Cell = ceil((U_A * cityA * Au)/A_cell); %Number of cells
R_Cell_Km = sqrt((2*cityA)/(3*sqrt(3)*N_Cell)); %Cell Radius

% HATA Model
cf = (1.1*log10(Fc)-0.7)*Hr-(1.566*log10(Fc)-0.8); %Correction Factor

PL=69.55+26.16*log(Fc)-13.82*log(Ht)-cf + ((44.9 - 6.55 * log10(Ht)) * log10(R_Cell_Km)); %Power Loss in dB
PT_xdbm=sensitivity_dbm+PL;
i=0;

for d=R_Cell_Km/10:R_Cell_Km/10:R_Cell_Km
    i=i+1;
    PL(i)=69.55+26.16*log(Fc)-13.82*log(Ht)-cf + ((44.9 - 6.55 * log10(Ht)) * log10(d));
    Pr_dbm(i)= PT_xdbm-PL(i);
    distance(i) = d;
end

figure
plot(distance,Pr_dbm)
xlabel('Distance (Km)');
ylabel('Received Power (dBm)');
title ('MS received power in dBm versus the receiver distance from the BS.');
