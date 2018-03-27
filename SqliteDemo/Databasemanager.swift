
import Foundation
import FMDB
class DataBaseManager:NSObject
{
    
    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    static let shared: DataBaseManager = DataBaseManager()
    
    override init()
    {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    func openDatabase() -> Bool
    {
        if database == nil
        {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
   
    func toCreateTables()->Bool
    {
        if !FileManager.default.fileExists(atPath: pathToDatabase)
        {
            database = FMDatabase(path: pathToDatabase!)
        }
        
        var IsCreated=false
        if openDatabase()
        {
             if !database.tableExists("student")
             {
                let createStudentQuery="create table student(id integer primary key autoincrement not null,name text not null,subjectsid text not null)"
                do
                {
                    try database.executeUpdate(createStudentQuery, values: nil)
                    IsCreated=true
                }
                catch
                {
                    print("exception in student table")
                    IsCreated=false
                }

             }
            
            if !database.tableExists("subject")
            {
                
                let createSubjectsQuery="create table subject(id integer primary key autoincrement not null,name text not null)"
                do
                {
                    try database.executeUpdate(createSubjectsQuery, values: nil)
                    IsCreated=true
                }
                catch
                {
                    print("exception in student table")
                    IsCreated=false
                }
            }
            database.close()
        }
         
        return IsCreated
    }
    
    func insertSubjectData(so:AnyObject) -> Bool
    {
        var isInserted=false
        
        if openDatabase()
        {
            if so is Subject
            {
               let obj = so as! Subject
                do
                {
                    try database.executeUpdate("insert into subject(name) values(?)", values: [obj.name])
                    isInserted=true
                }
                catch
                {
                    print("exception in subject insert")
                    isInserted=false
                }
            }
            
            if  so is Student
            {
                let obj = so as! Student
                do
                {
                    try database.executeUpdate("insert into student(name,subjectsid) values(?,?)", values: [obj.name,obj.subjectsId])
                    isInserted=true
                }
                catch
                {
                    print("exception in student insert")
                    isInserted=false
                }
            }
            database.close()
        }
         
        return isInserted
    }
    
    func ToFetchAlldata(tableName:String) -> [AnyObject]
    {
        if openDatabase()
        {
        do
            {
                let qry = "select * from \(tableName)"
               let results = try database.executeQuery(qry, values: nil)
               
                if tableName=="student"
                {
                    var studentArray=[Student]()
                while results.next()
                {
                    let studObj=Student()
                    studObj.id = Int(results.int(forColumn: "id"))
                    studObj.name = results.string(forColumn: "name")
                    studObj.subjectsId = results.string(forColumn: "subjectsid")
                    studentArray.append(studObj)
                }
                 database.close()
                return studentArray
                }
                if tableName=="subject"
                {
                      var subArray=[Subject]()
                    while results.next()
                    {
                        let studObj=Subject()
                        studObj.id = Int(results.int(forColumn: "id"))
                        studObj.name = results.string(forColumn: "name")
                        
                        subArray.append(studObj)
                    }
                    database.close()
                    return subArray
                }
                
            }
            catch
            {
                
            }
        }
       
        return []
    }
    func ToDeletedata(tableName:String) -> Bool {
        var ISDeleted=false
        if openDatabase()
        {
            if tableName=="student"
            {
                do
                {
                    try database.executeUpdate("delete from student where id = ?", values: [1])
                    ISDeleted=true
                }
                catch{
                    ISDeleted=false
                }
            }
            if tableName=="subject"
            {
                do
                {
                    try database.executeUpdate("delete from subject", values: nil)
                    ISDeleted=true
                }
                catch{
                    ISDeleted=false
                }
            }
            database.close()
        }
         
        return ISDeleted
    }
    
    func ToUpdatedata(tableName:String) -> Bool
    {
        var ISDeleted=false
        if openDatabase()
        {
            if tableName=="student"
            {
                do
                {
                    try database.executeUpdate("update student set name=? where id=?", values: ["test",1])
                    ISDeleted=true
                }
                catch{
                    print(error.localizedDescription)

                    ISDeleted=false
                }
            }
            if tableName=="subject"
            {
                do
                {
                   try database.executeUpdate("update subject set name=? where id=?", values: ["iOS",1])
                    ISDeleted=true
                }
                catch{
                    print(error.localizedDescription)
                    ISDeleted=false
                }
            }
            database.close()
        }
         
        return ISDeleted
    }
    
    
}
