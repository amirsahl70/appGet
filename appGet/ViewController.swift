//
//  ViewController.swift
//  appGet
//
//  Created by Amir on 7/2/18.
//  Copyright © 2018 uni. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    let url = URL(string: "https://192.168.17.253/app_dev.php/ios/test") // 217.218.171.90
    let parameters : Parameters = ["firstname" : "mansooreh" , "lastname" :"ranjbarian"]
    var array : [userData] = []
    var json = JSON()
    var sessionManager = SessionManager()
    @IBOutlet weak var tableview: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
    }
    
    
    private func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }

        return publicKey
    }

    private func pinnedKeys() -> [SecKey] {

        var publicKeys : [SecKey] = []
        let clientBundle: Bundle? = Bundle.main

        for localKey in ServerTrustPolicy.publicKeys(in: clientBundle!){

            publicKeys.append(localKey)
        }

        return publicKeys
    }
    func downloadData(){
        let delegate : SessionDelegate = sessionManager.delegate

        delegate.sessionDidReceiveChallengeWithCompletion = { session, challenge, completionHandler in

            guard let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 else {
                // This case will probably get handled by ATS, but still...
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("number of certs are lese than 0")
                return
            }

            if let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0), let serverCertificateKey = self.publicKey(for: serverCertificate) {
                print("serverCertKey is \(serverCertificateKey)")
                print("pinn key is \(self.pinnedKeys())")
                if self.pinnedKeys().contains(serverCertificateKey) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                }
            }
        }

        guard let downloadURL = url else { return }

       sessionManager.request(downloadURL, parameters: parameters).validate().responseJSON{ response in
            switch response.result{
            case .success :
                if let value = response.result.value{

                     self.json = JSON(value)

                    let firstName = self.json["firstname"].stringValue
                    let lastName = self.json["lastname"].stringValue
                    let message = self.json["message"].stringValue
                    //for(_,data): (String, JSON) in self.json{
                        let day = self.json["array"]["day"].stringValue
                        let month = self.json["array"]["month"].stringValue
                        let year = self.json["array"]["year"].stringValue
                        let initData = userData(firstName : firstName, lastName : lastName, message : message, year : year, month:month, day:day)
                        self.array.append(initData)
                       print(self.array.count)
                    //}

                    for item in self.array{
                        print("item \(item.firstName) and day is \(item.day)")
                    }
//                self.arrayNames = json.arrayValue.map({$0["firstname"].stringValue})
                self.tableview.reloadData()
                }
            case .failure(let error) : print("error->\(error)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = arrayNames[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableInfo", for: indexPath) as? userNames else { return UITableViewCell()}
        cell.nameLable.text = "Name: " + array[indexPath.row].firstName
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
}

