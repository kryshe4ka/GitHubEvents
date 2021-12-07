//
//  DataSourceForMenu.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 6.12.21.
//

import Foundation
import UIKit

class DelegateAndDataSourceForMenu: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var controller: EventListViewController?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return EventListDataSource.shared.menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventTypeMenuCell.reuseIdentifier, for: indexPath) as! EventTypeMenuCell
        cell.setupCell(text: EventListDataSource.shared.menuTitles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let controller = controller else { return }
        controller.eventListContentView.menuBar.selectedIndex = indexPath.item
        controller.eventListContentView.menuBar.refreshIndicator()
        controller.eventListContentView.contentView.contentCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension DelegateAndDataSourceForMenu: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let itemWidth = (UIScreen.main.bounds.size.width / CGFloat(EventListDataSource.shared.menuTitles.count))
        let itemHeight = collectionView.frame.size.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
