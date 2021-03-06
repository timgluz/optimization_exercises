include "alldifferent.mzn";

int: ROW_TOTAL = 30;
int: COL_TOTAL = 30;
int: n_rows = 6;
int: n_cols = 6;

array[1..n_cols] of int: NORTH = [8, 18, 9, 13, 14, 15];
array[1..n_cols] of int: SOUTH = [21, 9, 20, 22, 24, 16];
array[1..n_rows] of int: WEST = [17, 16, 17, 22, 15, 15];
array[1..n_rows] of int: EAST = [16, 13, 18, 9, 14, 16];

array[1..n_rows, 1..n_cols] of var 1..9: puzzle;

% each square in grid contains a single digit from 1 to 9
constraint forall(i, j in 0..1)
  (alldifferent(p, q in 1..2)(puzzle[3 * i + p, 3 * j + q]));

% all rows are different
constraint forall(i in 1..n_rows)
  (alldifferent(j in 1..n_cols)(puzzle[i, j]));

% all columns are different
constraint forall(j in 1..n_cols)
  (alldifferent(i in 1..n_rows)(puzzle[i, j]));

% all rows sum to 30
constraint forall(i in 1..n_rows)
  (ROW_TOTAL = sum(j in 1..n_cols)(puzzle[i, j]));

% all columns sums are 30
constraint forall(j in 1..n_cols)
  (COL_TOTAL = sum(i in 1..n_rows)(puzzle[i, j]));


% -- visible houses from NORTH
array[1..n_rows, 1..n_cols] of var 0..1: north_view;
constraint forall(j in 1..n_cols, i in 1..n_rows)
  (north_view[i, j] = if i = 1 then
    1
  else
    bool2int(puzzle[i, j] > max([puzzle[n, j] | n in 1..(i-1)]))
  endif);

% each NORTH column should add up to given limits
constraint forall(j in 1..n_cols)
  (NORTH[j] = sum(i in 1..n_rows)(north_view[i, j] * puzzle[i, j]));

% -- find visible houses from WEST
array[1..n_rows, 1..n_cols] of var 0..1: west_view;

constraint forall(i in 1..n_rows, j in 1..n_cols)
  (west_view[i, j] = if j = 1 then
    1
   else
    bool2int(puzzle[i, j] > max([puzzle[i, n] | n in 1..(j-1)]))
   endif);

% the each WEST column sould add up to the given limits on left side
constraint forall(i in 1..n_rows)
  (WEST[i] = sum(j in 1..n_cols)(west_view[i, j] * puzzle[i, j]));

% -- visible houses from EAST
array[1..n_rows, 1..n_cols] of var 0..1: east_view;

constraint forall(i in 1..n_rows, j in 1..n_cols)
  (east_view[i, j] = if j = n_cols then
    % all items of last column are visible from east
    1
   else
    bool2int(puzzle[i, j] > max([puzzle[i, n] | n in (j + 1)..n_cols]))
   endif);

% the each EAST column should add up to correct heights
constraint forall(i in 1..n_rows)
  (EAST[i] = sum(j in 1..n_cols)(east_view[i, j] * puzzle[i, j]));

% -- visible houses visible from SOUTH
array[1..n_rows, 1..n_cols] of var 0..1: south_view;

% any higher house than all previous one, are visible
constraint forall(j in 1..n_cols, i in 1..n_rows)
  (south_view[i,j] = if i = n_rows then
     1
   else
     bool2int(puzzle[i, j] > max([puzzle[n, j] | n in (i + 1)..n_rows]))
   endif);

% the each SOUTH column should add up to correct heights
constraint forall(j in 1..n_cols)
  (SOUTH[j] - sum(i in 1..n_rows)(south_view[i, j ] * puzzle[i, j]) = 0);

solve satisfy;

output
["North view:\n"] ++
[show(north_view[i, j]) ++ (if j mod n_cols = 0 then "\n" else ", " endif) | i in 1..n_rows, j in 1..n_cols] ++
["\n"] ++
["West view:\n"] ++
[show(west_view[i, j]) ++ (if j mod n_cols = 0 then "\n" else ", " endif) | i in 1..n_rows, j in 1..n_cols] ++
["\n"] ++
["East view:\n"] ++
[show(east_view[i, j]) ++ (if j mod n_cols = 0 then "\n" else ", " endif) | i in 1..n_rows, j in 1..n_cols] ++
["\n"] ++
["South view:\n"] ++
[show(south_view[i, j]) ++ (if j mod n_cols = 0 then "\n" else ", " endif) | i in 1..n_rows, j in 1..n_cols] ++
["\n"] ++
["Solution:\n"] ++
[(show_int(3, puzzle[i, j]) ++
  if (j mod 3) = 0 then "||" else "|" endif ++
  if (j mod n_cols) = 0 then "\n" else "" endif
) | i in 1..n_rows, j in 1..n_cols];
