//
//  GCDWrapper.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/29/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}