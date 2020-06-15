% Beibery attack with s (simulation)

a = 0.2;
b = 0.3;
r = 1;
bribes = 0.02;

nround = 100000000;

ra = 0;
rb = 0;
ro = 0;

% -1: attacker, bribee
% -2: attacker, others
state = 0;

% 0: accept
% else: deny
choice = 1;



for i=1:nround
    block = rand();
    if block <= a
        % attacker find
        if state >= 0
            % a
            state = state+1;
        else
            % b
            ra = ra+2;
            state = 0;
        end
    elseif a<block && block<=a+b
        % bribee find
        if state == 0
            % e
            rb = rb+1;
        elseif state == -1
            % d-4
            rb = rb+2;
            state = 0;
        elseif state == -2
            % 0: c-2 / else: d-2
            if choice == 0
                ra = ra+1;
            else
                ro = ro+1;
            end
            rb = rb+1;
            state = 0;
        elseif state == 1;
            % f
            state = -1;
        elseif state == 2
            % g
            state = 0;
            ra = ra+2;
        else
            % h
            state = state-1;
            ra = ra+1;
        end
    else
        % others find
        if state == 0
            % e
            ro = ro+1;
        elseif state == -1
            gamma = rand();
            if gamma <= r
                % c-3
                ra = ra+1;
            else
                % d-3
                rb = rb +1;
            end
            ro = ro+1;
            state = 0;
        elseif state == -2
            gamma = rand();
            if gamma <= r
                % c-1
                ra = ra+1;
            else
                % d-1
                ro = ro +1;
            end
            ro = ro+1;
            state = 0;
        elseif state == 1;
            % f
            state = -2;
        elseif state == 2
            % g
            state = 0;
            ra = ra+2;
        else
            state = state-1;
             % h
            ra = ra+1;
        end
    end
end



ra_f = ra;
rb_f = rb;
if choice == 0
    ra_f = ra*(1-bribes);
    rb_f = rb+ra*bribes;
end 
ra_f/(ra+rb+ro)
rb_f/(ra+rb+ro)
