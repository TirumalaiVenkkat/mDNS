//
//  ViewController.swift
//  mDNSTask
//
//  Created by trioangle on 04/11/22.
//

import UIKit
import Network

class ViewController: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var dataTbl: UITableView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var IPLbl: UILabel!
    @IBOutlet weak var portLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var serviceStk: UIStackView!
    
    var dataArr = [MDNSData]()
    
    var netService : NetService!
    var serviceBrowser = NetServiceBrowser()
    var index =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataTbl.delegate = self
        self.dataTbl.dataSource = self
        self.serviceBrowser.delegate = self
        
        self.serviceName.text = "Service"
        self.nameLbl.text = "Name"
        self.typeLbl.text = "Type"
        self.IPLbl.text = "IP"
        self.portLbl.text = "Port"
        
        self.publishBtn.layer.borderWidth = 1
        self.publishBtn.backgroundColor = UIColor.tintColor
        self.publishBtn.tintColor = UIColor.white
        
        self.scanBtn.layer.borderWidth = 1
        self.scanBtn.backgroundColor = UIColor.tintColor
        self.scanBtn.tintColor = UIColor.white
        
        self.serviceName.textColor = UIColor.white
        self.typeLbl.textColor = UIColor.white
        self.IPLbl.textColor = UIColor.white
        self.portLbl.textColor = UIColor.white
        
        self.serviceStk.layer.borderColor = UIColor.white.cgColor
        self.serviceStk.layer.borderWidth = 0.5
        self.typeLbl.layer.borderColor = UIColor.white.cgColor
        self.typeLbl.layer.borderWidth = 0.5
        self.IPLbl.layer.borderColor = UIColor.white.cgColor
        self.IPLbl.layer.borderWidth = 0.5
        self.portLbl.layer.borderColor = UIColor.white.cgColor
        self.portLbl.layer.borderWidth = 0.5
    }
    
    func publish() {
        index = index + 1
        print("Publishing...")
        self.netService = NetService(domain: "local.", type: "_http._tcp.", name: "iPhone \(index)", port: Int32(3000))
        
        self.netService.delegate = self
        self.netService!.publish()
    }
    
    func scan() {
        print("Scanning...")
        //Append values to a dictionary
        serviceBrowser.stop()
        serviceBrowser.searchForServices(ofType: "_http._tcp.", inDomain: "local.")
        //self.dataTbl.reloadData()
    }
    
    @IBAction func publishAction(_ sender: Any){
        self.publish()
    }
    
    @IBAction func scanAction(_ sender: Any){
        self.scan()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        cell.initView()
        
        let model = self.dataArr[indexPath.row]
        cell.serviceName.text = model.serviceName
        cell.typeLbl.text = model.type
        cell.IPLbl.text = model.ipAddr
        cell.portLbl.text = model.port
        
        return cell
    }
    
}

extension ViewController:NetServiceDelegate{

    //netservice delegate functions
        func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
            print("uh oh, could not publish netService. domain:\(netService!.domain) type:\(netService!.type) name:\(netService!.name) port:\(netService!.port)")
            print("error code:\(errorDict)")
        }

        func netServiceDidPublish(_ sender: NetService) {
            print("netService published.")
            print(sender.addresses)
        }

        func netServiceDidStop(_ sender: NetService) {
            print("netService stopped.")
        }

        func netServiceWillPublish(_ sender: NetService) {
            print("Service will publish, apparently")

        }
}
extension ViewController: NetServiceBrowserDelegate{
    func netServiceDidResolveAddress(_ sender: NetService) {
        print(sender.addresses?.first)
    }
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didFind aNetService: NetService, moreComing: Bool) {
      //Store a reference to aNetService for later use.


        print("Found something")
        print("Addresses", aNetService.addresses)
        print("Name", aNetService.name)
        print("Type",aNetService.type)
        print("Port", aNetService.port)
        if aNetService.port == -1 {
            self.dataArr.append(MDNSData(serviceName: aNetService.name, port: aNetService.port.description, ipAddr: "0.0.0.0", type: aNetService.type))
        } else {
            self.dataArr.append(MDNSData(serviceName: aNetService.name, port: aNetService.port.description, ipAddr: "", type: aNetService.type))
        }
        self.dataTbl.reloadData()
        
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        guard let data = aNetService.addresses?.first else { return }
        data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Void in
                let sockaddrPtr = pointer.bindMemory(to: sockaddr.self)
                guard let unsafePtr = sockaddrPtr.baseAddress else { return }
                guard getnameinfo(unsafePtr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    return
                }
            }
        
        let ipAddress = String(cString:hostname)
        print(ipAddress)
    }
}
class DataCell :UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var IPLbl: UILabel!
    @IBOutlet weak var portLbl: UILabel!
    
    func initView() {
        self.serviceName.layer.borderColor = UIColor.black.cgColor
        self.serviceName.layer.borderWidth = 0.5
        self.typeLbl.layer.borderColor = UIColor.black.cgColor
        self.typeLbl.layer.borderWidth = 0.5
        self.IPLbl.layer.borderColor = UIColor.black.cgColor
        self.IPLbl.layer.borderWidth = 0.5
        self.portLbl.layer.borderColor = UIColor.black.cgColor
        self.portLbl.layer.borderWidth = 0.5
    }
}

class MDNSData {
    
    let serviceName: String
    let port: String
    let ipAddr: String
    let type: String
    
    init(serviceName: String,port: String,ipAddr: String,type: String) {
        self.serviceName = serviceName
        self.type = type
        self.ipAddr = ipAddr
        self.port = port
    }
    
}
