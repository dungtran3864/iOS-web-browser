//
//  TabsViewController.swift
//  NeevaChallenge
//
//  Created by Toni Tran on 3/19/21.
//

import UIKit
import SwipeCellKit

class TabsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tabManager : TabManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTabPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        tabManager?.addTab()
        loadURLCallback?(K.emptyTabPlaceholder)
    }
    
    var loadURLCallback : ((String)->())?

}

// MARK: - UITableViewDataSource

extension TabsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tabs = tabManager?.getTabs() {
            return tabs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tabCellIdentifier, for: indexPath) as! SwipeTableViewCell
        if let safeTabManager = tabManager {
            cell.textLabel?.text = safeTabManager.getTabs()[indexPath.row]
            if safeTabManager.getCurrentIndex() == indexPath.row {
                cell.textLabel?.textColor = .black
            } else {
                cell.textLabel?.textColor = .gray
            }
        }
        cell.delegate = self
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension TabsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let safeTabManager = tabManager {
            safeTabManager.updateCurrentIndex(index: indexPath.row)
            loadURLCallback?(safeTabManager.getTabs()[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SwipeTableViewCellDelegate

extension TabsViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let safeTabManager = self.tabManager {
                if indexPath.row == safeTabManager.getCurrentIndex() {
                    safeTabManager.deleteTab(index: indexPath.row)
                    self.loadURLCallback?(safeTabManager.getCurrentTab())
                } else {
                    self.tabManager?.deleteTab(index: indexPath.row)
                }
            }
            tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
}
