//
//  PlanetCell.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import UIKit

class PlanetCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
			// Initialization code
	}

	func configure(planet: PlanetCellModel) {
		nameLabel.text = planet.name
	}
}
