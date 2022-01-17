function[Bttr_c,Bttr_d]=f_unbss(E_bt,E_grid,RRLs,E_bt_mx, Btt_c_mx,Btt_c_mn,ac_t,ad_t,eff,hour_max,Disch_mn,Disch_mx)
%Charing and Discharing computation
%Charing constraints
for hour=1:hour_max
    if RRLs(hour)>=0 && E_bt(hour)<=E_bt_mx
        Bttr_c (hour)=RRLs(hour)+E_grid(hour);
    else
        Bttr_c (hour)=E_grid(hour);
    end
    if Bttr_c (hour) >=Btt_c_mn && Bttr_c (hour)<= Btt_c_mx
        Bttr_c (hour)= Bttr_c (hour);
        ac_t (hour)= 1;
        ad_t(hour)=0;
    elseif Bttr_c(hour)> Btt_c_mx
        Bttr_c (hour)=Btt_c_mx;
        ac_t (hour)= 1;
        ad_t(hour)=0;
    else
        Bttr_c (hour)=Btt_c_mn;
        ac_t (hour)= 0;
        ad_t(hour)=1;
    end
    
end
%Discharing constraints
for hour=1:hour_max
    Bttr_d(hour)=Bttr_c (hour).*eff;
    if  Bttr_d(hour)>=Disch_mn &&  Bttr_d(hour)<=Disch_mx
        Bttr_d(hour)=Bttr_d (hour);
        ad_t(hour)= 1;
        ac_t (hour)= 0;
    elseif Bttr_d(hour) >=Disch_mx
        Bttr_d(hour)=Disch_mx;
        ad_t(hour)= 1;
        ac_t (hour)= 0;
    else
        Dis(hour)=Disch_mn;
        ad_t(hour)= 0;
        ac_t (hour)= 1;
    end
    
end
end