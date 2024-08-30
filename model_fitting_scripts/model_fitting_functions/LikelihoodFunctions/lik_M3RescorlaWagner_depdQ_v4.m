%% script that works best- 240323

% This is the likelihood function for dependent Q updating
%adapted for Uri 22/03/23
%written by YS 16/03/23
function NegLL = lik_M3RescorlaWagner_depdQ_v4(resp_vec, reward_vec, alpha, beta)


Q = [0.5 0.5];


T = length(resp_vec);

% loop over all trial
for t = 1:T

    % compute choice probabilities
    p = exp(beta*Q) / sum(exp(beta*Q));

    % compute choice probability for actual choice
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