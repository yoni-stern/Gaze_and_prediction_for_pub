%% RW with sticky parameter
%based on lik_M3RescorlaWagner_depdQ_v4
% written by YS 10/2/24


function NegLL = lik_RW_with_sticky(resp_vec, reward_vec, alpha, beta,rho)


Q = [0.5 0.5];


T = length(resp_vec);

Q = [0.5 0.5];


T = length(resp_vec);

% loop over all trial
for t = 1:T

    if t>1
    % 1. give value of 1 to choice that is repitiotion of previous trial
    rep_vec=[0,0];
    rep_vec(resp_vec(t-1))= 1; %choice that was made on previous trial is given value of 1
    else
       rep_vec=[0,0];
    end
    

    % 2. compute choice probabilities
    %with stickiness parameter and repition value
    p = exp(beta*Q + rho*rep_vec) / sum(exp(beta*Q+rho*rep_vec));

    % 3. extract the choice probability for choice actually made
    choiceProb(t) = p(resp_vec(t));

    % update values
    delta = reward_vec(t) - Q(resp_vec(t));
    Q(resp_vec(t)) = Q(resp_vec(t)) + alpha * delta;
    % updating the Q not chosen so that Q1 + Q2 =1
    Q([1,2]~=resp_vec(t))=1-Q(resp_vec(t));

end

% compute negative log-likelihood
NegLL = -sum(log(choiceProb));
end

