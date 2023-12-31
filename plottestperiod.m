function plottestperiod(avgPrices, dates, buyPoints, sellPoints)
%PLOTTESTPERIOD Summary of this function goes here
%   Detailed explanation goes here
figure;
plot(dates, avgPrices, 'k-');  % Black line for average Bitcoin prices
hold on;
grid on, grid minor
datetick('x', 2,'keepticks')
plot(dates(buyPoints), avgPrices(buyPoints), 'ro');  % Red points for buying actions
plot(dates(sellPoints), avgPrices(sellPoints), 'go');  % Green points for selling actions
title('Bitcoin Trading Strategy');
xlabel('Date');
ylabel('Average Price (USD)');
saveas(gcf, 'strategia.jpg');
end

