function coeff = get_odeCoeffsWithDiscreteSpines(params, nEdges, spineDist)

% author: CORNELIUS BERGMANN
%
% modified 06.08.2021
%
% This function calculates the coefficient matrix for the transport 
% equation on a linear segment with 'nEdges' segments induced by 
% nEdges-1 spines. The lengths of the nEdges segments are contained 
% in 'spineDist'. and the matrix encoding the boundary conditions at 
% x=0, x=1 and every spine location and saves them as 'coeff.eq' and 
% 'coeff.bc'.

%% load necessary parameters

D_m        = params.DEns_m;
D_p        = params.DEns_p;
tRate      = params.tRate;
lambda_m   = log(2)/params.halflife_m;
lambda_p   = log(2)/params.halflife_p;
somaRet    = params.somaRet;

%% ------ coefficients for the transport equation ------

% Starting with the ODE system 
%
%              0 = D_m m''(x) - lambda_m m(x)
%              0 = D_p p''(x) - lambda_p p(x) + tau m(x)
%
% on each segment parametrized on [0, L] with L the length of the 
% segment. Transform the variables according to
%
%       z = x/L , h_1(z) := h(x) = h(z L)     for     h = m, p.
%
% It follows for the derivatives and henceforth the ODE's:
%
%               dh_1(z)/dz = dh(z L)/dz = L dh(x)/dx.
%
% With abuse of notation write h_1 = h. Define
%
%                      f(z) = (D_m/L) dm(z)/dz
%                      g(z) = (D_p/L) dp(z)/dz
%
% which lead to the system of first order ODE's
%
% df(z)/dz =                L lambda_m m(z)
% dm(z)/dz = (L/D_m) f(z) 
% dg(z)/dz =              -      L tau m(z)                + L lambda_p p(z)
% dp(z)/dz =                                  (L/D_p) g(z) 
%
% or in matrix notation
%
%      |     0 lambda_m     0        0 |     |f(x)|
%  L x | 1/D_m        0     0        0 |  x  |m(x)|
%      |     0     -tau     0 lambda_p |     |g(x)|
%      |     0        0 1/D_p        0 |     |p(x)|
%
% where L depends on the actual segment.
%
% First define the coefficient matrix at each segment to be
A = [     0, lambda_m,     0,        0;
      1/D_m,        0,     0,        0;
          0,   -tRate,     0, lambda_p;
          0,        0, 1/D_p,        0];

% set up a diagonal block (4*num_edges x 4*num_edges)-matrix
%
%   A       |
%     \     | num_edges-times
%       A   |
%
A = repmat({A},nEdges,1);
A = blkdiag(A{:});

% To include the different lengths of the segments, define a diagonal 
% matrix containing 4-tuples of all segmental lengths and multiply with 
% coefficient matrix A
%
% Set up the matrix C
C = eye(4*nEdges);
v = transpose([0, 1, 2, 3]);

for k = 1:nEdges
    C(4*k-3+v,4*k-3+v) = eye(4)*spineDist(k);
end

coeff.eq = sparse(A*C);
clear A C

%% - define the coefficients for the boundary conditions -   

B = zeros(4*nEdges, 8*nEdges);

% At the nodes 2, ... nSpines-1 define the following boundary 
% conditions:
%
%  (BC 1) L_in f_in(1) - L_out f_out(0) = 0
%  (BC 2)      m_in(1) -       m_out(0) = 0
%                                                          perm p_in(1)
%  (BC 3) L_in g_in(1) - L_out g_out(0) = lambda_p ----------------------------
%                                                   (perm / eta_p) p_in(1) + 1
%  (BC 4)      p_in(1) -       p_out(0) = 0
%
% Set up the matrix C_in with the length of the "in" segments
C_in                      = eye(4*nEdges-4);
for k = 1:(nEdges-1)
    lenRatio              = 2*spineDist(k)/(spineDist(k) + spineDist(k + 1));
    C_in(4*k-3+v,4*k-3+v) = diag([lenRatio; 1; lenRatio; 1]);
end
% set the boundary conditions of the "in" segments
B(1:(4*nEdges-4), 5:(4*nEdges)  ) = C_in;

% Set up the matrix C_out with the length of the "out" segments
C_out                      = eye(4*nEdges-4);
for k = 1:(nEdges-1)
    lenRatio               = 2*spineDist(k+1)/(spineDist(k) + spineDist(k + 1));
    C_out(4*k-3+v,4*k-3+v) = diag([lenRatio; 1; lenRatio; 1]);
end
% set the boundary conditions of the "out" segments
B(1:(4*nEdges-4), (4*nEdges+1):(8*nEdges-4)) = - C_out;
% (the uptake in (BC 3) is added when handing equations over to "bvp5c")

% At the initial node (soma), define the boundary condition
%             _
%            /                 somaRet       tau 
%           |  0 = g_1(0) - ------------- ---------- f_1(0), somaRet < 1
%  (BC 1)  <                 1 - somaRet   lambda_m
%           |  0 = f_1(0)                                  , somaRet = 1
%            \_
%
if somaRet < 1
    B(4*nEdges-3, 3) = 1;
    B(4*nEdges-3, 1) = - somaRet/(1 - somaRet)*tRate/lambda_m;
elseif somaRet == 1
    B(4*nEdges-3, 1) = 1;
end

% At the last spine, define the boundary condition
%
%                                  1       phi
%  (BC 1)  0 = p_{nEdges-1}(1) - ------ --------- eta_p ,
%                                 perm   1 - phi
%
B(4*nEdges-2, 8*(nEdges-1)) = 1;
% (the minimal supply is added when handing equations over to "bvp5c")

% At the terminal node (distal tip), define the two boundary conditions
%  (BC 1)      0 = f_nEdges(1) ,
%  (BC 2)      0 = g_nEdges(1) ,
%
B(4*nEdges-1, 8*nEdges-3) = 1;
B(4*nEdges  , 8*nEdges-1) = 1;

coeff.bc = sparse(B);
clear B C_in C_out lenRatio
end