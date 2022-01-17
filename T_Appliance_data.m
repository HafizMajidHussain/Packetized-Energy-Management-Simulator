%Appliances Data
T_Unscheduled_states;
%Ceilling_fan= containers.Map({ 'Name', 'Power', 'cyclic', 'E_curr', 'E_max', 'E_min','loss_idle','loss_use','Flexible','Operation states', 'Time span'},...
%                               {'Ceilling Fan', 0.075, false, 0, 0.075,0,0,0, false,Uns_states(1,:),15});

%Lamp= containers.Map({ 'Name', 'Power', 'cyclic', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible', 'Operation states', 'Time span'},...
%                               {'Lampe',0.1,false, 0, 0.1,0,0,0, false,Uns_states(2,:), 13});
                            
%TV= containers.Map({ 'Name', 'Power', 'cyclic', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible', 'Operation states','Time span'},...
%                              {'TV',0.48,false, 0, 0.48,0,0,0, false,Uns_states(3,:),10});

Oven=containers.Map({ 'Name', 'Power', 'cyclic', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible', 'Operation states','Time span'},...
                               {'Oven',2.3,false, 0, 2.3,0,0,0, false,Uns_states(1,:),11});                              

Washing_machine=containers.Map({ 'Name', 'Power', 'cyclic', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible', 'Operation states', 'Time span'},...
                               {'Washing Machine',0.7,false, 0, 0.7,0,0,0, false,Uns_states(2,:),10});

%Iron=containers.Map({ 'Name', 'Power', 'cyclic', 'E_curr', 'E_max', 'E_min','loss_idle','loss_use','Flexible', 'Operation states', 'Time span'},...
%                               {'Iron',1.80,false, 0, 1.80,0,0,0, false,Uns_states(6,:),7});

Electric_Kettle= containers.Map({ 'Name', 'Power', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible','Operation states', 'Time span'},...
                                {'Electric Kettle', 0.60, 0,0.60,0,0,0, false,Uns_states(3,:),14});

Vacuum= containers.Map({ 'Name', 'Power', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible','Operation states', 'Time span'},...
                                {'Vacuum', 0.51, 0,0.51,0,0,0, false,Uns_states(4,:),11});
                            
Air_condition=containers.Map({ 'Name', 'Power', 'E_curr', 'E_max', 'E_min','loss_idle','loss_use','Flexible', 'Operation states', 'Time span'},...
                                {'Air condition',1.44, 0, 1.44,0,0,0, true,Uns_states(5,:),12});
                                                                                                                                                    
Water_heater=containers.Map({ 'Name', 'Power', 'E_curr', 'E_max', 'E_min', 'loss_idle','loss_use','Flexible','Operation states', 'Time span'},...
                                {'Water heater', 4.450, 0,4.450,0,0,0, true,Uns_states(6,:),13});
                            
         

                           
% E_curr= Current Energy
% E_max= Maximum Energy used
% E_min= Minium Energy used
% loss_idle= Energy loss in idle mood
% Operation states= The states when appliances are operating
% Flexible= Type of appliance
% Fixed=Type of appliance
% Time span= Operation Time (OT)