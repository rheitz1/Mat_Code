% loads AD or DSP channels from a file
% chan argument takes 'ALL','AD','DSP','EEG', or 'LFP'
%
% use 'decodeChaStruct' after
%
% RPH

function [loadList] = loadChan(file,chans)

loadList = [];
warning off

q = '''';

switch chans
    case 'AD' %All AD channels
        
        
        try
            load(file,'AD01')
            assignin('caller','AD01',AD01)
            loadList = [loadList ; 'AD01'];
        end
        
        try
            load(file,'AD02')
            assignin('caller','AD02',AD02)
            loadList = [loadList ; 'AD02'];
        end
        
        try
            load(file,'AD03')
            assignin('caller','AD03',AD03)
            loadList = [loadList ; 'AD03'];
        end
        
        try
            load(file,'AD04')
            assignin('caller','AD04',AD04)
            loadList = [loadList ; 'AD04'];
        end
        
        try
            load(file,'AD05')
            assignin('caller','AD05',AD05)
            loadList = [loadList ; 'AD05'];
        end
        
        try
            load(file,'AD06')
            assignin('caller','AD06',AD06)
            loadList = [loadList ; 'AD06'];
        end
        
        try
            load(file,'AD07')
            assignin('caller','AD07',AD07)
            loadList = [loadList ; 'AD07'];
        end
        
        
        try
            load(file,'AD09')
            assignin('caller','AD09',AD09)
            loadList = [loadList ; 'AD09'];
        end
        
        try
            load(file,'AD10')
            assignin('caller','AD10',AD10)
            loadList = [loadList ; 'AD10'];
        end
        
        try
            load(file,'AD11')
            assignin('caller','AD11',AD11)
            loadList = [loadList ; 'AD11'];
        end
        
        try
            load(file,'AD12')
            assignin('caller','AD12',AD12)
            loadList = [loadList ; 'AD12'];
        end
        
        try
            load(file,'AD13')
            assignin('caller','AD13',AD13)
            loadList = [loadList ; 'AD13'];
        end
        
        try
            load(file,'AD14')
            assignin('caller','AD14',AD14)
            loadList = [loadList ; 'AD14'];
        end
        
        try
            load(file,'AD15')
            assignin('caller','AD15',AD15)
            loadList = [loadList ; 'AD15'];
        end
        
        try
            load(file,'AD16')
            assignin('caller','AD16',AD16)
            loadList = [loadList ; 'AD16'];
        end
        
        try
            load(file,'AD17')
            assignin('caller','AD17',AD17)
            loadList = [loadList ; 'AD17'];
        end
        
        
    case 'ALL' %All AD and DSP channels
        varlist = who('-file',file);
        DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
        clear varlist
        
        try
            load(file,'AD01')
            assignin('caller','AD01',AD01)
            loadList = [loadList ; 'AD01'];
        end
        
        try
            load(file,'AD02')
            assignin('caller','AD02',AD02)
            loadList = [loadList ; 'AD02'];
        end
        
        try
            load(file,'AD03')
            assignin('caller','AD03',AD03)
            loadList = [loadList ; 'AD03'];
        end
        
        try
            load(file,'AD04')
            assignin('caller','AD04',AD04)
            loadList = [loadList ; 'AD04'];
        end
        
        try
            load(file,'AD05')
            assignin('caller','AD05',AD05)
            loadList = [loadList ; 'AD05'];
        end
        
        try
            load(file,'AD06')
            assignin('caller','AD06',AD06)
            loadList = [loadList ; 'AD06'];
        end
        
        try
            load(file,'AD07')
            assignin('caller','AD07',AD07)
            loadList = [loadList ; 'AD07'];
        end
        
        
        try
            load(file,'AD09')
            assignin('caller','AD09',AD09)
            loadList = [loadList ; 'AD09'];
        end
        
        try
            load(file,'AD10')
            assignin('caller','AD10',AD10)
            loadList = [loadList ; 'AD10'];
        end
        
        try
            load(file,'AD11')
            assignin('caller','AD11',AD11)
            loadList = [loadList ; 'AD11'];
        end
        
        try
            load(file,'AD12')
            assignin('caller','AD12',AD12)
            loadList = [loadList ; 'AD12'];
        end
        
        try
            load(file,'AD13')
            assignin('caller','AD13',AD13)
            loadList = [loadList ; 'AD13'];
        end
        
        try
            load(file,'AD14')
            assignin('caller','AD14',AD14)
            loadList = [loadList ; 'AD14'];
        end
        
        try
            load(file,'AD15')
            assignin('caller','AD15',AD15)
            loadList = [loadList ; 'AD15'];
        end
        
        try
            load(file,'AD16')
            assignin('caller','AD16',AD16)
            loadList = [loadList ; 'AD16'];
        end
        
        try
            load(file,'AD17')
            assignin('caller','AD17',AD17)
            loadList = [loadList ; 'AD17'];
        end
        
        
        %now get all the DSP channels
        for DSPchan = 1:size(DSPlist,1)
            eval(['load(' q file q ',' q DSPlist(DSPchan,:) q ');'])
            eval(['assignin(' q 'caller' q ',' q DSPlist(DSPchan,:) q ',' DSPlist(DSPchan,:) ')'])
          %  loadList = [loadList ; DSPlist(DSPchan,:)];
        end
        
    case 'LFP' % just LFP
        
        monkey = file(1);
        %deal with 'corrected' database
        if monkey == 'c'; monkey = file(2); end
        
        if monkey == 'S'
            try
                load(file,'AD09')
                assignin('caller','AD09',AD09)
                loadList = [loadList ; 'AD09'];
            end
            
            try
                load(file,'AD10')
                assignin('caller','AD10',AD10)
                loadList = [loadList ; 'AD10'];
            end
            
            try
                load(file,'AD11')
                assignin('caller','AD11',AD11)
                loadList = [loadList ; 'AD11'];
            end
            
            try
                load(file,'AD12')
                assignin('caller','AD12',AD12)
                loadList = [loadList ; 'AD12'];
            end
            
            try
                load(file,'AD13')
                assignin('caller','AD13',AD13)
                loadList = [loadList ; 'AD13'];
            end
            
            try
                load(file,'AD14')
                assignin('caller','AD14',AD14)
                loadList = [loadList ; 'AD14'];
            end
            
            try
                load(file,'AD15')
                assignin('caller','AD15',AD15)
                loadList = [loadList ; 'AD15'];
            end
            
            try
                load(file,'AD16')
                assignin('caller','AD16',AD16)
                loadList = [loadList ; 'AD16'];
            end
        elseif monkey == 'Q'
            try
                load(file,'AD04')
                assignin('caller','AD04',AD04)
                loadList = [loadList ; 'AD04'];
            end
            
            try
                load(file,'AD09')
                assignin('caller','AD09',AD09)
                loadList = [loadList ; 'AD09'];
            end
            
            try
                load(file,'AD10')
                assignin('caller','AD10',AD10)
                loadList = [loadList ; 'AD10'];
            end
            
            try
                load(file,'AD11')
                assignin('caller','AD11',AD11)
                loadList = [loadList ; 'AD11'];
            end
            
            try
                load(file,'AD12')
                assignin('caller','AD12',AD12)
                loadList = [loadList ; 'AD12'];
            end
            
            try
                load(file,'AD13')
                assignin('caller','AD13',AD13)
                loadList = [loadList ; 'AD13'];
            end
            
            try
                load(file,'AD14')
                assignin('caller','AD14',AD14)
                loadList = [loadList ; 'AD14'];
            end
            
            try
                load(file,'AD15')
                assignin('caller','AD15',AD15)
                loadList = [loadList ; 'AD15'];
            end
            
            try
                load(file,'AD16')
                assignin('caller','AD16',AD16)
                loadList = [loadList ; 'AD16'];
            end
        end
        
        
    case 'EEG' %just EEG
        
        monkey = file(1);
        if monkey == 'c'; monkey = file(2); end
        
        if monkey == 'S' || monkey == 'P'
            
            try %do iteratively so that we are not left with nothing when it fails
                load(file,'AD01')
                assignin('caller','AD01',AD01)
                loadList = [loadList ; 'AD01'];
            end
            
            try
                load(file,'AD02')
                assignin('caller','AD02',AD02)
                loadList = [loadList ; 'AD02'];
            end
            
            try
                load(file,'AD03')
                assignin('caller','AD03',AD03)
                loadList = [loadList ; 'AD03'];
            end
            
            try
                load(file,'AD04')
                assignin('caller','AD04',AD04)
                loadList = [loadList ; 'AD04'];
            end
            
            try
                load(file,'AD05')
                assignin('caller','AD05',AD05)
                loadList = [loadList ; 'AD05'];
            end
            
            try
                load(file,'AD06')
                assignin('caller','AD06',AD06)
                loadList = [loadList ; 'AD06'];
            end
            
            try
                load(file,'AD07')
                assignin('caller','AD07',AD07)
                loadList = [loadList ; 'AD07'];
            end
            
        elseif monkey == 'Q'
            
            try
                load(file,'AD01')
                assignin('caller','AD01',AD01)
                loadList = [loadList ; 'AD01'];
            end
            
            try
                load(file,'AD02')
                assignin('caller','AD02',AD02)
                loadList = [loadList ; 'AD02'];
            end
            
            try
                load(file,'AD03')
                assignin('caller','AD03',AD03)
                loadList = [loadList ; 'AD03'];
            end
        elseif monkey == 'F'
            
            try
                load(file,'AD01')
                assignin('caller','AD01',AD01)
                loadList = [loadList ; 'AD01'];
            end
            
            try
                load(file,'AD02')
                assignin('caller','AD02',AD02)
                loadList = [loadList ; 'AD02'];
            end
            
            try
                load(file,'AD03')
                assignin('caller','AD03',AD03)
                loadList = [loadList ; 'AD03'];
            end
            
            try
                load(file,'AD04')
                assignin('caller','AD04',AD04)
                loadList = [loadList ; 'AD04'];
            end
            
            try
                load(file,'AD05')
                assignin('caller','AD05',AD05)
                loadList = [loadList ; 'AD05'];
            end
        end
        
    case 'DSP'
        varlist = who('-file',file);
        DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
        clear varlist
        
        
        if isempty(DSPlist)
            disp('No DSP channels found...')
            ChanStruct = [];
            return
        end
        
        for DSPchan = 1:size(DSPlist,1)
            eval(['load(' q file q ',' q DSPlist(DSPchan,:) q ');'])
            eval(['assignin(' q 'caller' q ',' q DSPlist(DSPchan,:) q ',' DSPlist(DSPchan,:) ')'])
            loadList = [loadList ; DSPlist(DSPchan,:)];
        end
        
end

warning on