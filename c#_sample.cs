using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;

namespace TaifexDaily
{
    class Program
    {
        static String source_url = "http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx"; //台灣期貨交易所行情資訊網站 期貨商品當日行情報價
        static List<String> latest_data = new List<String>(); //最後更新資料
        static String save_path = "TaifexDaily"; //資料儲存位置
        static int period = 1000; //週期(微秒)
        static int retry = 10; //下載重試次數

        static void Main(String[] args)
        {
            try
            {
                //輸入參數設定週期(微秒)
                if (args.Length >= 1)
                {
                    //若週期不是正整數或零則停止
                    Regex pattern = new Regex("^[0-9]+$");
                    if (pattern.IsMatch(args[0]) == false)
                    {
                        Console.WriteLine("Period time (millisecond) must be a positive integer or zero.");
                        Console.WriteLine("");
                        Console.WriteLine("Stop . . .");
                        Console.WriteLine("Press the Enter key to exit.");
                        Console.ReadLine();
                        return;
                    }

                    period = Int32.Parse(args[0]);
                }

                //輸入參數設定資料儲存位置
                if (args.Length >= 2)
                {
                    save_path = args[1];
                }

                //若資料儲存位置不存在則建立
                if (Directory.Exists(save_path) == false)
                {
                    Directory.CreateDirectory(save_path);
                }
            }
            catch (Exception e2)
            {
                Console.WriteLine(e2.ToString());
                Console.WriteLine("");
                Console.WriteLine("Stop . . .");
                Console.WriteLine("Press the Enter key to exit.");
                Console.ReadLine();
                return;
            }

            //初次測試若錯誤則停止
            Console.WriteLine("Initializing . . .");
            Console.WriteLine("");
            if (get_data(false) == false)
            {
                Console.WriteLine("");
                Console.WriteLine("Stop . . .");
                Console.WriteLine("Press the Enter key to exit.");
                Console.ReadLine();
                return;
            }

            //開始
            Console.WriteLine("");
            Console.WriteLine("Start . . .");
            Console.WriteLine("");
            if (period == 0)
            {
                while (true)
                {
                    get_data(true);
                }
            }
            else
            {
                while (true)
                {
                    get_data(true);
                    System.Threading.Thread.Sleep(period);
                }
            }
        }
        public static Boolean get_data(Boolean record)
        {
            try
            {
                if (record)
                {
                    //開盤時間08:45~13:45，下載資料時間08:35~13:55
                    DateTime time = DateTime.Now;
                    if ((time.Hour < 8) || (time.Hour == 8) && (time.Minute < 35))
                    {
                        TimeSpan sapn = new DateTime(time.Year, time.Month, time.Day, 8, 35, 0) - time;
                        System.Threading.Thread.Sleep((int)sapn.TotalSeconds * 1000);
                        return true;
                    }
                    if ((time.Hour > 13) || (time.Hour == 13) && (time.Minute > 55))
                    {
                        DateTime next_day = time.AddDays(1);
                        TimeSpan sapn = new DateTime(next_day.Year, next_day.Month, next_day.Day, 8, 35, 0) - time;
                        System.Threading.Thread.Sleep((int)sapn.TotalSeconds * 1000);
                        return true;
                    }
                }

                //下載開始時間
                DateTime start_time = DateTime.Now;

                //下載網頁
                String html = Encoding.UTF8.GetString(new WebClient2().DownloadData(source_url));

                //下載結束時間
                DateTime end_time = DateTime.Now;

                //紀錄資料檔名
                String filename = end_time.ToString("yyyyMMdd") + ".txt";

                //尋找tr
                String pattern_1 = @"<tr class=""custDataGridRow""([\S\s]+?)</tr>";
                MatchCollection matches_1 = Regex.Matches(html, pattern_1);
                if (matches_1.Count == 0)
                {
                    Console.WriteLine("Regex pattern_1 no matches.");
                    return false;
                }
                for (int i = 0; i < matches_1.Count; i++)
                {
                    String html_tr = matches_1[i].Groups[1].Value;

                    //尋找td
                    String pattern_2 = @"<td[^>]*>([\S\s]*?)</td>";
                    MatchCollection matches_2 = Regex.Matches(html_tr, pattern_2);
                    if (matches_2.Count == 0)
                    {
                        Console.WriteLine("Regex pattern_2 no matches.");
                        return false;
                    }
                    if (matches_2.Count != 15)
                    {
                        Console.WriteLine("Regex pattern_2 number of matches failed.");
                        return false;
                    }

                    //去除多餘HTML標籤、符號
                    String pattern_replace_1 = "(<[^>]+>| |,|\r|\n|\t)";

                    //0商品 1狀態 2買價 3買量 4賣價 5賣量 6成交價 7漲跌 8振幅 9成交量 10開盤 11最高 12最低 13參考價 14時間
                    String item            = Regex.Replace(matches_2[ 0].Groups[1].Value, pattern_replace_1, "");
                    String status          = Regex.Replace(matches_2[ 1].Groups[1].Value, pattern_replace_1, "");
                    String buy_price       = Regex.Replace(matches_2[ 2].Groups[1].Value, pattern_replace_1, "");
                    String buy_amount      = Regex.Replace(matches_2[ 3].Groups[1].Value, pattern_replace_1, "");
                    String sell_price      = Regex.Replace(matches_2[ 4].Groups[1].Value, pattern_replace_1, "");
                    String sell_amount     = Regex.Replace(matches_2[ 5].Groups[1].Value, pattern_replace_1, "");
                    String price_close     = Regex.Replace(matches_2[ 6].Groups[1].Value, pattern_replace_1, "");
                    String change          = Regex.Replace(matches_2[ 7].Groups[1].Value, pattern_replace_1, "");
                    String amplitude       = Regex.Replace(matches_2[ 8].Groups[1].Value, pattern_replace_1, "");
                    String volume          = Regex.Replace(matches_2[ 9].Groups[1].Value, pattern_replace_1, "");
                    String open_price      = Regex.Replace(matches_2[10].Groups[1].Value, pattern_replace_1, "");
                    String high_price      = Regex.Replace(matches_2[11].Groups[1].Value, pattern_replace_1, "");
                    String low_price       = Regex.Replace(matches_2[12].Groups[1].Value, pattern_replace_1, "");
                    String reference_price = Regex.Replace(matches_2[13].Groups[1].Value, pattern_replace_1, "");
                    String price_time      = Regex.Replace(matches_2[14].Groups[1].Value, pattern_replace_1, "");

                    //紀錄資料
                    String logs = item    + "\t"
                        + status          + "\t"
                        + buy_price       + "\t"
                        + buy_amount      + "\t"
                        + sell_price      + "\t"
                        + sell_amount     + "\t"
                        + price_close     + "\t"
                        + change          +  "\t"
                        + amplitude       + "\t"
                        + volume          + "\t"
                        + open_price      + "\t"
                        + high_price      + "\t"
                        + low_price       + "\t"
                        + reference_price + "\t"
                        + price_time      + "\r\n";

                    //若舊資料不存在則設定空字串
                    if (latest_data.Count == i)
                    {
                        latest_data.Add("");
                    }

                    //若為新資料則更新
                    if (latest_data[i] != logs)
                    {
                        latest_data[i] = logs;
                        logs = start_time.ToString("yyyy/MM/dd_HH:mm:ss_fff") + "\t" + end_time.ToString("yyyy/MM/dd_HH:mm:ss_fff") + "\t" + logs;
                        if (record)
                        {
                            write_string(logs, Path.Combine(save_path, filename), true);
                        }

                        //顯示下載開始時間、下載結束時間、商品名稱、資料時間
                        Console.WriteLine(start_time.ToString("yyyy/MM/dd_HH:mm:ss") + "\t" + end_time.ToString("yyyy/MM/dd_HH:mm:ss") + "\t" + String.Format("{0,-10}", item) + "\t" + price_time);
                    }
                    else if (i == 0)
                    {
                        //若09:00:00~12:59:59後所取得資料時間仍為13:XX:XX則判斷當天非交易日，程式暫停8小時
                        DateTime time = DateTime.Now;
                        if (record && (time.Hour >= 9) && (time.Hour < 13) && (price_time.IndexOf("13:") == 0))
                        {
                            System.Threading.Thread.Sleep(8 * 3600 * 1000);
                            return true;
                        }
                    }
                }
            }
            catch (Exception e2)
            {
                Console.WriteLine(e2.ToString());
                return false;
            }
            return true;
        }
        public static void write_string(String content, String path, Boolean append)
        {
		    try
		    {
		        StreamWriter sw = new StreamWriter(path, append);
		        sw.Write(content);
                sw.Close();
		    }
            catch (IOException e2)
		    {
                Console.WriteLine(e2.ToString());
		    }
        }
    }
    public class WebClient2 : WebClient
    {
        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest request = base.GetWebRequest(address);
            request.Timeout = 2000;
            return request;
        }
    }
}
