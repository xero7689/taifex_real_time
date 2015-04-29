% Taifex Real Time Crawler
% author:xero7689
% email:volleyp7689@gmail.com

clear all;
clc;

% Sample of using taifex_realTime Function
% 直接呼叫taifex_realTime即可使用，參數為一矩陣，元素為欲查詢的期貨商品代號。
% [0]: 表示查詢全部的期貨
% [1,2,3]: 表示查詢第1~3支期貨
% 檔案都會輸出到data資料夾底下，以當天的日期加上所查詢的期貨代號為命名。
taifex_realTime([1, 2, 3]);
