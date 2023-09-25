//
//  ViewController.swift
//  NeevaChallenge
//
//  Created by Toni Tran on 3/18/21.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var bookmarkButton: UIButton!
    var test = false
    var hell = ["test"]
    
    var tabManager = TabManager()
    var bookmarkManager = BookmarkManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        URLTextField.delegate = self;
        webView.navigationDelegate = self;
        
    }
    
    @IBAction func refreshBrowser(_ sender: UIButton) {
        webView.reload()
    }
    
    @IBAction func goBackPage(_ sender: UIButton) {
        webView.goBack()
    }
    
    @IBAction func goForwardPage(_ sender: UIButton) {
        webView.goForward()
    }
    
    @IBAction func tabSwitcherPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.tabsSegue, sender: self)
    }
    
    @IBAction func bookmarkSwitcherPressed(_ sender: UIButton) {
        if let currentURL = webView.url {
            let currentURLString = currentURL.absoluteString
            bookmarkManager.addBookmark(urlString: currentURLString)
            if bookmarkManager.isBookMarked(urlString: currentURLString) {
                bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
        self.performSegue(withIdentifier: K.bookmarksSegue, sender: self)
    }
    
    func setBookmarkButton(urlString: String) -> Void {
        if self.bookmarkManager.isBookMarked(urlString: urlString) {
            self.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            self.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.tabsSegue {
            let destinationVC = segue.destination as! TabsViewController
            destinationVC.tabManager = tabManager
            destinationVC.loadURLCallback = { urlString in
                if (urlString == K.emptyTabPlaceholder) {
                    self.webView.load(URLRequest(url: URL(string: K.blankURL)!))
                } else {
                    self.webView.load(URLRequest(url: URL(string: urlString)!))
                }
            }
        } else if segue.identifier == K.bookmarksSegue {
            let destinationVC = segue.destination as! BookmarksViewController
            destinationVC.bookmarkManagar = bookmarkManager
            destinationVC.loadURLCallback = { urlString in
                self.webView.load(URLRequest(url: URL(string: urlString)!))
            }
            destinationVC.bookmarkIconCallback = {
                if let currentURLString = self.URLTextField.text {
                    self.setBookmarkButton(urlString: currentURLString)
                }
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension BrowserViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        URLTextField.endEditing(true);
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchString = URLTextField.text {
            let trimmedSearchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
            if let searchURL = URL(string: trimmedSearchString) {
                webView.load(URLRequest(url: searchURL))
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension BrowserViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url {
            let currentURLString = currentURL.absoluteString
            if (currentURLString != K.blankURL) {
                URLTextField.text = currentURLString
                tabManager.updateTab(urlString: currentURLString)
            } else {
                URLTextField.text = ""
                tabManager.updateTab(urlString: K.emptyTabPlaceholder)                
            }
            setBookmarkButton(urlString: currentURLString)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error._code == -1003) {
            webView.loadHTMLString("<p>This site can't be reached</p>", baseURL: nil)
        } else if (error._code == -1022) {
            webView.loadHTMLString("<p>Require secured connection</p>", baseURL: nil)
        }
    }
    
}

