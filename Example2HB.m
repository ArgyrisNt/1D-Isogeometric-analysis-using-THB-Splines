%% Poisson 1D Solver 2nd Example

clc;
clear all;

a = -2;
b = 2;
N = 4;
p = 2;
resol = 0.01;
lvl = 6;
obj = hbSplBasML(a,b,p,N,resol,lvl);

f = @(x) 1-abs(x);
g = @(x) ((abs(x)).^3)/6-((abs(x)).^2)/2+2/3;
dBC = boundCond('Dirichlet','Dirichlet',0,0);

% plotBas(obj);
refArea = [-1 1]; 
obj.HbRefinement1DML(1,refArea);
% plotBas(obj);
refArea2 = [-0.5 0.5];
obj.HbRefinement1DML(2,refArea2);
% plotBas(obj);
refArea3 = [-1/4 1/4];
obj.HbRefinement1DML(3,refArea3);
% plotBas(obj);

ps = PoissSolv(obj,f);
[Stiffn, rhs, ~,~] = ps.assembleMl();
y = ps.solveSyst(Stiffn,rhs,dBC);
fplot(g,[obj.levelBas{1}.a obj.levelBas{1}.b],'b')
hold on;
uh =  ps.generSol(y);
plot(obj.levelBas{1}.plotVector(1:end-1),uh(1:end-1),'r')
hold on;
plot(obj.getAllKnots,0.01,'k*', 'markers',4)
% 
% % Errors in H1, L2 and Energy norms
[H1err,L2err,Enerr] = ps.errCalc(g,y);