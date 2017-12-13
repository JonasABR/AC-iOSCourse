//
//  Downloader.swift
//  FundayApp
//
//  Created by Avenue Code on 12/13/17.
//  Copyright © 2017 Lucio Fonseca. All rights reserved.
//

import UIKit
import Unbox

class Downloader: NSObject {
    var dataTask: URLSessionDataTask?
    let defaultSession = URLSession(configuration: .default)

    func getDataFromMock (completion: @escaping (_ pastFunday: [PastFunday], _ futureFundaysArray: [FutureFunday]) -> Void) {
        let endpoint = "http://demo8129738.mockable.io/fundays"
        dataTask?.cancel()
        

        if let url = URL(string: endpoint) {
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {

                    do {
                        var futureFundaysArray:[FutureFunday] = []
                        var pastFundaysArray:[PastFunday] = []

                        let funday: FundaySchedule = try unbox(data: data)
                        if let future = funday.futureFundays {
                            futureFundaysArray.append(contentsOf: future)
                        }

                        if let past = funday.pastFundays {
                            pastFundaysArray.append(contentsOf: past)
                        }

                        completion(pastFundaysArray, futureFundaysArray)
                    } catch {
                        print("An error occurred: \(error)")
                    }


                    

                    print(response.debugDescription)
                    //self.updateSearchResults(data)

                }
            }
            dataTask?.resume()
        }


    }
}
