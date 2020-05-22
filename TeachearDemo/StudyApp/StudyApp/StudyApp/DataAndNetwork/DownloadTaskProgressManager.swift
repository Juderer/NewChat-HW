//
//  DownloadTaskProgressManager.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/27.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

struct DownloadError: Error {
    
}

typealias ProgressDidChanged = ((Int64, Int64) -> ())
typealias DownloadDidFinished = ((URL?, Error?) -> ())

struct DownloadOption {
    var task: URLSessionDownloadTask
    var downloadProgress: ProgressDidChanged
    var downloadFinsh: DownloadDidFinished
}

class DownloadTaskProgressManager: NSObject, URLSessionDownloadDelegate {
    static let manager = DownloadTaskProgressManager()
    lazy var downloadsSession: URLSession = {
      let configuration = URLSessionConfiguration.default
      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()
    
    private lazy var taskDict: [String: DownloadOption] = {
        return [String: DownloadOption]()
    }()
    
    private lazy var resumeDataDict: [String: Data] = {
        return [String: Data]()
    }()
    
    func startDownload(url: String, progress: @escaping ProgressDidChanged, completion: @escaping DownloadDidFinished) {
        if let _ = taskDict[url] {
            return
        }
        guard let tmpURL = URL(string: url) else {
            return
        }
        var task: URLSessionDownloadTask!
        if let tmpData = resumeDataDict[url] {
            task = downloadsSession.downloadTask(withResumeData: tmpData)
        }
        else {
           task = downloadsSession.downloadTask(with: tmpURL)
        }
        let option = DownloadOption(task: task, downloadProgress: progress, downloadFinsh: completion)
        taskDict[url] = option
        task.cancel { (resumeData) in
            if let tmpData = resumeData {
                self.resumeDataDict[url] = tmpData
            }
        }
        task.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let urlStr = task.currentRequest?.url?.absoluteString,
            let option = taskDict[urlStr] {
            option.downloadFinsh(nil, error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let urlStr = downloadTask.currentRequest?.url?.absoluteString,
            let option = taskDict[urlStr] {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(urlStr.md5).m4a"
            let fileManager = FileManager.default
            do {
                try fileManager.moveItem(atPath: location.path, toPath: path)
                option.downloadFinsh(URL(fileURLWithPath: path), nil)
            } catch {
                option.downloadFinsh(nil, error)
                print("move file error")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let urlStr = downloadTask.currentRequest?.url?.absoluteString,
            let option = taskDict[urlStr] {
            option.downloadProgress(totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    

}
