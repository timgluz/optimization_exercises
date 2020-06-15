/*
  Assigment problem.

  Assign N task to M agents to that totalValue exceed the minimum Limit;

  usage:
    minizinc assignment.mzn assignment0.dzn
*/

% -- parameters
enum people;
enum tasks;

array[people, tasks] of int: value;
set of int: vals;
int: limit;

% -- variables
array[tasks] of var people: A; % assignments
array[tasks] of var vals: TV; % task values
var int: totalValue;

% -- constraints
include "alldifferent.mzn";
constraint all_different(A);

% assign task values for each assigned item
constraint forall(t in tasks)
  (TV[t] = value[A[t], t]);

constraint totalValue = sum(t in tasks)(TV[t]);
constraint totalValue >= limit;

solve satisfy;

