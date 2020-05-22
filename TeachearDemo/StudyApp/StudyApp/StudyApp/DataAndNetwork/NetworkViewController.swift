//
//  NetworkViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/24.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit
import AVKit

struct Song: Codable {
    var artistName = ""
    var trackName = ""
    var artworkUrl60 = ""
    var artworkUrl100 = ""
    var previewUrl = ""
    var trackId: Int = 0
    var isDownload: Int = 0 //不参与解析
    
    enum CodingKeys: CodingKey {
        case artistName
        case trackName
        case artworkUrl60
        case artworkUrl100
        case previewUrl
        case trackId
    }
}

struct SongResponse: Codable {
    var resultCount: Int = 0
    var results: [Song] = [Song]()
}

class SongCell: UITableViewCell {
    var titleLabel: UILabel!
    var descLabel: UILabel!
    var iconImageView: UIImageView!
    var progress: UIProgressView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(titleLabel)
        
        descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = UIColor.gray
        self.contentView.addSubview(descLabel)
        
        iconImageView = UIImageView()
        iconImageView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(iconImageView)
        
        progress = UIProgressView()
        progress.tintColor = UIColor.red
        progress.trackTintColor = UIColor.lightGray
        self.contentView.addSubview(progress)
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.top.equalTo(self.iconImageView)
        }
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        progress.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.bottom.equalTo(self.iconImageView)
            make.right.equalTo(self.contentView).offset(-10)
            make.height.equalTo(5)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        progress.progress = 0
        self.iconImageView.image = nil
    }
    
    func setupSong(song: Song) {
        if let url = URL(string: song.artworkUrl100) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.iconImageView.image = UIImage(data: data)
                    }
                } catch {
                    print("download image error: ", error)
                }
            }
        }
        titleLabel.text = song.trackName
        descLabel.text = song.artistName
    }
}

class NetworkViewController: BaseViewController {
    //object
    let reachability = try! Reachability()
    var urlSession: URLSession!
    var dataTask: URLSessionDataTask?
    var postDataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    var songList: [Song] = [Song]()
    //ui
    var searchBar: UISearchBar!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        
        URLProtocol.registerClass(MyURLProtocol.self)
        URLProtocol.unregisterClass(MyURLProtocol.self)
        checkNetwork()
        setupSession()
        postRequest()
        getSongs(searchTerm: "Muse")
        uploadTask()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "input something"
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
        }
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.register(SongCell.self, forCellReuseIdentifier: "SongCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.searchBar.snp.bottom)
        }
    }
}

extension NetworkViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            getSongs(searchTerm: text)
            searchBar.resignFirstResponder()
        }
    }
}

extension NetworkViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
        cell.setupSong(song: songList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as? SongCell
        let song = songList[indexPath.row]
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(song.previewUrl.md5).m4a"
        if FileManager.default.fileExists(atPath: path) {
            cell?.progress.progress = 1
            let vc = AVPlayerViewController()
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            vc.player = player
            self.present(vc, animated: true, completion: nil)
        } else {
            DownloadTaskProgressManager.manager.startDownload(url: song.previewUrl, progress: { (received, total) in
                print("progress:\(received), \(total)")
                DispatchQueue.main.async {
                    cell?.progress.progress = Float(received)/Float(total)
                }
            }) { (location, error) in
                if let tmp = location {
                    DispatchQueue.main.async {
                        let vc = AVPlayerViewController()
                        let player = AVPlayer(url: tmp)
                        vc.player = player
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension NetworkViewController {
    func checkNetwork() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func setupSession() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.protocolClasses = [MyURLProtocol.self]
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    func getSongs(searchTerm: String) {
        dataTask?.cancel()
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
        urlComponents?.query = "media=music&entity=song&term=\(searchTerm)"
        guard let url = urlComponents?.url else {
            return
        }
        dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    print(String(data: data, encoding: .utf8) ?? "")
                    let tmpModel = try JSONDecoder().decode(SongResponse.self, from: data)
                    self.songList = tmpModel.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        })
        dataTask?.resume()
    }
    
    func downloadSong(song: Song) {
        downloadTask?.cancel()
        let urlComponents = URLComponents(string: song.previewUrl)
        guard let url = urlComponents?.url else {
            return
        }
        downloadTask = urlSession.downloadTask(with: url, completionHandler: { (localURL, response, error) in
            if let localURL = localURL,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let documnets = NSHomeDirectory() + "\(song.trackId).m4a"
                let fileManager = FileManager.default
                do {
                    try fileManager.moveItem(atPath: localURL.path, toPath: documnets)
                } catch {
                    print("move file error")
                }
                DispatchQueue.main.async {
                    let vc = AVPlayerViewController()
                    let player = AVPlayer(url: URL(fileURLWithPath: documnets))
                    vc.player = player
                    self.present(vc, animated: true, completion: nil)
                }
            } else if let error = error {
                print("download error: ", error)
            }
        })
        downloadTask?.resume()
    }
    
    func postRequest() {
        let urlStr = "http://127.0.0.1:8001/add"
        guard let url = URL(string: urlStr) else {
            return
        }
        postDataTask?.cancel()
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        postDataTask = urlSession.dataTask(with: req, completionHandler: { (data, response, error) in
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
            } else if let error = error {
                print("post error: ", error)
            }
            do {
                self.postDataTask = nil
            }
        })
        postDataTask?.resume()
    }
    
    func uploadTask() {
        let url = URL(string: "http://127.0.0.1:8001/upload")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        let str = "{\"message\": \"return local data\"}"
        let tmpData = str.data(using: .utf8)
        
        let uploadTask = urlSession.uploadTask(with: request, from: tmpData) { (data, resp, error) in
            if let err = error {
                print("failed", err)
            } else if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
                print("success")
            }
        }
        uploadTask.resume()
    }
}

extension NetworkViewController: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                let credentials = URLCredential(trust: trust)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credentials)
                return
            }
        }
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
}
