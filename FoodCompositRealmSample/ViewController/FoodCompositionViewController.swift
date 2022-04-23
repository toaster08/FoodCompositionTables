//
//  FoodCompositionViewController.swift
//  FoodCompositionTables
//  Created by 山田　天星 on 2022/04/09.
//

import UIKit

protocol FoodRegistrationDelegate: AnyObject {
    func transitPresentingVC()
}

final class FoodCompositionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: FoodRegistrationDelegate?

    var selectFood: FoodObject?
//    var selectFoodObject: SelectFoodObject?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registerFoodButton: UIButton!
    @IBOutlet private weak var foodWeightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "CompositionCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        registerFoodButton
            .addTarget(self,
                       action: #selector(registerFoodTouchUpInside),
                       for: .touchUpInside)
        
//        foodWeightTextField
//            .addTarget(self,
//                       action: #selector(textFieldValueChanged),
//                       for: .editingChanged)
    }
    
//    @objc private func textFieldValueChanged() {
//        guard let selectFood = selectFood else { return }
//        guard let selectFoodWeight
//                = Double(foodWeightTextField.text ?? "") else { return }
//
//        selectFoodObject = SelectFoodObject(food: selectFood, weight: selectFoodWeight)
//        tableView.reloadData()
//    }
    
    @objc private func registerFoodTouchUpInside() {
        guard let selectFood = selectFood else { return }
        guard let selectFoodWeight
                = Double(foodWeightTextField.text ?? "") else { return }
       
        let selectFoodObject = SelectFoodObject(food: selectFood,
                                          weight: selectFoodWeight)
        SelectFoodsTableUseCase().save(selectFood: selectFoodObject)
        delegate?.transitPresentingVC()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Composition.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell") else { fatalError() }
        guard let selectFood = selectFood else { return cell }
        //栄養素名称
        let composition = Composition.allCases[indexPath.row]
        let compositionName = composition.nameString
        //栄養素量
        let compositionValueString = composition.valueString(in: selectFood)

        var content = UIListContentConfiguration.valueCell()
        content.text = compositionName
        content.secondaryText = compositionValueString
        cell.contentConfiguration = content
        return cell
    }
}


