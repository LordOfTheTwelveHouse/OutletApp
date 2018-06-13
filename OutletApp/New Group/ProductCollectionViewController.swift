
//  Created by Akshay C Khanna on 29/05/2018.
//  Copyright © 2018 Akshay C Khanna. All rights reserved.
//

import UIKit
import Foundation


class ProductCollectionViewController: UICollectionViewController{

    fileprivate let reuseIdentifier = "productCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var productArr = Array<ProductDetails>()
    fileprivate let itemsPerRow: CGFloat = 2

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidLoad), name: .productWebService, object: nil)
        //Populate productArr
        helperPopulateProductArrayInCollectionViewCell()
    }
    
   override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView?.reloadData()
    }

    func helperPopulateProductArrayInCollectionViewCell() {
        ProductWebService.getProductJSON { closureArr in
            self.productArr = closureArr as! [ProductDetails]
            return nil
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Init Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.backgroundColor = UIColor.black
        self.helperProductImageIcon(cell: cell, indexPath: indexPath)
        cell.priceLabel.text = "£\(String(self.productArr[indexPath.item].price.amount / self.productArr[indexPath.item].price.divisor))"
        cell.productNameLabel.text = String(self.productArr[indexPath.item].name)
    
        return cell
    }
    
    func helperProductImageIcon(cell:ProductCollectionViewCell, indexPath:IndexPath){
        let url:String = self.productArr[indexPath.item].images.urlTemplate
        //REGEX: "{{scheme}}//cache.net-a-porter.com/images/products/1066074/1066074_{{shot}}_{{size}}.jpg"
        let pattern = ["\\{\\{scheme\\}\\}\\/\\/", // Schema substitute with space
                        "\\{\\{shot\\}\\}", //  Shot substitute with in
                       "\\{\\{size\\}\\}" // Size substitute with l
                       ]
        let urlWithID = url.replacingOccurrences(of: pattern[0], with: "", options: .regularExpression, range: nil)
        let urlWithIDShot = urlWithID.replacingOccurrences(of: pattern[1], with: "in", options: .regularExpression, range: nil)
        let urlwithIDShotSize = urlWithIDShot.replacingOccurrences(of: pattern[2], with: "l", options: .regularExpression, range: nil)
        let iconUrl = URL(string: "https://\(urlwithIDShotSize)" )
        ImageService.getImage(withURL: iconUrl!, completion: { closureImg in
            cell.productImageView.image = closureImg
        } )
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }



}
