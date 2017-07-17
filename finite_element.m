clc;
close all;
clear;

% Finite element approximation to dSCC/de for perturbation e

% Set perturbation, 0.1 corresponds to 10% perturbation of parameter
% ONLY perturb one value at a time, otherwise set to 0

pert.deta = 0.1;                           
pert.dM_AT_Base = 0;                     
pert.ddelta = 0;                         
pert.dgamma = 0;                        
pert.dtheta2 = 0;                        
pert.dalpha = 0;                         
pert.drho = 0;                           
pert.dxi1 = 0;                           
pert.dxi2 = 0;                           
pert.dphi11 = 0;                        
pert.dphi12 = 0;
pert.dphi21 = 0;
pert.dphi22 = 0;
pert.dzeta11 = 0;                      
pert.dzeta21 = 0;
pert.dzeta32 = 0;
pert.ddamage = 0;
pertList = [pert.deta; pert.dM_AT_Base; pert.ddelta; pert.dgamma; pert.dtheta2; ...
                 pert.dalpha; pert.drho; pert.dxi1; pert.dxi2; pert.dphi11; pert.dphi12; ...
                 pert.dphi21; pert.dphi22; pert.dzeta11; pert.dzeta21; pert.dzeta32; pert.ddamage];
pertNames = {'eta', 'M_AT_Base', 'delta', 'gamma', 'theta2', 'alpha', 'rho', 'xi1', 'xi2', ...
             'phi11', 'phi12', 'phi21', 'phi22', 'zeta11', 'zeta21', 'zeta32', 'damage'};
           
% Get unperturbed SCC
SCC_unperturbed = importdata('SCC')';
SCC_unperturbed = SCC_unperturbed * 100;
% 
SCC_diff = zeros(size(SCC_unperturbed));
SCC = DICE2013R_mc(pert);


pertInd = 0;
for i = 1:length(pertList)
   if pertList(i) ~= 0
       SCC_diff = (SCC - SCC_unperturbed) / pertList(i);
       pertInd = i;
   end
end

if pertInd ~= 0
    subplot(2,1,1)
    plot(1:length(SCC), SCC_diff)
    title(['dSCC /', pertNames(pertInd), 'for perturbation: ', pertList(pertInd)])
    
    subplot(2,1,2)
    title('Perturbed and non-perturbed SCC')
    hold on
    plot(1:length(SCC), SCC, 'x')
    plot(1:length(SCC), SCC_unperturbed);
    legend('SCC with perturbation', 'SCC unperturbed', 'Location', 'northwest')
else
    disp('============================================================')
    disp('No perturbation, skipping plots')
end
