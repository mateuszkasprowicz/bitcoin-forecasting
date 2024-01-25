function [sellUSD, sellBitcoin] = mymethod(file, usdWallet, btcWallet) 
    %MYMETHOD Implements trading strategy. Returns selling/buying decision
    %for next day
    arguments
        file {mustBeFile}
        usdWallet {mustBeNonnegative}
        btcWallet {mustBeNonnegative}
    end
    data = readtimetable(file, MissingRule="error", ExpectedNumVariables=5, ...
        DecimalSeparator=".", ExtraColumnsRule="error");

    mustBeInOhlcFormat(data)

    sellUSD = 0;
    sellBitcoin = btcWallet * 0.1;
 end

function mustBeInOhlcFormat(timetbl)
    correct_columns = {"Close","High","Low", "Open"};
    if ~isequal(sort(timetbl.Properties.VariableNames), correct_columns)
        msg = "The timetable must have following columns: Close, High, Low, and Open";
        error(msg)
    end
end
