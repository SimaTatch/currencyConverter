

import Foundation

protocol ApiManagerProtocol {
    func fetchJson(key: String, completion: @escaping (ExchangeRates) -> ())
}

struct APIManager: ApiManagerProtocol {
    

      func fetchJson(key: String = "USD", completion: @escaping (ExchangeRates) -> ()) {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(String(describing: key))") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let safeData = data else {return}
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                completion(results)
            } catch {
                print(error)
            }
        }.resume()
    }
}
