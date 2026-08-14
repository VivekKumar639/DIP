clc;
clear;
close all;

ticket = zeros(3,9);

% Number of numbers required in each column
columnCount = zeros(1,9);

% Select 15 positions
while true

    positions = zeros(3,9);

    % Select 5 positions in each row
    for row = 1:3
        pos = randperm(9,5);
        positions(row,pos) = 1;
    end

    columnCount = sum(positions,1);

    % Every column must contain at least one number
    if all(columnCount > 0)
        break;
    end

end

% Number ranges for each column
minNum = [1 10 20 30 40 50 60 70 80];
maxNum = [9 19 29 39 49 59 69 79 90];

% Fill the ticket
for col = 1:9

    rows = find(positions(:,col));

    % Generate unique numbers for this column
    nums = randperm(maxNum(col)-minNum(col)+1, length(rows));
    nums = nums + minNum(col) - 1;

    % Sort numbers in ascending order
    nums = sort(nums);

    % Put numbers into the selected rows
    for k = 1:length(rows)
        ticket(rows(k),col) = nums(k);
    end

end

% Display ticket
disp('Tambola Ticket:');
disp(ticket);