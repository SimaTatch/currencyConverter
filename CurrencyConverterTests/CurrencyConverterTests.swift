

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {

     let apiMan = APIManager()
    
    func testParseNonJsonString() {
        let json = """
{
"time_last_update_utc": "Fri, 28 Jan 2022 00:02:32 +0000",
"base_code": "USD",
"rates": {
        "USD": 1,
        "AED": 3.67,
        "AFN": 103.94 }
}
"""
        let jsonData = json.data(using: .utf8)!
        let currencyData = try! JSONDecoder().decode(ExchangeRates.self, from: jsonData)
        XCTAssertEqual("USD", currencyData.base_code)
        XCTAssertEqual("Fri, 28 Jan 2022 00:02:32 +0000", currencyData.time_last_update_utc)
        XCTAssertEqual(["USD": 1,
                       "AED": 3.67,
                       "AFN": 103.94] , currencyData.rates)


    }
}
