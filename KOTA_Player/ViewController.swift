//
//  CollectionViewController.swift
//  KOTA_Player
//
//  Created by  noble on 2017. 4. 13..
//  Copyright © 2017년 KOTA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["앙상블 동영상", "UCC 동영상", "오카리나 콘서트", "운지법", "CCM", "복음성가", "팬플룻", "팬플룻 동영상", "7중주", "2중주", "Fake", "독주", "휘슬", "휘슬 동영상", "공연안내", "동영상 강의", "찬송가/7중주", "찬송가/4중주", "찬송가/2중주", "찬송가/독주", "회원관리", "오카리나 교본", "진행사업", "연주자소개", "강사소개"]
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CellClass
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if indexPath.item == 0 {
            print("yogi")
            
        }
        
    }
}
