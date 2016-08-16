//
//  DataManager.swift
//  Flick
//
//  Created by mac on 8/14/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import Foundation
import RealmSwift

enum DataStorageType {
    case NSUserDefaults, File, CoreData, Realm
}

class DataManager {
    // class vs static methods:
    // http://stackoverflow.com/questions/29636633/static-vs-class-functions-variables-in-swift-classes
    
    static func saveToNSUserDefaults(movies: [Movie]?) {
        guard let movies = movies else {
            print("saving nothing")
            return
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(movies)
        defaults.setObject(data, forKey: "now_playing_archived")
        defaults.synchronize()
    }
    
    static func loadFromNSUserDefaults() -> [Movie]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = defaults.objectForKey("now_playing_archived") as? NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [Movie]
    }
    
    static func dataFile() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsPath.stringByAppendingString("/data.archive")
    }
    
    static func saveToFile(movies: [Movie]?) {
        NSKeyedArchiver.archiveRootObject(movies!, toFile: dataFile())
    }
    
    static func loadFromFile() -> [Movie]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dataFile()) as? [Movie]
    }
    
    static func loadFromRealm() -> [Movie]? {
        return Array(try! Realm().objects(Movie))
    }
    
    static func saveToRealm(movies: [Movie]?) {
        if let movies = movies {
            // Get the default Realm
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
                movies.forEach({ movie in
                    realm.add(movie)
                })
            }
            print("Realm path: \(realm.configuration.fileURL)")
        }
    }
}
