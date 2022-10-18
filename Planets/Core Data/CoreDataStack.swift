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

class CoreDataStackManager {
	
	static let shared = CoreDataStackManager()
	
	lazy var coreDataStack: CoreDataStack = {
		CoreDataStack(modelName: "Planets")
	}()
	
	private init() { }
}
