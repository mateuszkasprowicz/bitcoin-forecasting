function portfolioValueBtc = raport(trainFile, testFile)
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

    testPeriod = testData.Date;
    lengthTestPeriod = length(testPeriod);

    data = [testData; trainData];
    avgPrices = mean([testData.High, testData.Low], 2); 

    % Assuming the wallet had 5 Bitcoins and $0 at the end of the training period
    btcWallet = 5;
    usdWallet = 0;

    buyPoints = zeros(lengthTestPeriod);

    for i = 1:lengthTestPeriod
        target = testPeriod(i);
        history = timerange("-inf", target, intervalType="openright");
        
        [sellUSD, sellBitcoin] = mymethod(data(history), usdWallet, btcWallet);
        
        currentPrice = avgPrices(i);
        if sellUSD
            buyPoints(i) = 1;
            btcWallet = btcWallet + sellUSD / currentPrice;
        else
            usdWallet = usdWallet + sellBitcoin * currentPrice;
        end

        currentPortfolioValueBtc = btcWallet + usdWallet * currentPrice;

        fprintf('Day %d: Portofolio value = %.4f BTC\n', i, currentPortfolioValue);
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
    portfolioValueBtc = currentPortfolioValueBtc;
end
