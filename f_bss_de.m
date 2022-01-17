function[Bttr_cde,Bttr_dde]=f_bss_de(E_grid_ed,RRLsde,Btt_c_mn,E_bt_mx,Btt_c_mx,hour_max,E_bt_ed,ac_t_ed,ad_t_ed,Disch_mx,Disch_mn,eff)
%Charing and Discharing description 
for hor=1:hour_max
    if RRLsde(hor)>=0 && E_bt_ed (hor)<=E_bt_mx
        Bttr_cde(hor)=RRLsde(hor)+E_grid_ed(hor);
    else
        Bttr_cde(hor)=E_grid_ed(hor);
    end
    if Bttr_cde(hor) >=Btt_c_mn && Bttr_cde(hor)<= Btt_c_mx
        Bttr_cde(hor)= Bttr_cde(hor);
        ad_t_ed(hor)=0;
        ac_t_ed (hor)= 1;
    elseif Bttr_cde(hor)> Btt_c_mx
        Bttr_cde(hor)=Btt_c_mx;
        ad_t_ed(hor)=0;
        ac_t_ed (hor)= 1;
    else
        Bttr_cde(hor)=Btt_c_mn;
        ad_t_ed(hor)=1;
        ac_t_ed (hor)= 0;
    end

end
%Charing and Discharing description 
for hor=1:hour_max
    Bttr_dde(hor)=Bttr_cde(hor).*eff;
    if  Bttr_dde(hor)>Disch_mn &&  Bttr_dde(hor)<=Disch_mx       
        Bttr_dde(hor)=Bttr_dde (hor);
        ad_t_ed(hor)=1;
        ac_t_ed (hor)= 0;
    elseif Bttr_dde(hor) >Disch_mx
        Bttr_dde(hor)=Disch_mx;
        ad_t_ed(hor)=1;
       ac_t_ed (hor)= 0;
    else
        Bttr_dde(hor)=Disch_mn;
        ad_t_ed(hor)=0;
        ac_t_ed (hor)= 1;
    end
end
end