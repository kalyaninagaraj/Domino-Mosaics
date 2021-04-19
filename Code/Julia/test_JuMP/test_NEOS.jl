using JuMP, NEOS

m = Model(solver=NEOSSolver(solver=:CPLEX, email="kalyanin@email.com"))

# Model definition
@variable(m, 0 <= x <= 2 )
@variable(m, 0 <= y <= 30 )

@objective(m, Max, 5x + 3*y )
@constraint(m, 1x + 5y <= 3.0 )

status = solve(m)