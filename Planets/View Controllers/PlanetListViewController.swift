//
//  PlanetListViewController.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import UIKit

class PlanetListViewController: UITableViewController {

		// Inject viewModel with appropriate service
	private var viewModel = PlanetListViewModel(service: PlanetListService())

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.delegate = self
		viewModel.fetchPlanetList()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.planets.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath) as? PlanetCell else {
			fatalError()
		}
		let planet = viewModel.planets[indexPath.row]
		cell.configure(planet: planet)
		return cell
	}
}

extension PlanetListViewController: PlanetListViewModelDelegate {
		// Refresh data
	func planetListUpdated() {
		tableView.reloadData()
	}

		// Present Error
	func handle(error: Error) {
		let errorMessage = (error as? AppError)?.description ?? "Unknown Error!"
		let alert = UIAlertController(title: "Error!", message: errorMessage,
									  preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}
