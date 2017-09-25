//
//  AttachmentTableViewController.swift
//  MessageUI:Email+SMS
//
//  Created by Chris Huang on 25/09/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class AttachmentTableViewController: UITableViewController {

	// MARK: Model
	private let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg",
	                         "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
	
	// MARK: UITableViewDataSource and UITableViewDelegate
	override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filenames.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = filenames[indexPath.row]
		cell.imageView?.image = UIImage(named: "icon\(indexPath.row)")
		return cell
	}
}
