function [Bttr_cg, Bttr_dg]=f_bss_ga(E_bt_ga,E_grid_ga,RRLsg,hour_max,E_bt_mx, Btt_c_mx,Btt_c_mn,ac_t_ga,ad_t_ga,eff,Disch_mn,Disch_mx)
%Charing and Discharing description 
%Charing Conditions
for gen=1:hour_max
    if RRLsg(gen)>=0 && E_bt_ga(gen)<=E_bt_mx
        Bttr_cg (gen)=RRLsg(gen)+E_grid_ga(gen);
    else
        Bttr_cg (gen)=E_grid_ga(gen);
    end
    if Bttr_cg(gen) >=Btt_c_mn && Bttr_cg(gen)<= Btt_c_mx
        Bttr_cg (gen)= Bttr_cg (gen);
        ad_t_ga(gen)=0;
        ac_t_ga (gen)= 1;
    elseif Bttr_cg(gen)> Btt_c_mx
        Bttr_cg(gen)=Btt_c_mx;
        ad_t_ga(gen)=0;
        ac_t_ga (gen)= 1;
    else
        Bttr_cg(gen)=Btt_c_mn;
        ad_t_ga(gen)=1;
        ac_t_ga (gen)= 0;
    end
end
%Discharing Condtions
for gen=1:hour_max
    Bttr_dg(gen)=Bttr_cg(gen).*eff;
    if  Bttr_dg(gen)>Disch_mn &&  Bttr_dg(gen)<=Disch_mx  
        Bttr_dg(gen)=Bttr_dg (gen);
        ad_t_ga(gen)=1;
        ac_t_ga (gen)= 0;
    elseif Bttr_dg(gen) >Disch_mx
        Bttr_dg(gen)=Disch_mx;
        ad_t_ga(gen)=1;
        ac_t_ga (gen)= 0;
    else
        Bttr_dg(gen)=Disch_mn;
        ad_t_ga(gen)=0;
        ac_t_ga (gen)= 1;
    end
end    
end