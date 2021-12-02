//
//  EventListViewController+CollectionViewProtocols.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 2.12.21.
//

import UIKit

extension EventListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(EventListDataSource.menuTitles.count)
        return EventListDataSource.menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventTypeMenuCell.reuseIdentifier, for: indexPath) as! EventTypeMenuCell
        cell.setupCell(text: EventListDataSource.menuTitles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let itemWidth = (UIScreen.main.bounds.size.width / CGFloat(EventListDataSource.menuTitles.count))
        let itemHeight = collectionView.frame.size.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        eventListContentView.selectedIndex = indexPath.item
        eventListContentView.refreshContent()
    }
}
