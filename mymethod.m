 function [sellUSD, sellBitcoin] = mymethod(data, usdWallet, btcWallet) 

    arguments
        data (:, 4) timetable {mustBeInOhlcFormat}
        usdWallet (1, 1) {mustBeNonnegative}
        btcWallet (1, 1) {mustBeNonnegative}
    end

    shortTermWindow = 20;
    longTermWindow = 50;

    % Calculate moving averages
    shortTermMA = movmean(data.Close, shortTermWindow);
    longTermMA = movmean(data.Close, longTermWindow);

    % Get the last day's moving averages
    lastShortTermMA = shortTermMA(end);
    lastLongTermMA = longTermMA(end);

    sellUSD = 0;
    sellBitcoin = 0;
    % Buying signal: Short-term MA crosses above Long-term MA
    % Selling signal: Short-term MA crosses below Long-term MA
    if lastShortTermMA > lastLongTermMA
        % Buy Bitcoin using 10% of USD wallet
        % TODO: Add the budget constraint
        sellUSD = usdWallet * 0.1;
    elseif lastShortTermMA < lastLongTermMA
        % Sell 10% of Bitcoin holdings
        sellBitcoin = btcWallet * 0.1;
    end
 end

 function mustBeInOhlcFormat(timetbl)
    correct_columns = {"Close","High","Low", "Open"};
    if ~isequal(sort(timetbl.Properties.VariableNames), correct_columns)
        msg = "The timetable must have following columns: Close, High, Low, and Open";
        error(msg)
    end
 end

