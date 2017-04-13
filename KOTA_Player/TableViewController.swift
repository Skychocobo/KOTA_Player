//
//  ViewController.swift
//  KOTA_Player
//
//  Created by  noble on 2016. 10. 27..
//  Copyright © 2016년 KOTA. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet var tblJSON: UITableView!
    
    var userID = ""
    var userGrade = ""
    var userName = ""
    var listURL = "https://www.ocarinafestival.kr"
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let objects = try! managedObjectContext.fetch(request)
        
        if !objects.isEmpty {
            for i in 0..<objects.count {
                let match = objects[i] as! NSManagedObject
                userID = match.value(forKey: "id") as! String
                userGrade = match.value(forKey: "grade") as! String
                userName = match.value(forKey: "name") as! String
            }
            self.loginBtn.setTitle(userName, for: .normal)
        }
        callAlamo(url: listURL)
    }
    
    //로그인 버튼
    @IBAction func loginBtn(_ sender: AnyObject) {
        
        if userGrade.isEmpty {
            loginChecker()
        } else {
            logoutChecker()
        }
    }
    
    //로그인
    func loginChecker() {
        
        let alertController = UIAlertController(title: "로그인", message: "아이디와 페스워드를 입력해주세요", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "아이디"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "페스워드"
            textField.isSecureTextEntry = true
        }
        
        let confirmAction = UIAlertAction(title: "로그인", style: .default) { (_) in
            
            let ID = String((alertController.textFields![0]).text!)!
            let userPassword = String((alertController.textFields![1]).text!)!
            
            if ID == "" || userPassword == "" {
                let alertController = UIAlertController(title: "아이디와 패스워드를 입력해주세요", message: "", preferredStyle: .alert)
                let MessageAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(MessageAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            let myUrl = NSURL(string: "https://www.ocarinafestival.kr/Ncv5/App/userLogin.php")
            let request = NSMutableURLRequest(url: myUrl! as URL)
            request.httpMethod = "POST"
            
            let postString = "id=\(ID)&password=\(userPassword)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, responds, error in
                
                if error != nil {
                    print("error=\(String(describing: error))")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parsenJSON = json {
                        let resultValue = parsenJSON["status"] as! String
                        
                        if resultValue == "Success" {
                            
                            UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            self.dismiss(animated: true, completion:nil)
                            
                            let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: self.managedObjectContext)
                            let user = User(entity: entityDescription!, insertInto: self.managedObjectContext)
                            
                            self.userID = ID
                            self.userName = parsenJSON["name"] as! String
                            self.userGrade = parsenJSON["grade_id"] as! String
                            
                            user.id = self.userID
                            user.name = self.userName
                            user.grade = self.userGrade
                            
                            self.loginBtn.setTitle(self.userID, for: .normal)
                            
                        } else {
                            
                            let alertController = UIAlertController(title: "로그인 실패", message: "아이디와 패스워드를 확인해주세요", preferredStyle: .alert)
                            let MessageAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(MessageAction)
                            self.present(alertController, animated: true, completion: nil)
                            print("result:\(resultValue)")
                            
                        }
                        
                    }
                    
                } catch {print(error)}
                
            }
            task.resume()
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //로그아웃
    func logoutChecker() {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: self.managedObjectContext)
        let user = User(entity: entityDescription!, insertInto: self.managedObjectContext)
        
        user.id = String(describing: userID = "")
        user.name = String(describing: userName = "")
        user.grade = String(describing: userGrade = "")
        
        self.loginBtn.setTitle("Login", for: .normal)
        
        let alertController = UIAlertController(title: "로그아웃 되었습니다.", message: "", preferredStyle: .alert)
        let MessageAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(MessageAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //CallList
    func callAlamo(url : String) {
        
        Alamofire.request(url+"/Ncv5/App/test.php", method: .post, parameters: ["inst":"43"]).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if swiftyJsonVar["status"] == "Success" {
                    
                    print("success")
                    
                    if let resData = swiftyJsonVar["data"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if self.arrRes.count > 0 {
                        self.tblJSON.reloadData()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell") as! TableViewCell
        
        var dict = arrRes[(indexPath as NSIndexPath).row]
        
        cell.listTitle.text = dict["title"] as? String
        cell.listInstrument.text = dict["instrument_name"] as? String
        cell.listGenre.text = dict["genre_name"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let fileTitle = (arrRes[indexPath.row])["title"]! as! String
        
        print(fileTitle)
        
        let imgName = (arrRes[indexPath.row])["solo_musicreg"]! as! String
        //let reImgName = imgName.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        let fileName = (arrRes[indexPath.row])["solo_normal"]! as! String
        //let reFileName = fileName.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        SharingManager.sharedInstance.fileTitle = fileTitle
        SharingManager.sharedInstance.fileName = fileName
        SharingManager.sharedInstance.imgName = imgName
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
