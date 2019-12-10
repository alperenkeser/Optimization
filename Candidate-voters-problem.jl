#-------------------------------------Problem--------------------------------------------#

#   250 candidates participated in an election and 5000 voters cast their votes. 
#   If the candidates with the same number of votes are grouped in the same group, 
#   what is the minimum number of candidates that will be in the largest of these groups?

#----------------------------------------------------------------------------------------#


#-------------------------------------Solution-------------------------------------------#
using JuMP, Clp, Cbc ,Printf

m = Model(with_optimizer(Cbc.Optimizer))

s = 5001 # s is size of group.

@variable(m, 0<= g[1:s] <= 250 , Int) # g means group. Array is how many vote they get (g[2] (2-1) 1 vote get this group).
@variable(m, max >= 0, Int) # max is  max group size.

@constraint(m, sum(g) == 250) # sum of group(g) gives 250 candidates
@constraint(m, sum((i-1)*g[i] for i in 1:s) == 5000) # the sum of the multiplication of the people in the group(g[i]) and their votes(i-1) must be equal to 5000. 

@constraint(m, [i=1:s], max >= g[i]) 
@objective(m, Min, max)

status = optimize!(m)


for i in 1:s
    if value(g[i])>0
    @printf("Group[%d] : %d \n",i,value(g[i]))
    end
end

@printf("Max group size : %d \n",value(z))

@printf("Sums : %d",value(sum((i-1)*g[i] for i in 1:s)))
