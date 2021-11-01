//
//  InfoTableVC.swift
//  BanchExample
//
//  Created by User on 7.10.21.
//

import UIKit

final class InfoTVCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var dayLabel: UILabel!

    private weak var day: Day?

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

//    func configure(by images: [UIImage?]) {
//        day = Day(day: Date(), images: images)
//    }

    func configure(by day: Day) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dayLabel.text = formatter.string(from: day.day)
        self.day = day
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        return day?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let infoColVC = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionVCell.identifier, for: indexPath) as? InfoCollectionVCell
        infoColVC?.configure(with: day?.images[indexPath.row])
        return infoColVC ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension InfoTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellHeight, height: cellHeight)
    }

}
