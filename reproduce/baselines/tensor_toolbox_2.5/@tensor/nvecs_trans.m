function [u, varargout] = nvecs(X,n,r,opts)
%NVECS Compute the leading mode-n vectors for a tensor.
%
%   U = NVECS(X,n,r) computes the r leading eigenvalues of Xn*Xn'
%   (where Xn is the mode-n matricization of X), which provides
%   information about the mode-n fibers. In two-dimensions, the r
%   leading mode-1 vectors are the same as the r left singular vectors
%   and the r leading mode-2 vectors are the same as the r right
%   singular vectors.
%
%   U = NVECS(X,n,r,OPTS) specifies options:
%   OPTS.eigsopts: options passed to the EIGS routine [struct('disp',0)]
%   OPTS.flipsign: make each column's largest element positive [true]
%
%   See also TENSOR, TENMAT, EIGS.
%
%MATLAB Tensor Toolbox.
%Copyright 2012, Sandia Corporation.

% This is the MATLAB Tensor Toolbox by T. Kolda, B. Bader, and others.
% http://www.sandia.gov/~tgkolda/TensorToolbox.
% Copyright (2012) Sandia Corporation. Under the terms of Contract
% DE-AC04-94AL85000, there is a non-exclusive license for use of this
% work by or on behalf of the U.S. Government. Export of this data may
% require a license from the United States Government.
% The full license terms can be found in the file LICENSE.txt


if ~exist('opts','var')
    opts = struct;
end

if isfield(opts,'eigsopts')
    eigsopts = opts.eigsopts;
else
    eigsopts.disp = 0;
end

Xn = double(tenmat(X,n));

% Code for orig. prob.
% Y = Xn*Xn';
% [u,d] = eigs(Y, r, 'LM', eigsopts);

% Code for trans. prob.
Y = Xn'*Xn;
[u2, d] = eigs(Y, r, 'LM', eigsopts);
u = Xn*u2*inv(sqrt(d));

if (nargout > 1)
	varargout = cell(1, nargout - 1);
	varargout{1} = d;
end


if isfield(opts,'flipsign') 
    flipsign = opts.flipsign;
else
    flipsign = true;
end
    
if flipsign
    % Make the largest magnitude element be positive
    [val,loc] = max(abs(u));
    for i = 1:r
        if u(loc(i),i) < 0
            u(:,i) = u(:,i) * -1;
        end
    end
end
