function selectOutliers()
	theFigure=gcf;
	set(theFigure,'Tag','selectOutliers_figure');
	set(theFigure,'KeyPressFcn',@figureKeyPress);
	set(gca,'Tag','waveformsAxes');
	theChildren=get(gca,'Children');
	for thisChild=theChildren
		if strcmp(get(thisChild,'Type'),'line')
			try
				set(thisChild,'Color','b')
				set(thisChild,'ButtonDownFcn',@selectLine) 
				set(thisChild,'Tag','lineObject')
			catch E
				%disp(E.message)
			end
		end
	end
end

function selectLine(src,eventData)
	if strcmp(get(src,'Selected'),'off')
		set(src,'Selected','on','Color','r')
	else
		set(src,'Selected','off','Color','b')
	end
end

function figureKeyPress(src,eventData)
	switch (eventData.Key)
		case 'delete'
			deleteLines
		case 'return'
			exportToDesktop
	end
end

function deleteLines()
	theLines=findobj('Tag','lineObject');
	for i=1:length(theLines)
		thisLine=theLines(i);
		if strcmp(get(thisLine,'Selected'),'on')
			set(thisLine,'Visible','off')
		end
	end
end

function exportToDesktop()
	theLines=findobj('Tag','lineObject');
	logicalMask=strcmp(get(theLines,'Visible'),'off');
	assignin('base','selected',logicalMask);
end