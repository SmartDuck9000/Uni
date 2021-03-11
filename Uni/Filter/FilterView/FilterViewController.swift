//
//  ViewController.swift
//  university
//
//  Created by Георгий Куликов on 11.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import UIKit

/// An object that manages views in window for filter
class FilterViewController: UIViewController {
    
    private var presenter = FilterPresenter()
    
    private var firstUsage: Bool = true
    
    private let constraints = Size() // sizes and coordinates for views
    private let dataView = FilterViewData() // some data about colors, corner radiuses, text colors for views
    private var barHeight: CGFloat = 0 // height of status bar if in future we prefer opening filter window using navigation controller
    
    // Constraints, that we will change in window, when user will add or remove subjects
    private var subjectConstraint = NSLayoutConstraint()
    private var contentConstraint = NSLayoutConstraint()
    
    private let dataSourceCountry = ["Любой", "Москва", "Санкт-Петербург", "Омск", "Волгоград", "Владимир", "Екатеринбург", "Уфа", "Владивосток"]
    
    private var dataSourceSubject = ["математика", "русский", "физика", "химия", "история", "обществознание", "информатика", "биология", "георграфия", "английский", "немецкий", "французсский", "испанский", "литература"]
    
    private let filterScrollView = UIScrollView()
    private let filterContainerView = UIView() // Container to all views using in filter window
    
    private var contentView = UIView() // Container with views going after subjects for most comfortable layout managment
    
    private var subjectTableData = [subjectData]()
    private let subjectTableTitle = "Предметы"
    private let addSubject = UIButton()
    private var subjectTable = UITableView()
    
    private let countryLabel = UILabel()
    private let countryPicker = UIPickerView()
    
    private let pointsSlider = UISlider()
    private let pointsTextField = UITextField()
    
    private let militaryLabel = UILabel()
    private let militaryButton = UISwitch()
    
    private let campusLabel = UILabel()
    private let campusButton = UISwitch()
    
    
    /// Updates constraints to table with subjects
    /// - Parameter height: new height for subject table
    private func updateSubjectTableConstraints(height: CGFloat) {
        subjectConstraint.constant = height
    }
    
    /// Updates constraints for container with views, that going after subjects
    /// - Parameter y: method add parameter to current coordinate
    private func updateContentViewConstraints(to y: CGFloat) {
        contentConstraint.constant += y
    }
    
    // MARK: filter view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        firstUsage = Manager.shared.flagFilterFirstUsage
        
        filterScrollView.addSubview(filterContainerView)
        filterContainerView.frame = view.bounds
        
        view.addSubview(filterScrollView)
        filterScrollView.frame = filterContainerView.bounds
        filterScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 500)
        
        view.backgroundColor = dataView.FilterViewColor
//        barHeight = navigationController?.navigationBar.frame.size.height ?? 0
        
        setupCountry()
        setupAddSubject()
        setupSubjectTable()
        
        setupContentView()
        setupPoints()
        setupMilitary()
        setupCampus()
        
        if (presenter.loadFilterSettings()) {
            presenter.fillFields(country: &countryLabel.text,
                                 subjects: &subjectTableData,
                                 minPoints: &pointsSlider.value,
                                 military: &militaryButton.isOn,
                                 campus: &campusButton.isOn)
            
            updateSubjectTableConstraints(height: CGFloat(subjectTableData.count) * constraints.subjectTableCellHeight)
            updateContentViewConstraints(to: CGFloat(subjectTableData.count - 1) * constraints.subjectTableCellHeight)
            
            dataSourceSubject = dataSourceSubject.filter({ (subj) -> Bool in
                for data in subjectTableData {
                    if data.title == subj {
                        return false
                    }
                }
                return true
            })
            
            for i in 0...(subjectTableData.count - 1) {
                subjectTableData[i].sectionData = dataSourceSubject
            }
            
            if let row = dataSourceCountry.firstIndex(of: countryLabel.text ?? "nil") {
                self.countryPicker.selectRow(row, inComponent: 0, animated: true)
            }
            
            if countryLabel.text == nil {
                countryLabel.text = "Город"
            }
            
            pointsSlider.maximumValue = Float(510)
            pointsTextField.text = String(Int(pointsSlider.value))
            
            self.pointsTextField.text = " \(Int(pointsSlider.value))"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Manager.shared.flagFilterChanged = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.fillDataFilter()
        presenter.checkFilterChanged()
        presenter.updateFilterSettings()
        Manager.shared.flagFilterFirstUsage = false
        Manager.shared.updateController(controller: presentingViewController!)
    }
    
    private func fillDataFilter() {
        var subjectsData: [String]? = []
        
        let subjectsStruct = subjectTableData.filter({ (data) -> Bool in
            return data.title != subjectTableTitle
        })
        
        for data in subjectsStruct {
            subjectsData!.append(data.title)
        }
        
        presenter.updateSubject(newSubjects: subjectsData == [] ? nil : subjectsData)
        presenter.changeCountry(newCountry: countryLabel.text == "Город" || countryLabel.text == "Любой" ? nil : countryLabel.text)
        if firstUsage {
            presenter.changeMinPoint(for: Int(pointsSlider.value) == 0 ? nil : Int(pointsSlider.value))
            presenter.changeMilitary(for: !militaryButton.isOn ? nil : true)
            presenter.changeCampus(for: !campusButton.isOn ? nil : true)
        } else {
            presenter.changeMinPoint(for: Int(pointsSlider.value))
            presenter.changeMilitary(for: militaryButton.isOn)
            presenter.changeCampus(for: campusButton.isOn)
        }
    }
    
    // MARK: targets
    
    @objc private func changePoints() {
        pointsTextField.text = " " + String(Int(pointsSlider.value))
    }
    
    @objc private func pushSubject() {
        if subjectTableData.count == 14 {
            let noneSubjectsAlert = UIAlertController(title: "Предметы кончились!", message: "Вы добавили все возможные предметы.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            noneSubjectsAlert.addAction(ok);
            present(noneSubjectsAlert, animated: true, completion: nil)
            
            return
        }
        
        for data in subjectTableData {
            if data.opened {
                let chooseSubjectsAlert = UIAlertController(title: "Пожалуйста, выберите предмет!", message: "Прежде чем добавить новый предмет, необходимо выбрать предмет.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                chooseSubjectsAlert.addAction(ok);
                present(chooseSubjectsAlert, animated: true, completion: nil)
                
                return
            }
        }
        
        subjectTableData.append(subjectData(opened: false,
                                            title: subjectTableTitle,
                                            sectionData: dataSourceSubject))
//        if (subjectTableData.count > 3) {
//            pointsSlider.maximumValue = Float(subjectTableData.count * 100 + 10)
//        } else {
//            pointsSlider.maximumValue = Float(310)
//        }
        subjectTable.reloadData()
        
        updateSubjectTableConstraints(height: CGFloat(subjectTableData.count) * constraints.subjectTableCellHeight)
        updateContentViewConstraints(to: constraints.subjectTableCellHeight)
    }
}

// MARK: setups
// All setups for views on filter window
extension FilterViewController {
    private func setupContentView() {
        filterScrollView.addSubview(contentView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentConstraint = contentView.topAnchor.constraint(equalTo: filterContainerView.topAnchor, constant: constraints.contentViewY + barHeight)
        contentConstraint.isActive = true
        contentView.heightAnchor.constraint(equalToConstant: constraints.contentViewHeight).isActive = true
        contentView.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor).isActive = true
    }
    
    private func setupCountryLabel() {
        filterScrollView.addSubview(countryLabel)
        
        countryLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        countryLabel.layer.masksToBounds = true
        countryLabel.layer.cornerRadius = dataView.cornerRadius
        countryLabel.backgroundColor = dataView.countryLabelColor
        countryLabel.textColor = dataView.countryLabelTextColor
        countryLabel.textAlignment = .center
        countryLabel.text = "Город"
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countryLabel.topAnchor.constraint(equalTo: filterContainerView.topAnchor, constant: constraints.countryLabelY + barHeight).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: filterContainerView.leftAnchor, constant: constraints.safeAreaBorder / 2).isActive = true
        countryLabel.heightAnchor.constraint(equalToConstant: constraints.countryLabelHeight).isActive = true
        countryLabel.widthAnchor.constraint(equalToConstant: constraints.countryLabelWidth).isActive = true
    }
    
    private func setupCountryPicker() {
        filterScrollView.addSubview(countryPicker)
        
        countryPicker.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        countryPicker.translatesAutoresizingMaskIntoConstraints = false
        
        countryPicker.topAnchor.constraint(equalTo: filterContainerView.topAnchor, constant: constraints.countryPickerY + barHeight).isActive = true
        countryPicker.centerXAnchor.constraint(equalTo: filterContainerView.centerXAnchor).isActive = true
        countryPicker.heightAnchor.constraint(equalToConstant: constraints.countryPickerHeight).isActive = true
        countryPicker.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor).isActive = true
    }
    
    private func setupCountry() {
        setupCountryLabel()
        setupCountryPicker()
    }
    
    private func setupAddSubject() {
        addSubject.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        addSubject.layer.cornerRadius = dataView.cornerRadius
        addSubject.setTitle("Добавить предмет", for: .normal)
        addSubject.backgroundColor = dataView.addSubjectColor
        
        
        addSubject.addTarget(self, action: #selector(pushSubject), for: .touchUpInside)
        
        filterScrollView.addSubview(addSubject)
        
        addSubject.translatesAutoresizingMaskIntoConstraints = false
        
        addSubject.topAnchor.constraint(equalTo: filterContainerView.topAnchor, constant: constraints.addSubjectButtonY + barHeight).isActive = true
        addSubject.leftAnchor.constraint(equalTo: filterContainerView.leftAnchor, constant: constraints.safeAreaBorder / 2).isActive = true
        addSubject.heightAnchor.constraint(equalToConstant: constraints.addSubjectButtonHeight).isActive = true
        addSubject.widthAnchor.constraint(equalToConstant: constraints.addSubjectButtonWidth).isActive = true
    }
    
    private func setupSubjectTable() {
        filterScrollView.addSubview(subjectTable)
        subjectTableData = []
        pushSubject()
        
        subjectTable.translatesAutoresizingMaskIntoConstraints = false

        subjectTable.centerXAnchor.constraint(equalTo: self.filterContainerView.centerXAnchor).isActive = true
        subjectTable.topAnchor.constraint(equalTo: self.filterContainerView.topAnchor, constant: constraints.subjectTableY + barHeight).isActive = true
        subjectTable.widthAnchor.constraint(equalToConstant: self.filterContainerView.center.x * 2 - constraints.safeAreaBorder).isActive = true
        subjectConstraint = subjectTable.heightAnchor.constraint(equalToConstant: constraints.subjectTableCellHeight)
        subjectConstraint.isActive = true
        
        subjectTable.delegate = self
        subjectTable.dataSource = self
    }
    
    private func setupPointsSlider() {
        pointsSlider.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        pointsSlider.tintColor = dataView.sliderColor
        
        pointsSlider.minimumValue = 0
        pointsSlider.maximumValue = Float(510)
        
        pointsSlider.isContinuous = true
        pointsSlider.addTarget(self, action: #selector(changePoints), for: .valueChanged)
        
        contentView.addSubview(pointsSlider)
        
        pointsSlider.translatesAutoresizingMaskIntoConstraints = false
        
        pointsSlider.leftAnchor.constraint(equalTo: self.filterContainerView.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        pointsSlider.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.pointsSliderY).isActive = true
        pointsSlider.widthAnchor.constraint(equalToConstant: self.filterContainerView.center.x * 2 - constraints.safeAreaBorder * 2).isActive = true
        pointsSlider.heightAnchor.constraint(equalToConstant: constraints.pointsSliderHeight).isActive = true
    }
    
    private func setupPointsTextField() {
        pointsTextField.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        pointsTextField.layer.cornerRadius = 10
        pointsTextField.layer.borderColor = UIColor.black.cgColor
        pointsTextField.layer.borderWidth = 1
        
        pointsTextField.placeholder = " Минимальный балл "
        pointsTextField.textAlignment = .center
        pointsTextField.contentHorizontalAlignment = .left
        
        pointsTextField.delegate = self
        
        contentView.addSubview(pointsTextField)
        
        pointsTextField.translatesAutoresizingMaskIntoConstraints = false
        pointsTextField.leftAnchor.constraint(equalTo: self.filterContainerView.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        pointsTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.pointsTextFieldY).isActive = true
        pointsTextField.heightAnchor.constraint(equalToConstant: constraints.pointsTextFieldHeight).isActive = true
    }
    
    private func setupPoints() {
        setupPointsSlider()
        setupPointsTextField()
    }
    
    private func setupMilitaryLabel() {
        contentView.addSubview(militaryLabel)
        
        militaryLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        militaryLabel.text = "Военная Кафедра"
        
        militaryLabel.translatesAutoresizingMaskIntoConstraints = false

        militaryLabel.leftAnchor.constraint(equalTo: self.filterContainerView.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        militaryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.militaryLabelY).isActive = true
        militaryLabel.heightAnchor.constraint(equalToConstant: constraints.militaryLabelHeight).isActive = true
    }
    
    private func setupMilitaryButton() {
        contentView.addSubview(militaryButton)
        
        militaryButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        militaryButton.isOn = false
        militaryButton.onTintColor = dataView.militaryButtonColor
        
        militaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        militaryButton.rightAnchor.constraint(equalTo: self.filterContainerView.rightAnchor, constant: -constraints.safeAreaBorder).isActive = true
        militaryButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.militaryButtonY).isActive = true
    }
    
    private func setupMilitary() {
        setupMilitaryLabel()
        setupMilitaryButton()
    }
    
    private func setupCampusLabel() {
        campusLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        campusLabel.text = "Общежитие"
        
        contentView.addSubview(campusLabel)
        
        campusLabel.translatesAutoresizingMaskIntoConstraints = false

        campusLabel.leftAnchor.constraint(equalTo: self.filterContainerView.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        campusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.campusLabelY).isActive = true
        campusLabel.heightAnchor.constraint(equalToConstant: constraints.campusLabelHeight).isActive = true
    }
    
    private func setupCampusButton() {
        contentView.addSubview(campusButton)
        
        campusButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        campusButton.isOn = false
        campusButton.onTintColor = dataView.campusButtonColor
        
        campusButton.translatesAutoresizingMaskIntoConstraints = false
        
        campusButton.rightAnchor.constraint(equalTo: self.filterContainerView.rightAnchor, constant: -constraints.safeAreaBorder).isActive = true
        campusButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.campusButtonY).isActive = true
    }
    
    private func setupCampus() {
        setupCampusLabel()
        setupCampusButton()
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceCountry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryLabel.text = dataSourceCountry[row]
    }
}

extension FilterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var num = Int(textField.text ?? "non num") {
            num = (Float(num) - pointsSlider.maximumValue) > .ulpOfOne ? 300 : num
            num = num < 0 ? 0 : num
            pointsSlider.value = Float(num)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subjectTableData[section].opened {
            return subjectTableData[section].sectionData.count + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = dataView.subjectCellColor
        cell.layer.cornerRadius = dataView.cornerRadius
        cell.textLabel?.textColor = dataView.subjectCellTextColor
        
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0 {
            cell.textLabel?.text = subjectTableData[indexPath.section].title
        } else {
            cell.textLabel?.text = subjectTableData[indexPath.section].sectionData[dataIndex]
            cell.backgroundColor = .darkGray
        }
        
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subjectTableData.count
    }
    
    private func removeSubject(at index: Int) {
        if (index != 0) {
            let dataIndex = index - 1;
            
            dataSourceSubject.remove(at: dataIndex)
            for i in 0...(subjectTableData.count - 1) {
                subjectTableData[i].sectionData.remove(at: dataIndex)
            }
            
            subjectTable.reloadData()
        }
    }
    
    private func insertSubject(_ subj: String, at index: Int) {
        if (subj != subjectTableTitle) {
            dataSourceSubject.insert(subj, at: index)
            for i in 0...(subjectTableData.count - 1) {
                subjectTableData[i].sectionData.insert(subj, at: index)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataIndex = indexPath.row - 1
        let curTitle = subjectTableData[indexPath.section].title
        
        if indexPath.row != 0 {
            subjectTableData[indexPath.section].title = subjectTableData[indexPath.section].sectionData[dataIndex]
        }
        
        subjectTableData[indexPath.section].opened = !(subjectTableData[indexPath.section].opened)
        
        let curHeight = subjectConstraint.constant
        
        if (subjectTableData[indexPath.section].opened) {
            updateSubjectTableConstraints(height: curHeight + constraints.subjectTableCellHeight * 4)
            updateContentViewConstraints(to: constraints.subjectTableCellHeight * 4)
        } else {
            removeSubject(at: indexPath.row)
            if indexPath.row != 0 {
                insertSubject(curTitle, at: 0)
            }
            
            updateSubjectTableConstraints(height: curHeight - constraints.subjectTableCellHeight * 4)
            updateContentViewConstraints(to: -constraints.subjectTableCellHeight * 4)
        }
        subjectTable.reloadData()
//        let sections = IndexSet.init(integer: indexPath.section)
//        subjectTable.reloadSections(sections, with: .none)
    }
}

// Editing subjects extension
extension FilterViewController {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !subjectTableData[indexPath.section].opened && indexPath.row == 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if subjectTableData[indexPath.section].title != subjectTableTitle {
                dataSourceSubject.insert(subjectTableData[indexPath.section].title, at: 0)
                for i in 0...(subjectTableData.count - 1) {
                    subjectTableData[i].sectionData.insert(subjectTableData[indexPath.section].title, at: 0)
                }
            }
            
            subjectTableData.remove(at: indexPath.section)
            
//            if (subjectTableData.count > 3) {
//                pointsSlider.maximumValue = Float(subjectTableData.count * 100)
//            } else {
//                pointsSlider.maximumValue = Float(510)
//            }
            
            self.changePoints()
            
            subjectTable.deleteSections(IndexSet.init(integer: indexPath.section), with: .fade)
            subjectTable.reloadData()
            
            updateSubjectTableConstraints(height: CGFloat(subjectTableData.count) * constraints.subjectTableCellHeight)
            updateContentViewConstraints(to: -constraints.subjectTableCellHeight)
        } else if editingStyle == .insert {
            
        }
    }
}
