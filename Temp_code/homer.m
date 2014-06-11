function [] = homer(n)


%Silly program to echo Homer simpson quotes similar to the 'why' command

%Homer simpson quotes taken from:
%http://www.wattpad.com/3859
%http://www.thesimpsonsquotes.com/characters/homer-simpson-quotes.html

%Richard Heitz, Vanderbilt
%richard.p.heitz@vanderbilt.edu

q = '''';

if nargin < 1
    x = ceil(randinterval(1,[0 66])); 

else
    x = n;
end


switch x

    case 1
        disp('Weaseling out of things is important to learn. Its what separates us from the animals ... except the weasel.')

    case 2
        disp('Kids, you tried your best and you failed miserably. The lesson is, never try.')

    case 3
        disp(['[drunk] Look, the thing about my family is there' q 's five of us. Marge, Bart, Girl Bart, the one who doesn' q 't talk, and the fat guy. How I loathe him.'])

    case 4
        disp('How is education supposed to make me feel smarter? Besides, every time I learn something new, it pushes some old stuff out of my brain. Remember when I took that home winemaking course, and I forgot how to drive?')

    case 5
        disp(['Marge: Homer, the plant called. They said if you don' q 't show up tomorrow don' q 't bother showing up on Monday.'])
        disp('Homer: Woo-hoo. Four-day weekend!')

    case 6
        disp('Homer no function beer well without.')

    case 7
        disp(['Yeah, Moe, that team sure did suck last night. They just plain sucked! I' q 've seen teams suck before, but they were the suckiest bunch of sucks that ever sucked!'])

    case 8
        disp(['Here' q 's to alcohol, the cause of and solution to all life' q 's problems.'])

    case 9
        disp('This has purple in it. Purple is a fruit. ')

    case 10
        disp(['I' q 'm normally not a praying man, but if you' q 're up there, please save me Superman.'])

    case 11
        disp(['What' q 's a wedding?  Webster' q 's dictionary describes it as the act of removing weeds from one' q 's garden.'])

    case 12
        disp('Fame was like a drug, but what was even more like a drug were the drugs.')

    case 13
        disp(['Lisa: Do we have any food that wasn' q 't brutally slaughtered?'])
        disp('Homer: Well, I think the veal died of loneliness.')

    case 14
        disp('Marge: Homer, is this how you pictured married life?')
        disp('Homer: Yeah, pretty much, except we drove around in a van solving mysteries.')

    case 15
        disp(['The only monster here is the gambling monster that has enslaved your mother! I call him Gamblor, and it' q 's time to snatch your mother from his neon claws!'])

    case 16
        disp(['If The Flintstones has taught us anything, it' q 's that pelicans can be used to mix cement.'])

    case 17
        disp(['When I held that gun in my hand, I felt a surge of power ... like God must feel when he' q 's holding a gun.'])

    case 18
        disp(['Facts are meaningless. You could use facts to prove anything that' q 's even remotely true!'])

    case 19
        disp(['You don' q 't like your job, you don' q 't strike. You go in every day and do it really half-assed. That' q 's the American way.'])

    case 20
        disp(['Son, when you participate in sporting events, it' q 's not whether you win or lose: it' q 's how drunk you get.'])

    case 21
        disp(['I am so smart! I am so smart! S-M-R-T! I mean S-M-A-R-T...'])

    case 22
        disp(['Getting out of jury duty is easy. The trick is to say you' q 're prejudiced against all races.'])

    case 23
        disp('Oh, so they have internet on computers now!')

    case 24
        disp(['Good things don' q 't end with ' q 'eum,' q ' they end with ' q 'mania' q ' or ' q 'teria' q '.' ])

    case 25
        disp(['Old people don' q 't need companionship. They need to be isolated and studied so it can be determined what nutrients they have that might be extracted for our personal use.'])

    case 26
        disp(['Bart, with $10,000, we' q 'd be millionaires! We could buy all kinds of useful things like...love!'])

    case 27
        disp('Marge, it takes two to lie. One to lie and one to listen.')

    case 28
        disp(['Marge, I' q 'm going to miss you so much. And it' q 's not just the sex. It' q 's also the food preparation.'])

    case 29
        disp(['Marge, I' q 'm going to Moe' q 's. Send the kids to the neighbors, I' q 'm coming back loaded!'])

    case 30
        disp(['It' q 's not easy to juggle a pregnant wife and a troubled child, but somehow I managed to fit in eight hours of TV a day.'])

    case 31
        disp(['I' q 'm like that guy who single-handedly built the rocket & flew to the moon. What was his name? Apollo Creed?'])

    case 32
        disp(['"You know, the one with all the well meaning rules that don' q 't work out in real life, uh, Christianity"'])

    case 33
        disp(['I' q 've gone back in time to when dinosaurs weren' q 't just confined to zoos.'])

    case 34
        disp(['Bad bees. Get away from my sugar. Ow. OW. Oh, they' q 're defending themselves somehow!'])

    case 35
        disp(['Uh-huh, uh-huh. Okay. Um Can you repeat the part of the stuff where you said all about uuhhh, things. Uhh... the things.'])

    case 36
        disp('I want the answers now or eventually!')

    case 37
        disp('I feel that if a gun is good enough to protect something as important as a bar, then its good enough to protect my family.')

    case 38
        disp('The lesson is: Our God is vengeful! O spiteful one, show me who to smite and they shall be smoten!')

    case 39
        disp(['If he' q 's so smart, how come he' q 's dead?'])

    case 40
        disp('The problem in the world today is communication. Too much communication.')

    case 41
        disp(['When I look at the smiles on all the children' q 's faces, I just know they' q 're about to jab me with something.'])

    case 42
        disp(['Donuts. Is there anything they can' q 't do?'])

    case 43
        disp(['It' q 's not just a store - it' q 's a Megastore! ' q 'Mega' q ' means ' q 'good,' q ' ' q 'store' q ' means ' q 'thing.' q])

    case 44
        disp(['I' q 've always wondered if there was a god. And now I know there is -- and it' q 's me.'])

    case 45
        disp(['I' q 'm going to the back seat of my car, with the woman I love, and I won' q 't be back for ten minutes!'])

    case 46
        disp(['Kids, kids. I' q 'm not going to die. That only happens to bad people.'])

    case 47
        disp('Oh sure. In theory, communism works. In theory...')

    case 48
        disp('Note to self: Stop. Doing. Anything.')

    case 49
        disp('You mean you gave away both your dogs? You know how I feel about giving.')

    case 50
        disp('God bless those pagans.')

    case 51
        disp(['Well, it' q 's 1 a.m. Better go home and spend some quality time with the kids.'])

    case 52
        disp(['Maybe, just once, someone will call me ' q 'Sir' q ' without adding, ' q 'You' q 're making a scene.' q])

    case 53
        disp('You know, boys, a nuclear reactor is a lot like a woman. You just have to read the manual and press the right buttons.')

    case 54
        disp('Lisa, Vampires are make-believe, like elves, gremlins, and eskimos.')

    case 55
        disp('Oh, people can come up with statistics to prove anything, Kent. 14% of people know that.')

    case 56
        disp('Television! Teacher, mother, secret lover.')

    case 57
        disp('Kill my boss? Do I dare live out the American dream?')

    case 58
        disp(['If something goes wrong at the plant, blame the guy who can' q 't speak English.'])

    case 59
        disp(['I' q 'm never going to be disabled. I' q 'm sick of being so healthy.'])

    case 60
        disp(['Dad, you' q 've done a lot of great things, but you' q 're a very old man, and old people are useless.'])

    case 61
        disp('But Marge, what if we chose the wrong religion? Each week we just make God madder and madder.')

    case 62
        disp(['I think Smithers picked me because of my motivational skills. Everyone says they have to work a lot harder when I' q 'm around.'])

    case 63
        disp(['That' q 's it! You people have stood in my way long enough. I' q 'm going to clown college!'])

    case 64
        disp(['If something' q 's hard to do, then it' q 's not worth doing'])

    case 65
        disp(['I' q 'm in no condition to drive...wait! I shouldn' q 't listen to myself, I' q 'm drunk!'])

    case 66
        disp(['To Start Press Any Key. Where' q 's the ANY key?'])

end


    function [R, ind] = randinterval(N, Interval, Weight)
        % RANDINTERVAL - random numbers within multiple intervals
        %
        %   R = RANDINTERVAL(N, INTERVALS) returns a N-by-N matrix R of random numbers
        %   taken from a uniform distribution over multiple intervals.
        %
        %   Similar to RAND, RANDINTERVAL([N M],..) returns a N-by-M matrix, and
        %   RANDINTERVAL([N M P ...],..) returns a N-by-M-by-P-by-.. array. Note
        %   that a notation similar to rand(N,M,P,..) is not available.
        %
        %   INTERVALS is a N-by-2 matrix in which the rows specify the intervals from
        %   which the numbers are drawn. Each interval is given by a lower bound
        %   (in the first column of INTERVALS) and an upper bound (2nd column of
        %   INTERVALS). If the lower bound equals the upper bound, no numbers will
        %   be drawn from that interval. The upper bound cannot be smaller than the
        %   lower bound.
        %   If INTERVALS is a vector (K-by-1 or 1-by-K), the intervals are
        %   formed as (INTERVALS(1),INTERVALS(2)), (INTERVALS(2),INTERVALS(3)),
        %   ... , (INTERVALS(K-1),INTERVALS(K)). In this case, the number of
        %   intervals N is one less than the number of elements K, i.e., N=K-1.
        %   The relative length of an interval determines the likelihood that a
        %   number is drawn from that interval. For instance, when INTERVALS is [1
        %   2 ; 10 12], the probablity that a number is drawn from the first
        %   interval (1,2) is 1 out of 3, vs 2 out of 3 for the second interval (10,12).
        %
        %   R = RANDINTERVAL(N, INTERVALS, WEIGHTS) allow for weighting each
        %   interval specifically. WEIGHTS is vector with N numbers. These numbers
        %   specify, in combination with the length of the corresponding interval,
        %   the relative likelihood for each interval (i.e., the weight). Larger
        %   values of W(k) increases the likelihood that a number is drawn from the
        %   k-th interval.
        %   For instance, when INTERVALS is [11 12 ; 20 21] and WEIGHTS is [3 1], the
        %   probability that a numbers is drawn from the first interval is 3 out of
        %   4, vs 1 out of 4 for the second interval. Note that both intervals have
        %   the same length. When the intervals do not have the same lengths, the
        %   likelihood that a number is drawn from an interval k, with length L(k)
        %   and weight W(k) is given by the formula:
        %      p(k) = (W(k) x L(k)) / sum(W(i) ./ L(i)),i=1:N
        %
        %   [R, IND] = RANDINTERVAL(..) also returns a index array IND, which has the
        %   same size as R. IND contains numbers between 1 and the number of
        %   intervals. Intervals with zero length and/or a weight of zero will not
        %   be present in IND.
        %
        %   Notes:
        %   - overlapping intervals are allowed, but may produce hard-to-debug
        %     results. In this case a warning is issued. On the other, such
        %     overlapping intervals could be (ab-)used to draw from specific
        %     distributions.
        %   - for a single interval (A B) this function is equivalent to
        %     A + (B-A) * rand(N)
        %
        %   Examples:
        %     % Basic use, no weights
        %     R = randinterval([1,10000], [1 3 ; 5 7 ; 10 15 ; 20 26]) ;
        %       % returns a row vector with 10000 numbers between 1 and 3, between
        %       % 5 and 7, between 10 and 15, or between 20 and 26. Approximately
        %       % 2/5 of the numbers is between 20 and 26:
        %     N = histc(R,[-Inf 1 3 5 7 10 15 20 26 Inf]), N = N ./ sum(N), bar(N)
        %
        %     % Weights
        %     [R,n] = randinterval([10,100], [1 2 ; 100 200 ; -2 -1 ; 12 12], [1 0 2 3]) ;
        %       % returns a 10-by-100 matrix with values in the intervals (-2,-1)
        %       % or (1,2). Roughly 666 numbers are negative:
        %     sum(R(:)<0), sum(n(:)==3)
        %       % The interval (100,200) has a weight of zero, and the interval
        %       % (12,12) has zero length; these are "ignored".
        %     histc(n(:),1:4)
        %
        %     % Adjacent intervals with weights:
        %     [R,n] = randinterval([10000,1], [-2:2],[1 4 2 8]) ;
        %     bar(-2:2,histc(R,-2:2)/100,'histc') ; ylabel('Percentage')
        %
        %   See also RAND, RANDN, RANDPERM
        %       RANDSAMPLE (Stats Toolbox)
        %       RANDP (File Exchange)

        % for Matlab R13 and up
        % version 1.0 (oct 2008)
        % (c) Jos van der Geest
        % email: jos@jasen.nl

        % History
        % Created: oct 2008
        % Revisions: -

        % Argument checks
        error(nargchk(2,3,nargin)) ;

        if ndims(Interval) ~= 2 || ~isnumeric(Interval) || numel(Interval)<2,
            error([mfilename ':IntervalWrongSize'],...
                'INTERVALS should be a N-by-2 (or N-by-1, with N>1) numeric matrix.')
        end

        if min(size(Interval)) == 1,
            % Interval is a vector. Make the bounds column vectors
            LowerBound = reshape(Interval(1:end-1),[],1) ;
            UpperBound = reshape(Interval(2:end),[],1) ;
        elseif size(Interval,2) ~= 2
            error([mfilename ':IntervalWrongSize'],...
                'INTERVALS should be a N-by-2 (or N-by-1) numeric matrix.')
        else
            % Get the lower and upper bounds of the intervals
            LowerBound = Interval(:,1) ;
            UpperBound = Interval(:,2) ;
        end

        if any(UpperBound < LowerBound),
            error([mfilename ':NegativeInterval'],...
                'Intervals cannot be smaller than 0') ;
        end

        if nargin==3 && (~isempty(Weight) || ~isnumeric(Weight)),
            if numel(Weight) ~= numel(LowerBound),
                error([mfilename ':WeightsWrongSize'],...
                    'The number of weights should match the number of intervals.') ;
            end
            if any(Weight < 0)
                error([mfilename ':WeightsNegative'],...
                    'Weights cannot be negative.')
            end
        else
            % default, all intervals are equally likely
            Weight = 1 ;
        end

        tmp = [LowerBound UpperBound] ;
        if any(isnan(tmp(:)) | isinf(tmp(:))) || any(isnan(Weight(:)) | isinf(Weight(:))),
            error('Intervals or weights cannot contain NaNs or Infs.') ;
        end

        % It is nice to give a warning when intervals overlap. If they do, the
        % lowerbound of an interval is smaller than the upperbound of a previous
        % interval, when the intervals are in sorted order
        tmp = sortrows(tmp) ;
        if any(tmp(2:end,1) < tmp(1:end-1,2)),
            warning([mfilename ':OverlappingIntervals'], ...
                'Intervals overlap.') ;
        end

        % The trick is to put all the intervals next to each other. Intervals with
        % larger weights should become larger, so they are more likely. The whole
        % range spans numbers between 0 and IntervalEdges(end):
        IntervalSize = (UpperBound - LowerBound) ;
        IntervalEdges = [0 ; cumsum(Weight(:) .* IntervalSize(:))].' ;

        if IntervalEdges(end) == 0,
            % all intervals had a zero length and/or a zero weight, so there is
            % nothing to do!
            error([mfilename ':AllZero'],...
                'All intervals have a length and/or weight of zero.') ;
        end

        try
            % let RAND catch the errors in the size argument
            R = rand(N) ; % random numbers between 0 and 1
        catch
            % rephrase the error
            ERR = lasterror ;
            ERR.message = strrep(ERR.message,'rand',[mfilename ' (in a call to RAND) ']) ;
            rethrow(ERR) ;
        end

        if isempty(R),
            % nothing to do, e.g. when N contains zero.
            ind = [] ;
            return
        end

        % To which interval do these random random numbers belong
        [ind,ind] = histc(IntervalEdges(end) * R(:),IntervalEdges) ; %#ok, first output is not used

        % now map a new series of random numbers between 0 and 1 to their
        % respective interval. We have to create a new series, otherwise not the
        % all values in an interval are possible.
        R(:) = LowerBound(ind) + IntervalSize(ind) .* rand(numel(R),1) ;

        % also return interval numbers in same shape as R
        ind = reshape(ind,size(R)) ;

        % %#debug plots
        %  E = linspace(min(Interval(:)), max(Interval(:)),100) ;
        %  N2 = histc(R(:),E) ;
        %  figure ;
        %  subplot(2,1,1) ; bar(E,N2,'histc')
        %  subplot(2,1,2) ; plot(sort(R(:)),'k.')
    end
end


