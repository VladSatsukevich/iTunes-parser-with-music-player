//
//  FavoriteTracksViewController.swift
//  FavoriteTracks
//
//  Created by VironIT on 29.08.22.
//
import CoreData
import Kingfisher
import UIKit

final class FavoriteTracksViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    private var models = [FavoriteTrack]()
    @IBOutlet weak var favoriteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title.self = "Favorite"
        tableSetup()
        getModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Updating favoriteTable after tabbar
        getModels()
    }
    
// MARK: - Get models from Core Data
    
    private func getModels() {
        do {
            let fetchRequest = FavoriteTrack.fetchRequest()
            let sectionSortDescriptor = NSSortDescriptor(key: #keyPath(FavoriteTrack.trackName), ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            try models = context.fetch(fetchRequest)
            DispatchQueue.main.async { [unowned self] in
                self.favoriteTable.reloadData()
            }
            try context.save()
        } catch {
            fatalError()
        }
    }
    
// MARK: - Table Setup
    
    private func tableSetup() {
        favoriteTable.delegate = self
        favoriteTable.dataSource = self
        favoriteTable.rowHeight = 100
        favoriteTable.estimatedRowHeight = 0
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        favoriteTable.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    }
}

// MARK: - Table settings

extension FavoriteTracksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
        let model = models[indexPath.row]
        favoriteCell?.favoriteSetup(viewModel: model)
        return favoriteCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteMusicPlayer") as? FavoriteTracksPlayerViewController else {
            return
        }
        vc.playerSetup(viewModel: model)
        vc.favoriteDelegate = self
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(models[indexPath.row] as NSManagedObject)
            try? context.save()
            favoriteTable.beginUpdates()
            models.remove(at: indexPath.row)
            favoriteTable.deleteRows(at: [indexPath], with: .fade)
            favoriteTable.endUpdates()
        }
    }
}

// MARK: - Player next/forward button settings

extension FavoriteTracksViewController: FavoritePlayerViewControllerDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> FavoriteTrack? {
        guard let indexPath = favoriteTable.indexPathForSelectedRow else { return nil}
        favoriteTable.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == models.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = models.count - 1
            }
        }
        favoriteTable.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let model = models[nextIndexPath.row]
        return model
    }
    func moveBack() -> FavoriteTrack? {
        return getTrack(isForwardTrack: false)
    }
    func moveForward() -> FavoriteTrack? {
        return getTrack(isForwardTrack: true)
    }
}
