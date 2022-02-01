

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {

     let apiMan = APIManager()
    
//    func testFetchJSON() {
//        apiMan.fetchJson(key: <#T##String#>, completion: <#T##(ExchangeRates) -> ()#>)
//    }
    
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

class MockSession: URLSession {
    
    var completionHandler: ((Data, URLResponse, Error) -> Void)?
    static var mockResponse: (data: Data?, URLResponse: URLResponse?, error: Error?)

    override class var shared: URLSession {
        return MockSession()
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
    }
    
}
class MockTask: URLSessionDataTask {
    
    typealias Response = (data: Data?, URLResponse: URLResponse?, error: Error?)
    var mockResponse: Response
    let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    init(response: Response, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.mockResponse = response
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler!(mockResponse.data, mockResponse.URLResponse, mockResponse.error)
    }
}
