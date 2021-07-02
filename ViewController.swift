//
//  ViewController.swift
//  webCirc
//
//  Created by Sandy Lord on 6/21/21.
//

import UIKit
import Foundation

struct APIResponse: Codable {
    let _id: APIID?
    let abQuestion: String?
    let abQuestionDomain: String?
    let abSentence: String?
    let bcQuestion: String?
    let bcQuestionDomain: String?
    let bcSentence: String?
    let imageName: String?
    let numSyll: APINumSyll?
    let photo: String?
    let progName: String?
    let syllStructure: String?
    let theme: String?
    let unit: APIUnit?
    let vocabulary: String?
}
    
// individual structures for parts of the APIResponse
struct APIUnit: Codable {
    let numberInt: Int
}
struct APINumSyll: Codable {
    let numberInt: Int
}
struct APIID: Codable {
    let oid: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addLabel()

        getData{(APIResponse) in
            let labels = self.view.subviews.compactMap { $0 as? UILabel }

            for label in labels {
                print("Label text: ", label.text)
                if label.accessibilityIdentifier == "abSentence" {
                    // here I want to use the APIResponse to show abSentence, but nothing happens b/c 2 reasons: 1) It is asynchronous and 2) APIResponse is not properly set up
                    label.text = "abSentence is changed"
                }
            }
            print("APIResponse: ", APIResponse) // prints nothing, as the APIResponse returned out of the guard let statement
        }
    }

    func getData(_ completion: @escaping ((APIResponse?) -> ())) {
        let urlPath = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/cirdata-khyvx/service/cirData/incoming_webhook/cirlAPI"
        guard let url = URL(string: urlPath) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print("data",data) // some 304000 bytes, indicating success

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    // print("jsonResult", jsonResult) // prints a copy of the database to use, eg., for debugging, also indicating success
                }
            } catch {
            }

            // Now I would like to use JSONDecoder() to decode the data following the APIResponse struct defined on lines 11-27.
            do {
                                        
                guard let APIResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else { return }
                print("APIResponse", APIResponse.self) // nothing prints here, so the JSONDecoder must not be able to decode. It is probably my struct that is not formatted correctly.
                completion(APIResponse)
            } catch {
            }
        }
        task.resume()
    }
    
    func addLabel() {
        let showSentenceLabel = UILabel()
        showSentenceLabel.text = "This is a great abSentence."
        showSentenceLabel.backgroundColor = .cyan
        showSentenceLabel.frame = CGRect(x: 10, y: 100, width: 300, height: 50)
        showSentenceLabel.accessibilityIdentifier = "abSentence"
        
        self.view.addSubview(showSentenceLabel)
    }

}

