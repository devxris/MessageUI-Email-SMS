//
//  AttachmentTableViewController.swift
//  MessageUI:Email+SMS
//
//  Created by Chris Huang on 25/09/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit
import MessageUI // UI will be identical to the "mail" app

class AttachmentTableViewController: UITableViewController {

	// MARK: Model
	private let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg",
	                         "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
	
	private enum MIME: String { // Multipurpose Internet Mail Extensions "type/extension"
		case html = "text/html"
		case jpg =  "image/jpeg"
		case png =  "image/png"
		case doc =  "application/msword"
		case ppt =  "application/vnd.ms-powerpoint"
		case pdf =  "application/pdf"
		
		init?(type: String) {
			switch type.lowercased() {
			case "jpg":  self = .jpg
			case "png":  self = .png
			case "doc":  self = .doc
			case "ppt":  self = .ppt
			case "pdf":  self = .pdf
			case "html": self = .html
			default: return nil
			}
		}
	}
	
	lazy var mailComposer: MFMailComposeViewController = {
		// initialize a mailComposer and configure the email template
		let emailTitle = "Great Photo and Doc"
		let messageBody = "Hey, check this out!"
		let toRecipents = ["support@devxris.com"]
		let composer = MFMailComposeViewController()
		composer.mailComposeDelegate = self // conform to mailComposeDelegate
		composer.setSubject(emailTitle)
		composer.setMessageBody(messageBody, isHTML: false)
		composer.setToRecipients(toRecipents)
		return composer
	}()
	
	private func showEmail(with attachment: String) {
		
		guard MFMailComposeViewController.canSendMail() else { return } // check device can send email or not
		
		// configure attachment and transfer to Data object
		let fileParts = attachment.components(separatedBy: ".")
		let file: (name: String, ext: String) = (fileParts[0], fileParts[1])
		guard let filePath = Bundle.main.path(forResource: file.name, ofType: file.ext) else { return }
		guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return }
		guard let mimeType = MIME(type: file.ext) else { return }
		
		// add attachment to mailComposer
		mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: file.name)
		
		// show MFMailComposeViewController
		present(mailComposer, animated: true, completion: nil)
	}
	
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
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedFile = filenames[indexPath.row]
		showEmail(with: selectedFile)
	}
}

extension AttachmentTableViewController: MFMailComposeViewControllerDelegate {
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		switch result {
		case .cancelled : print("Mail cancelled")
		case .saved     : print("Mail saved")
		case .sent 	    : print("Mail sent")
		case .failed    : print("Failed to send \(error!.localizedDescription)")
		}
		dismiss(animated: true , completion: nil)
	}
}
