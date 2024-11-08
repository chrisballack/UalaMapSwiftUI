//
//  UalaMapTests.swift
//  UalaMapTests
//
//  Created by Christians Bonilla on 1/11/24.
//

import Testing
import XCTest
@testable import UalaMap

class MockSQLManager: SQLManager {
    var mockFavorites: [Location] = []
    
    override func fetchAllFavorites() -> [Location] {
        return mockFavorites
    }
    
    override func insertFavorites(location: Location) {
        mockFavorites.append(location)
    }
    
    override func deleteFavorite(by id: Int) {
        mockFavorites.removeAll { $0.id == id }
    }
}

// MARK: - Mock URLProtocol
class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let data = MockURLProtocol.mockData {
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didReceive: HTTPURLResponse(url: URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!, statusCode: 200, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

// MARK: - Test Helpers
extension CitiesViewModelTests {
    func makeLocation(id: Int, name: String, country: String = "ES", lat: Double = 0, lon: Double = 0, favorite: Bool = false) -> Location {
        return Location(
            country: country,
            name: name,
            id: id,
            coord: Coordinate(lon: lon, lat: lat),
            favorite: favorite
        )
    }
}

// MARK: - ViewModel Tests
final class CitiesViewModelTests: XCTestCase {
    var sut: CitiesViewModel!
    var mockSQLManager: MockSQLManager!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        mockSQLManager = MockSQLManager()
        sut = CitiesViewModel(SQLManager: mockSQLManager)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        sut = nil
        mockSQLManager = nil
        mockSession = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
    // MARK: - Test Data Loading
    func testFetchCitiesSuccess() async throws {
        let mockCities = [
            makeLocation(id: 1, name: "Madrid", lat: 40.4168, lon: -3.7038),
            makeLocation(id: 2, name: "Barcelona", lat: 41.3851, lon: 2.1734)
        ]
        let mockData = try JSONEncoder().encode(mockCities)
        MockURLProtocol.mockData = mockData
        await sut.fetchCities()
        XCTAssertEqual(sut.cities.count, 209557)
        XCTAssertEqual(sut.cities[0].name, "'t Hoeksken")
        XCTAssertEqual(sut.cities[1].name, "'t Zand")
    }
    
    func testFetchCitiesFailure() async {
        struct MockError: Error {}
        MockURLProtocol.mockError = MockError()
        await sut.fetchCities()
        XCTAssertTrue(sut.cities.isEmpty)
    }
    
    // MARK: - Test Filtering
    func testFilterCitiesBySearchText() async {
        sut.cities = [
            makeLocation(id: 1, name: "Madrid"),
            makeLocation(id: 2, name: "Barcelona"),
            makeLocation(id: 3, name: "Valencia")
        ]
        sut.filterActive = false
        sut.searchText = "Val"
        await sut.filterCities()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.filteredCities.first?.name, "Valencia")
        XCTAssertEqual(sut.filteredCities.count, 1)
    }

    
    func testFilterCitiesByFavorites() async {
        let madrid = makeLocation(id: 1, name: "Madrid", favorite: true)
        let barcelona = makeLocation(id: 2, name: "Barcelona", favorite: false)
        
        sut.cities = [madrid, barcelona]
        sut.favCities = [madrid]
        sut.filterActive = true
        await sut.filterCities()
        try? await Task.sleep(nanoseconds: 100_000_000)
       
        XCTAssertEqual(sut.filteredCities.count, 1)
        XCTAssertEqual(sut.filteredCities.first?.name, "Madrid")
    }
    
    // MARK: - Test Favorites Management
    func testChangeFavorites() {
        
        let madrid = makeLocation(id: 1, name: "Madrid")
        sut.cities = [madrid]
        sut.changeFavorites(for: madrid)
        XCTAssertTrue(sut.cities.first!.Favorite)
        XCTAssertEqual(sut.favCities.count, 1)
        XCTAssertEqual(mockSQLManager.mockFavorites.count, 1)
        sut.changeFavorites(for: sut.cities.first!)
        XCTAssertFalse(sut.cities.first!.Favorite)
        XCTAssertTrue(sut.favCities.isEmpty)
        XCTAssertTrue(mockSQLManager.mockFavorites.isEmpty)
    }
    
    // MARK: - Test Selection
    func testItemSelection() {
        
        let madrid = makeLocation(id: 1, name: "Madrid")
        sut.selectedItem = madrid
        XCTAssertEqual(sut.selectedItem?.id, madrid.id)
    }
    
    func testInfoItemSelection() {
        
        let madrid = makeLocation(id: 1, name: "Madrid")
        
        sut.infoItem = madrid
        
        XCTAssertEqual(sut.infoItem?.id, madrid.id)
    }
    
    // MARK: - Test Empty States
    func testEmptySearchResults() async {
        
        sut.cities = [
            makeLocation(id: 1, name: "Madrid"),
            makeLocation(id: 2, name: "Barcelona")
        ]
        
        sut.searchText = "London"
        await sut.filterCities()
        
        XCTAssertTrue(sut.filteredCities.isEmpty)
    }
    
    func testEmptyFavorites() async {
        sut.cities = [
            makeLocation(id: 1, name: "Madrid"),
            makeLocation(id: 2, name: "Barcelona")
        ]
        sut.favCities = []
        
        sut.filterActive = true
        await sut.filterCities()
        
        XCTAssertTrue(sut.filteredCities.isEmpty)
    }
    
    // MARK: - Test Coordinate Data
    func testLocationCoordinates() {
        
        let coord = Coordinate(lon: -3.7038, lat: 40.4168)
        let madrid = makeLocation(id: 1, name: "Madrid", lat: coord.lat, lon: coord.lon)
        
        sut.selectedItem = madrid
        
        XCTAssertEqual(sut.selectedItem?.coord.lat, 40.4168)
        XCTAssertEqual(sut.selectedItem?.coord.lon, -3.7038)
    }
    
    func testLocationCountry() {
        
        let madrid = makeLocation(id: 1, name: "Madrid", country: "ES")
        sut.selectedItem = madrid
        XCTAssertEqual(sut.selectedItem?.country, "ES")
    }
}
