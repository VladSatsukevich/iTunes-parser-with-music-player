//
//  FavoriteTracks+CoreDataProperties.swift
//  
//
//  Created by VironIT on 29.08.22.
//
//

import Foundation
import CoreData

extension FavoriteTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTrack> {
        return NSFetchRequest<FavoriteTrack>(entityName: "FavoriteTrack")
    }

    @NSManaged public var previewUrl: String?
    @NSManaged public var image: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var trackName: String?
}
