//
//  CoreDataStack.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/18/22.
//

import CoreData

class CoreDataStack {
	private let modelName: String

	init(modelName: String) {
		self.modelName = modelName
	}

	private lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: self.modelName)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()

	lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

	func saveContext() {
		guard managedContext.hasChanges else { return }
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Unresolved error \(error), \(error.userInfo)")
		}
	}
}

class SavedDataManager {

	static let shared = SavedDataManager()

	lazy var coreDataStack: CoreDataStack = {
		CoreDataStack(modelName: "Planets")
	}()

	private init() { }
	
	func saveData(_ planets: [(planetUrl: String, planetName: String)]) {
		for planet in planets {
			let planetEntity = PlanetEntity(context: managedContext)
			planetEntity.setValue(planet.planetUrl, forKey: #keyPath(PlanetEntity.planetUrl))
			planetEntity.setValue(planet.planetName, forKey: #keyPath(PlanetEntity.planetName))
			SavedDataManager.shared.coreDataStack.saveContext()
		}
	}
	
	func getSavedData() -> [PlanetCellModel]? {
		do {
			let planetsFetch: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
			let results = try managedContext.fetch(planetsFetch)
			guard results.count > 0 else {
				return nil
			}
			return results.compactMap({ PlanetCellModel(from: $0) })
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
			return nil
		}
	}
	
	private var managedContext: NSManagedObjectContext {
		return SavedDataManager.shared.coreDataStack.managedContext
	}
}
