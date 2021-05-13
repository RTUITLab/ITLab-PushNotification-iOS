//
//  RegistrationDevice.swift
//  
//
//  Created by Mikhail Ivanov on 16.04.2021.
//

import Foundation

struct RegistrationDeviceNone: Encodable {
    var device: DeviceInfo
    
    public init(device: String) {
        self.device = .init(deviceID: device)
    }
    
    func request(_ url: URL) {
        let url = url.appendingPathComponent("/user/addDevice")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json = try? JSONEncoder().encode(self) as Data
        request.httpBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Not registration device")
                }
            }
        }
        
        task.resume()
    }
    
    enum CodingKeys: CodingKey {
        case deviceID, type
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(device.deviceID, forKey: .deviceID)
        try container.encode(device.type, forKey: .type)
    }
}

struct RegistrationDeviceJWT: Encodable {
    var device: DeviceInfo
    var token: String
    
    public init(device: String, token: String) {
        self.device = .init(deviceID: device)
        self.token = token
    }
    
    func request(_ url: URL) {
        let url = url.appendingPathComponent("/user/addDevice")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json = try? JSONEncoder().encode(self) as Data
        request.httpBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Not registration device")
                }
            }
        }
        
        task.resume()
    }
    
    enum CodingKeys: CodingKey {
        case deviceID, type
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(device.deviceID, forKey: .deviceID)
        try container.encode(device.type, forKey: .type)
    }
}

struct RegistrationDeviceUser: Encodable {
    var device: DeviceInfo
    var id: UUID
    
    public init(device: String, id: UUID) {
        self.device = .init(deviceID: device)
        self.id = id
    }
    
    func request(_ url: URL) {
        let url = url.appendingPathComponent("/user/addDevice")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json = try? JSONEncoder().encode(self) as Data
        request.httpBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Not registration device")
                }
            }
        }
        
        task.resume()
    }
}


struct DeviceInfo: Codable {
    let deviceID: String
    let type: String
    
    init(deviceID: String) {
        self.type = "ios"
        self.deviceID = deviceID
    }
}
