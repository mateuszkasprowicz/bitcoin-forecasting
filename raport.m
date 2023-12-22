function btcBalance = report(trainFile, testFile)
    % Load training and testing data
    trainData = readtable(trainFile, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error", DecimalSeparator=",");
    testData = readtable(testFile, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error", DecimalSeparator=",");
    
    trainData = table2timetable(trainData);
    testData = table2timetable(testData);
    testDates = testData.Date

    data = [testData; trainData];
    % Initialize wallet based on training data
    % Assuming the wallet had 5 Bitcoins and $0 at the end of the training period
    btcWallet = 5;
    usdWallet = 0;

    % Store information for plotting
    dates = testData.Date;

    avgPrices = mean([testData.High, testData.Low], 2); 
    buyPoints = [];
    sellPoints = [];

    % here the logic should be that I combine both datasets and each next
    % day I'm using the test data as well; I'm just doing next day
    % prediction
    % Apply strategy for each day in the test set
    for targetDate = 1:height(testData)
        % Use mymethod to decide on transactions
        [sellUSD, sellBitcoin] = mymethod(testFile, usdWallet, btcWallet);
        
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
