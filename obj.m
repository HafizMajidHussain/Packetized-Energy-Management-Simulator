function [F]=obj(electricity_cost,c_electricity_cost,x,swarm,d)
for i=1:swarm
F(i,1)=(electricity_cost*x(i,:)');
error=c_electricity_cost*x(i,:)'-d;
F(i,1)=F(i,1)+1000*abs(error);
end