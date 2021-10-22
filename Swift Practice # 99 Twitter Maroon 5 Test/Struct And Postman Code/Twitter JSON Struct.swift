//
//  Twitter JSON Struct.swift
//  Swift Practice # 99 Twitter Maroon 5 Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/22.
//

import Foundation

//解析上方推特主介紹ＪＳＯＮ
struct TwitterScreenJSON: Codable {
    let name: String                    //名字首字大寫
    let screen_name: String             //名字
    let location: String                //註冊地點
    let description: String             //介紹
    let url: URL                        //魔力紅官網
    let followers_count: Int            //被追蹤者人數
    let friends_count:Int               //追蹤者朋友
    let created_at: String              //建立日期後續要轉換
    let profile_image_url_https: URL    //大頭貼照片
    let profile_banner_url: URL         //封面照
    let entities: Entities
    let status: Status
    struct Entities:Codable {
        let description: Description
        struct Description: Codable {
            let urls: [Urls]
            struct Urls: Codable {
                let url: URL?           //linktree
            }
        }
    }
    
    struct Status: Codable {
        let text: String
        
    }
}


//解析推文內容ＪＳＯＮ
struct TwitterTweetJSON : Codable {
    let created_at: String      //建立日期
    let text: String            //推文內文
    let retweet_count: Int      //轉貼
    let favorite_count: Int     //喜歡
}



//postman screen 寫法
/*
var semaphore = DispatchSemaphore (value: 0)

var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=Maroon5")!,timeoutInterval: Double.infinity)
request.addValue("Bearer nX4GbmUtKDN056DjoxbCzewsh", forHTTPHeaderField: "Authorization")
request.addValue("guest_id=v1%3A163488192719284267; personalization_id=\"v1_p6mRu/TQj+FQkh0H8B+6bA==\"", forHTTPHeaderField: "Cookie")

request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let data = data else {
    
    print(String(describing: error))
    semaphore.signal()
    return
  }
  print(String(data: data, encoding: .utf8)!)
  semaphore.signal()
}

task.resume()
semaphore.wait()

*/





/*
//postman 推文寫法
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

var semaphore = DispatchSemaphore (value: 0)

var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=Maroon5&count=50")!,timeoutInterval: Double.infinity)
request.addValue("Bearer FoSk9TAryPGaFvm5ofZBdcje", forHTTPHeaderField: "Authorization")
request.addValue("guest_id=v1%3A163488192719284267; personalization_id=\"v1_p6mRu/TQj+FQkh0H8B+6bA==\"", forHTTPHeaderField: "Cookie")

request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let data = data else {
    print(String(describing: error))
    semaphore.signal()
    return
  }
  print(String(data: data, encoding: .utf8)!)
  semaphore.signal()
}

task.resume()
semaphore.wait()

*/
