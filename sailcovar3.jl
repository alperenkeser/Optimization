using JuMP, Clp , Printf

d = [40 60 75 25]                   # monthly demand for boats

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:4] <= 40)       # boats produced with regular labor
@variable(m, y[1:4] >= 0)             # boats produced with overtime labor

@variable(m, ha[1:5] >= 0)             # boats held in inventory h+
@variable(m, he[1:5] >= 0)             # boats held in inventory h-

@variable(m, ca[1:4] >= 0)            # c artý(ca) = c+
@variable(m, ce[1:4] >= 0)            # c eksi(ce) = c-

@constraint(m, he[4] <= 0)              # h artý(ha) = h+
@constraint(m, ha[4] >= 10)             # h eksi(h3) = h-

@constraint(m, ha[1] - he[1] == 10 + x[1] + y[1] - d[1]) 
@constraint(m, x[1] + y[1] - 50 == ca[1] - ce[1])

@constraint(m, flow1[i in 2:4], ha[i]-he[i] == ha[i-1] - he[i-1] + x[i] + y[i] - d[i]) 
@constraint(m, flow2[i in 2:4], x[i] + y[i] - x[i-1] - y[i-1] == ca[i] - ce[i])     # conservation of boats

@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(ha) + 100*sum(he) + 400*sum(ca) + 500sum(ce))     # minimize costs

status = optimize!(m)

@printf("Boats to build regular labor (x): %d %d %d %d \n", value(x[1]), value(x[2]), value(x[3]), value(x[4]))
@printf("Boats to build extra labor (y): %d %d %d %d \n", value(y[1]), value(y[2]), value(y[3]), value(y[4]))
@printf("Inventories (h+): %d %d %d %d %d\n ", value(ha[1]), value(ha[2]), value(ha[3]), value(ha[4]), value(ha[5]))
@printf("Inventories (h-): %d %d %d %d %d\n ", value(he[1]), value(he[2]), value(he[3]), value(he[4]), value(he[5]))

@printf("C+: %d %d %d %d\n ", value(ca[1]), value(ca[2]), value(ca[3]), value(ca[4]))
@printf("C-: %d %d %d %d\n ", value(ce[1]), value(ce[2]), value(ce[3]), value(ce[4]))

@printf("Objective cost: %f\n", objective_value(m))