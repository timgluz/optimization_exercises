/*
The Knapsack problem

It was introduced in the chapter 2.2.3, page.16;
Implementation details were provided in the chapter 4.2.1

Usage:
  minizinc knapsack.mzn knapsack0.dzn

*/

% -- parameters
int: capacity; % number of items fit into knapsack

%int: max_weight = 42; % unsatisfiable
int: max_weight;

int: n; % number of items we have
array[1..n] of int: items;

% -- variables
array[1..n] of var 0..1: selected;

% -- constraints
% exactly capacity items should be included
constraint capacity = sum(i in 1..n)(selected[i]);
%constraint count(i in selected)(i = 1) = 4

% the total of the included numbers should be max_weight
constraint max_weight = sum(i in 1..n)(selected[i] * items[i]);

solve satisfy;

