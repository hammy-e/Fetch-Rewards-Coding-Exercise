//
//  SeatGeekAPIService.swift
//  Fetch Rewards Coding Exercise
//
//  Created by Abraham Estrada on 5/19/21.
//

import Foundation
import SwiftyJSON

protocol SeatGeekAPIServiceDelegate {
    func didFetchData(data: JSON)
}

struct SeatGeekAPIService {
    
    private let apiURL = "https://api.seatgeek.com/2"
    private let clientID = "MjE5NjE3MzB8MTYyMTQ0NjUyNC45OTA1Nzcy"
    
    var delegate: SeatGeekAPIServiceDelegate?
    
    func fetchData() {
        if let url = URL(string: "\(apiURL)/events?client_id=\(clientID)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let data = try JSON(data: data)
                        delegate?.didFetchData(data: data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}
