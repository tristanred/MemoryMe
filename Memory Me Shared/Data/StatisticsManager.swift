//
//  PreferenceManager.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-19.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation

class UserStatistics : NSObject, NSCoding
{
    var overallAverageLength: Int32 = 0;
    var overallLongestLength: Int32 = 0;
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(overallAverageLength, forKey: "overallAverageLength");
        aCoder.encode(overallLongestLength, forKey: "overallLongestLength");
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        self.init();
        
        self.overallAverageLength = aDecoder.decodeInt32(forKey: "overallAverageLength");
        self.overallLongestLength = aDecoder.decodeInt32(forKey: "overallLongestLength");
    }
}

func getUserPreferencePath() -> String
{
    #if os(OSX)
    return "";
    #else
    return NSHomeDirectory();
    #endif
}

class StatisticsManager
{
    private static var _pref: StatisticsManager?;
    static var `default`: StatisticsManager {
        get {
            if _pref == nil
            {
                _pref = StatisticsManager(archiveName: "a.bin");
                _pref?.load();
            }
            
            return _pref!;
        }
    }
    
    public var current: UserStatistics;
    
    private var preferenceFile: FileHandle?;
    
    init(archiveName: String)
    {
        current = UserStatistics();

        preferenceFile = FileHandle(forUpdatingAtPath: getUserPreferencePath() + "/" + archiveName);
        
        if(preferenceFile == nil)
        {
            if FileManager.default.createFile(atPath: getUserPreferencePath() + "/" + archiveName, contents: nil, attributes: nil)
            {
                preferenceFile = FileHandle(forUpdatingAtPath: getUserPreferencePath() + "/" + archiveName);
            }
            else
            {
                print("Can't open or create a preference file");
            }
        }
        else
        {
            print("Opened the preference file successfully");
        }
    }
    
    public func load()
    {
        if let openFile = preferenceFile
        {
            openFile.seek(toFileOffset: 0);
            
            do
            {
                let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(openFile.readDataToEndOfFile()) as? UserStatistics
                
                if result != nil
                {
                    current = result!;
                }
            }
            catch
            {
                print("Unable to open preference file");
            }
        }
    }
    
    public func save()
    {
        if let openFile = preferenceFile
        {
            openFile.seek(toFileOffset: 0);
            
            do
            {
                let dat = try NSKeyedArchiver.archivedData(withRootObject: current, requiringSecureCoding: false);
                try dat.write(to: URL(fileURLWithPath: getUserPreferencePath() + "/a.bin"));
                
                return;
            }
            catch
            {
                
            }
            
            let write = NSKeyedArchiver(requiringSecureCoding: false);
            write.encode(current, forKey: "pref");
            
            let data = write.encodedData;
            
            preferenceFile?.seek(toFileOffset: 0);
            preferenceFile?.write(data);
        }
    }
}
