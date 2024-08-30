function [sub_tbt] = fill_eye_resp(sub_tbt)
% adapted function for filling eye 
% 18/1/24
%instead of filling two tables. here we use a single table that is the
%output of the pre-processing for publication

%function joins eye resp with explicit response. If there is missing data,
%then for eye resp and resp cntngcy it codes the explicit response

% preliminaries
T=[1:159];
% T=sub_tbt.TrialNumber;
% eye_col_names2choose={'m_gz','m_bf_gz','m_pred_gz','m_cue_gz','eye_acc','eye_rule_acc','eye_resp_cntgcy','eye_resp'}; %this line for replication

sub_tbt.orig_eye_resp=sub_tbt.eye_resp;
% % adding to sub_tbt relevant columns for eye data
% empty_eye_resp_tbl=[array2table(nan(length(T),length(eye_col_names2choose)-1)),cell2table(cell(length(T),1),"VariableNames",["eye_resp"])];
% 
% empty_eye_resp_tbl.Properties.VariableNames=eye_col_names2choose;
% 
% sub_tbt=[sub_tbt,empty_eye_resp_tbl];

%% getting to work- looping through trial

for t=1:length(T)
if (t==5)
    g=9;
end

if(~isnan(sub_tbt.m_gz(T(t)))& ...
        (~isempty(find(sub_tbt.TrialNumber==T(t)))) &...
        (sub_tbt.eye_resp{sub_tbt.TrialNumber==T(t)}=="right"|sub_tbt.eye_resp{sub_tbt.TrialNumber==T(t)}=="left"))%ensure that there is eye data
   

    else % there is no eye data for the trial

        %replace eye resp with explicit response
        sub_tbt(sub_tbt.TrialNumber==T(t),"eye_resp")=sub_tbt(sub_tbt.TrialNumber==T(t),"QuestionResult");

        %replace eye_resp_cntgcy with explicit eye resp contingency
        sub_tbt(sub_tbt.TrialNumber==T(t),"eye_resp_cntgncy")=sub_tbt(sub_tbt.TrialNumber==T(t),"resp_cntgncy");
        
        sub_tbt(sub_tbt.TrialNumber==T(t),"eye_acc")=sub_tbt(sub_tbt.TrialNumber==T(t),"is_acc");

    end
end
