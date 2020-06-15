/*
The Harbourmaster problem introduced in the chapter 2.2.3;

A number of boats are waiting to enter harbour,
the harbour master must decide to which dock any boat should go,
given that some boats may not fit into some docks;

Usage:
  minizinc boats.mzn
*/

enum docks = {dock1, dock2, dock3};

% include "boats_data.dzn"

% variable of domain docks, names as Boat1
var docks: Boat1;
var docks: Boat2;
var docks: Boat3;
var docks: Boat4;
var docks: Boat5;

constraint Boat1 != dock1;
constraint Boat2 != dock1;

solve satisfy;

