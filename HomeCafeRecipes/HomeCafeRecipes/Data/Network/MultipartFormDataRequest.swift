//
//  MultipartFormDataRequest.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/16/24.
//

import Foundation

struct MultipartFormDataRequest {
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    mutating func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value).data(using: .utf8)!)
    }
    
    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    mutating func addDataField(named name: String, data: Data, filename: String, mimeType: String) {
        httpBody.append(dataFormField(named: name, data: data, filename: filename, mimeType: mimeType))
    }
    
    private func dataFormField(named name: String, data: Data, filename: String, mimeType: String) -> Data {
        let fieldData = NSMutableData()
        
        fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        fieldData.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
        fieldData.append("\r\n".data(using: .utf8)!)
        fieldData.append(data)
        fieldData.append("\r\n".data(using: .utf8)!)
        
        return fieldData as Data
    }
    
    mutating func finalize() {
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody as Data
        return request
    }
}
