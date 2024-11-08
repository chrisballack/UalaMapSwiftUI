//
//  SQLManager.swift
//  UalaMap
//
//  Created by Christians bonilla on 4/11/24.
//

import SQLite3
import Foundation

/// A manager class responsible for handling all SQLite database operations related to storing and retrieving favorite locations.
class SQLManager {
    var db: OpaquePointer?

    /// Initializes the `SQLManager` and opens the database connection.
    init() {
        openDatabase()
    }

    /// Opens the SQLite database from the app's document directory and creates the `Favorites` table if it doesn't already exist.
    func openDatabase() {
        // Get the file URL for the database in the document directory.
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("LocationDatabase.sqlite")

        // Open the database at the specified file path.
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            print("Successfully opened database at \(fileURL.path)")
            createFavoritesTable()
        }
    }

    /// Creates the `Favorites` table in the database if it does not already exist.
    func createFavoritesTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Favorites (
            id INTEGER PRIMARY KEY,
            country TEXT NOT NULL,
            name TEXT NOT NULL,
            lon REAL NOT NULL,
            lat REAL NOT NULL 
        );
        """
        
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Favorites table created.")
            } else {
                print("Favorites table could not be created.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("CREATE TABLE statement could not be prepared: \(errorMessage)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    /// Inserts a location into the `Favorites` table.
    func insertFavorites(location: Location) {
        let insertStatementString = """
        INSERT INTO Favorites (id, country, name, lon, lat) VALUES (?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(location.id))
            sqlite3_bind_text(insertStatement, 2, (location.country as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (location.name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, location.coord.lon)
            sqlite3_bind_double(insertStatement, 5, location.coord.lat)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted favorites.")
            } else {
                print("Could not insert favorites. Error: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("INSERT statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    /// Fetches all favorite locations from the `Favorites` table.
    func fetchAllFavorites() -> [Location] {
        let queryStatementString = "SELECT * FROM Favorites;"
        var queryStatement: OpaquePointer?
        var locations: [Location] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let country = String(cString: sqlite3_column_text(queryStatement, 1))
                let name = String(cString: sqlite3_column_text(queryStatement, 2))
                let lon = sqlite3_column_double(queryStatement, 3)
                let lat = sqlite3_column_double(queryStatement, 4)
                let coordinate = Coordinate(lon: lon, lat: lat)
                let location = Location(country: country, name: name, id: id, coord: coordinate, favorite: true)
                locations.append(location)
            }
        } else {
            print("SELECT statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(queryStatement)
        return locations
    }
    
    /// Deletes a favorite location from the `Favorites` table by its ID.
    func deleteFavorite(by id: Int) {
        let deleteStatementString = "DELETE FROM Favorites WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        
        // Prepare and execute the DELETE statement.
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted favorites with id \(id).")
            } else {
                print("Could not delete favorites with id \(id).")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }
}
