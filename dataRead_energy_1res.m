% dataRead_energy_1res.m
% Project csgA adsorption
% YJL 12/8/2015
% Description: Function reads in energy files output by vmd and saves a MAT
% file with the energy for each residue over time. The energy files are 
% organized by residue and give the energy for the surface-residue 
% interaction during adsorption. 
%   NB: EDB used Stride of 10
% Input:
%   expSurf = eg: gr or si
%   expStr = eg: LH_0
%   dp = directory containing energy files
%   saveDP = directory to save matrix of energy for each residue over time
% Output:
%   none
% Saved file(s):
%   E is a MAT file with the energy for each residue over time
% Example Use
%   dir = 'D:\Profile\jyl365\Downloads';
%   saveDP = 'D:\Profile\jyl365\Documents\Graphene';
% 
%   expSurf = 'si'; expStr = 'LH_0';
%   dp = [dir '\' expSurf '_' expStr];
%   dataRead_energy_1res(expSurf, expStr, dp, saveDP);


function [] = proc_read_energy_1res(expSurf, expStr, dp, saveDP)
fileStr = 'allfiles-res';

% Find energy for all residue-surface interactions
dataE = nan(4000,131);
%   % Iterate across all residues
for resNo = 1:131
    fp = [dp '\' fileStr num2str(resNo) '.txt'];
    E_res = read_energy_1res(fp);
    dataE(:,resNo) = E_res;
end

% clean up nans
dataE(isnan(dataE(:,1)),:) = [];

% save file
dp = saveDP; 
saveStr = [expSurf '_surfContE_'];

%   % E
E = dataE;
fp = [dp '\' saveStr expStr '.mat'];
save(fp,'E');
end

function [E] = read_energy_1res(fp)
E = nan(4000,1); % data vector
ctr = 1; % counter
if exist(fp, 'file')
    fid = fopen(fp);
    while ~feof(fid)
        strLine = fgetl(fid);
        if strncmp(strLine,'output',6)
            strLine = fgetl(fid);
        else
            dataLine = str2double(strsplit(strLine));
            if ~isempty(dataLine)
                energy = dataLine(end-1);
                E(ctr) = energy; ctr = ctr+1;
            end
        end
    end
    
else
    disp('ERROR: file does not exist')
end

% % clean up nan Edit: do this later
% E(isnan(E))=[];
end
