//
//  TrackCell.swift
//  iTunes
//
//  Created by VironIT on 25.08.22.
//
import CoreData
import SDWebImage
import UIKit

protocol TrackCellViewModel {
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
    var trackLogo: String { get }
}

final class TrackCell: UITableViewCell {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest = FavoriteTrack.fetchRequest()
    static let reuseId = "TrackCell"
    var cell: SearchViewModel.Cell?
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addButton(_ sender: Any) {
        checkTrack()
    }
    
    private func addFavoriteTrack() {
        let favoriteTrack = FavoriteTrack(context: self.context)
        favoriteTrack.trackName = cell?.trackName
        favoriteTrack.artistName = cell?.artistName
        favoriteTrack.collectionName = cell?.collectionName
        favoriteTrack.image = cell?.trackLogo
        favoriteTrack.previewUrl = cell?.previewURL
    }
    
    private func checkTrack() {
        fetchRequest.predicate = NSPredicate(format: "trackName = %@ AND artistName = %@ AND collectionName = %@",
                                             argumentArray: [cell!.trackName,
                                                             cell!.artistName,
                                                             cell!.collectionName])
        let count = try? context.count(for: fetchRequest)
        do {
            if count! == 0 {
                addFavoriteTrack()
                print("\(cell!.trackName), \(cell!.artistName), \(cell!.collectionName) was added")
                addButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object)
                }
                try context.save()
                print("\(cell!.trackName), \(cell!.artistName), \(cell!.collectionName) was removed")
                addButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error)")
            return
        }
    }
    
    func parsingSetup(viewModel: SearchViewModel.Cell?){
        self.cell = viewModel
        fetchRequest.predicate = NSPredicate(format: "trackName = %@ AND artistName = %@ AND collectionName = %@",
                                             argumentArray: [cell!.trackName,
                                                             cell!.artistName,
                                                             cell!.collectionName])
        let count = try? context.count(for: fetchRequest)
        if count! > 0 {
            addButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            addButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        trackNameLabel?.text = viewModel?.trackName
        artistLabel?.text = viewModel?.artistName
        collectionLabel?.text = viewModel?.collectionName
        guard let url = URL(string: viewModel!.trackLogo) else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    func favoriteSetup(viewModel: FavoriteTrack){
        addButtonOutlet.isHidden = true
        trackNameLabel?.text = viewModel.trackName
        artistLabel?.text = viewModel.artistName
        collectionLabel?.text = viewModel.collectionName
        trackImageView?.kf.setImage(with: URL(string: viewModel.image!))
    }
}
