function [commandLines, remainder] = TempoParse(stream)%function accepts a stream of characters received from Tempo, and calls%within the scope of the function calling TempoParse the functions within%the input stream.  %%If the final command in the input stream is incomplete, then we return %in remainder all of the characters following the last complete command in the% stream.    %% 5/11/00  awi wrote it.%break stream into strings of single cammands, find reaminder.  Semicolons mark the %end of of a command.streamLen = length(stream);if (streamLen ~= 0)	endNdxs = find(stream == ';');	if ~isempty(endNdxs);		numCommands = length(endNdxs);		lastEnd = endNdxs(numCommands);		if (lastEnd < streamLen)			remainder = stream((lastEnd + 1):streamLen);		else			remainder = '';		end %if..else		commandLines = {};		startNdxs = [1 (endNdxs(1:numCommands - 1) + 1)];		for i = 1:numCommands			commandLines{i} = stream(startNdxs(i):endNdxs(i));		end %for	else %if 		remainder = stream;		commandLines = '';	end %elseelse	commandLines = '';	remainder = '';end %if..else	