function outDat=MultiDimSelect(inDat,varargin)
%function outDat=MultiDimSelect(inDat,varargin)
% Can simulatneously select array data for specific indices in more than 1 
% dim at a time, without a for loop.
%
% Note- recently adjusted to handle NaNs in input! It will output a NaN for
% the given trial with a NaN input.
%
% inDat is a multi-dimensional array you want to sample from. Each varargin
% corresponds to the indices of inDat to take as samples for each
% subsequent dimension starting with the first. SO the second input to the
% function corresponds to the first dimension, the third input to the
% second dimension, and so on. The indices to be matched correspond to the
% indices input for the first dimension.
%
% It is assumed that the first dim indices are a 1-D vector. Each 
% subsequent dim argument can be a vector of column numbers, or an array of
% indices, with the array of indices being the whole point I wrote this. If
% the number of rows in the argument equals the length of the first dim
% argument vector, it is assumed the numbers refer to indices for the given
% dimension, that correspond to the first dimension indices given in the
% first dim arg. The array can be multiple columns to produce multiple 
% outputs in the given dimension. A vector of column numbers can also be
% chosen, but that's something that matlab can already do with current 
% built-in syntax.
%
% Each dim argument can also be a ':', corresponding to taking all columns
% for that dim, or for later dimensions, no argument can be given, in which
% the program assumes all indices are 1 for that dimension.
%
%Note- if you happen to want the same number of "columns" for a dimension
%as the number of first dimension indices, the program will assume that you
%want one column and that the numbers were indices for each specific row, 
%not column values. To get around this if that's case, split the data and 
%call this twice, or input a 2D array for the later dimension in question,
%i.e. [1 2 3; 1 2 3; 1 2 3] if you wanted columns 1 through 3 for that
%dimension for 3 different rows

sz=size(inDat);
nd=length(sz);
szprod=cumprod(sz(1:end-1)); %this determines what you add to the indices...
nvarargin=length(varargin);

%first determine dimensions of output
outsz=zeros(1,nd);  %this determines how you shape the indices
for id=1:nd      
    if id==1    
        if strcmp(':',varargin{id})     varargin{id}=[1:sz(id)];    end     %check for colon operator in the input
        ninds=length(varargin{1});
        outsz(id)=ninds;
    else
        if id>nvarargin     varargin{id}=ones(ninds,1);     %if a given dimension is present in inDatm but not in varargin, assume that dim to be 1 everywhere
        elseif strcmp(':',varargin{id})     varargin{id}=repmat([1:sz(id)],ninds,1);    %check for colon operator in the input   
        end
        
        if size(varargin{id},1)==ninds  outsz(id)= size(varargin{id},2);    %input size matches ninds, vals taken as trial indices
        elseif size(varargin{id},1)>1 && size(varargin{id},2)>1
            error(['Error- Size of varargin{' num2str(id) '} is: ' num2str(size(varargin{id})) ' and size of varargin{1} is: ' num2str(ninds) '. Size of varargin in more than one dimension can''t be more than one, if the length isn''t equal to the length of varagin{1}.'])
        else
            outsz(id)=length(varargin{id});     %here we have input a vector of different length than ninds; the values are taken to be "column" indices
            if size(varargin{id},1)>size(varargin{id},2)    varargin{id}=varargin{id}'; end
            varargin{id}=repmat(varargin{id},ninds,1);
        end
    end
end
outszprod=cumprod(outsz(2:end));

%gather 1-D indices (of inDat) in proper shape
InputInds=zeros(outsz);
for id=1:nd
    if id==1    varargin{id}=reshape( repmat(varargin{id},1,outszprod(end)),outsz );
    else
        %adjust the numbers in varargin
        varargin{id}=(varargin{id}-1).*szprod(id-1);
        
        %first add vert repmats for prev inputs after d1
        if id>2     varargin{id}=repmat(varargin{id},outszprod(id-2),1);    end
        varargin{id}=reshape( repmat(varargin{id},1,outszprod(end)/outszprod(id-1)),outsz );
    end    
    
    InputInds=InputInds+varargin{id};
end

%Now assign InputInds of inDat to outDat, while taking care of NanInds appropriately
NanInds=find(isnan(InputInds));     
if ~isempty(NanInds)    InputInds(NanInds)=1;   end     %set NanInds to output first index of inDat temporarily
outDat=inDat(InputInds);
if ~isempty(NanInds)    outDat(NanInds)=NaN;   end      %now set those NanInds to output NaN
        