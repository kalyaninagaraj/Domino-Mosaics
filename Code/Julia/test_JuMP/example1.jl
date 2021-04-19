```
example1.jl
===========
Getting started with JuMP with a `hello world` equivalent problem in
optimization. 


For an explanation of each line, see
https://jump.dev/JuMP.jl/v0.21.6/quickstart/#Quick-Start-Guide
```
using JuMP
import GLPK

model = Model(GLPK.Optimizer)

@variable(model, 0 <= x <= 2)
@variable(model, 0 <= y <= 30)

@objective(model, Max, 5x + 3y)

@constraint(model, con, 1x + 5y <= 3.0)

print(model)

optimize!(model)
print(termination_status(model), "\n")
print(primal_status(model), "\n")
print(dual_status(model), "\n")

print(objective_value(model), "\n")
print(value(x), "\n")
print(value(y), "\n")
print(dual(con), "\n")
x_upper = UpperBoundRef(x)
print(dual(x_upper), "\n")
y_lower = LowerBoundRef(y)
print(dual(y_lower), "\n")