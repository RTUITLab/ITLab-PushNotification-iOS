//
//  RemoveDevice.swift
//  
//
//  Created by Михаил Иванов on 05.05.2021.
//

import Foundation

struct RemoveDeviceUser: Codable {
    var device: DeviceInfo
    var id: UUID
    
    public init(device: String, id: UUID) {
        self.device = .init(deviceID: device)
        self.id = id
    }
    
    func request(_ url: URL) {
        let url = url.appendingPathComponent("/user/removeDevice")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
