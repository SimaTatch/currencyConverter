

import Foundation



struct ExchangeRates: Codable {
    let time_last_update_utc: String
    let base_code: String
    let rates: [String: Double]

}




