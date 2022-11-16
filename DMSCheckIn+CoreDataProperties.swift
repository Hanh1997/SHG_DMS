//
//  DMSCheckIn+CoreDataProperties.swift
//  SH_SS
//
//  Created by phạm Hưng on 3/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//
//

import Foundation
import CoreData


extension DMSCheckIn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DMSCheckIn> {
        return NSFetchRequest<DMSCheckIn>(entityName: "DMSCheckIn")
    }

    @NSManaged public var username: String?
    @NSManaged public var cmp_wwn: String?
    @NSManaged public var checkdate: NSDate?
    @NSManaged public var checktime: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var imgpath: String?

}
