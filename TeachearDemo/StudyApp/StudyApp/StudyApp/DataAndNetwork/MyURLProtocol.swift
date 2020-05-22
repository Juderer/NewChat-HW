//
//  MyURLProtocol.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/27.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import Foundation

struct MyError: Error {
    var localizedDescription: String = "local date error"
}

class MyURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        if let url = request.url?.absoluteString, url.contains("127.0.0.1:8001/add") {
            return true
        }
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        var req1 = request
        req1.setValue("xxx", forHTTPHeaderField: "xxx")
        return req1
    }
    
    override func startLoading() {
        let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .allowed)
        let str = "{\"message\": \"你好，我是本地数据\"}"
        if let tmpData = str.data(using: .utf8) {
            self.client?.urlProtocol(self, didLoad: tmpData)
        } else {
            self.client?.urlProtocol(self, didFailWithError: MyError())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}



