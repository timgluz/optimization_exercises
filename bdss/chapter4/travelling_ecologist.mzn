/*
  Travelling Ecologist is short version of famous Travelling Salesman problem;
  It's from chapter 2.2.3, but implementation starts at chapter 4;
*/


% -- parameters
int: n_cities = 4;
int: max_distance = 6000;

array[1..n_cities, 1..n_cities] of int: distances =
[| 0, 1000, 2500, 500 |
  1000, 0,  1500, 3000|
  2500, 1500, 0, 2000 |
  500, 3000, 2000, 0  |];

% -- variables
array[1..n_cities] of var 1..n_cities: X;


% -- constraints
include "alldifferent.mzn";

% all assigned cities must be different
constraint  all_different(X);

% total travel distance should be smaller than max_distanc;
constraint max_distance >= sum(i in 1..n_cities-1)(distances[X[i], X[i + 1]]) + distances[X[n_cities], X[1]];

solve satisfy;
