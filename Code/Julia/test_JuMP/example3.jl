# Example 3
# =========
# Bob Bosch's linear assignment problem (assign professors to classes)
# that he presented in his talk at Google
# https://www.youtube.com/watch?v=g3CiVrN-BnY

using JuMP
import GLPK

classassignment = Model(GLPK.Optimizer)

cost = [2.5 3.5 4.0 4.0 3.5;
        2.5 1.5 2.5 1.5 4.0;
        4.0 3.0 3.5 2.0 3.5;
        3.5 4.0 3.5 2.5 4.0;
        4.0 3.5 3.5 2.0 1.5]

# x_ij = 1 if professor i teaches class j, and 0 if not
@variable(classassignment, x[i=1:5, j=1:5], Bin);

@objective(classassignment, Min, sum(cost .* x ))

# 1. Each professor teaches one class
for i = 1:5
    # sum of each row of x_ij's equals 1
    @constraint(classassignment, sum(x[i,j] for j in 1:5) == 1)
end

# 2. Each class receives a professor
for j = 1:5
    # sum of each column of x_ij's equals 1
    @constraint(classassignment, sum(x[i,j] for i in 1:5) == 1)
end

# print(classassignment)


# And finally, solve problem
optimize!(classassignment)

display(value.(x))