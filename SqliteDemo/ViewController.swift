
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let subObj:Subject=Subject()
        subObj.name="Maths"
        if DataBaseManager.shared.insertSubjectData(so: subObj)
        {
            print("inserted subjects")
        }
        let studObj:Student=Student()
        studObj.name="test"
        studObj.subjectsId="1"
        if DataBaseManager.shared.insertSubjectData(so: studObj)
        {
            print("inserted stdents data")
        }
         let studentArray = DataBaseManager.shared.ToFetchAlldata(tableName: "student")
        print(studentArray.count)
        
        for studObj in studentArray
        {
            let s = studObj as! Student
            print(s.id,s.name,s.subjectsId)
        }
        
        let subjectArray = DataBaseManager.shared.ToFetchAlldata(tableName: "subject")
        print(subjectArray.count)
        
        for studObj in subjectArray
        {
            let s = studObj as! Subject
            print(s.id,s.name)
        }
//        if DataBaseManager.shared.ToDeletedata(tableName: "subject") {
//            print("deleted subject data")
//        }
//        if DataBaseManager.shared.ToDeletedata(tableName: "student") {
//            print("deleted student data")
//        }
        
        if DataBaseManager.shared.ToUpdatedata(tableName: "subject") {
            print("updated subject data")
        }
        if DataBaseManager.shared.ToUpdatedata(tableName: "student") {
            print("updated student data")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

