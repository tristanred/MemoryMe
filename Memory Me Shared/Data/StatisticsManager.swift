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
    
    var gamesWon: Int32 = 0;
    var gamesLost: Int32 = 0;
    
    // Misc. stats
    
    // Trace stat of how much players spam click on shapes
    var overclick: Int32 = 0;
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(overallAverageLength, forKey: "overallAverageLength");
        aCoder.encode(overallLongestLength, forKey: "overallLongestLength");
        aCoder.encode(gamesWon, forKey: "gamesWon");
        aCoder.encode(gamesLost, forKey: "gameLost");
        aCoder.encode(overclick, forKey: "overclick");
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        self.init();
        
        self.overallAverageLength = aDecoder.decodeInt32(forKey: "overallAverageLength");
        self.overallLongestLength = aDecoder.decodeInt32(forKey: "overallLongestLength");
        self.gamesWon = aDecoder.decodeInt32(forKey: "gamesWon");
        self.gamesLost = aDecoder.decodeInt32(forKey: "gamesLost");
        self.overclick = aDecoder.decodeInt32(forKey: "overclick");
    }
}

func getUserPreferencePath() -> String
{
    #if os(OSX)
    return NSHomeDirectory();
    #else
    return NSHomeDirectory();
    #endif
}

/**
 * Manager class for a player's statistics. This class handles the persistance
 * of a UserStatistics class.
 *
 * The stats are saved in an NSKeyedArchive and handled using the save/load
 * methods.
 *
 * The manager has a static 'default' property with the default set of stats.
 * This static property can be used to manipulate the main statistic manager
 * instead of creating a separate instance.
 */
class StatisticsManager
{
    private static var _pref: StatisticsManager?;
    static var `default`: StatisticsManager = StatisticsManager(archiveName: "a.bin");
    
    public var current: UserStatistics;
    
    private var statsFile: FileHandle?;
    
    /**
     * Main initializer, must specify a file name and the class will handle
     * locating the file into it's application directory.
     *
     * The default archive name is "a.bin"
     */
    init(archiveName: String)
    {
        current = UserStatistics();

        statsFile = FileHandle(forUpdatingAtPath: getUserPreferencePath() + "/" + archiveName);
        
        if(statsFile == nil)
        {
            if FileManager.default.createFile(atPath: getUserPreferencePath() + "/" + archiveName, contents: nil, attributes: nil)
            {
                statsFile = FileHandle(forUpdatingAtPath: getUserPreferencePath() + "/" + archiveName);
                
                if(statsFile == nil)
                {
                    logError(withMessage: "Could not open new statistics file.", export: true);
                }
                else
                {
                    logTrace(withMessage: "Opened new statistics file.");
                }
            }
            else
            {
                logError(withMessage: "Could not open or create a statistics file.", export: true);
            }
        }
        else
        {
            logTrace(withMessage: "Opened existing statistics file.");
        }
        
        self.load();
    }
    
    /**
     * Load the statistics from the archive file.
     *
     * If the load is successful, the 'current' property is updated with a new
     * instance with the deserialized values. If the load failed, the
     * 'current' property is not updated.
     */
    public func load()
    {
        if let openFile = statsFile
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
                logError(withMessage: "Unable to load the statistics file.", export: true);
            }
        }
    }
    
    /**
     * Save the 'current' object into the archive file.
    */
    public func save()
    {
        if let openFile = statsFile
        {
            openFile.seek(toFileOffset: 0);
            
            do
            {
                let dat = try NSKeyedArchiver.archivedData(withRootObject: current, requiringSecureCoding: false);
                try dat.write(to: URL(fileURLWithPath: getUserPreferencePath() + "/a.bin"));
            }
            catch
            {
                logError(withMessage: "Failed to save the archive file.", export: true);
            }
        }
        else
        {
            logError(withMessage: "Unable to open the statistics file.", export: true);
        }
    }
}
