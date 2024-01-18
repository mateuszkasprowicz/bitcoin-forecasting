function portfolioValueBtc = raport(trainFile, testFile)
    %RAPORT Plots the test period investment decisions (buy/sell) together 
    % with the price of Bitcoin; saves a plot to strategia.jpg. 
    % Displays a table with the portfolio performance in Bitcoin for each day. 
    % Returns a portfolio balance at the end of a specified period.

    arguments
        trainFile {mustBeFile}
        testFile {mustBeFile}
    end

    trainData = readtimetable(trainFile, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error", DecimalSeparator=",");
    testData = readtimetable(testFile, MissingRule="error", ExpectedNumVariables=5, ...
        ExtraColumnsRule="error", DecimalSeparator=",");

    tmpFile = [tempname,'.csv'];

    testPeriod = testData.Date;
    lengthTestPeriod = length(testPeriod);

    avgPrices = mean([testData.High, testData.Low], 2); 

    btcWallet = 5;
    usdWallet = 0;

    buyPoints = false(lengthTestPeriod);
    sellPoints = false(lengthTestPeriod);

    for i = 1:lengthTestPeriod
        target = testPeriod(i);
        history = timerange("-inf", target);

        updatedTrainData = [testData; trainData(history, :)];
        writetimetable(updatedTrainData, tmpFile)
        
        [sellUSD, sellBitcoin] = mymethod(tmpFilePath, usdWallet, btcWallet);
        
        currentPrice = avgPrices(i);
        if sellUSD
            buyPoints(i) = true;
            btcWallet = btcWallet + sellUSD / currentPrice;
            usdWallet = usdWallet - sellUSD;
        elseif sellBitcoin
            sellPoints(i) = true;
            usdWallet = usdWallet + sellBitcoin * currentPrice;
            btcWallet = btcWallet - sellBitcoin;
        end

        currentPortfolioValueBtc = btcWallet + usdWallet / currentPrice;

        fprintf('Day %d: Portfolio value = %.4f BTC\n', i, currentPortfolioValueBtc);
    end
    
    plottestperiod(avgPrices, testPeriod, buyPoints, sellPoints);

    portfolioValueBtc = currentPortfolioValueBtc;

    delete(tmpFile);
end

function plottestperiod(avgPrices, dates, buyPoints, sellPoints)
%PLOTTESTPERIOD Plots an average Bitcoin price and buying/selling points

    figure;
    plot(dates, avgPrices, 'k-');
    hold on;
    grid on, grid minor
    datetick('x', 2,'keepticks')
    plot(dates(buyPoints), avgPrices(buyPoints), 'ro');
    plot(dates(sellPoints), avgPrices(sellPoints), 'go');
    title('Bitcoin Trading Strategy');
    xlabel('Date');
    ylabel('Average Price (USD)');
    saveas(gcf, 'strategia.jpg');
end


