//
//  Mail.swift
//  aji
//
//  Created by aco on 07/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
	
	class var sharedInstance: SendEmailViewController {
		struct Singleton {
			static let instance = SendEmailViewController()
		}
		
		return Singleton.instance
	}
	
	internal func sendEmail(from viewController: UIViewController, body: String) {
		// Modify following variables with your text / recipient
		let recipientEmail = "hi@neanews.co"
		let subject = "Unsupported Recipe Site"
		
		// Show default mail composer
		if MFMailComposeViewController.canSendMail() {
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setToRecipients([recipientEmail])
			mail.setSubject(subject)
			mail.setMessageBody(body, isHTML: false)
			
			viewController.present(mail, animated: true)
			
			// Show third party email composer if default Mail app is not present
		} else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
			UIApplication.shared.open(emailUrl)
		}
	}
	
	private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
		let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		
		let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
		let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
		let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
		
		if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
			return gmailUrl
		} else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
			return outlookUrl
		} else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
			return yahooMail
		} else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
			return sparkUrl
		}
		
		return defaultUrl
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}
