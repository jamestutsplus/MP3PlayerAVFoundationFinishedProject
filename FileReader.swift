//
//  FileReader.swift
//  MP3Player
//
//  Created by James Tyner on 7/17/15.
//  Copyright (c) 2015 James Tyner. All rights reserved.
//

import UIKit

class FileReader: NSObject {
    
    class func readFiles() -> [String] {
        return  NSBundle.mainBundle().pathsForResourcesOfType("mp3", inDirectory: nil) as! [String]
    }

}


