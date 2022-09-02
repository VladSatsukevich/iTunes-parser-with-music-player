//
//  TrackCell.swift
//  MyFinalSwiftProject
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

class TrackCell: UITableViewCell {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    static let reuseId = "TrackCell"
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    var cell: SearchViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addButton(_ sender: Any) {
        addTrack()
    }

    private func addTrack() {
        
        let favoriteTrack = FavoriteTrack(context: self.context)
        favoriteTrack.trackName = cell?.trackName
        favoriteTrack.artistName = cell?.artistName
        favoriteTrack.collectionName = cell?.collectionName
        favoriteTrack.image = cell?.trackLogo
        favoriteTrack.previewUrl = cell?.previewURL
        do {
            context.insert(favoriteTrack)
            print("\(favoriteTrack.trackName!), \(favoriteTrack.artistName!) was edded to Core Data")
            try context.save()
        } catch {
            context.rollback()
            fatalError()
        }
    }
    
    func setup(viewModel: SearchViewModel.Cell?){
        self.cell = viewModel
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
