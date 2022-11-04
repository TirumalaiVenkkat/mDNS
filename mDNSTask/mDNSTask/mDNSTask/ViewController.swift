//
//  ViewController.swift
//  mDNSTask
//
//  Created by trioangle on 04/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var dataTbl: UITableView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var IPLbl: UILabel!
    @IBOutlet weak var portLbl: UILabel!

    var dataArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataTbl.delegate = self
        self.dataTbl.dataSource = self
        self.serviceName.text = "Service Name"
        self.typeLbl.text = "Type"
        self.IPLbl.text = "IP"
        self.portLbl.text = "Port"
    }
    
    func publish() {
        print("Publishing...")
        
    }
    
    func scan() {
        print("Scanning...")
        //Append values to a dictionary
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        cell.serviceName.text = "Service Name"
        cell.typeLbl.text = "Type"
        cell.IPLbl.text = "IP"
        cell.portLbl.text = "Port"
        return cell
    }
    
}

class DataCell :UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var IPLbl: UILabel!
    @IBOutlet weak var portLbl: UILabel!
}

