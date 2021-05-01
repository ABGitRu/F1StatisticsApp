//
//  StatisticsViewController.swift
//  F1StatisticsApp
//
//  Created by Mac on 01.05.2021.
//

import UIKit

class StatisticsViewController: UITableViewController {
    
    var data: Welcome?
    private let defaultText = ""
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = data?
                .mrData?
                .standingsTable?
                .standingsLists?
                .first?
                .driverStandings?
                .count else { return 0 }
        
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConfigTableViewCell
        let path = data?.mrData?.standingsTable?.standingsLists?.first?.driverStandings?[indexPath.row]
        
        cell.positionLabel.text = "Position: \(path?.position ?? defaultText)"
        cell.driverLabel.text = "Driver: \(path?.driver?.familyName ?? defaultText)"
        cell.constructorLabel.text = "Team: \(path?.constructors?.first?.name ?? defaultText)"
        cell.pointsLabel.text = "Points: \(path?.points ?? defaultText)"
        cell.winsLabel.text = "Wins: \(path?.wins ?? defaultText)"
        
        return cell
    }

}
