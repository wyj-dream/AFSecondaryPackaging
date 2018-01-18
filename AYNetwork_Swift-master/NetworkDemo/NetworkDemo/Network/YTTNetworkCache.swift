//
//  YTTNetworkCache.swift
//
//  Created by Andy on 2017/7/19.
//  Copyright © 2017年 AndyCuiYTT. All rights reserved.
//


/**
 *  网络请求缓存处理
 *
 *  将网络请求结果保存在本地，发起网路请求时先检测缓存区是否有缓存数据并判断是否超出缓存有效时间，如果数据有效则加载缓存区数据，否则加载网络数据.
 *
 *  数据缓存采用 SQLite 存储，采用 FMDB 库.
 *
 *  缓存数据表表数据有 key,value,date 三个字段. key: 网络请求参数 MD5加密数据. value:网络请求数据. date: 数据有效时间
 *
 *  添加计时器,定时清除无效数据.
 *
 */





import UIKit

class YTTNetworkCache: NSObject {
    
    private var timer: Timer!
    
    static var networkCache: YTTNetworkCache = YTTNetworkCache()
    
    private var dbQueue: FMDatabaseQueue!
    
    class func shareInstance() -> YTTNetworkCache {
        return networkCache
    }
    
    override init() {
        super.init()
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/netCache/")
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: path!) {
            try! fileManager.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
        }
        path?.append("netcache.sqlite")
        
        print(path ?? "")
        dbQueue = FMDatabaseQueue(path: path)
        dbQueue.inDatabase { (db) in
            db.open()
            do{
                try db.executeUpdate("CREATE TABLE IF NOT EXISTS T_netCache(key varchar(20) PRIMARY KEY , value TEXT,date varchar(25),verify varchar(16))", values: nil)
            }catch {
                print(error)
            }
            db.close()
        }
        
        timer = Timer.scheduledTimer(timeInterval: YTTNetworkConfig.updateCacheTime, target: self, selector: #selector(checkDate), userInfo: nil, repeats: true)
        
    }
    
    
    @objc private func checkDate() -> Void {
        DispatchQueue.init(label: "com.andy.netcache").async {
            self.removeResult(withOldDate: Date().timeIntervalSince1970)
        }
    }
    
    /// 根据 key 移除数据
    ///
    /// - Parameter key: 键值
    func removeResult(_ key: String) -> Void {
        dbQueue.inDatabase { (db) in
            db.open()
            do{
                try db.executeUpdate("delete from T_netCache where key = ?", values: [key])
            }catch {
                print("移除缓存数据失败，错误：\(error)")
            }
            db.close()
        }
    }
    
    /// 移除全部数据
    func removeAllResults() -> Void {
        dbQueue.inDatabase { (db) in
            db.open()
            do{
                try db.executeUpdate("delete from T_netCache", values: [])
            }catch {
                print("移除缓存数据失败，错误：\(error)")
            }
            db.close()
        }
    }
    
    
    /// 移除失效数据
    ///
    /// - Parameter date: 时间点
    func removeResult(withOldDate date: TimeInterval) -> Void {
        dbQueue.inDatabase { (db) in
            db.open()
            do{
                try db.executeUpdate("delete from T_netCache where date < ?", values: [date])
            }catch {
                print("移除缓存数据失败，错误：\(error)")
            }
            db.close()
        }
    }
    
    /// 添加数据
    ///
    /// - Parameters:
    ///   - key: 键值
    ///   - result: 请求数据
    ///   - date: 有效时间
    func addResult(_ key: String, result: String, date: TimeInterval, verify: String) -> Void {
        dbQueue.inDatabase { (db) in
            db.open()
            do{
                try db.executeUpdate("insert into T_netCache (key,value,date,verify) values (?,?,?,?)", values: [key, result, date, verify])
            }catch {
                print("添加缓存数据失败，错误：\(error)")
            }
            db.close()
        }
    }
    
    func updateResult(_ key: String, result: String, date: TimeInterval, verify: String) -> Void {
        dbQueue.inDatabase { (db) in
            db.open()
            do{
                try db.executeUpdate("update T_netCache set value = ? , date = ?, verify = ? where key = ?", values: [result, date,verify, key])
            }catch {
                print(error)
            }
            db.close()
        }
    }
    
    /// 获取数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 数据
    func getResult(_ key: String) -> String? {
        
        var result: (value: String , date: TimeInterval, verify: String)?
        dbQueue.inDatabase { (db) in
            db.open()
            if let resultSet = try? db.executeQuery("select * from T_netCache where key = ?", values: [key]) {
                if (resultSet.next()) {
                    result = (resultSet.string(forColumn: "value"), resultSet.double(forColumn: "date"), resultSet.string(forColumn: "verify")) as? (String, TimeInterval, String)
                }
                resultSet.close()
            }
            db.close()
        }
        
        if result != nil {
            
            if (result?.date)! > Date().timeIntervalSince1970 && YTTNetworkCache.MD5((result?.value)!) == result?.verify {
                return result?.value
            }else {
                self.removeResult(key)
            }
        }
        return nil
    }
    
    deinit {
        timer.invalidate()
        timer = nil
        dbQueue.close()
        dbQueue = nil
    }
    
    
    class func MD5(_ str: String) -> String {
        let cChar = str.cString(using: .utf8)
        let strLen = CUnsignedInt(str.lengthOfBytes(using: .utf8))
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cChar, strLen, result)
        let MD5Str = NSMutableString()
        for i in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
            MD5Str.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return MD5Str as String
    }

    
}
