function btcBalance = raport(trainFile, testFile)
    %report.m Plots the test period investment decisions (buy/sell) together 
    % with the price of Bitcoin; saves a plot to strategia.jpg. 
    % Displays a table with the portfolio performance in Bitcoin for each day. 
    % Returns a portfolio balance at the end of a specified period.
    % Inputs:
    %   trainFile   : a path to a file with training data in a .csv format
    %   testFile   : a path to a file with test data in a .csv format
    % Outputs:
    %   btcBalance  : A portfolio balance at the end of a period in Bitcoin

    trainData = readtable(trainFile, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error", DecimalSeparator=",");
    testData = readtable(testFile, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error", DecimalSeparator=",");
    
    trainData = table2timetable(trainData);
    testData = table2timetable(testData);
    testDates = testData.Date;

    data = [testData; trainData];
    % Initialize wallet based on training data
    % Assuming the wallet had 5 Bitcoins and $0 at the end of the training period
    btcWallet = 5;
    usdWallet = 0;

    avgPrices = mean([testData.High, testData.Low], 2); 
    buyPoints = [];
    sellPoints = [];

    % Apply strategy for each day in the test set
    for i = 1:length(testDates)
        target = testDates(i);
        history = timerange("-inf", target, intervalType="openright");
        
        [sellUSD, sellBitcoin] = mymethod(data(history), usdWallet, btcWallet);
        
        % Update wallet based on the decision
        currentPrice = avgPrices(i);
        btcWallet = btcWallet + sellUSD / currentPrice - sellBitcoin;
        usdWallet = usdWallet + sellBitcoin * currentPrice - sellUSD;

        % Record buy/sell points for graph
        if sellUSD > 0
            buyPoints = [buyPoints; i];
        elseif sellBitcoin > 0
            sellPoints = [sellPoints; i];
        end

        % Display wallet balance in Bitcoins
        fprintf('Day %d: Wallet balance = %.4f BTC\n', i, btcWallet);
    end

    % Plotting the graph
    % TODO: Add a separate function for plotting
    figure;
    plot(dates, avgPrices, 'k-');  % Black line for average Bitcoin prices
    hold on;
    plot(dates(buyPoints), avgPrices(buyPoints), 'ro');  % Red points for buying actions
    plot(dates(sellPoints), avgPrices(sellPoints), 'go');  % Green points for selling actions
    title('Bitcoin Trading Strategy');
    xlabel('Date');
    ylabel('Average Price (USD)');
    saveas(gcf, 'strategia.jpg');

    % Return the final balance in Bitcoins
    btcBalance = btcWallet;
end
