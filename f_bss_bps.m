function[Bttr_cbp,Bttr_dbps]=f_bss_bps(E_grid_pso,RRLsbp,Btt_c_mn,E_bt_mx,Btt_c_mx,hour_max,E_bt_pso,ac_t_pso,ad_t_pso,Disch_mx,Disch_mn,eff)
%Charing and Discharing computation
%Charing conditions
for phour=1:hour_max
    if RRLsbp(phour)>=0 && E_bt_pso(phour)<=E_bt_mx
        Bttr_cbp (phour)=RRLsbp(phour)+E_grid_pso(phour);
    else
        Bttr_cbp (phour)=E_grid_pso(phour);
    end
    if Bttr_cbp(phour) >=Btt_c_mn && Bttr_cbp(phour)<= Btt_c_mx
        Bttr_cbp (phour)= Bttr_cbp (phour);
        ad_t_pso(phour)=0; 
        ac_t_pso (phour)= 1;
    elseif Bttr_cbp(phour)> Btt_c_mx
        Bttr_cbp(phour)=Btt_c_mx;
        ad_t_pso(phour)=0;
        ac_t_pso (phour)= 1;
    else
        Bttr_cbp(phour)=Btt_c_mn;
        ad_t_pso(phour)=1;
        ac_t_pso (phour)= 0;
    end
end  
%Discharing Conditions
for phour=1:hour_max
    Bttr_dbps(phour)=Bttr_cbp(phour).*eff;
    if  Bttr_dbps(phour)>Disch_mn &&  Bttr_dbps(phour)<=Disch_mx           
        Bttr_dbps(phour)=Bttr_dbps (phour);
        ad_t_pso(phour)=1;
        ac_t_pso (phour)= 0;
    elseif Bttr_dbps(phour) >Disch_mx
        Bttr_dbps(phour)=Disch_mx;
        ad_t_pso(phour)=1;
       ac_t_pso (phour)= 0;
    else
        Bttr_dbps(phour)=Disch_mn;
        ad_t_pso(phour)=0;
        ac_t_pso (phour)= 1;
    end
    
end
end