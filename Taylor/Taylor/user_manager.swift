//
//  user_manager.swift
//  Taylor
//
//  Created by mac on 2023/6/19.
//

import Foundation

import SQLite3





class UserManager {
    static let shared = UserManager()
    
    private var db: OpaquePointer?
    
    private init() {
        // Connect to the database
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("TestDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        // Create the users table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (Username TEXT PRIMARY KEY, Password TEXT, PhoneNumber TEXT, LivingAddress TEXT, Email TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        
        
        // include Height and Weight
        if sqlite3_exec(db, "ALTER TABLE Users ADD COLUMN Height TEXT", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error adding height column: \(errmsg)")
        }

        if sqlite3_exec(db, "ALTER TABLE Users ADD COLUMN Weight TEXT", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error adding weight column: \(errmsg)")
        }

        
        
    }
    
    func register(username: String, password: String, phoneNumber: String?, livingAddress: String?, email: String?, height: String? = nil, weight: String? = nil) -> Bool {
        
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO Users (Username, Password, PhoneNumber, LivingAddress, Email, Height, Weight) VALUES (?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return false
        }
         
        if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding username: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, password, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding password: \(errmsg)")
            return false
        }
        
        if let phoneNumber = phoneNumber {
            if sqlite3_bind_text(stmt, 3, phoneNumber, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Failure binding phoneNumber: \(errmsg)")
                return false
            }
        }
        
        if let livingAddress = livingAddress {
            if sqlite3_bind_text(stmt, 4, livingAddress, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Failure binding livingAddress: \(errmsg)")
                return false
            }
        }
        
        if let email = email {
            if sqlite3_bind_text(stmt, 5, email, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Failure binding email: \(errmsg)")
                return false
            }
        }
        
        // Binding height and weight.
        if let height = height {
                if sqlite3_bind_text(stmt, 6, height, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("Failure binding height: \(errmsg)")
                    return false
                }
            }

            if let weight = weight {
                if sqlite3_bind_text(stmt, 7, weight, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("Failure binding weight: \(errmsg)")
                    return false
                }
            }

        
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure inserting user: \(errmsg)")
            return false
        }
        
        return true
    }
    
    
    // Your existing methods here (register, login, getAllUsers)

     func getUserInfo(username: String) -> (String, String, String?, String?, String?, String?, String?)? {
         var stmt: OpaquePointer?
         let queryString = "SELECT * FROM Users WHERE Username = ?"

         if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(db)!)
             print("Error preparing select: \(errmsg)")
             return nil
         }
         
         if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(db)!)
             print("Failure binding username: \(errmsg)")
             return nil
         }
         
         if sqlite3_step(stmt) == SQLITE_ROW {
             let username = String(cString: sqlite3_column_text(stmt, 0))
             let password = String(cString: sqlite3_column_text(stmt, 1))
             let phoneNumber = sqlite3_column_text(stmt, 2) != nil ? String(cString: sqlite3_column_text(stmt, 2)) : nil
             let livingAddress = sqlite3_column_text(stmt, 3) != nil ? String(cString: sqlite3_column_text(stmt, 3)) : nil
             let email = sqlite3_column_text(stmt, 4) != nil ? String(cString: sqlite3_column_text(stmt, 4)) : nil
             let height = sqlite3_column_text(stmt, 5) != nil ? String(cString: sqlite3_column_text(stmt, 5)) : nil
             let weight = sqlite3_column_text(stmt, 6) != nil ? String(cString: sqlite3_column_text(stmt, 6)) : nil
             
             return (username, password, phoneNumber, livingAddress, email, height, weight)
         } else {
             return nil
         }
     }
    
    
    
    func login(username: String, password: String) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM Users WHERE Username = ? AND Password = ?"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding username: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, password, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding password: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            return true
        } else {
            return false
        }
    }
    
    
    func getAllUsers() -> [(String, String, String?, String?, String?, String?, String?)]   {

        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM Users"
        var result = [(String, String, String?, String?, String?, String?, String?)]()


        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return result
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
                let username = String(cString: sqlite3_column_text(stmt, 0))
                let password = String(cString: sqlite3_column_text(stmt, 1))
                let phoneNumber = sqlite3_column_text(stmt, 2) != nil ? String(cString: sqlite3_column_text(stmt, 2)) : nil
                let livingAddress = sqlite3_column_text(stmt, 3) != nil ? String(cString: sqlite3_column_text(stmt, 3)) : nil
                let email = sqlite3_column_text(stmt, 4) != nil ? String(cString: sqlite3_column_text(stmt, 4)) : nil
                // Get height and weight.
                let height = sqlite3_column_text(stmt, 5) != nil ? String(cString: sqlite3_column_text(stmt, 5)) : nil
                let weight = sqlite3_column_text(stmt, 6) != nil ? String(cString: sqlite3_column_text(stmt, 6)) : nil

                result.append((username, password, phoneNumber, livingAddress, email, height, weight))
            }

            return result
    }

    
}

