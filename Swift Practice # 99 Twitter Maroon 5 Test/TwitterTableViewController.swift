//
//  TwitterTableViewController.swift
//  Swift Practice # 99 Twitter Maroon 5 Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/22.
//

import UIKit

class TwitterTableViewController: UITableViewController {

    
    @IBOutlet weak var barnnerImageview: UIImageView!       //封面
    @IBOutlet weak var profileImageView: UIImageView!       //大頭貼
    @IBOutlet weak var nameLabel: UILabel!                  //name粗體
    @IBOutlet weak var atNameLabel: UILabel!                //@name
    @IBOutlet weak var intrTextView: UITextView!            //介紹
    
    @IBOutlet weak var locationLabel: UILabel!              //地點
    @IBOutlet weak var linkLabel: UILabel!                  //連結
    @IBOutlet weak var dateLabel: UILabel!                  //建立日期
    
    @IBOutlet weak var followLabel: UILabel!                //關注對象
    @IBOutlet weak var fansLabel: UILabel!                  //跟隨者粉絲
    @IBOutlet weak var followButton: UIButton!              //黑色跟隨按鈕
    
    var twitterScanerJSON: TwitterScreenJSON?               //取得自定義TwitterScreenJSON格式指派給twitterScanerJSON
    var twitterTweetArray = [TwitterTweetJSON]()            //取得Array的自定義TwitterTweetJSON指派給twitterTweetArray
    
    
    //自己改寫抓Screen
    func getTwitterScreenAPI () {
        //取得連結後解碼透過URLRequest帶入barner token後指定為"GET"後取得API資料
        if let twitterScreenUrl = URL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=Maroon5".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            var twitterScreenRequest = URLRequest(url: twitterScreenUrl, timeoutInterval: Double.infinity)
            twitterScreenRequest.setValue("Bearer 自己的API", forHTTPHeaderField: "Authorization")
            twitterScreenRequest.addValue("guest_id=v1%3A163488192719284267; personalization_id=\"v1_p6mRu/TQj+FQkh0H8B+6bA==\"", forHTTPHeaderField: "Cookie")
            twitterScreenRequest.httpMethod = "GET"
            URLSession.shared.dataTask(with: twitterScreenRequest) { data, response, error in
                
                
                if let data = data {
                    let JSDecoder = JSONDecoder()
                    JSDecoder.dateDecodingStrategy = .iso8601
                    do{
                        //取得的資料指派給twitterScanerJSON
                        let twitterScreenResponse = try JSDecoder.decode(TwitterScreenJSON.self, from: data)
                        self.twitterScanerJSON = twitterScreenResponse
                        print("screenSuccess")
                        
                        //封面照加入
                        URLSession.shared.dataTask(with: self.twitterScanerJSON!.profile_banner_url) { data, response, error in
                            if let bannerPhoto = data {
                                DispatchQueue.main.async {
                                    self.barnnerImageview.image = UIImage(data: bannerPhoto)
                                }
                            }
                            
                        }.resume()
                        
                        //大頭貼加入
                        URLSession.shared.dataTask(with: self.twitterScanerJSON!.profile_image_url_https) {
                            data, response, error in
                            if let proFilePhoto = data {
                                DispatchQueue.main.async {
                                    self.profileImageView.image = UIImage(data: proFilePhoto)
                                }
                            }
                        }.resume()
                        
                        //於主執行緒修改畫面內容
                        DispatchQueue.main.async {
                            self.nameLabel.text = self.twitterScanerJSON!.name                  //名稱
                            self.atNameLabel.text = "@\(self.twitterScanerJSON!.screen_name)"   //@名稱
                            self.intrTextView.text = self.twitterScanerJSON!.description        //自介
                            
                            self.locationLabel.text = self.twitterScanerJSON!.location          //地點位置
                            
                            
                            if let urlLink = self.twitterScanerJSON!.entities.description.urls[0].url {
                                self.linkLabel.text = "\(urlLink)"                              //推主網站連結
                            }
                            
                            //透過日期格式更改改為需要的 "於 YYYY年MM月 加入"的樣式後存入 self.dateLabel.text
                            let dateFormatterToDate = DateFormatter()
                            dateFormatterToDate.dateFormat = "E MMM d HH:mm:ss Z yyyy"
                            let dateFormatterToString = DateFormatter()
                            dateFormatterToString.dateFormat = "於 YYYY年MM月 加入"
                            self.dateLabel.text = dateFormatterToString.string(from: (dateFormatterToDate.date(from: self.twitterScanerJSON!.created_at)!))
                            
                            self.followLabel.text = "\(self.twitterScanerJSON!.friends_count)跟隨中"       //關注人數
                            
                            //透過NumberFormatter()取得金融數字三位數一撇的字串格式
                            let numFormatter = NumberFormatter()
                            numFormatter.numberStyle = .decimal
                            numFormatter.maximumFractionDigits = 0
                            self.fansLabel.text = "\(numFormatter.string(from: NSNumber(value: self.twitterScanerJSON!.followers_count))!)跟隨者"
                        }
                    }catch{
                        print(error)
                        print("screenFail")
                    }
                }
            }.resume()
        }
    }



    //自己的寫法 抓推文後用於Tableview顯示
    func getTwitterTweetAPI () {
        if let twitterTweetUrl = URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=Maroon5&count=50".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            var twitterTweetRequest = URLRequest(url: twitterTweetUrl, timeoutInterval: Double.infinity)
            twitterTweetRequest.setValue("Bearer Bearer 自己的API", forHTTPHeaderField: "Authorization")
            twitterTweetRequest.addValue("guest_id=v1%3A163488192719284267; personalization_id=\"v1_p6mRu/TQj+FQkh0H8B+6bA==\"", forHTTPHeaderField: "Cookie")
            twitterTweetRequest.httpMethod = "GET"
            URLSession.shared.dataTask(with: twitterTweetRequest) { data, response, error in
                
                if let data = data {
                    let JSDecoder = JSONDecoder()
                    JSDecoder.dateDecodingStrategy = .iso8601
                    do{
                        let twitterTweetResponse = try JSDecoder.decode([TwitterTweetJSON].self, from: data)
                        self.twitterTweetArray = twitterTweetResponse
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        print("tweetSuccess")
                    }catch{
                        print(error)
                        print("tweetFail")
                    }
                }
            }.resume()
        }
    }

    
    //viewDidLoad執行Function與改變元件的尺寸狀態
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTwitterTweetAPI()
        getTwitterScreenAPI()
        
        //封面照片顯示
        barnnerImageview.contentMode = .scaleAspectFill
        
        //黑色跟隨圓形
        followButton.layer.cornerRadius = followButton.frame.height / 2
        
        //大頭照圓形及加入邊框白色
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        //推主名稱加粗
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
        nameLabel.font = UIFont.systemFont(ofSize: 20)
    }

    // MARK: - Table view data source

    //回傳一個section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //顯示為json抓到twitterTweetArray總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return twitterTweetArray.count
    }

    //tableView內顯示資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterTableViewCell", for: indexPath) as? TwitterTableViewCell else {return UITableViewCell()}
        
        
        cell.blackNameLabel.text = twitterScanerJSON?.name                                  //名稱
        cell.blackNameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)  //加粗
        cell.atNameLabel.text = "@\(twitterScanerJSON!.screen_name)"                        //@名稱
        
        //發文日期格式改為需要的"YYYY/MM/dd"
        let dateFormatterToDate = DateFormatter()
        dateFormatterToDate.dateFormat = "E MMM d HH:mm:ss Z yyyy"
        let dateFormatterToString = DateFormatter()
        dateFormatterToString.dateFormat = "YYYY/MM/dd"
        cell.dateLabel.text = dateFormatterToString.string(from: (dateFormatterToDate.date(from: twitterTweetArray[indexPath.row].created_at)!))

        
        cell.textContentView.text = twitterTweetArray[indexPath.row].text                   //推文內容
        cell.commentLabel.text = "\(Int.random(in: 1...999))"                               //隨機亂數留言人數
        cell.retweetLabel.text = "\(twitterTweetArray[indexPath.row].retweet_count)"        //轉推次數
        cell.likeLabel.text = "\(twitterTweetArray[indexPath.row].favorite_count)"          //like人數
        
        //大頭貼圓形並透過網址取得大頭照照片
        cell.profileImageview.layer.cornerRadius = cell.profileImageview.frame.height / 2
        if twitterScanerJSON?.profile_banner_url != nil {
            URLSession.shared.dataTask(with: twitterScanerJSON!.profile_image_url_https) {data , response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.profileImageview.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        

        return cell
    }

}
