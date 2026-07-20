%==============================================================
% File : matlab/reference_decoder.m
%==============================================================

clear;
clc;

%% Parameters

M = 10;
N = 20;

MAX_ITER = 10;

%% Load H

H = zeros(M,N);

% Fill according to ldpc_h_matrix.sv
% (Placeholder)

%% Channel LLR

Lch = [
42
38
35
51
29
41
36
47
32
44
40
39
34
48
43
46
31
37
45
33
];

Lch = double(Lch(:));

%% Initialization

Q = zeros(M,N);
R = zeros(M,N);

for c = 1:M

    idx = find(H(c,:));

    for v = idx

        Q(c,v)=Lch(v);

    end

end

%% Iterative Decoding

for iter=1:MAX_ITER

    %% Check Node Update

    for c=1:M

        idx=find(H(c,:));

        q=Q(c,idx);

        s=prod(sign(q));

        a=abs(q);

        [m1,pos]=min(a);

        tmp=a;

        tmp(pos)=inf;

        m2=min(tmp);

        for k=1:length(idx)

            if k==pos
                mag=m2;
            else
                mag=m1;
            end

            sg=s*sign(q(k));

            R(c,idx(k))=sg*mag;

        end

    end

    %% Variable Node Update

    APP=Lch;

    for v=1:N

        rows=find(H(:,v));

        APP(v)=Lch(v)+sum(R(rows,v));

        for c=rows'

            others=setdiff(rows,c);

            Q(c,v)=Lch(v)+sum(R(others,v));

        end

    end

    %% Hard Decision

    bits=(APP<0);

    %% Syndrome

    syn=mod(H*bits,2);

    fprintf('Iteration %d\n',iter);

    disp(bits')

    if all(syn==0)

        fprintf('Decode Success\n');
        break;

    end

end

fprintf('Finished\n');
