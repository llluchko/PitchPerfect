//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Latchezar Mladenov on 10/22/15.
//  Copyright © 2015 Latchezar Mladenov. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: URL!
    var title: String!
    
    init(filePathUrl: URL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
