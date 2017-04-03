//
//  User+CoreDataProperties.swift
//  KOTA_Player
//
//  Created by  noble on 2016. 10. 27..
//  Copyright © 2016년 KOTA. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: String?
    @NSManaged public var grade: String?
    @NSManaged public var name: String?

}
