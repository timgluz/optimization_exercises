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


% all heights of visible skyscrapers adds up to NORTHs
% constraint forall(n in 1..n_cols)()

% check costs from NORTH
array[1..n_rows, 1..n_cols] of var 1..9: north_view;
constraint forall(j in 1..n_cols, i in 1..n_rows)
  (if i = 1 then
    north_view[i, j] = puzzle[i, j]
  else
    north_view[i, j] = max(puzzle[i, j], north_view[i - 1, j])
  endif);

% the each NORTH column should add up to given limits
constraint forall(j in 1..n_cols)
  (NORTH[j] =
      sum(i in 1..n_rows where north_view[i, j] = puzzle[i, j])(north_view[i, j]));

% check costs from WEST
array[1..n_rows, 1..n_cols] of var 1..9: west_view;
constraint forall(i in 1..n_rows, j in 1..n_cols)
  (if j = 1 then
    west_view[i, j] = puzzle[i, j]
   else
    west_view[i, j] = max(puzzle[i, j], west_view[i, j-1])
   endif);

% the each WEST column sould add up to the given limits on left side
constraint forall(i in 1..n_cols)
  (WEST[i] =
    (sum(j in 1..n_cols where west_view[i, j] = puzzle[i, j])(west_view[i, j])));

solve satisfy;

output [(show_int(3, puzzle[i, j]) ++
          if (j mod 3) = 0 then "||" else "|" endif ++
          if (j mod n_cols) = 0 then "\n" else "" endif
        ) | i in 1..n_rows, j in 1..n_cols];
