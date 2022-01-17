%Time in hrs 1   2   3   4   5   6   7   8   9   10  11  12  13 14  15  16  17  18  19  20  21  22  23  24  

Uns_states= [%1   1   1   1   1   1   0   0   1   0   1   1   1   1   1   1   1   1   0   0   0   0   0   0; %Ceilling Fan
             %0   0   0   0   0   1   0   1   1   1   1   1   1   1   1   1   1   0   1   1   0   0   0   0; %Lampe
             %0   0   0   0   0   0   0   1   1   0   0   1   0   1   0   1   1   1   0   0   1   1   1   0; % TV
             0   1   1   0   0   1   1   1   0   0   0   1   1   1   1   0   0   1   0   0   1   0   0   0; %Micro Oven
             1   1   0   0   0   0   0   0   1   1   0   0   0   0   1   1   1   0   0   1   1   1   0   0; %Wahsing Machine
             %0   0   0   1   1   0   0   0   0   0   1   1   1   0   0   0   0   0   0   1   1   0   0   0; %Iron
             1   1   1   1   1   0   0   0   0   1   0   1   1   0   1   1   1   0   1   0   1   1   0   0; %Electric Kettle
             0   0   0   0   0   1   1   0   0   0   1   1   1   1   1   1   0   1   1   0   0   0   0   1; %Vaccum
             0   0   0   1   1   0   1   1   0   1   0   0   1   1   1   1   0   1   1   0   0   1   0   0; %Air condition
             0   1   1   0   0   0   1   1   1   1   1   0   0   0   0   0   1   1   1   1   0   0   1   1];%Water heater
         
         
 %Uns_states= Unschedule state of Appliances, at time when no optimization is applied        