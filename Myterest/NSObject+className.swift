//
//  NSObject+className.swift
//  Myterest
//
//  Created by Mikael Teklehaimanot on 3/26/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
