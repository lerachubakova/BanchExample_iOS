//
//  FiltersViewController.swift
//  BanchExample
//
//  Created by User on 29.10.21.
//

import UIKit

protocol FiltersSubscriber: AnyObject {
    func updateFilter()
}

class FiltersViewController: UIViewController {

    @IBOutlet private weak var pickerView: UIPickerView!
    private weak var filtersDelegate: FiltersSubscriber?

    init(delegate: FiltersSubscriber) {
        super.init(nibName: "FiltersViewController", bundle: Bundle.main)

        self.filtersDelegate = delegate

        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurePickerView()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmissAction)))
    }

    static func getTitleForPickerView(for row: Int) -> String {
        var title = ""
        switch row {
        case 0: title = LocalizeKeys.Filters.all.localized()
        case 1: title = LocalizeKeys.Filters.withoutDeleted.localized()
        case 2: title = LocalizeKeys.Filters.interesting.localized()
        case 3: title = LocalizeKeys.Filters.trash.localized()
        case 4: title = LocalizeKeys.Filters.hidden.localized()
        default:
            break
        }
        return title
    }

    private func configurePickerView() {
        pickerView.layer.masksToBounds = false

        pickerView.layer.shadowColor = UIColor.black.cgColor
        pickerView.layer.shadowRadius = 20.0
        pickerView.layer.shadowOpacity = 0.4
        pickerView.layer.shadowOffset.height = 15.0

        pickerView.layer.cornerRadius = pickerView.frame.height / 5.5

        pickerView.delegate = self
        pickerView.dataSource = self
        
        let row = userDefaults.integer(forKey: UserDefaultsKeys.filter)
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }

    @objc private func dissmissAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UIPickerViewDelegate
extension FiltersViewController: UIPickerViewDelegate {

}

// MARK: - UIPickerViewDelegate
extension FiltersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        NewsFilter.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: FiltersViewController.getTitleForPickerView(for: row))
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userDefaults.setValue(row, forKey: UserDefaultsKeys.filter)
        self.filtersDelegate?.updateFilter()
    }

}
