//
//  FilePathViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/22.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class FilePathViewController: BaseViewController {
    
    var control: UISegmentedControl!
    var function: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function = UISegmentedControl(items: ["Read", "Write"])
//        function.addTarget(self, action: #selector(controlAction), for: .valueChanged)
        function.sizeToFit()
        function.tintColor = .black
        self.view.addSubview(function)
        function.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        control = UISegmentedControl(items: ["AppName", "Documents", "Caches", "tmp", "Home"])
        control.addTarget(self, action: #selector(controlAction), for: .valueChanged)
        control.sizeToFit()
        control.tintColor = .black
        self.view.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.function.snp.bottom).offset(20)
        }
        
//        let path = createDirectory(directory: "Mine")
//        do {
//            let filePath = path.appendingPathComponent("name1.json")
////            filePath = filePath.replacingOccurrences(of: "file://", with: "")
//            try "我是name1".write(to: filePath, atomically: true, encoding: .utf8)
////            try "我是name1".write(toFile: filePath, atomically: true, encoding: .utf8)
//        } catch let error {
//            print("write error:", error)
//        }
//        propertyListRead()
        propertyListReadArray()
//        propertyListWrite(dictionary: ["name": "Bob", "age": "25"])
//        propertyListWriteArray(array: ["Bob", "Dell"])
//        deleteDirectory()
//        deleteFile()
        
        testCodable()
        testUserDefault()
    }
    
    
    @objc func controlAction() {
        var path: String?
        switch control.selectedSegmentIndex {
        case 0:
            path = Bundle.main.bundlePath
        case 1:
            path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        case 2:
            path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        case 3:
            path = NSTemporaryDirectory()
        case 4:
            path = NSHomeDirectory()
        default:
            break
        }
        print(path ?? "不存在")
        guard let tmpPath = path else {
            return
        }
        let filePath = tmpPath.appending("/name.json")
    
        if function.selectedSegmentIndex == 0 {
            do {
                let content = try String(contentsOfFile: filePath)
                print(content)
            } catch let err {
                print("read error", err)
            }
        } else {
            let content = "{\"name\": \"zzh\"}"
            do {
                try content.write(toFile: filePath, atomically: true, encoding: .utf8)
            } catch let error {
                print("write error:", error)
            }
        }
    }
}

extension FilePathViewController {
    
    func getPath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent("Mine")
        return directoryURL
    }
    
    func createDirectory(directory: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent(directory)
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return directoryURL
    }
    
    func deleteDirectory() {
        do {
            try FileManager.default.removeItem(at: getPath())
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: getPath().appendingPathComponent("address.plist"))
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
}

extension FilePathViewController {
    
    func testCodable() {
        fromJSON()
        toJSON()
        jsonEncodeAddressBook()
        jsonDecodeAddressBook()
        
        propertyListWriteAddressBook()
        propertyListReadAddressBook()
    }
    
}

extension FilePathViewController {
    
    func propertyListWrite(dictionary: [String: String]) {
        let fileExtension = "plist"
        let directoryURL = createDirectory(directory: "Mine")
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .binary, options: 0)
            try data.write(to: directoryURL.appendingPathComponent("address").appendingPathExtension(fileExtension))
        }  catch {
            print(error)
        }
    }
    
    func propertyListWriteArray(array: [String]) {
        let fileExtension = "plist"
        let directoryURL = createDirectory(directory: "Mine")
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: array, format: .binary, options: 0)
            try data.write(to: directoryURL.appendingPathComponent("address").appendingPathExtension(fileExtension))
        }  catch {
            print(error)
        }
    }
    
    func propertyListReadArray() {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.binary //Format of the Property List.
        var array: [String] = [] //Our data
        let path = getPath().appendingPathComponent("address").appendingPathExtension("plist")
        let readPath = path.absoluteString.replacingOccurrences(of: "file://", with: "")
        let data = FileManager.default.contents(atPath: readPath)
//        let plistPath: String? = Bundle.main.path(forResource: "Info", ofType: "plist")! //the path of the data
//        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        
        do {//convert the data to a dictionary and handle errors.
            array = try PropertyListSerialization.propertyList(from: data!, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String]
            print(array)
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
    }
    
    func propertyListRead() {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.binary //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let plistPath: String? = Bundle.main.path(forResource: "Info", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
            print(plistData)
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
    }
    
    func propertyListWriteAddressBook() {
        var models = [AddressBook]()
        models.append(AddressBook(name: "Alex", age: 23))
        models.append(AddressBook(name: "Bob", age: 25))
        models.append(AddressBook(name: "Cartter", age: 40))
        
        let fileExtension = "plist"
        let directoryURL = createDirectory(directory: "Property")
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            let data = try encoder.encode(models)
            try data.write(to: directoryURL.appendingPathComponent("address").appendingPathExtension(fileExtension))
        }  catch {
            print("propertyListWriteAddressBook error:", error)
        }
    }
    
    func propertyListReadAddressBook() {
        do {
            let fileExtension = "plist"
            let directoryURL = createDirectory(directory: "Property")
            let data = try Data(contentsOf: directoryURL.appendingPathComponent("address").appendingPathExtension(fileExtension))
            let decoder = PropertyListDecoder()
            let models = try decoder.decode([AddressBook].self, from: data)
            print(models)
        } catch {
            print("propertyListReadAddressBook error:", error)
        }
    }
}

extension FilePathViewController {
    
    func toJSON() {
        let models = ["Alex", "Bob", "Cartter"]
//        if !JSONSerialization.isValidJSONObject(models) {
//            print("toJSON not valid JSON data")
//            return
//        }
        do {//convert the data to a dictionary and handle errors.
            let data = try JSONSerialization.data(withJSONObject: models, options: .init(rawValue: 0))
            print(String(data: data, encoding: .utf8) ?? "")
        } catch {
            print("Error to json: \(error)")
        }
    }
    
    func fromJSON() {
        let str = "[\"Alex\", \"Bob\", \"Cartter\"]"
        guard let tmpData = str.data(using: .utf8) else {
            return
        }
        do {
            let models = try JSONSerialization.jsonObject(with: tmpData, options: .allowFragments)
            print(models)
        } catch {
           print("Error from json: \(error)")
        }
    }
    
    func jsonEncodeAddressBook() {
        var models = [AddressBook]()
        models.append(AddressBook(name: "Alex", age: 23))
        models.append(AddressBook(name: "Bob", age: 25))
        models.append(AddressBook(name: "Cartter", age: 40))
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(models)
            print(String(data: data, encoding: .utf8) ?? "")
        } catch {
            print("Error reading plist: \(error), format: xml")
        }
    }
    
    func jsonDecodeAddressBook() {
        let str = "[{\"name\":\"Alex\",\"age\":23},{\"name\":\"Bob\",\"age\":25},{\"name\":\"Cartter\",\"age\":40}]"
        guard let tmpData = str.data(using: .utf8) else {
            return
        }
        
        do {
            let models = try JSONDecoder().decode([AddressBook].self, from: tmpData)
            print(type(of: models))
        } catch {
            print("Error decodeAddressBook: \(error)")
        }
    }
    
}


extension FilePathViewController {
    
    func testUserDefault() {
        UserDefaults.standard.set("Bob", forKey: "User")
        let name = UserDefaults.standard.value(forKey: "User")
        print(name)
        
    }
}
