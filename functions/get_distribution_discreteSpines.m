function solution = get_distribution_discreteSpines(spineDist, params)

% number of segments between neighbouring spines and interval boundaries
nEdges       = numel(spineDist);

%% get coefficients for ODE equations and boundary conditions

coeff        = get_odeCoeffsWithDiscreteSpines(params, nEdges, spineDist);

%% auxiliary definitions

% create a (4*nEdges x 8*nEdges)-matrix to target p variables at the end of
% each segment except the last one (i.e., each spine location)
%
% Example: nEdges = 2, i.e., one spine. 
% 
%  Sketch:       soma |---- edge 1 ----| spine |---- edge 2 ----| tip
%
%       in(1)         in(2)        out(1)        out(2)         BCs at:
%             p             p             p             p
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0   \    spine
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0    |   spine 
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0    |   spine
%    0  0  0  0    0  0  0  0    0  0  0  1    0  0  0  0   /    spine
%                                         ^
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0   \     tip
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0    |   soma
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0    |   soma
%    0  0  0  0    0  0  0  0    0  0  0  0    0  0  0  0   /    soma

get_p_4nx8n  = [0, 0, 0, 0;
                0, 0, 0, 0;
                0, 0, 0, 0;
                0, 0, 0, 1];
get_p_4nx8n  = repmat({get_p_4nx8n},nEdges - 1, 1);
get_p_4nx8n  = sparse([zeros(4*nEdges), blkdiag(get_p_4nx8n{:}, zeros(4))]);

% Create matrices to add values to the previous/next equation row
addToPrevRow = sparse(diag(ones(4*nEdges-1, 1), 1));

%% ------------------ Solve the ODE's ------------------  

% Set the tolerances of bvp5c such that ||res/solution - e-8|| < e-8, for
% further definitions of absolute and relative tolerance see mathworks.com
options      = bvpset('AbsTol', 10^(-8), 'RelTol', 10^(-4), 'Stats', 'off');

% Create and initiate the guess on a mesh with only few mesh points
meshPoints   = 5;
solinit      = bvpinit(linspace(0, 1, meshPoints), ones(4*nEdges, 1));

% Solve the ODE system with boundary conditions. 
% bvp5c is a finite difference code that implements the four-stage Lobatto
% IIIa formula. This is a collocation formula and the collocation 
% polynomial provides a C1-continuous solution that is fifth-order accurate 
% uniformly in [a,b]. The formula is implemented as an implicit Runge-Kutta 
% formula.

% Call the solver up to 'max_runs' times or until the relative tolerance is
% met
solution     = get_odeSolution(solinit, 0);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Local functions                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------  
% transport equation and boundary condition function
%--------------------------------------------------------  

    function dydt = transporteq(t,y)
        % multiply the vector of variables with the coefficient matrix
        v    = y(1:4*nEdges);
        dydt = coeff.eq * v;
        clear v;
    end

    function res = transportbc(ya, yb)
        % The boundary condition at the last spine is
        %
        %                                  1       phi
        %  (BC 1)      0 = p_nEdges(1) - ------ --------- eta_p ,
        %                                 perm   1 - phi
        %
        % In the coefficient matrix, it is defined in the third-last 
        % row. We now add the minimal supply term to (BC 1):
        % 
        %                     1       phi                                   1       phi
        % 0 = p_nEdges(1) - ------ --------- eta_p  <=>  0 = yb(nEdges) - ------ --------- eta_p .
        %                    perm   1 - phi                                perm   1 - phi
        %
        % Use a 4*nEdges-vector to add the minimal supply to the boundary 
        % condition at the last spine (third-last row) 
        minSupply             = zeros(4*nEdges,1);
        minSupply(4*nEdges-2) = - (1/params.permeability)*(params.phi/(1 - params.phi))*params.eta_p;
        % add boundary conditions at distal tip and spine uptake at spine
        % locations to "res"
        v                     = [ya(1:4*nEdges); yb(1:4*nEdges)];
        res                   = minSupply + coeff.bc*v - spineuptake(v);
        clear v
    end

%--------------------------------------------------------  
% spine uptake function
%-------------------------------------------------------- 

    function y = spineuptake(v)
        % Model for the uptake of protein into spines at the defined 
        % locations 'spineLocs'. The upake at one spine is given by
        %
        %                               perm p_in(1)
        %              lambda_p ----------------------------
        %                        (perm / eta_p) p_in(1) + 1
        %
        % Access p_k(1) for all k = 1, ..., nEdges-1 and apply the uptake 
        % function and add to the previous equation 
        %
        %   dg_k(x)/dx = ...
        %
        % Access p_k(1) (hence y(a)) for k = 1, ..., nEdges-1 ...
        % ("get_p_4nx8n" automatically ignores the last edge terminating at
        %  the distal tip)
        y = get_p_4nx8n*v;
        % ... apply uptake function ...
        y = (log(2)/params.halflife_p) ...
            .*(params.permeability.*y) ...
            ./((params.permeability/params.eta_p).*y + 1);
        % ... and add to previous equations
        y = addToPrevRow*y;
    end

%--------------------------------------------------------  
% Recursive call of bvp5c to increase accuracy
%-------------------------------------------------------- 

    function solution = get_odeSolution(solinit, counter)
        % This function solves the ODE system given by 'transporteq' with
        % boundary conditions 'transportbc'. It uses the solution as the new
        % initial guess until either 
        %  1  the required tolerance is met
        %  2  the maximal number of iterations 'counter' has been used
        
        % Get first solution
        solution = bvp5c(@transporteq, @transportbc, solinit, options);
        counter  = counter + 1;
        % check, if actual solution is meets the requested error tolerance.
        % The requested tolerance is set to 10 times the "relative
        % tolerance" of the solver bvp5c.
        if (solution.stats.maxerr > 10*options.RelTol)
            if (counter < params.maxRuns) 
                solution = get_odeSolution(bvpinit(solution, [0, L]), counter);
            else
                disp(solution.stats.maxerr)
            end
        end
    end
end