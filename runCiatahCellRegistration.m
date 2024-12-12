

%cell registration options

opts.maxDistance = 5; % distance in pixels between centroids for them to be grouped
opts.trialToAlign = 1; % which session to start alignment on
opts.nCorrections = 1; %number of rounds to register session cell maps.
opts.RegisTypeFinal = 2; % 3 = rotation/translation and iso scaling; 2 = rotation/translation, no iso scaling


% Run alignment code


[alignmentStruct] = ciapkg.api.matchObjBtwnTrials(cellsForSort_cell_array,'options',opts);

%%
% Global IDs is a matrix of [globalID sessionID]
% Each (globalID, sessionID) pair gives the within session ID for that particular global ID
globalIDs = alignmentStruct.globalIDs;

%%

% View the cross-session matched cells, saved to `private\_tmpFiles` sub-folder.
[success] = ciapkg.api.createMatchObjBtwnTrialsMaps(cellsForSort_cell_array,alignmentStruct);