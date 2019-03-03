//
//  UITableExt.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

/**
 Build an extension on UITableView to refresh the values in the cells.
 */
extension UITableView {
    
    /**
     A function to refresh the UITableView Cells.
     */
    func refresh() {
        let indexPathForSection: IndexSet = [0]
        self.reloadSections(indexPathForSection, with: UITableView.RowAnimation.middle)
    }
}
