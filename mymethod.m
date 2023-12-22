function [sellUSD, sellBitcoin] = mymethod(filename, usdWallet, btcWallet)
    % Load data considering bitcoin.csv properties
    data = readtable(filename, MissingRule="error", ExpectedNumVariables=5, ExtraColumnsRule="error", DecimalSeparator=",");
    
    data = table2timetable(data);
    
    % Define the short-term and long-term windows for moving averages
    shortTermWindow = 20;
    longTermWindow = 50;

    % Calculate moving averages
    shortTermMA = movmean(data.Close, shortTermWindow);
    longTermMA = movmean(data.Close, longTermWindow);

    % Get the last day's moving averages
    lastShortTermMA = shortTermMA(end);
    lastLongTermMA = longTermMA(end);

    % Buying signal: Short-term MA crosses above Long-term MA
    % Selling signal: Short-term MA crosses below Long-term MA
    if lastShortTermMA > lastLongTermMA
        % Buy Bitcoin using 10% of USD wallet
        sellUSD = usdWallet * 0.1;
        sellBitcoin = 0;
    elseif lastShortTermMA < lastLongTermMA
        % Sell 10% of Bitcoin holdings
        sellBitcoin = btcWallet * 0.1;
        sellUSD = 0;
    else
        % No action
        sellUSD = 0;
        sellBitcoin = 0;
    end
end
