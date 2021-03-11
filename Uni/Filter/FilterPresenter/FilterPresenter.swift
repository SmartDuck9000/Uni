import UIKit

struct FilterPresenter {
    private var model = Filter()
    
    init() {
        model.country = ""
        model.subjects = []
        model.minPoint = 100
        model.military = true
        model.campus = true
    }
    
    mutating func loadFilterSettings() -> Bool {
        self.model = Manager.shared.loadFilterSettings()
        
        return model.country != nil || model.campus != nil || model.military != nil || model.minPoint != nil || model.subjects != nil
    }
    
    func updateFilterSettings() {
        Manager.shared.updateFilterSettings(with: self.model)
    }
    
    func checkFilterChanged(){
        Manager.shared.filterSettingsChanged(filter: self.model)
    }
    
    func fillFields(country: inout String?, subjects: inout [subjectData], minPoints: inout Float, military: inout Bool, campus: inout Bool) {
        country = self.model.country
        
        if let data = self.model.subjects {
            let sectionData: [String] = subjects[0].sectionData
            subjects = []
            
            for title in data {
                subjects.append(subjectData(opened: false, title: title, sectionData: sectionData))
            }
        }
        
        minPoints = Float(self.model.minPoint ?? 0)
        military = self.model.military ?? false
        campus = self.model.campus ?? false
    }
    
    mutating func changeCountry(newCountry: String?) {
        if newCountry != "Город"{
        model.country = newCountry
        }
    }
    
    mutating func updateSubject(newSubjects: [String]?) {
        model.subjects = newSubjects
    }
    
    mutating func changeMinPoint(for value: Int?) {
        model.minPoint = value
    }
    
    mutating func changeMilitary(for value: Bool?) {
        model.military = value
    }
    
    mutating func changeCampus(for value: Bool?) {
        model.campus = value
    }
    
//    func countOfCountrys() -> Int? {
//        return self.model.country?.count
//    }
    
    func countOfSubjects() -> Int? {
        return self.model.subjects?.count
    }
}
