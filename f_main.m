clear all;
close all;
clc;

T_Appliance_data;
T_Unscheduled_states;

% Initialization of paramters
%---------------- operation states-------------%
Fixed_OS_app= [Oven('Operation states')'];
Nonintrrpt_OS_app=[Washing_machine('Operation states')'  Electric_Kettle('Operation states')' Vacuum('Operation states')'];
Flexible_OS_app=[Air_condition('Operation states')' Water_heater('Operation states')'];

Appliances=[Fixed_OS_app Nonintrrpt_OS_app Flexible_OS_app];
Fetch_states= @(mtx, m, n) mtx(m,n);
Oven_St=Fetch_states(Oven('Operation states'),1,':');
W_Machine_St=Fetch_states(Washing_machine('Operation states'),1,':');
Electric_Kettle_St=Fetch_states(Electric_Kettle('Operation states'),1,':');
Vacuum_St=Fetch_states(Vacuum('Operation states'),1,':');
Air_cond_St=Fetch_states(Air_condition('Operation states'),1,':');
Water_h_St=Fetch_states(Water_heater('Operation states'),1,':');
%------------Finding Onslots-----------------------------
Oven_on=strfind(Oven_St, [1]);
W_Machine_on=strfind(W_Machine_St, [1]);
Electric_Kettle_on=strfind(Electric_Kettle_St, [1]);
Vacuum_on=strfind(Vacuum_St, [1]);
Air_cond_on=strfind(Air_cond_St, [1]);
Water_h_on=strfind(Water_h_St, [1]);

Load_arrive=[ Oven_on W_Machine_on  Electric_Kettle_on Vacuum_on Air_cond_on Water_h_on];Load_arrive_1=[ sum(Oven_on) sum(W_Machine_on) sum(Electric_Kettle_on) sum(Vacuum_on) sum(Air_cond_on) sum(Water_h_on)];

%----------- Power ratings(PR)--------------------%
Fixed_PR_app= [Oven('Power')];
Nonintrrpt_PR_app= [Washing_machine('Power') Electric_Kettle('Power') Vacuum('Power')];
Flex_PR_app=[Air_condition('Power') Water_heater('Power')];
PR=[Fixed_PR_app Nonintrrpt_PR_app Flex_PR_app];

%----------- Operational time interval---------------%
Fixed_TS_app= [Oven('Time span')];
Nonintrrpt_TS_app=[Washing_machine('Time span') Electric_Kettle('Time span') Vacuum('Time span')];
Flex_TS_app=[Air_condition('Time span') Water_heater('Time span')];
Time_OP=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Time_OP_DE=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Time_OP_HSA=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Time_OP_GA1=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Time_OP_HSA1=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Time_OP_PSO1=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Time_OP_DE1=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
%-----Following values have been used as sample to working steps of algorithms
%----------- Per hour real time energy price information--------------%
EP=[1.9 2.5 1.9 2.1 2.0 2.0 2.9 2.0 1.9 1.9 1.8 2.0 1.9 1.9 1.4 1.6 3.7 3.2 1.5 0.6 1.7 1.6 1.6 2.5];
EP_sell=[0.19 0.25 0.19 0.21 0.20 0.20 0.29 0.20 0.19 0.19 0.18 0.50 0.50 0.50 0.35 0.36 0.57 0.32 0.55 0.06 0.17 0.16 0.16 0.25];
%----------- Temperature and solar irrdiance information--------------%
Temp=[0 0 0 0 0  0  3.2 7.5 7.5 7.5 7.5 7.5 7.5 7.1 3.2 0 0 0 0 0 0 0 0 0];
Irr= [0 0 0 0 0  0  4.1 15.8 27  29.4 22.2 34.8 16 7.6 1.1 0 0 0 0 0 0 0 0 0];
%--------- Paramter Initialization------------------------------------%
Z=zeros(1,24); NSM_0=10;
A=0.5; EF=0.18; eff=0.8;
del_max=10;
Q_buy=EP;
Q_sell=EP_sell;
P_buy=Z; P_sell=Z; C_sell=Z; C_buy=Z; Btt_c1=Z;Dis=Z;E_bt=Z; E_grid=Z;
R_Pv_min=0; Ex_t=Z; RRs=Z;RRLs=Z;Bttr_d=Z; Energy_D=Z;E_sup=Z;Energy_p=Z;Bttr_cc=Z;Dis_c=Z; ac_t=Z; ad_t=Z;
%%%%% Battery parameters intialization
Btt_c_mn=0; Btt_c_mx=5; hour_max=24;  E_bt_mn=0; E_bt_mx=5; Disch_mx=5; Disch_mn=0;
%%%%%%%%%%%%%%%%%%%%%%%%%
Avail_e=Z; E_bt_ga=Z; R_Pv_ga=Z; E_grid_ga=Z; Dis_ef_ga=Z; Dis_ga=Z;  Dichar_ga=Z;Up_ga_sch=Z; Obje_hr=Z;
RRsg=Z; Dis_cg=Z; B_ga=Z;RRLsg=Z;D_ga=Z; sum1=0; zz=zeros(); sum_schedule_load=0; Dis_gas=0;
%%%%%%%%%%%%%%%%%%%%%%%%
Q_buy_ga=EP; Q_sell_ga=EP_sell;P_buy_ga=Z;P_sell_ga=Z;C_sell_ga=Z;C_buy_ga=Z;R_DS_ga=Z; Btt_c2=Z; GA_sch=Z;E_sup_ga=Z;
Bttr_c_ga=Z; Btt_cs_ga=Z; ac_t_ga=Z; ad_t_ga=Z; %T_C_Dg=0;;
%%%%%%%%%%%%%%%%%%%%%%%
T_GA_cost_RE=0; C_bt=Z; C_bt_hs=Z; C_bt_ga=Z; C_bt_pso=Z; C_bt_ed=Z;
%%%%%%%%%%%%%%%%%%%%%%%
Avail_ep=Z; E_bt_pso=Z; R_Pv_pso=Z; E_grid_pso=Z; Dis_ef_pso=Z;Dis_pso=Z; Dichar_pso=Z; ac_t_pso=Z; ad_t_pso=Z;
Btt_c_pso=Z; Bttr_c_pso=Z;
%%%%%%%%%%%%%%%%%%%%%%%
Q_buy_pso=EP; Q_sell_pso=EP_sell; P_buy_pso=Z; P_sell_pso=Z; C_sell_pso=Z; C_buy_pso=Z; R_DS_pso=Z; S_C_pso=Z;
demx=[10 20 30 40 50 60];
%%%%%%%%%%%%%%%%%%%%%%%
C_T=0; R_v=0; sum_schedule_lod=0;sum_E_Cost=0; RRLsbp=Z;   B_bps=Z; D_bps=Z; dlzp=ones(10,1);

Btt_cs=Z; Dichar=Z;  Dicharg=Z; Dicharg_ede =Z;Btt_c=Z; C_ted=Z;Bttr_c_de=Z; E_bt_ed=Z; E_grid_ed=Z; Idle=Z;
E_Cost_SS_RE=0;sum_schedule_cost_RE=0;
T_Ch_t_ed=0;Ch_t_ed=0; T_cost_LS=0;

Q_buy_ed=EP; Q_sell_ed=EP_sell;P_buy_ed=Z;P_sell_ed=Z;C_sell_ed=Z;C_buy_ed=Z;R_Pv_ed=Z;Btt_cs_ed=Z;
Dichar_ed=Z;Dis_use_ede=Z;E_ED_ed=Z;E_ED=Z; Btt_c_ed=Z; R_DS_ed=Z; Dis_ef_de=Z;  C_t=Z; ac_t_ed=Z; ad_t_ed=Z;
Demand_H=zeros(10,24);B_de=Z; D_de=Z; RRLsde=Z;

Avail_ehs=Z; E_bt_hs=Z; R_Pv_hs=Z; E_grid_hs=Z;
%%%%%%%%%%%%%%%%%%%%%%%
Dis_ef_hs=Z; Dis_hs=Z; Dichar_hs=Z; ac_t_hs=Z;ad_t_hs=Z; Btt_c_hs=Z;Bttr_c_hs=Z; Q_buy_hs=EP; Q_sell_hs=EP_sell;
P_buy_hs=Z; P_sell_hs=Z; C_sell_hs=Z; C_buy_hs=Z; R_DS_hs=Z; Diss_hs=Z; Bttr_hs=Z; RRLs_hs=Z; RRs_hs=Z;
%%%%%%%%%%%%%%%%%%%%%%%
Ch_t_hs=0; Dis_ef_s_hs=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Homes=ones(10,1);
%%%%%%%%%%%%%%%%%%%%%%
% Below lines from 100 to 242, computes the demand, supply, and overall cost of the system considering one day
% Note: This computation is based on scenario when no optimization is applied

for hour=1:hour_max
    % Line 107 to 114 calculates the Energy demand and cost of the energy demand
    Load(hour)= Appliances(hour,:)*PR';
    Energy_p (hour)=ceil((Load (hour)));
    Energy_D (hour)=Energy_p (hour);
    Q_power_buy=[EP(hour)*PR(1) EP(hour)*PR(2) EP(hour)*PR(3) EP(hour)*PR(4) EP(hour)*PR(5) EP(hour)*PR(6)]; % Price of Energy
    unsch_load_cost(hour)= Appliances(hour,:)*Q_power_buy';
    unsch_cost_t= sum(unsch_load_cost);
    Q_cost_sell= 0.80*unsch_load_cost;
    RG_new(hour)= (EF*A*Irr(hour)*(1-0.005.*(Temp(hour)-25))); % Calculates PV Generation
    up_Energy_p(hour)= Energy_p(hour)-RG_new(hour);            % Calculates the Energy demand considering PV Generation
    cost_Re(hour)=up_Energy_p(hour)*EP(hour);                  % Computes the Cost of the Energy
    T_cost=1/24*(sum(cost_Re));
    % Line 115 to 175 calculates the Energy supply element i.e, Utility grid energy, PV energy, and Energy storage system
    if RG_new(hour)> Energy_D(hour)
        R_Pv(hour)=RG_new(hour)-Energy_p(hour);
    end
    if RG_new(hour)< Energy_D(hour)
        R_Pv(hour)=0;
    end
    E_grid (hour)=Energy_D (hour)- RG_new(hour)- E_bt (hour);
    if E_grid (hour)< 0 && RG_new(hour)+ E_bt (hour) > E_grid (hour)
        E_grid (hour)=0;
    end
    E_bt(hour)= 0.7* E_bt(hour)+0.7*(R_Pv(hour)+E_grid(hour))-0.8.*(Dis_c(hour));
    
    if E_bt (hour) >=E_bt_mn && E_bt (hour) <=E_bt_mx
        E_bt(hour)=E_bt(hour);
    elseif E_bt (hour)>E_bt_mx
        E_bt (hour)=E_bt_mx;
    else
        E_bt (hour)=E_bt_mn;
    end
    
    Ex_t (hour)=E_grid (hour)+ R_Pv (hour);
    RRs (hour)=RG_new(hour)+E_bt(hour);
    RRLs(hour)=abs(Energy_D(hour)- RRs(hour));
    T_E_grid= sum(E_grid);
    E_sup (hour)= E_grid (hour)+ RG_new(hour)+ Dis_c (hour);
    R_DS (hour)= Energy_D (hour)/E_sup (hour);
    T_sup=sum(E_sup);
    T_Dem=sum(Energy_D);
    T_R_DS=T_Dem/T_sup; 
    [Btt_un,Dis_un]=f_unbss(E_bt,E_grid,RRLs,E_bt_mx, Btt_c_mx,Btt_c_mn,ac_t,ad_t,eff,hour_max,Disch_mn,Disch_mx);
    if Btt_un(hour)>0 && Dis_un(hour)>0
        if RRLs(hour)>=mean(RRLs)
            Bttr_cc(hour)=Btt_un(hour);
            Dis_un(hour)=Z(hour);
            ad_t(hour)=0;
            ac_t(hour)=1;
        end
        if Btt_un(hour)>0 && Dis_un(hour)>0
            if RRLs(hour)<=mean(RRLs)
                Dis_c(hour)=Dis_un(hour);
                Bttr_cc(hour)=Z(hour);
                ad_t(hour)=1;
                ac_t(hour)=0;
            end
        end
        if(Btt_un(hour)==0 && Dis_c(hour)>0)  || (Btt_un(hour)>0 && Dis_c(hour)==0)
            Bttr_cc(hour)=Btt_un(hour);
            Dis_c(hour)=Dis_un(hour);
            ad_t=ad_t(hour);
            ac_t(hour)=ac_t(hour);
        end
    end
    Ch_uns=sum(Bttr_cc);
    Dis_uns=sum(Dis_c);
    F_Load(hour)=ceil(up_Energy_p(hour)-Dis_c(hour));%Energy Demand after the integartion Renewable Resources
    F_C(hour)=F_Load(hour).*EP(hour);
    C_F=1/24*sum(F_C);
    C_bt (hour)=Bttr_cc(hour)*0.001+ Dis_c(hour)*0.001;
    C_bt_s= 1/24*sum(C_bt);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The lines 176 to 203 are implemenatation of the Pricing Model
    P_sell(hour)=(Q_buy(hour).*Q_sell(hour))./(Q_buy(hour)-Q_sell(hour)).*R_DS(hour)+Q_sell(hour);
    P_buy(hour)=P_sell(hour).*R_DS(hour)+Q_buy(hour).*(1-R_DS(hour));
    
    if R_DS(hour)>=0 && R_DS(hour)<=1
        P_sell(hour)=P_sell(hour);
    elseif R_DS(hour)==0
        P_sell(hour)=Q_buy(hour);
    else R_DS(hour)>=1
        P_sell(hour)=Q_sell(hour);
    end
    if R_DS(hour)>=0 && R_DS(hour)<=1
        P_buy(hour)=P_buy(hour);
    elseif R_DS(hour)==0
        P_buy(hour)=Q_buy(hour);
    else R_DS(hour)>=1
        P_buy(hour)=Q_sell(hour);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Energy_D (hour)>= RG_new(hour)+ E_bt (hour)
        C_buy(hour)= P_sell (hour)*(Energy_D (hour)-(RG_new(hour)+ E_bt (hour)));
    end
    if  RG_new(hour)+ E_bt (hour) > Energy_D (hour)
        C_sell(hour)=P_buy(hour)*((RG_new(hour)+ E_bt (hour))-Energy_D (hour));
    end
    C_t(hour)= abs((C_sell(hour)-C_buy(hour)));
    C_unT=1/24*sum(C_t);
    Obje_f=C_unT+C_bt_s+C_F;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % D_n(NS,hour)= Homes(NS,1).*Energy_p (1,hour);
    % S_D_n= sum(D_n);
    % Check= sum(S_D_n);
    % PV_n(NS, hour)= Homes(NS,1).*RG_new (1,hour);
    % S_PV_n=sum(PV_n);
    % Es_n(NS, hour)=Homes(NS,1).*E_bt(1,hour);
    % S_Es_n=sum(Es_n);
    % Un_n(NS, hour)= Homes(NS,1).*cost_Re(1, hour);
    % S_Un_n=sum(Un_n);
    % Un_b(NS, hour)= Homes(NS, 1)*C_buy(1,hour);
    % Un_buy=sum(Un_b);
    % Un_se(NS, hour)=Homes(NS, 1)*C_sell(1,hour);
    % Un_sell=sum(Un_se);
    % E_grid_n(NS, hour)=Homes(NS,1).*E_grid(1, hour);
    % C_bt_n(NS, hour)=Homes(NS,1).*C_bt(1, hour);
    % S_C_bt_n=sum(C_bt_n);
    % C_t_n(NS, hour)=Homes(NS,1).*C_t(1, hour);
    % S_C_n= sum(C_t_n);
    %
    % Obj_n= 1/10*sum((S_Un_n+S_C_bt_n+S_C_n));
end

disp('-------------------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    The next code lines describe the "Genetic Algorithm"             %%%
%%%            based on the designed system model                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setting up basic paramters of the algorithm


Time_OP_GA=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
Plimit=20;
popsize=50;   % Maximum generation of the chromosomes
maxgen=10;    % Maximum generation of the chromomes during crossover and muatation
insite=2;     % Two point crossover
pc=0.9;       % Crossover probabaility
pm=0.1;       % Mutation probability
count=0;
ss=zeros();
%a=0;
ind=popsize;
tbits=length(Time_OP_GA);
% Generating random number  between Zero and One
for j=1:popsize
    for i=1:tbits
        if rand>=0.15
            X=1;
        else
            X=0;
        end
        pop(j,i)=X;
    end
end
popnew=pop;
noupdate=pop;
for gen=1:24  lgen=25-gen;
    electricity_cost=Q_power_buy;
    n=length(electricity_cost);
    for a=1:popsize
        for b=1:tbits
            if Time_OP_GA(1,b)==0
                popnew(a,b)=0;
            end
            if lgen<=Time_OP_GA(1,b)
                popnew(a,b)=1;
            end
        end
    end
    for i=1:popsize       %Computing values of the generated population
        F1(i,1)=(electricity_cost*popnew(i,:)');
        psum(:,i)=popnew(i,:)*PR';
        sum1=psum;       
    end
    %Using Crossover and Mutation Process for the better population
    for j=1:maxgen
        ii=floor(ind*rand);
        jj=floor(ind*rand);
        if ii==0
            ii=randi(ind,1,1);
        end
        if jj==0
            jj=randi(ind,1,1);
        end
        if pc>rand
            [popnew(ii,:),popnew(jj,:)]= crossover(pop(ii,:),pop(jj,:));
            count=count+2;
        end
        if pm>rand
            kk=floor(ind*rand);
            if kk==0
                kk=randi(ind,1,1);
            end
            count=count+1;
            popnew(kk,:)=mutate(popnew(kk,:),insite);
        end
        popnew;
    end
    uppopvalue=popnew;
    for i__=1:popsize %Computing values of the generated and modified population
        F2(i__,1)=(electricity_cost*uppopvalue(i__,:)');
    end
    for i_ = 1:popsize
        gsum(:,i_)=uppopvalue(i_,:)*PR';
        sum2=gsum;
        if (F2(i_,1)<=F1(i_,1))&&(sum2(1,i_)<=Plimit)
            best(1,:) = uppopvalue(i_,:);
        elseif  (F1(i_,1)<F2(i_,1))&&(sum1(1,i_)<=Plimit)
           best(1,:) = popnew(i,:); 
        end
    end
    for f=1:tbits
        if best(1,f)==1
            Time_OP_GA(1,f)=Time_OP_GA(1,f)-1;
        end
        if Time_OP_GA(1,f)<=0
            Time_OP_GA(1,f)=0;
        end
    end
    gbest(gen,:)=best;
    app_Sh(gen,:)=best;
%%%Line 326 to 335 calculates the Energy demand and cost of the energy demand
    schedule_load2(gen)=app_Sh(gen,1)*PR(1)+app_Sh(gen,2)*PR(2)+app_Sh(gen,3)*PR(3)+app_Sh(gen,4)*PR(4)+app_Sh(gen,5)*PR(5)+app_Sh(gen,6)*PR(6);
    sum_scheduledload=sum(schedule_load2);
    E_Cost_SS(gen)=schedule_load2(gen)*EP(gen);  %% Cost without PV energy
    sum_schedule_cost=sum(E_Cost_SS);            %% Total Cost without PV energy 
    GA_sch(gen)= ceil((schedule_load2(gen)));    %% Load without PV energy
    Up_GA_sch(gen)=GA_sch(gen)-RG_new(gen);      %% Load with PV energy
    GA_cost_RE(gen)=Up_GA_sch(gen)*EP(gen);      %% Cost with PV energy
    T_GA_cost_RE=1/24*(sum(GA_cost_RE));
    % Line 336 to 392 calculates the Energy supply element i.e, Utility grid energy, PV energy, and Energy storage system
    if RG_new(gen)> GA_sch(gen)
        R_Pv_ga(gen)=RG_new(gen)-GA_sch(gen);
    end
    if RG_new(gen)< GA_sch(gen)
        R_Pv_ga(gen)=0;
    end
    E_grid_ga(gen)=GA_sch(gen)- RG_new(gen)- E_bt_ga (gen);
    if E_grid_ga (gen)< 0 && RG_new(gen)+ E_bt_ga (gen) > E_grid_ga (gen)
        E_grid_ga (gen)=0;
    end
    E_bt_ga(gen)=  0.7* E_bt_ga(gen)+0.7*(R_Pv_ga(gen)+E_grid_ga(gen))-0.8*(D_ga(gen));
    if E_bt_ga (gen) >=E_bt_mn && E_bt_ga (gen) <=E_bt_mx
        E_bt_ga (gen)=E_bt_ga (gen);
    elseif E_bt_ga (gen)>E_bt_mx
        E_bt_ga (gen)=E_bt_mx;
    else
        E_bt_ga (gen)=E_bt_mn;
    end
    Avail_e(gen)=E_grid_ga (gen)+R_Pv_ga(gen);
    RRsg (gen)=RG_new(gen)+E_bt_ga(gen);
    RRLsg(gen)=abs(GA_sch (gen)- RRsg(gen));
    T_E_grid_ga= sum(E_grid_ga);
    E_sup_ga (gen)= E_grid_ga (gen)+ RG_new(gen)+ D_ga (gen);
    R_DS_ga (gen)= GA_sch (gen)/E_sup_ga (gen);
    T_sup_ga=sum(E_sup_ga);
    T_Dem_ga=sum(GA_sch);
    T_R_DS_ga=T_Dem_ga/T_sup_ga;
    [Btt_ga,Dis_ga]=f_bss_ga(E_bt_ga,E_grid_ga,RRLsg,hour_max,E_bt_mx, Btt_c_mx,Btt_c_mn,ac_t_ga,ad_t_ga,eff,Disch_mn,Disch_mx);
    %Charing and Discharing computation
    if Btt_ga(gen)>0 &&Dis_ga(gen)>0
        if RRLsg(gen)>=mean(RRLsg)
            B_ga(gen)=Btt_ga(gen);
            D_ga(gen)=Z(gen);
            ad_t_ga(gen)=0;
            ac_t_ga (gen)=1;
        end
        if Btt_ga(gen)>0 &&Dis_ga(gen)>0
            if RRLsg(gen)<=mean(RRLsg)
                D_ga(gen)=Dis_ga(gen);
                B_ga(gen)=Z(gen);
                ad_t_ga(gen)=1;
                ac_t_ga (gen)=0;
            end
        end
        if(Btt_ga(gen)==0 &&Dis_ga(gen)>0)  || (Btt_ga(gen)>0 &&Dis_ga(gen)==0)
            B_ga(gen)=Btt_ga(gen);
            D_ga(gen)=Dis_ga(gen);
            ad_t_ga(gen)=ad_t_ga(gen);
            ac_t_ga (gen)=ac_t_ga (gen);
        end
    end
    Ch_gas=sum(B_ga);  %Total Charging
    Dis_gas=sum(D_ga); %Total Discharing 
    F_Load_ga(gen)=ceil(Up_GA_sch(gen)-D_ga(gen)); %Load per hour
    F_C_ga(gen)=F_Load_ga(gen).*EP(gen);           %Cost per hour    
    C_F_ga=1/24*sum(F_C_ga);                       %Total cost
    C_bt_g(gen)=B_ga(gen)*0.001+ D_ga(gen)*0.001;  %Battery cost    
    T_Ch_t_ga=1/24*sum(C_bt_g);                    %Total battery cost    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The lines 394 to 418 are implemenatation of the Pricing Model
    P_sell_ga(gen)=(Q_buy_ga(gen)*Q_sell_ga(gen))/(Q_buy_ga(gen)-Q_sell_ga(gen))*R_DS_ga(gen)+Q_sell_ga(gen);
    P_buy_ga(gen)=P_sell_ga(gen)*R_DS_ga(gen)+Q_buy_ga(gen)*(1-R_DS_ga(gen));
    if R_DS_ga(gen)>=0 && R_DS_ga(gen)<=1  %R_DS represent Demand-supply ratio
        P_sell_ga(gen)=P_sell_ga(gen);     
    elseif R_DS_ga(gen)==0                   
        P_sell_ga(gen)=Q_buy_ga(gen);
    else R_DS_ga(gen)>=1
        P_sell_ga(gen)=Q_sell_ga(gen);
    end
    if R_DS_ga(gen)>=0 && R_DS_ga(gen)<=1
        P_buy_ga(gen)=P_buy_ga(gen);
    elseif R_DS_ga(gen)==0
        P_buy_ga(gen)=Q_buy_ga(gen);
    else R_DS_ga(gen)>=1
        P_buy_ga(gen)=Q_sell_ga(gen);
    end
    if GA_sch (gen)> RG_new(gen)+ E_bt_ga (gen)
        C_buy_ga(gen)= P_sell_ga (gen).*(GA_sch (gen)-(RG_new(gen)+ E_bt_ga (gen)));
    end
    if  RG_new(gen)+ E_bt_ga (gen)> GA_sch (gen)
        C_sell_ga(gen)=P_buy_ga(gen).*((RG_new(gen)+ E_bt_ga (gen))-GA_sch (gen));
    end
    C_tga(gen)= abs((C_sell_ga(gen)-C_buy_ga(gen)));
    T_C_ga=1/24*sum(C_tga);
    Obj_GA=T_C_ga+T_Ch_t_ga +C_F_ga;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Storing the optimized energy plans for the appliances
    Oven_sh(gen)=app_Sh(gen,1);
    Washing_machine_sh(gen)=app_Sh(gen,2);
    Electric_Kettle_sh(gen)=app_Sh(gen,3);
    Vacuum_sh(gen)=app_Sh(gen,4);
    Air_condition_sh(gen)=app_Sh(gen,5);
    Water_heater_sh(gen)=app_Sh(gen,6);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % D_gaa(Sg,gen)= Homes(Sg,1).*F_Load_ga (1,gen);
    % S_D_ga= sum(D_gaa);
    % Check_ga= sum(S_D_ga);  % No need of it.
    % Es_ga(Sg, gen)=Homes(Sg,1).*E_bt_ga(1,gen);
    % S_Es_ga=sum(Es_ga);
    % Un_ga(Sg, gen)= Homes(Sg,1).*GA_cost_RE(1, gen);
    % S_Un_ga=sum(Un_ga);
    % E_grid_gaaa(Sg, gen)=Homes(Sg,1).*E_grid_ga(1, gen);  %%% Grid Energy
    % Un_ga_b(Sg, gen)= Homes(Sg,1).*C_buy_ga(1, gen); %Buy and selling cost
    % Un_ga_buy=sum(Un_ga_b);
    % Un_ga_s(Sg, gen)= Homes(Sg,1).*C_sell_ga(1, gen); %Buy and selling cost
    % Un_ga_sell=sum(Un_ga_s);
    % C_bt_ga(Sg, gen)=Homes(Sg,1).*C_bt_g(1, gen); %%%% Chargind Discharging Cost
    % S_C_bt_ga=sum(C_bt_ga);
    % C_t_ga(Sg, gen)=Homes(Sg,1).*C_tga(1, gen);
    % S_C_ga= sum(C_t_ga);
    
    %Obj_ga= 1/10*sum((S_C_ga+S_C_bt_ga+S_Un_ga));
    Oven_sc=strfind(Oven_sh, [1]);
    W_Machine_sc=strfind(Washing_machine_sh, [1]);
    Electric_Kettle_sc=strfind(Electric_Kettle_sh, [1]);
    Vacuum_sc=strfind(Vacuum_sh, [1]);
    Air_cond_sc=strfind(Air_condition_sh, [1]);
    Water_h_sc=strfind(Water_heater_sh, [1]);
    Sch_startg=[ Oven_sc W_Machine_sc  Electric_Kettle_sc Vacuum_sc Air_cond_sc Water_h_sc];
    Sch_start_g=[sum(Oven_sc) sum(W_Machine_sc) sum(Electric_Kettle_sc) sum(Vacuum_sc) sum(Air_cond_sc) sum(Water_h_sc) ];
end

disp('-------------------------------------------------------------');
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    The next code lines describe the "Prtical Swarm Optimization"    %%%
%%%            based on the designed system model                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Setting up basic paramters of the algorithm

Time_OP_PSO=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];
vpmaxp=4;       % Velocity of particle in a swarm
vpmin=-vpmaxp;  % Maximum and minmum velocity of particle in a swarm
swarm=30;       % Maximum size of the swarm
nitra=length(Time_OP_PSO);
c1=2.0;         % Weights for local and global positions
c2=c1;          % Weights for local and global positions
wi=1.0;         % Intial angular velocity of particle in a swarm
wf=0.2;         % Final  angular velocity of particle in a swarm
sum_E_Cost_PS=0;
sum_Pschedule_load=0;
PPlimit=18;
P2Plimit=18;
for phour=1:24
    electricity_cost=[EP(phour)*PR(1) EP(phour)*PR(2) EP(phour)*PR(3) EP(phour)*PR(4) EP(phour)*PR(5) EP(phour)*PR(6)]; %EP(phour)*PR(7) EP(phour)*PR(8) EP(phour)*PR(9) EP(phour)*PR(10)
    c_electricity_cost=-[PR(1) PR(2) PR(3) PR(4) PR(5) PR(6) ];
    d=-2500;
    n=length(electricity_cost);
    for s=1:swarm   % Generation of randome swarm between Zero and One
        for t=1:n
            if rand(1)>0.5
                Y=1;
            else
                Y=0;
            end
            xp(s,t)=Y;
        end
    end
    vp= vpmin+((vpmaxp-vpmin).*rand(swarm,n));  % Calculates the velocity of each particle in the swarm
    for ap=1:length(Time_OP_PSO)
        for bp=1:length(Time_OP_PSO)
            if Time_OP_PSO(1,bp)==0
                xp(ap,bp)=0;
            end
        end
    end
    ppbest=xp;
    PF=obj(electricity_cost,c_electricity_cost,xp,swarm,d);
    DP = inf;
    for t = 1:swarm
        if (PF(t,1)<DP)&& sum(xp(t,:))>0
            DP = PF(t,1);
            pgbest(1,:) = xp(t,:);
        end
    end
    g=pgbest;
    pgbest;
    Fppbest=PF;
    DP1=inf;
    % Calucating and Updating intial and final velocities and positions of the particles in swarm
    for k = 1:nitra
        w=wi+((wf-wi)*k/nitra);
        for t = 1:swarm
            for s = 1:n
                vp(t,s) =w*vp(t,s)+c1*rand(1)*(ppbest(t,s)-xp(t,s))+c2*rand(1)*(pgbest(1,s)-xp(t,s));
                if ( (vp(t,s)<=vpmaxp) && (vp(t,s)>=vpmin) )
                    vp(t,s) = vp(t,s);
                elseif ( vp(t,s) < vpmin )
                    vp(t,s) = vpmin;
                elseif ( vp(t,s) > vpmaxp )
                    vp(t,s) = vpmaxp;
                end
                sigg(t,s)=1/(1+exp(-vp(t,s)));
                if rand(1)<sigg(t,s)
                    xp(t,s)=1;
                else
                    xp(t,s)=0;
                end
            end
        end
        for ap=1:length(Time_OP_PSO)
            for bp=1:length(Time_OP_PSO)
                if Time_OP_PSO(1,bp)==0
                    xp(ap,bp)=0;
                end
            end
        end
        % PF=obj(electricity_cost,c_electricity_cost,xp,swarm,d);
        for t = 1:swarm
            ppsum(:,t)=xp(t,:)*PR';
            if ( Fppbest(t,1)<PF(t,1) ) && ppsum(1,t)<PPlimit
                ppbest(t,:) = ppbest(t,:);
            else
                ppbest(t,:) = xp(t,:);
            end
        end
        %Fppbest=obj(electricity_cost,c_electricity_cost,ppbest,swarm,d);
        DP = inf;
        for t = 1:swarm
            if (Fppbest(t,1)<DP)&&PR*ppbest(t,:)'<=P2Plimit
                DP = Fppbest(t,1);
                pgbest(1,:) = ppbest(t,:);
            end
        end
    end
    ppower_pattern=pgbest;
    app_ppower_pattern(phour,:)= pgbest;
    pds=inf;
    P_E_Cost=0;
    pprice=0;
    for phr=1:24
        yz=find(zz==phr);
        if ~isempty(yz)
            phr=phr+1;
        else
            electricity_cost_PS=[EP(phr)*PR(1) EP(phr)*PR(2) EP(phr)*PR(3) EP(phr)*PR(4) EP(phr)*PR(5) EP(phr)*PR(6)];
            EP_xp_AppStatus= pgbest;
            P_E_Cost(phr)=electricity_cost_PS*pgbest';
            pprice=P_E_Cost(phr);
            if pprice < pds
                pds = pprice;
                phr=phr;
                phph(phr)=phr;
            else
                pds = pds;
            end
        end
        if phr>24
            break
        end
    end
    zz(phr)=phr;
    % Line 590 to 601 calculates the Energy demand and cost of the energy demand
    Pschedule_load1(phour)=[app_ppower_pattern(phour,1)*PR(1)+app_ppower_pattern(phour,2)*PR(2)+app_ppower_pattern(phour,3)*PR(3)+app_ppower_pattern(phour,4)*PR(4)+app_ppower_pattern(phour,5)*PR(5)+app_ppower_pattern(phour,6)*PR(6)];
    Pschedule_load(phour)=Pschedule_load1(phour);
    Pschedule_load_PSO(phour)=Pschedule_load(phour)-RG_new(phour);
    Pschedule_PSO=sum(Pschedule_load_PSO);
    cost_RES(phour)=Pschedule_load_PSO(phour)*EP(phour);
    Pcost_RES=sum(cost_RES);
    Pso_sch(phour)= ceil((Pschedule_load1(phour)));     %% Load without PV energy
    Pso_cost_NRE(phour)=Pso_sch(phour)*EP(phour);       %% Cost without PV energy
    Up_pso_sch(phour)=Pso_sch(phour)-RG_new(phour);     %% Load with PV energy
    Pso_cost_RE(phour)=Up_pso_sch(phour)*EP(phour);     %% Cost with PV energy
    T_pso_RE=1/24*(sum(Pso_cost_RE));                   %% Total cost 
    % Line 603 to 659 calculates the Energy supply element i.e, Utility grid energy, PV energy, and Energy storage system
    if RG_new(phour)> Pso_sch(phour)
        R_Pv_pso(phour)=RG_new(phour)-Pso_sch(phour);
    end
    if RG_new(phour)< Pso_sch(phour)
        R_Pv_pso(phour)=0;
    end
    E_grid_pso(phour)=Pso_sch(phour)- RG_new(phour)- E_bt_pso (phour); % Energy Balance
    if E_grid_pso (phour)< 0 && RG_new(phour)+ E_bt_pso (phour) > E_grid_pso (phour)
        E_grid_pso (phour)=0;
    end
    E_bt_pso(phour)=  0.7* E_bt_pso(phour)+0.7*(R_Pv_pso(phour)+E_grid_pso(phour))-0.8*(D_bps (phour));
    Avail_ep(phour)=E_grid_pso (phour)+R_Pv_pso(phour);
    if E_bt_pso (phour) >=E_bt_mn && E_bt_pso (phour) <=E_bt_mx
        E_bt_pso (phour)=E_bt_pso (phour);
    elseif E_bt_pso (phour)>E_bt_mx
        E_bt_pso (phour)=E_bt_mx;
    else
        E_bt_pso (phour)=E_bt_mn;
    end
    RRsbp(phour)=RG_new(phour)+E_bt_pso(phour);
    RRLsbp(phour)=abs(Pso_sch(phour)- RRsbp(phour));
    T_E_grid_pso= sum(E_grid_pso);
    E_sup_pso (phour)= E_grid_pso (phour)+ RG_new(phour)+ D_bps (phour);
    R_DS_pso (phour)= Pso_sch (phour)/E_sup_pso (phour);
    T_sup_pso=sum(E_sup_pso);
    T_Dem_pso=sum(Pso_sch);   
    T_R_DS_pso=T_Dem_pso/T_sup_pso;
    [Btt_bps, Dis_bps]=f_bss_bps(E_grid_pso,RRLsbp,Btt_c_mn,E_bt_mx,Btt_c_mx,hour_max,E_bt_pso,ac_t_pso,ad_t_pso,Disch_mx,Disch_mn,eff)
    if Btt_bps(phour)>0 && Dis_bps(phour)>0
        if RRLsbp(phour)>=mean(RRLsbp)
            B_bps(phour)=Btt_bps(phour);
            D_bps(phour)=Z(phour);
            ad_t_pso(phour)=0;
            ac_t_pso (phour)=1;
        end
        if Btt_bps(phour)>0 && Dis_bps(phour)>0
            if RRLsg(phour)<=mean(RRLsg)
                D_bps(phour)=Dis_bps(phour);
                B_bps(phour)=Z(phour);
                ad_t_pso(phour)=1;
                ac_t_pso (phour)=0;
            end
        end
        if(Btt_bps(phour)==0 && Dis_bps(phour)>0)  || (Btt_bps(phour)>0 && Dis_bps(phour)==0)
            B_bps(phour)=Btt_bps(phour);
            D_bps(phour)=Dis_bps(phour);
            ad_t_pso(phour)=ad_t_pso(phour);
            ac_t_pso (phour)=c_t_pso(phour);
        end
    end
    Ch_sbp=sum(B_bps);
    Dis_sbp=sum(D_bps);
    F_Load_pso(phour)= ceil(Up_pso_sch(phour)-D_bps(phour));
    F_C_pso(phour)=F_Load_pso(phour).*EP(phour);
    C_F_pso=1/24*sum(F_C_pso);
    C_bt_pso(phour) =B_bps(phour)*0.001+ Dis_cg(phour) *0.001; %%%%%% Per hour total charging and discharing can be set here
    T_Ch_t_pso=1/24*sum(C_bt_pso);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The lines 662 to 688 are implemenatation of the Pricing Model
    P_sell_pso(phour)=(Q_buy_pso(phour).*Q_sell_pso(phour))./((Q_buy_pso(phour)-Q_sell_pso(phour)).*R_DS_pso(phour)+Q_sell_pso(phour));
    P_buy_pso(phour)=P_sell_pso(phour).*R_DS_pso(phour)+Q_buy_pso(phour).*(1-R_DS_pso(phour));
    if R_DS_pso(phour)>=0 && R_DS_pso(phour)<=1
        P_sell_pso(phour)=Q_sell_pso(phour);
    elseif R_DS_pso(phour)==0
        P_sell_pso(phour)=Q_buy_pso(phour);
    else R_DS_pso(phour)>=1
        P_sell_pso(phour)=Q_sell_pso(phour);
    end
    if R_DS_pso(phour)>=0 && R_DS_pso(phour)<=1
        P_buy_pso(phour)=Q_buy_pso(phour);
    elseif R_DS_pso(phour)==0
        P_buy_pso(phour)=Q_buy_pso(phour);
    else R_DS_pso(phour)>=1
        P_buy_pso(phour)=Q_sell_pso(phour);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Pso_sch (phour)> (RG_new(phour)+ E_bt_pso (phour))
        C_buy_pso(phour)= P_sell_pso (phour).* (Pso_sch (phour)-(RG_new(phour)+ E_bt_pso (phour)));
    end
    if  (RG_new(phour)+ E_bt_pso (phour))> Pso_sch (phour)
        C_sell_pso(phour)=P_buy_pso(phour).*((RG_new(phour)+ E_bt_pso (phour))-Pso_sch (phour));
    end
    C_tpso(phour)=abs((C_sell_pso(phour)-C_buy_pso(phour)));
    T_C_pso=1/24*sum(C_tpso);
    Obj_p= T_C_pso+T_Ch_t_pso+C_F_pso;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for pf=1:length(Time_OP_PSO)
        if ppower_pattern(1,pf)==1
            Time_OP_PSO(1,pf)=Time_OP_PSO(1,pf)-1;
        end
        if Time_OP_PSO(1,pf)<=0
            Time_OP_PSO(1,pf)=0;
        end
    end
    Oven_psh(phour)=app_ppower_pattern(phour,1);
    Washing_machine_psh(phour)=app_ppower_pattern(phour,2);
    Electric_Kettle_psh(phour)=app_ppower_pattern(phour,3);
    Vacuum_psh(phour)=app_ppower_pattern(phour,4);
    Air_condition_psh(phour)=app_ppower_pattern(phour,5);
    Water_heater_psh(phour)=app_ppower_pattern(phour,6);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % D_pso(Sp,phour)= Homes(Sp,1).*F_Load_pso (1,phour);
    % S_D_pso= sum(D_pso);
    % Check_pso= sum(S_D_pso);
    % Es_pso(Sp, phour)=Homes(Sp,1).*E_bt_pso(1,phour);
    % S_Es_pso=sum(Es_pso);
    % Un_pso(Sp, phour)= Homes(Sp,1).*Pso_cost_RE(1,phour);
    % S_Un_pso=sum(Un_pso);
    % E_grid_pso_n(Sp, phour)=Homes(Sp,1).*E_grid_pso(1, phour);
    % C_bt_pso_n(Sp, phour)=Homes(Sp,1).*C_bt_pso(1, phour); % cost of the charging and discharing
    % S_C_bt_pso=sum(C_bt_pso_n);
    % C_pso_b(Sp, phour)=Homes(Sp,1).*C_buy_pso(1, phour);
    % C_pso_buy=sum(C_pso_b);
    % C_pso_s(Sp, phour)=Homes(Sp,1).*C_sell_pso(1, phour);
    % C_pso_sell= sum(C_pso_s);
    % o_n(Sp, phour)=Homes(Sp,1).*C_tpso(1, phour);  % energy transactioncost
    % S_C_pso=sum(C_tpso_n);
    %
    % Obj_pso= 1/10*sum((S_Un_pso+S_C_bt_pso+S_C_pso));
    
    Oven_psc=strfind(Oven_psh, [1]);
    W_Machine_psc=strfind(Washing_machine_psh, [1]);
    Electric_Kettle_psc=strfind(Electric_Kettle_psh, [1]);
    Vacuum_psc=strfind(Vacuum_psh, [1]);
    Air_cond_psc=strfind(Air_condition_psh, [1]);
    Water_h_psc=strfind(Water_heater_psh, [1]);
    Sch_startp=[ Oven_psc W_Machine_psc Electric_Kettle_psc Vacuum_psc Air_cond_psc Water_h_psc];
    Sch_start_p=[ sum(Oven_psc) sum(W_Machine_psc) sum(Electric_Kettle_psc) sum(Vacuum_psc) sum(Air_cond_psc) sum(Water_h_psc) ];
end

disp('-------------------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    The next code lines describe the "Differential Evolation"        %%%
%%%            based on the designed system model                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setting up basic paramters of the algorithm

nitrr=100; %Maximum no of generations
Xpop=30;   %Maximum no of populations
xl=50;     %Upper limits of the geneartion
xu=100;    %Lower limits of the geneartion
Nvar=length(Time_OP_DE);
Plimit=15;
for hor= 1:hour_max
    for xpop=1:Xpop %%%% Generates the radom popluation
        for nvar=1:Nvar
            Paren(xpop,nvar) = xl+rand(1)*(xu-xl);
        end
    end
    y=max(Paren(:));
    x2=Paren/y;
    EP=[1.9 2.5 1.9 2.1 2.0 2.0 2.9 2.0 1.9 1.9 1.8 2.0 1.9 1.9 1.4 1.6 3.7 3.2 1.5 0.6 1.7 1.6 1.6 2.5];
    electricity_cost=[EP(hor)*PR(1) EP(hor)*PR(2) EP(hor)*PR(3) EP(hor)*PR(4) EP(hor)*PR(5) EP(hor)*PR(6)];
    lhor=25-hor;
    for xpop=1:Xpop
        for nvar=1:Nvar
            if Time_OP_DE(1,nvar)==0
                x2(xpop,nvar)=0;
            end
            if lhor<=Time_OP_DE(1,nvar)
                x2(xpop,nvar)=1;
                %                  else
            end
        end
        
    end
    for gen=1:nitrr
        a=randperm(Xpop);%random permutation
        a1=a(1,1);
        rev1=x2(a1,:);
        a2=a(1,2);
        rev2=x2(a2,:);
        a3=a(1,3);
        rev3=x2(a3,:);
        Mutantt= rev1+0.7*(rev2-rev3);
        for nvar=1:Nvar
            if rand(1)>0.7
                Y1(1,nvar)=rev1(1,nvar);
            else
                Y1(1,nvar)=Mutantt(1,nvar);
            end
        end
        F1=electricity_cost*Y1';
        F2=electricity_cost*rev1';
        if F1<F2
            x2(a1,:)=Y1;
        else
            x2(a1,:)=rev1;
        end
    end
    for xpop=1:Xpop
        for nvar=1:Nvar
            if x2(xpop,nvar)>0.5
                X=1;
            else
                X=0;
            end
            x2(xpop,nvar)=X;
        end
    end
    
    for xpop=1:Xpop
        F(xpop,1)=electricity_cost*x2(xpop,:)';
    end
    D11=inf;
    for xpop=1:Xpop
        if F(xpop,1)<D11&& PR*x2(xpop,:)'<=Plimit
            D11=F(xpop,1);
            gbst(1,:)=x2(xpop,:);% trial vector value using fourth equation
        end
    end
    % Line 816 to 825 calculates the Energy demand and cost of the energy demand
    app_Sch(hor,:)=gbst;
    schedule_load(hor)=PR*gbst';                          %% Load without PV energy
    E_cost(hor)=electricity_cost*app_Sch(hor,:)';         %% Cost without PV energy
    schedule_load_RE(hor)=schedule_load(hor)-RG_new(hor); %% Load with PV energy
    E_ED(hor)= ceil((schedule_load(hor)));                %% Load per hour
    E_ED_LS(hor)=E_ED(hor)-RG_new(hor);
    cost_LS(hor)=E_ED_LS(hor)*EP(hor);                   %% Cost with PV energy
    T_cost_LS=1/24*(sum(cost_LS));
    % Line 826 to 886 calculates the Energy supply element i.e, Utility grid energy, PV energy, and Energy storage system
    RRsde(hor)=RG_new(hor)+E_bt_ed (hor);
    RRLsde(hor)=abs(E_ED(hor)- RRsde(hor));
    T_E_grid_ed= sum(E_grid_ed);
    E_sup_ed (hor)= E_grid_ed (hor)+ RG_new(hor)+ D_de (hor);
    R_DS_ed (hor)= E_ED (hor)/E_sup_ed (hor);
    T_sup_ed=sum(E_sup_ed);
    T_Dem_ed=sum(E_ED);
    T_R_DS_ed=T_Dem_ed/T_sup_ed;
    if RG_new(hor)> E_ED(hor)
        R_Pv_ed(hor)=RG_new(hor)-E_ED(hor);
    end
    if RG_new(hor)< E_ED(hor) 
        R_Pv_ed(hor)=0;
    end
    E_ED_ed(hor)=E_ED(hor)-RG_new(hor);
    
    E_grid_ed(hor)=E_ED(hor)- RG_new(hor)- E_bt_ed (hor);
    if E_grid_ed (hor)< 0 && RG_new(hor)+ E_bt_ed (hor) > E_grid_ed (hor)
        E_grid_ed (hor)=0;
    end
    E_bt_ed(hor)= 0.7* E_bt_ed(hor)+0.7*(R_Pv(hor)+E_grid_ed(hor))-0.8.*(D_de(hor));
    Ex_t_ed (hor)=E_grid_ed (hor)+ R_Pv_ed (hor);
    
    if E_bt_ed (hor) >=E_bt_mn && E_bt_ed (hor) <=E_bt_mx
        E_bt_ed(hor)=E_bt_ed(hor);
    elseif E_bt_ed (hor) >E_bt_mx
        E_bt_ed (hor)=E_bt_mx;
    else
        E_bt_ed (hor)=E_bt_mn;
    end
    [Btt_de,Dis_de]=f_bss_de(E_grid_ed,RRLsde,Btt_c_mn,E_bt_mx,Btt_c_mx,hour_max,E_bt_ed,ac_t_ed,ad_t_ed,Disch_mx,Disch_mn,eff);
    if Btt_de(hor)>0 &&Dis_de(hor)>0
        if RRLsde(hor)>=mean(RRLsde)
            B_de(hor)=Btt_de(hor);
            D_de(hor)=Z(hor);
            ad_t_ed(hor)=0;
            ac_t_ed (hor)=1;
        end
        if Btt_de(hor)>0 &&Dis_de(hor)>0
            if RRLsg(hor)<=mean(RRLsg)
                D_de(hor)=Dis_de(hor);
                B_de(hor)=Z(hor);
                ad_t_ed(hor)=1;
                ac_t_ed (hor)=0;
            end
        end
        if(Btt_de(hor)==0 &&Dis_de(hor)>0)  || (Btt_de(hor)>0 &&Dis_de(hor)==0)
            B_de(hor)=Btt_de(hor);
            D_de(hor)=Dis_de(hor);
            ad_t_ed(hor)=ad_t_ed(hor);
            ac_t_ed (hor)=ac_t_ed(hor);
        end
    end
    Ch_des=sum(B_de);
    Dis_des=sum(D_de);
    F_Load_de(hor)=ceil(E_ED_LS(hor)-D_de(hor));
    F_C_de(hor)=F_Load_de(hor).*EP(hor);
    C_F_de=1/24*sum(F_C_de);
    C_bt_ed(hor) =B_de(hor)*0.001+  D_de(hor)*0.001;
    T_Ch_t_ed=1/24*sum(C_bt_ed);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The lines 888 to 912 are implemenatation of the Pricing Model
    P_sell_ed(hor)=(Q_buy_ed(hor)*Q_sell_ed(hor))/(Q_buy_ed(hor)-Q_sell_ed(hor))*R_DS_ed(hor)+Q_sell_ed(hor);
    P_buy_ed(hor)=P_sell_ed(hor)*R_DS_ed(hor)+Q_buy_ed(hor)*(1-R_DS_ed(hor));
    
    if R_DS_ed(hor)>=0 && R_DS_ed(hor)<=1
        P_sell_ed(hor)=Q_sell_ed(hor);
    elseif R_DS_ed(hor)==0
        P_sell_ed(hor)=Q_buy_ed(hor);
    else R_DS_ed(hor)>=1
        P_sell_ed(hor)=Q_sell_ed(hor);
    end
    if R_DS_ed(hor)>=0 && R_DS_ed(hor)<=1
        P_buy_ed(hor)=Q_buy_ed(hor);
    elseif R_DS_ed(hor)==0
        P_buy_ed(hor)=Q_buy_ed(hor);
    else R_DS_ed(hor)>=1
        P_buy_ed(hor)=Q_sell_ed(hor);
    end
    if E_ED (hor)> RG_new(hor)+ E_bt_ed (hor)
        C_buy_ed(hor)= P_sell_ed (hor)* (E_ED (hor)-(RG_new(hor)+ E_bt_ed (hor)));
    end
    if  RG_new(hor)+ E_bt_ed (hor)> E_ED (hor)
        C_sell_ed(hor)=P_buy_ed(hor)*((RG_new(hor)+ E_bt_ed (hor))-E_ED (hor));
    end
    C_ted(hor)= abs((C_sell_ed(hor)-C_buy_ed(hor)));
    T_C_ed=1/24*sum(C_ted);
    
    Obj_de=T_C_ed+T_Ch_t_ed+C_F_de;
    Oven_sh(hor)=app_Sch(hor,1);
    Washing_machine_sh(hor)=app_Sch(hor,2);
    Electric_Kettle_sh(hor)=app_Sch(hor,3);
    Vacuum_sh(hor)=app_Sch(hor,4);
    Air_condition_sh(hor)=app_Sch(hor,5);
    Water_heater_sh(hor)=app_Sch(hor,6);
    
    for f=1:length(Time_OP_DE)
        if gbst(1,f)==1
            Time_OP_DE(1,f)=Time_OP_DE(1,f)-1;
        end
        if Time_OP_DE(1,f)<=0
            Time_OP_DE(1,f)=0;% avoid negative  time slot
            % gbest(1,f)=0;
        end
    end
    Time_OP_DE;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % D_dE(Se,hor)= Homes(Se,1)*F_Load_de (1,hor);       %Load
    % S_D_dE= sum(D_dE);
    % Check_dE= sum(S_D_dE);  % No need of it.
    % Es_dE(Se, hor)=Homes(Se,1)*E_bt_ed(1,hor);   %state of the battery
    % S_Es_dE=sum(Es_dE);
    % Un_dE(Se, hor)= Homes(Se,1)*cost_LS(1,hor);  %%% Energy delaying COST
    % S_Un_dE=sum(Un_dE);
    % E_grid_dE_n(Se, hor)=Homes(Se,1).*E_grid_ed(1, hor);
    % E_dE_b(Se, hor)=Homes(Se,1).*C_buy_ed(1, hor);
    % E_dE_buy=sum(E_dE_b);
    % E_dE_s(Se, hor)=Homes(Se,1).*C_sell_ed(1, hor);
    % E_dE_sell=sum(E_dE_s);
    % C_bt_dE_n(Se, hor)=Homes(Se,1).*C_bt_ed(1, hor);  % Battery cost
    % S_C_bt_dE=sum(C_bt_dE_n);
    % C_tdE_n(Se, hor)=Homes(Se,1).*C_ted(1, hor);
    % S_C_dE=sum(C_tdE_n);
    % Obj_dE= 1/10*sum((S_Un_dE+S_C_bt_dE+S_C_dE));
    
    Oven_sc=strfind(Oven_sh, [1]);
    W_Machine_sc=strfind(Washing_machine_sh, [1]);
    Electric_Kettle_sc=strfind(Electric_Kettle_sh, [1]);
    Vacuum_sc=strfind(Vacuum_sh, [1]);
    Air_cond_sc=strfind(Air_condition_sh, [1]);
    Water_h_sc=strfind(Water_heater_sh, [1]);
    Sch_start_de=[sum(Oven_sc) sum(W_Machine_sc) sum(Electric_Kettle_sc) sum(Vacuum_sc) sum(Air_cond_sc) sum(Water_h_sc) ];
end


disp('-------------------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    The next code lines describe the "Harmony Search Algorithm"      %%%
%%%            based on the designed system model                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Load_hour=Energy_D;
Price_Pwer=Q_power_buy;
%clear hour;
%-------------- The HSA Parameters------------------
HMS=30;          %population size
NVAR=length(Time_OP_HSA);          % number of appliances
HMCR=0.9;        % HMRC probability
PAmin=0.4;       % minumum pitch adjusting rate
PAmax=0.9;       % maximum pitch adjusting rate
bwmin=0.0001;    % minumum bandwidth
bwmax=1.0;       % maxiumum bandwidth
MaxItr=10;		 % maximum generation
xl=0.1;          % Upper bound 
xu=0.9;          % Lower bound
best=inf;
gbest=inf;
Fbest=inf;
%% Intialize Population
for i=1:HMS
    for j=1:NVAR
        HM(i,j) = xl+rand(1)*(xu-xl);
    end
end
for hour=1:24 % gen=24
    %%%% Convert into binary %%%%
    HM1=HM;
    for i=1:HMS
        for j=1:NVAR
            if HM1(i,j)>0.5%std(unscheduledload) % rand(1) means 1*1 matrix
                HM1(i,j)=1;
            else
                HM1(i,j)=0;
            end
        end
    end
    lhour=25-hour;
    if hour>=1
        for a=1:HMS
            for b=1:NVAR
                if Time_OP_HSA(1,b)<=0
                    HM1(a,b)=0;
                elseif (lhour<=Time_OP_HSA(1,b)&& Time_OP_HSA(1,b)>0)
                    HM1(a,b)=1;
                end
            end
        end
        %% Selection and Calculation %%
        F=(Price_Pwer*HM1');
        E_Cost=(Price_Pwer*HM1');
        if hour<24
            Cost_next=EP(hour+1)*PR;
        else
            Cost_next=EP(hour)*PR;
        end
        F1=(Cost_next*HM1');
        % error=c_Price_Pwer*HM1';
        % F1=F1+1000*abs(error);
        Load=PR*HM1';
        gbest=inf;
        Lbest=inf;
        D11=inf;
        if D11==inf
            for i = 1:HMS
                if (F(1,i)<D11 && Load(1,i)>min(Load_hour))
                    D11 = F(1,i);
                    Lbest = HM1(i,:); % gbest position achieved here.    ?
                    Fbest=D11;
                    ds= E_Cost(1,i);
                    ij=i;
                end
            end
        end
        if D11==inf
            for i = 1:HMS
                if (F(1,i)<D11)% && Load(1,i)>min(unscheduledload))
                    D11 = F(1,i);
                    Lbest = HM1(i,:); % gbest position achieved here.    ?
                    Fbest=D11;
                    ds= E_Cost(1,i);
                    ij=i;
                end
            end
        end
        gbest=Lbest(1,:);
        HM1(ij,:)=0;
        for b=1:NVAR
            if (gbest(1,b)==1)
                Time_OP_HSA(1,b)=Time_OP_HSA(1,b)-1;
            elseif (gbest(1,b)==0)
                Time_OP_HSA(1,b)=Time_OP_HSA(1,b);
            end
        end
        Time_OP_HSA;
        hour;
        % Line 1063 to 1072 calculates the Energy demand and cost of the energy demand
        app_Sch_G(hour,:)=gbest(:,:);
        schedule_load_G(hour)=PR*gbest';            %% Load without PV energy
        E_Cost_SS_G(hour)=Price_Pwer*gbest';        %% Cost without PV energy
        sum_scheduled_load_G=sum(schedule_load_G);  %% Total load with RES Integration
        cost_sum=sum(E_Cost_SS_G);                  %% Total load with RES Integration
        PAR_scheduled_G=(max(schedule_load_G)^2/((sum_scheduled_load_G)/24)^2);
        HSA_(hour)=ceil(schedule_load_G(hour));
        HSA_L(hour)=HSA_(hour)-RG_new(hour);
        T_hsa(hour)= HSA_L(hour)*EP(hour);
        T_hsa_cost=1/24*(sum(T_hsa));
        % Line 1073 to 1129 calculates the Energy supply element i.e, Utility grid energy, PV energy, and Energy storage system
        RRs_hs(hour)=RG_new(hour)+ E_bt_hs (hour);
        RRLs_hs(hour)=abs(HSA_(hour)- RRs_hs(hour));
        T_E_grid_hs= sum(E_grid_hs);
        E_sup_hs (hour)= E_grid_hs (hour)+ RG_new(hour)+ Diss_hs(hour);
        R_DS_hs (hour)= HSA_(hour)/E_sup_hs (hour);
        T_sup_hs=sum(E_sup_hs);
        T_Dem_hs=sum(HSA_);
        T_R_DS_hs=T_Dem_hs/T_sup_hs;
        if RG_new(hour)> HSA_(hour)
            R_Pv_hs(hour)=RG_new(hour)-HSA_(hour);
        end
        if RG_new(hour)< HSA_(hour)
            R_Pv_hs(hour)=0;
        end
        E_grid_hs(hour)=HSA_(hour)- RG_new(hour)- E_bt_hs (hour); % Energy Balance
        if E_grid_hs (hour)< 0 && RG_new(hour)+ E_bt_hs (hour) > E_grid_hs (hour)
            E_grid_hs (hour)=0;
        end
        E_bt_hs(hour)= 0.7* E_bt_hs(hour)+0.7*(R_Pv_hs(hour)+E_grid_hs(hour))-0.8*(Diss_hs(hour));
        Avail_ehs(hour)=E_grid_hs (hour)+R_Pv_hs(hour);
        if E_bt_hs (hour) >=E_bt_mn && E_bt_hs (hour) <=E_bt_mx
            E_bt_hs (hour)=E_bt_hs (hour);%Battery calculation
        elseif E_bt_hs (hour)>E_bt_mx
            E_bt_hs (hour)=E_bt_mx;
        else
            E_bt_hs (hour)=E_bt_mn;
        end
        [Ch_hs,Dis_hs]=f_bss_hs(E_bt_hs,E_grid_hs,RRLs_hs,hour_max,E_bt_mx, Btt_c_mx,Btt_c_mn,ac_t_hs,ad_t_hs,Disch_mx,Disch_mn,eff);
        if Ch_hs(hour)>0 && Dis_hs(hour)>0
            if RRLs_hs(hour)>=mean(RRLs_hs)
                Bttr_hs(hour)=Ch_hs(hour);
                Diss_hs(hour)=Z(hour);
                ad_t_hs(hour)=0;
                ac_t_hs(hour)=1;
            end
            if Ch_hs(hour)>0 && Dis_hs(hour)>0
                if RRLs_hs(hour)<=mean(RRLs_hs)
                    Diss_hs(hour)=Dis_hs(hour);
                    Bttr_hs(hour)=Z(hour);
                    ad_t_hs(hour)=1;
                    ac_t_hs (hour)=0;
                end
            end
            if(Ch_hs(hour)==0 && Dis_hs(hour)>0)  || (Ch_hs(hour)>0 && Dis_hs(hour)==0)
                Bttr_hs(hour)=Ch_hs(hour);
                Diss_hs(hour)=Dis_hs(hour);
                ad_t_hs(hour)=ad_t_hs(hour);
                ac_t_hs (hour)=ac_t_hs(hour);
            end
        end
        Ch_hss=sum(Bttr_hs);
        Dis_hss=sum(Diss_hs);
        F_Load_hs(hour)=ceil(HSA_L(hour)-Diss_hs(hour));
        F_C_hs(hour)=F_Load_hs(hour).*EP(hour);
        C_F_hs=1/24*sum(F_C_hs);
        C_bt_hs(hour) =Bttr_hs(hour)*0.001+ Diss_hs (hour)*0.001;
        T_Ch_t_hs=1/24*sum(C_bt_hs);
        % The lines 1132 to 1159 are implemenatation of the Pricing Model
        P_sell_hs(hour)=(Q_buy_hs(hour)*Q_sell_hs(hour))/(Q_buy_hs(hour)-Q_sell_hs(hour))*R_DS_hs(hour)+Q_sell_hs(hour);
        P_buy_hs(hour)=P_sell_hs(hour)*R_DS_hs(hour)+Q_buy_hs(hour)*(1-R_DS_hs(hour));
      
        if R_DS_hs(hour)>=0 && R_DS_hs(hour)<=1
            P_sell_hs(hour)=Q_sell_hs(hour);
        elseif R_DS_hs(hour)==0
            P_sell_hs(hour)=Q_buy_hs(hour);
        else R_DS_hs(hour)>=1
            P_sell_hs(hour)=Q_sell_hs(hour);
        end
        if R_DS_hs(hour)>=0 && R_DS_hs(hour)<=1
            P_buy_hs(hour)=Q_buy_hs(hour);
        elseif R_DS_hs(hour)==0
            P_buy_hs(hour)=Q_buy_hs(hour);
        else R_DS_hs(hour)>=1
            P_buy_hs(hour)=Q_sell_hs(hour);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if HSA_ (hour)> RG_new(hour)+ E_bt_hs (hour)
            C_buy_hs(hour)= P_sell_hs (hour)* (HSA_ (hour)-(RG_new(hour)+ E_bt_hs (hour)));
        end
        if  RG_new(hour)+ E_bt_hs (hour)> HSA_ (hour)
            C_sell_hs(hour)=P_buy_hs(hour)*((RG_new(hour)+ E_bt_hs (hour))-HSA_ (hour));
        end
        C_ths(hour)= abs((C_sell_hs(hour)-C_buy_hs(hour)));
        T_C_hs=1/24*sum(C_ths);
        
        Obj_HSA=T_C_hs+T_Ch_t_hs+ T_hsa_cost; %C_F_hs
        
        %% Next Generation
        %````````````~~~~~~~~~~~~~~~~~~~~~~~~~```````````````````~~~~~~~~~~~~~~~~~%
        %----------------Genereate new population using Harmony---------------------------------%
        for j=1:MaxItr
            PA=(PAmax-PAmin)/(MaxItr)*j+PAmin;  % pitch adjustment rate%
            coef=log(bwmin/bwmax)/MaxItr;
            for pp =1:NVAR
                BW(pp)=bwmax*exp(coef*j);
                
            end
            % improvise a new harmony vector
            for i =1:NVAR
                ran = rand(1);
                if( ran < HMCR ) % memory consideration
                    
                    A=randperm(HMS);
                    index = A(1,HMS);
                    NCHV(i) = HM(index,i);
                    %% gbest
                    % NCHV(i)
                    pvbRan = rand(1);
                    if( pvbRan < PA) % pitch adjusting
                        pvbRan1 = rand(1);
                        result = NCHV(i);
                        if( pvbRan1 < 0.5)
                            result =result+  rand(1) * BW(i);
                            %if( result < PVB(i,2))
                            NCHV(i) = result;
                            % answer= NCHV(i)
                            % end
                        else
                            result =result- rand(1) * BW(i);
                            %if( result > PVB(i,1))
                            NCHV(i) = result;
                        end
                    end
                    %end % for end
                else
                    NCHV(i) = xl+rand(1)*(xu-xl); % random selection
                    %answer = NCHV(i)
                end
                new_h= NCHV;
            end
            new_h1=new_h;
            %nchv=NCHV(i)
            % new_h= NCHV % new harmony
            for i=1:NVAR
                if (new_h1(1,i) > 0.5)
                    new_h1(1,i)=1;
                else
                    new_h1(1,i)=0;
                end
            end
            F=F1;
            if hour<24
                Price_Pwer=EP(hour+1)*PR;
                new = Price_Pwer*new_h1';
                [worst worst_index]= max(F1);
            else
                new = (Price_Pwer*new_h1');
                [worst worst_index]= max(F1);
            end
            if (new<worst)&& new_h1*PR'>min(Load_hour)
                HM(worst_index,:)=new_h;
                F(worst_index)= new;
                
            end
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Oven_G(:,hour)=app_Sch_G(hour,1);
    WM_G(:,hour)=app_Sch_G(hour,2);
    Electric_Kettle_G(:,hour)=app_Sch_G(hour,3);
    Vacuum_G(:,hour)=app_Sch_G(hour,4);
    AC_G(:,hour)=app_Sch_G(hour,5);
    WH_G(:,hour)=app_Sch_G(hour,6);
    % D_hS(Sa,hour)= Homes(Sa,1)*F_Load_hs(1,hour);       %Load
    % S_D_hS= sum(D_hS);
    % Check_hS= sum(S_D_hS);  % No need of it.
    % Es_hS(Sa, hour)=Homes(Sa,1)*E_bt_ed(1,hour);   %state of the battery
    % S_Es_hS=sum(Es_hS);
    % Un_hS(Sa, hour)= Homes(Sa,1)*T_hsa(1,hour);
    % S_Un_hS=sum(Un_hS);
    % E_grid_hS_n(Sa, hour)=Homes(Sa,1).*E_grid_hs(1, hour);
    % E_hS_b(Sa, hour)=Homes(Sa,1).*C_buy_hs(1, hour);
    % E_hS_buy=sum(E_hS_b);
    % E_hS_s(Sa, hour)=Homes(Sa,1).*C_sell_hs(1, hour);
    % E_hS_sell=sum(E_hS_s);
    % C_bt_hS_n(Sa, hour)=Homes(Sa,1).*C_bt_hs(1, hour);
    % S_C_bt_hS=sum(C_bt_hS_n);
    % C_thS_n(Sa, hour)=Homes(Sa,1).*C_ths(1, hour);
    % S_C_hS=sum(C_thS_n);
    % Obj_hS= 1/10*sum((S_Un_hS+S_C_bt_hS+S_C_hS));
    %
    Oven_hs=strfind(Oven_G, [1]);
    W_Machine_hs=strfind(WM_G, [1]);
    Electric_Kettle_hs=strfind(Electric_Kettle_G, [1]);
    Vacuum_hs=strfind(Vacuum_G, [1]);
    Air_cond_hs=strfind(AC_G, [1]);
    Water_h_hs=strfind(WH_G, [1]);
    Sch_start_hs=[sum(Oven_hs) sum(W_Machine_hs)  sum(Electric_Kettle_hs) sum(Vacuum_hs) sum(Air_cond_hs) sum(Water_h_hs) ];
end
disp('-------------------------------------------------------------');
% Line 1265 to 1285 computes the departure and arrival time of the load
for delta=1:tbits
    Diff_g(delta)=abs (Sch_start_g(delta)- Load_arrive_1(delta));
    Diff_p(delta)=abs (Sch_start_p(delta)- Load_arrive_1(delta));
    Diff_de(delta)=abs (Sch_start_de(delta) - Load_arrive_1(delta));
    Diff_hs(delta)=abs (Sch_start_hs(delta) - Load_arrive_1(delta));
    
    denom_g(delta)=abs (demx(delta)-Time_OP_GA1(delta));
    denom_p(delta)= abs(demx(delta)-Time_OP_PSO1(delta));
    denom_de(delta)=abs (demx(delta)-Time_OP_DE1(delta));
    denom_hs(delta)=abs (demx(delta)-Time_OP_HSA1(delta));
    
    Delay_g(delta)= Diff_g(delta) /denom_g(delta);
    Delay_p(delta)=Diff_p(delta) / denom_p(delta);
    Delay_d(delta)= Diff_de(delta) /denom_de(delta);
    Delay_h(delta)= Diff_hs(delta) /denom_hs(delta);
    T_Dg=1/24*sum(Delay_g);
    T_Dp=1/24*sum(Delay_p);
    T_De=1/24*sum(Delay_d);
    T_Dh=1/24*sum(Delay_h);
end



