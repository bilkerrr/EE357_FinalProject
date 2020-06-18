b = 0.3;
bribes = 0.02;

ite = 1000000;

len = 50;

result_a = zeros(len, len);
result_b = zeros(len, len);

for tmp1=1:len
    r = tmp1/len;
    for tmp2=1:len
        attacker = tmp2/len/2;
        ra = 0;
        rb = 0;
        ro = 0;

        state = 0;

        choice = 0;

        for i=1:ite
            block1 = rand();
            if block1 <= attacker
                % attacker
                if state >= 0
                    state = state+1;
                else
                    ra = ra+2;
                    state = 0;
                end
            elseif attacker<block1 && block1<=attacker+b
                % bribee
                if state == 0
                    rb = rb+1;
                elseif state == -1
                    rb = rb+2;
                    state = 0;
                elseif state == -2
                    if choice == 0
                        ra = ra+1;
                    else
                        ro = ro+1;
                    end
                    rb = rb+1;
                    state = 0;
                elseif state == 1;
                    state = -1;
                elseif state == 2
                    state = 0;
                    ra = ra+2;
                else
                    state = state-1;
                    ra = ra+1;
                end
            else
                % others
                if state == 0
                    ro = ro+1;
                elseif state == -1
                    block2 = rand();
                    if block2 <= r
                        ra = ra+1;
                    else
                        rb = rb +1;
                    end
                    ro = ro+1;
                    state = 0;
                elseif state == -2
                    block2 = rand();
                    if block2 <= r
                        ra = ra+1;
                    else
                        ro = ro +1;
                    end
                    ro = ro+1;
                    state = 0;
                elseif state == 1;
                    state = -2;
                elseif state == 2
                    state = 0;
                    ra = ra+2;
                else
                    state = state-1;
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
        ra_f=ra_f/(ra+rb+ro);
        ra_f = (ra_f-attacker)/attacker;
        result_a(tmp1, tmp2) = ra_f;
        rb_f=rb_f/(ra+rb+ro);
        rb_f = (rb_f-b)/b;
        result_b(tmp1, tmp2) = rb_f;
    end
end