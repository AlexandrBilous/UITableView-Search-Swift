//
//  ViewController.swift
//  Lesson 35 SW HW
//
//  Created by Marentilo on 08.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
            self.createStudents()
            self.setupSearchbar()
    }
    
    var students = [Student]()
    
    var sortedSections = [Section]()
    
    let formatter : DateFormatter = {
        var tmp = DateFormatter()
        tmp.dateFormat = "dd-MMM-yyyy"
        return tmp
    } ()
    
    
    let monthFormatter : DateFormatter = {
        var tmp = DateFormatter()
        tmp.dateFormat = "MMMM"
        return tmp
    } ()
    
    let sortingControl : UISegmentedControl = {
        var control = UISegmentedControl(items: ["D", "FN", "LN"])
        control.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        control.selectedSegmentIndex = 0
        return control
    } ()
    
    func setupSearchbar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.automaticallyShowsScopeBar = true
        
        
        sortingControl.addTarget(self, action: #selector(sortStudents(sender:)), for: .valueChanged)
        let barControl = UIBarButtonItem(customView: sortingControl)
        self.navigationItem.rightBarButtonItem = barControl
        
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Students"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    func createStudents () {
        for _ in 0...100_000 {
            let student = Student()
            student.randomSettings()
            students.append(student)
        }
        
        students = self.sortByDate(source: students)
        
        sortedSections = self.devideInSection(source: students, withFilter: "", andSender: sortingControl.selectedSegmentIndex)
    }
    
    func sortByDate (source: [Student]) -> [Student] {
       return source.sorted { (s1, s2) -> Bool in
            if s1.firstName == s2.firstName && s1.dateOfBirth == s2.dateOfBirth {
                return s1.lastName < s2.lastName
            } else if s1.dateOfBirth == s2.dateOfBirth {
                return s1.firstName < s2.firstName
            }
            return s1.dateOfBirth < s2.dateOfBirth
        }
    }
    
    func sortByFirstName (source: [Student]) -> [Student] {
       return source.sorted { (s1, s2) -> Bool in
        if s1.firstName == s2.firstName && s1.lastName == s2.lastName {
                return s1.dateOfBirth < s2.dateOfBirth
            } else if s1.firstName == s2.firstName {
                return s1.lastName < s2.lastName
            }
            return s1.firstName < s2.firstName
        }
    }
    
    func sortByLastName (source: [Student]) -> [Student] {
       return source.sorted { (s1, s2) -> Bool in
            if s1.lastName == s2.lastName && s1.dateOfBirth == s2.dateOfBirth {
                return s1.firstName < s2.firstName
            } else if s1.lastName == s2.lastName {
                return s1.dateOfBirth < s2.dateOfBirth
            }
            return s1.lastName < s2.lastName
        }
    }
    
    func nameOfIndexTitles (student : Student, withSender sender: Int) -> String {
        var name = String()
        switch sender {
        case 0:
            name = monthFormatter.string(from: student.dateOfBirth)
        case 1:
            name = "\(student.firstName.first!)"
        case 2:
            name = "\(student.lastName.first!)"
        default:
            break
        }
        return name
    }
    
    func devideInSection (source : [Student], withFilter filter: String, andSender : Int) -> [Section]{
        var array = [Section]()
        var sectionName = NSMutableOrderedSet()
        
        for student in source {
            
            let name = self.nameOfIndexTitles(student: student, withSender: andSender)

            if filter.count > 0 && !student.fullName.contains(filter) {
                continue
            }
            
            if sectionName.contains(name) {
                let section = array[sectionName.index(of: name)]
                section.students.append(student)
            } else {
                let section = Section()
                section.name = name
                section.students.append(student)
                array.append(section)
                
                sectionName.add(name)
            }
        }

        return array
    }
    
    
    // MARK: - Actions
    
    @objc func sortStudents(sender: UISegmentedControl) {
        var tmp = [Student]()
        sortedSections.forEach({tmp.append(contentsOf: $0.students)})
        
        switch sender.selectedSegmentIndex {
        case 0:
            tmp = self.sortByDate(source: tmp)
            sortedSections = self.devideInSection(source: tmp, withFilter: "", andSender: sortingControl.selectedSegmentIndex)
        case 1:
            tmp = self.sortByFirstName(source: tmp)
            sortedSections = self.devideInSection(source: tmp, withFilter: "", andSender: sortingControl.selectedSegmentIndex)
        case 2:
            tmp = self.sortByLastName(source: tmp)
            sortedSections = self.devideInSection(source: tmp, withFilter: "", andSender: sortingControl.selectedSegmentIndex)
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSections[section].students.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "id"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        let section = sortedSections[indexPath.section]
        let source = section.students[indexPath.row]
        
        cell?.textLabel?.text = "\(source.firstName) \(source.lastName)"
        cell?.detailTextLabel?.text = formatter.string(from: source.dateOfBirth)
        
        return cell!
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedSections.count
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section].name
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var arrayOfTitles = [String]()
        
        for section in sortedSections {
            arrayOfTitles.append("\(section.name.first!)")
        }
        
        return arrayOfTitles
    }
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = "Search"
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let globalQueue = DispatchQueue.global()
        
        searchBar.text = searchBar.placeholder == "Search" ? "" : searchBar.placeholder
        searchBar.placeholder = searchText
        
        globalQueue.sync {
                self.sortedSections = self.devideInSection(source: self.students, withFilter: searchText, andSender: self.sortingControl.selectedSegmentIndex)
        }

        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        sortedSections = self.devideInSection(source: students, withFilter: String(), andSender: sortingControl.selectedSegmentIndex)
        tableView.reloadData()
    }
}

