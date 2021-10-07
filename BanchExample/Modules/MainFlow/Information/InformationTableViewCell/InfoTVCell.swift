//
//  InfoTableVC.swift
//  BanchExample
//
//  Created by User on 7.10.21.
//

import UIKit

class InfoTVCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    static let identifier = "infoTVCell"

    static func nib() -> UINib {
        return UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(InfoCollectionVCell.nib(), forCellWithReuseIdentifier: InfoCollectionVCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
// MARK: - UICollectionViewDelegate
extension InfoTVCell: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension InfoTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionVCell.identifier, for: indexPath) as? InfoCollectionVCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}
