function [Bttr_chs,Bttr_dhs]=f_bss_hs(E_bt_hs,E_grid_hs,RRLs_hs,hour_max,E_bt_mx, Btt_c_mx,Btt_c_mn,ac_t_hs,ad_t_hs,Disch_mx,Disch_mn,eff)
%Charing and Discharing computation
%Charing Conditions
for our=1:hour_max
    if RRLs_hs(our)>=0 && E_bt_hs(our)<=E_bt_mx
        Bttr_chs (our)=RRLs_hs(our)+E_grid_hs(our);
    else
        Bttr_chs (our)=E_grid_hs(our);
    end
    if Bttr_chs(our) >=Btt_c_mn && Bttr_chs(our)<= Btt_c_mx
        Bttr_chs (our)= Bttr_chs (our);
        ad_t_hs(our)=0;
        ac_t_hs (our)= 1;
    elseif Bttr_chs(our)> Btt_c_mx
        Bttr_chs(our)=Btt_c_mx;
        ad_t_hs(our)=0;
        ac_t_hs (our)= 1;
    else
        Bttr_chs(our)=Btt_c_mn;
        ad_t_hs(our)=1;
        ac_t_hs (our)= 0;
    end
end
%Discharing Conditions
for our=1:hour_max
    Bttr_dhs(our)=Bttr_chs(our).*eff;
    if  Bttr_dhs(our)>Disch_mn &&  Bttr_dhs(our)<=Disch_mx             
        Bttr_dhs(our)=Bttr_dhs (our);
        ad_t_hs(our)=1;
        ac_t_hs(our)= 0;
    elseif Bttr_dhs(our) >Disch_mx
        Bttr_dhs(our)=Disch_mx;
        ad_t_hs(our)=1;
       ac_t_hs(our)= 0;
    else
        Bttr_dhs(our)=Disch_mn;
        ad_t_hs(our)=0;
        ac_t_hs(our)= 1;
    end
end