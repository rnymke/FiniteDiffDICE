function pertParam = set_parameter_perturbation(Params,perturbs)
    
    % Constant
    pertParam.N = Params.N;    
    pertParam.eta = Params.eta * (1 + perturbs.deta);
    pertParam.M_AT_Base = Params.M_AT_Base * (1 + perturbs.dM_AT_Base);
    pertParam.delta = Params.delta * (1 + perturbs.ddelta);
    pertParam.gamma = Params.gamma * (1 + perturbs.dgamma);
    pertParam.theta2 = Params.theta2 * (1 + perturbs.dtheta2);
    pertParam.alpha = Params.alpha * (1 + perturbs.dalpha);
    pertParam.rho = Params.rho * (1 + perturbs.drho);
    pertParam.xi1 = Params.xi1 * (1 + perturbs.dxi1);
    pertParam.xi2 = Params.xi2 * (1 + perturbs.dxi2);
    
    % Temperature carbon interaction
    % Column summation must equal 1

    %pertParam.phi11 = Params.Phi_T(1,1) * (1 + perturbs.dphi11);
    %pertParam.phi12 = Params.Phi_T(1,2) * (1 + perturbs.dphi12);
    %pertParam.phi21 = Params.Phi_T(2,1) * (1 + perturbs.dphi21);
    %pertParam.phi22 = Params.Phi_T(2,2) * (1 + perturbs.dphi22);

    if perturbs.dphi11 ~= 0
        pertParam.phi11 = Params.Phi_T(1,1) * (1 + perturbs.dphi11);
        pertParam.phi21 = 1 - pertParam.phi11;
    elseif perturbs.dphi21 ~= 0
        pertParam.phi21 = Params.Phi_T(2,1) * (1 + perturbs.dphi21);
        pertParam.phi11 = 1 - pertParam.phi21;
    else
        pertParam.phi11 = Params.Phi_T(1,1);
        pertParam.phi21 = Params.Phi_T(2,1);
    end

    if perturbs.dphi12 ~= 0
        pertParam.phi12 = Params.Phi_T(1,2) * (1 + perturbs.dphi12);
        pertParam.phi22 = 1 - pertParam.phi12;
    elseif perturbs.dphi22 ~= 0
        pertParam.phi22 = Params.Phi_T(2,2) * (1 + perturbs.dphi22);
        pertParam.phi12 = 1 - pertParam.phi22;
    else
        pertParam.phi12 = Params.Phi_T(1,2);
        pertParam.phi22 = Params.Phi_T(2,2);
    end


    % Dynamics of carbon cycle
    % Column summation must equal 1
    if perturbs.dzeta11 ~= 0
        pertParam.zeta11 = Params.Phi_M(1,1) * (1 + perturbs.dzeta11);
        pertParam.zeta21 = 1 - pertParam.zeta11;
    elseif perturbs.dzeta21 ~= 0
        pertParam.zeta21 = Params.Phi_M(2,1) * (1 + perturbs.dzeta21);
        pertParam.zeta11 = 1 - pertParam.zeta21;
    else
        pertParam.zeta11 = Params.Phi_M(1,1);
        pertParam.zeta21 = Params.Phi_M(2,1);
    end

    if perturbs.dzeta32 ~= 0
        pertParam.zeta32 = Params.Phi_M(3,2) * (1 + perturbs.dzeta32);
        pertParam.zeta12 = (588/1350)*pertParam.zeta21;
        pertParam.zeta22 = 1 - pertParam.zeta32 - pertParam.zeta12;
    else
        pertParam.zeta32 = Params.Phi_M(3,2);
        pertParam.zeta12 = (588/1350)*pertParam.zeta21;
        pertParam.zeta22 = 1 - pertParam.zeta12 - 0.00250;
    end

    pertParam.zeta23 = pertParam.zeta32*(1350/10000);
    pertParam.zeta33 = 1 - pertParam.zeta23;


    
    pertParam.Phi_T = [pertParam.phi11 pertParam.phi12; pertParam.phi21 pertParam.phi22];
    pertParam.Phi_M = [pertParam.zeta11 pertParam.zeta12 0; pertParam.zeta21 pertParam.zeta22 pertParam.zeta23; 0 pertParam.zeta32 pertParam.zeta33];

    pertParam.Phi_T
    for i = 1:3
        if sum(pertParam.Phi_M(:, i)) ~= 1
            disp(['Not summing to 1 at Phi_M: ', num2str(i)]);
            keyboard
        end
    end

    %     Dynamic
    pertParam.sigma = Params.sigma;
    pertParam.L = Params.L;
    pertParam.A_TFP = Params.A_TFP;
    pertParam.E_Land = Params.E_Land;
    pertParam.F_EX = Params.F_EX;
    pertParam.theta1 = Params.theta1;
    
    %     Damages (note this changes in dice_dynamics.m)
    pertParam.ddamage = perturbs.ddamage;
    
end
