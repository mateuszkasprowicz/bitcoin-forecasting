function [sellUSD, sellBitcoin] = mymethod(file, usdWallet, btcWallet) 
    %MYMETHOD Implements trading strategy. Returns selling/buying decision
    %for next day
    arguments
        file {mustBeFile}
        usdWallet {mustBeNonnegative}
        btcWallet {mustBeNonnegative}
    end
    data = readtimetable(file, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error");

    shortTermWindow = 20;
    longTermWindow = 50;

    shortTermMA = movmean(data.Close, shortTermWindow);
    longTermMA = movmean(data.Close, longTermWindow);

    lastShortTermMA = shortTermMA(end);
    lastLongTermMA = longTermMA(end);

    sellUSD = 0;
    sellBitcoin = 0;

    if lastShortTermMA > lastLongTermMA
        sellUSD = usdWallet * 0.1;
    elseif lastShortTermMA < lastLongTermMA
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

