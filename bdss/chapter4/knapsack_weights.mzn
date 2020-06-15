/*
The Knapsack problem where each item has weight
and the knapsack has limited total capacity;

usage:
  minizinc knapsack_weights.mzn knapsack2.dzn
*/

% -- parameters
int: weightLimit;
int: itemCount;
array[1..itemCount] of int: weights;
array[1..itemCount] of int: values;

% include "knapsack2.dzn"

% -- variables
array[1..itemCount] of var 0..1: selected;
var int: totalValue;

% -- constraints
constraint weightLimit >= sum(i in 1..itemCount)(selected[i] * weights[i]);
constraint totalValue = sum(i in 1..itemCount)(selected[i] * values[i]);

%solve satisfy;
solve maximize totalValue;
