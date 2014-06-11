function plot_jpstc(jpstc_data, scale)
	if nargin < 2
		scale = 1.37; % seems to be ideal for printing .pdfs
	end
	if nargin < 1
		jpstc_data = jpstc();
	end
	figure_handle = figure('Tag','correlogram','NumberTitle','off',...
					'Name','JPSTC Figure','Menubar','none','Resize','off',...
					'Units','points','Position',[50 50 scale*420 scale*580],...
					'PaperPositionMode','manual',...
					'PaperUnits','normalized',...
					'PaperPosition',[0 0 1 1],...
					'Color',[1 1 1]);
	print_information(figure_handle, scale, jpstc_data.info);
	draw_jpstc(figure_handle, scale, [scale*45 scale*20], jpstc_data);
end

function print_information(figure_handle, scale, info)
	set(gcf,'Units','points');
	axes('parent',figure_handle,'Units','points',...
			'position',[scale*0 scale*520 scale*420 scale*50],...
			'xtick',[],'ytick',[],'Visible','off','xlim',[0 1],'ylim',[0 1])
	text(.1, .75, info.filename,'FontSize',scale*12,'FontUnits','points',...
						'Units','normalized','interpreter','none');
	text(.5, .75,[info.signal_1_name ' v ' info.signal_2_name],...
					'FontSize',scale*12,'FontUnits','points',...
						'Units','normalized','interpreter','none');
	text(.1, .25,['Align Event: ' info.align_event ],...
					'FontSize',scale*12,'FontUnits','points',...
						'Units','normalized','interpreter','none');
	text(.5, .25,['Type of Trials: ' info.type_of_trials],...
					'FontSize',scale*12,'FontUnits','points',...
						'Units','normalized','interpreter','none');
end

function draw_jpstc(figure_handle, scale, origin, data)
	origin_x = origin(1);
	origin_y = origin(2);
	graph_size = scale * 50;
	jpstc_size = scale * 200;
	% PSTC 1
	pstc_1 = axes('Parent',figure_handle,'Tag','pstc1','Units','points',...
					'Position',[origin_x origin_y+scale*280 graph_size jpstc_size]);
	switch (data.info.signal_1_name(1:2))
		case 'AD'
			plot(data.normal.pstc_1);
		case 'DS'
			bar(data.normal.pstc_1);
			set(pstc_1,'XLim',[0 length(data.normal.pstc_1)]);
	end
	set(pstc_1,'cameraupvector',[1 0 0]); % this command rotates plot to vertical axis
	set(pstc_1,'XTick',get(gca,'XLim'),'YTick',get(gca,'YLim'));
	% JPSTC
	jpstc_image = axes('Parent',figure_handle,'Tag','jpstc','Units','points',...
						'Position',[origin_x+scale*70 origin_y+scale*280 jpstc_size jpstc_size],...
						'PlotBoxAspectRatio',[1 1 1],'DataAspectRatio',[1 1 1]);
	imagesc(data.normal.jpstc(end:-1:1,:)); % notice that we must flip jpstc for correct display
	set(jpstc_image,'XTick',zeros(1,0),'YTick',zeros(1,0));
	% Create colorbar
	colorbar('peer',jpstc_image,'Units','points',...
				'Position',[origin_x+scale*290 origin_y+scale*280 scale*20 jpstc_size]);
	% PSTC 2
	pstc_2 = axes('Parent',figure_handle,'Tag','pstc2','Units','points',...
			'Position',[origin_x+scale*70 origin_y+scale*210 jpstc_size graph_size]);
	switch (data.info.signal_2_name(1:2))
		case 'AD'
			plot(data.normal.pstc_2);
		case 'DS'
			bar(data.normal.pstc_2);
			set(pstc_2,'XLim',[0 length(data.normal.pstc_2)]);
	end
	set(pstc_2,'XTick',get(gca,'XLim'),'YTick',get(gca,'YLim'));
	% Correlogram 1
	axes('Parent',figure_handle,'Units','points',...
			'Position',[origin_x+scale*70 origin_y+scale*140 jpstc_size graph_size]);
	plot(data.normal.correlation(:,1),data.normal.correlation(:,2));
	set(gca,'XTick',get(gca,'XLim'),'YTick',get(gca,'YLim'));
	y_lims = get(gca,'YLim');
	shuffled_min = min(data.shuffled.correlation(:,2));
	shuffled_max = max(data.shuffled.correlation(:,2));
	if shuffled_min > y_lims(1) && shuffled_max < y_lims(2)
		line(get(gca,'XLim'), [shuffled_min shuffled_min],'Color','red', 'LineStyle','--');
		line(get(gca,'XLim'), [shuffled_max shuffled_max],'Color','red', 'LineStyle','--');
	end
	clear ylims shuffled_min shuffled_max
	% Coicidence
	axes('Parent',figure_handle,'Tag','coincidence','Units','points',...
			'Position',[origin_x+scale*70 origin_y+scale*70 jpstc_size graph_size]);
	area(data.normal.coincidence(:,1),data.normal.coincidence(:,2));
	set(gca,'XTick',get(gca,'XLim'),'YTick',get(gca,'YLim'));
	% Correlogram 2
	axes('Parent',figure_handle,'Tag','correlogram2','Units','points',...
			'Position',[origin_x+scale*70 origin_y jpstc_size graph_size]);
	plot(data.normal.correlation(:,1),data.normal.correlation(:,2));
	set(gca,'XLim', [-20 20]); % zoom in on x-axis
	set(gca,'XTick',get(gca,'XLim'),'YTick',get(gca,'YLim'));
	y_lims = get(gca,'YLim');
	shuffled_min = min(data.shuffled.correlation(:,2));
	shuffled_max = max(data.shuffled.correlation(:,2));
	if shuffled_min > y_lims(1) && shuffled_max < y_lims(2)
		line(get(gca,'XLim'), [shuffled_min shuffled_min],'Color','red', 'LineStyle','--');
		line(get(gca,'XLim'), [shuffled_max shuffled_max],'Color','red', 'LineStyle','--');
	end
end
