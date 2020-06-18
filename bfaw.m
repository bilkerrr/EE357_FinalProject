function r = faw_brib(x, a, b, c)
    r = (1-x(1))*a/(1-x(1)*a)+(b/(1-x(1)*a)+c*x(1)*a*(1-a-b)/(1-x(1)*a))*x(1)*a/(b+x(1)*a);
    r = -r;

attacker = 0.2;
vpool = 0.1;
% if no bribe, bribe=0
bribe = 0.02;
bribee = 0.3;

ite = 1000000;

choice = 0;

len = 100;
result_a = zeros(len, (1-alp-bb)*len);
result_v = zeros(len, (1-alp-bb)*len);

for tmp1=1:len
	c = tmp1/len;
	[x, total_reward] = fmincon(@(x) faw_brib(x, attacker, vpool, c), [0.5, 0.5], [], [], [], [], [0, 0], [1, 1]);
	infil = x(1);
	for tmp2=1:(1-attacker-bribee)*len
		vpool = tmp2/len;
        ra = 0;
        rb = 0;
        rv = 0;
        ro = 0;
        rab = 0;
        for i=1:ite
        	block1 = rand();
        	if block1 <= (1-infil)*attacker
        		% innocent mining
        		ra = ra+1;
        	elseif (1-infil)*attacker<block1 && block1<=(1-infil)*attacker+vpool
        		% victim pool
                ra = ra+infil*attacker/(infil*attacker+vpool);
                rv = rv+vpool/(infil*attacker+vpool);
            elseif (1-infil)*attacker+vpool<block1 && block1<=(1-infil)*attacker+vpool+bribee
            	% bribee
                rb = rb+1;
            elseif (1-infil)*attacker+vpool+bribee<block1 && block1<=(1-infil)*attacker+vpool+bribee+(1-attacker-bribee-vpool)
                % others
                ro = ro+1;
            else
                % infiltration mining
                block2 = rand();
                if block2 <= (1-infil)*attacker/(1-infil*attacker)
                    % innocent mining
                    ra = ra+1;
                elseif (1-infil)*attacker/(1-infil*attacker)<block2 && block2<=((1-infil)*attacker+vpool)/(1-infil*attacker)
                    % victim pool
                    ra = ra+infil*attacker/(infil*attacker+vpool);
                    rv = rv+vpool/(infil*attacker+vpool);
                elseif ((1-infil)*attacker+vpool)/(1-infil*attacker)<block2 && block2<=((1-infil)*attacker+vpool+bribee)/(1-infil*attacker)
                    % bribee
                    block3 = rand();
                    if block3 <= attacker
                        % attacker
                        block4 = rand();
                        if block4 <= infil
                            % infiltration
                            ra = ra+infil*attacker/(infil*attacker+vpool);
                            rv = rv+vpool/(infil*attacker+vpool);
                        else
                            % innocent
                            ra = ra+1;
                        end
                        rab = rab+1;
                        ra = ra+infil*attacker/(infil*attacker+vpool);
                        rv = rv+vpool/(infil*attacker+vpool);
                    elseif attacker<block3 && block3<=attacker+vpool
                        % victim
                        rab = rab+1;
                        ra = ra+2*infil*attacker/(infil*attacker+vpool);
                        rv = rv+2*vpool/(infil*attacker+vpool);
                    elseif attacker+vpool<block3 && block3<=attacker+vpool+(1-attacker-bribee-vpool)
                        % others
                        rab = rab+1;
                        ra = ra+infil*attacker/(infil*attacker+vpool);
                        rv = rv+vpool/(infil*attacker+vpool);
                        ro = ro+1;
                    elseif attacker+vpool+(1-attacker-bribee-vpool)<block3 && block3<=1-bribee
                        rb = rb+1;
                        ro = ro+1;
                    else
                        rb = rb+2;
                    end
                else
                    % others
                    % d
                    block3 = rand();
                    if block3 <= attacker
                        % d-1 (attacker)
                        block4 = rand();
                        if block4 <= infil
                            % infiltration
                            ra = ra+infil*attacker/(infil*attacker+vpool);
                            rv = rv+vpool/(infil*attacker+vpool);
                        else
                            % innocent
                            ra = ra+1;
                        end
                        rab = rab+1;
                        ra = ra+infil*attacker/(infil*attacker+vpool);
                        rv = rv+vpool/(infil*attacker+vpool);
                    elseif attacker<block3 && block3<=attacker+vpool
                        % d-1 (victim)
                        rab = rab+1;
                        ra = ra+2*infil*attacker/(infil*attacker+vpool);
                        rv = rv+2*vpool/(infil*attacker+vpool);
                    elseif attacker+vpool<block3 && block3<=attacker+vpool+(1-attacker-bribee-vpool)
                        % d-1 (others)
                        rab = rab+1;
                        ra = ra+infil*attacker/(infil*attacker+vpool);
                        rv = rv+vpool/(infil*attacker+vpool);
                        ro = ro+1;
                    elseif attacker+vpool+(1-attacker-bribee-vpool)<block3 && block3<=1-bribee
                        % d-4 (others)
                        ro = ro+2;
                    else
                        % accept: d-2 / deny: d-3
                        if choice == 0
                            % accept d-2
                            rab = rab+1;
                            ra = ra+infil*attacker/(infil*attacker+vpool);
                            rv = rv+vpool/(infil*attacker+vpool);
                        else
                            % deny d-3
                            ro = ro+1;
                        end
                        rb = rb+1;
                    end
                end
            end
        end
        ra_f = ra;
        rb_f = rb;
        rv_f = rv;
        if choice == 0
            ra_f = ra-rab*bribe;
            rb_f = rb+rab*bribe;
        end 
        ra_f = ra_f/(ra+rb+ro+rv);
        ra_f = (ra_f-attacker)/attacker*100;
        rb_f = rb_f/(ra+rb+ro+rv);
        rb_f = (rb_f-bribee)/bribee*100;
        rv_f = rv_f/(ra+rb+ro+rv);
        rv_f = (rv_f-vpool)/vpool*100;
        result_a(tmp1, tmp2) = ra_f;
        result_v(tmp1, tmp2) = rv_f;
    end
end