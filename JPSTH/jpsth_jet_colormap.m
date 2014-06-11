function [this_colormap] = jpsth_jet_colormap(cm_length)
	if nargin < 1, cm_length=65; end
	if mod(cm_length,2)==0, cm_length=cm_length+1; end
	this_colormap = zeros(cm_length, 3);
	
	clim = get(gca,'CLim');
	cmin = clim(1);
	cmax = clim(2);
	zero_i = fix((0-cmin)/(cmax-cmin)*cm_length)+1;
	
	neg_length = zero_i - 1;
	pos_length = cm_length - zero_i;
	
	for i = 1:2*neg_length/3
		j = i-1;
		this_colormap(i,:) = [0 j/(2*neg_length/3) 1];
	end
	
	start_index = fix(2*neg_length/3)+1;
	for i = start_index:zero_i-1
		j = length(start_index:zero_i-1) - (i - start_index) - 1;
		this_colormap(i,:) = [0 1 (3*j/neg_length)^.7];
	end
	
	this_colormap(zero_i,:) = [0 1 0];
		 
	start_index = zero_i+1;
	for i = start_index:zero_i+(pos_length/3)
		j = i - start_index;
		this_colormap(i,:) = [(3*j/(pos_length))^.7 1 0];
	end
	
	start_index = fix(zero_i+(pos_length/3))+1;
	for i = start_index:cm_length
		j = length(start_index:cm_length) - (i - start_index) - 1;
		this_colormap(i,:) = [1 (j/(2*pos_length/3)) 0];
	end
	
end
