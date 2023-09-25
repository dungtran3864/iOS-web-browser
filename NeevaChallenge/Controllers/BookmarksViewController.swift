//
//  BookmarksViewController.swift
//  NeevaChallenge
//
//  Created by Toni Tran on 3/19/21.
//

import UIKit
import SwipeCellKit

class BookmarksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var bookmarkManagar : BookmarkManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        bookmarkIconCallback?()
        self.dismiss(animated: true, completion: nil)
    }
    
    var loadURLCallback : ((String)->())?
    var bookmarkIconCallback: (() -> ())?
}

// MARK: - UITableViewDataSource

extension BookmarksViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bookmarks = bookmarkManagar?.getBookmarks() {
            return bookmarks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.bookmarkCellIdentifier, for: indexPath) as! SwipeTableViewCell
        if let bookmarks = bookmarkManagar?.getBookmarks() {
            cell.textLabel?.text = bookmarks[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension BookmarksViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookmarks = bookmarkManagar?.getBookmarks() {
            loadURLCallback?(bookmarks[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - SwipeTableViewCellDelegate

extension BookmarksViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.bookmarkManagar?.deleteBookmark(index: indexPath.row)
            tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
}
