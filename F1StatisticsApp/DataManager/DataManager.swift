//
//  DataManager.swift
//  F1StatisticsApp
//
//  Created by Mac on 30.04.2021.
//

import Foundation


enum StatisticsError: Error {
    case noDataAvailable
    case canNotProcessData
}

class StatisticsRequest {
    
    let resourceURL: URL
    
    init(year: String) {
        let resourceString = "https://ergast.com/api/f1/\(year)/driverStandings.json"
        
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        
        self.resourceURL = resourceURL
    }
    
    func getStatistics (completion: @escaping(Result<Welcome, StatisticsError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            print(jsonData)
            do {
                let decoder = JSONDecoder()
                let statResponce = try decoder.decode(Welcome.self, from: jsonData)
                completion(.success(statResponce))
            }catch{
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
