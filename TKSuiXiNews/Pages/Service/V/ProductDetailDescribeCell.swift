//
//  ProductDetailDescribeCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ProductDetailDescribeCell: BaseTableViewCell {
    //设置内容
    var content: String? {
        willSet(newValue) {
            if let value = newValue, !value.isEmpty{
                do{
                    let srtData = value.data(using: String.Encoding.unicode, allowLossyConversion: true)!
                    let strOptions = [NSMutableAttributedString.DocumentReadingOptionKey.documentType: NSMutableAttributedString.DocumentType.html]
                    let attrStr = try NSMutableAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
                    attrStr.addAttributes([NSMutableAttributedString.Key.font: kFont(14 * iPHONE_AUTORATIO)], range: NSRange(location: 0, length: attrStr.length - 1))
                    contentLabel.attributedText = attrStr
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(10 * iPHONE_AUTORATIO)
        }
    }
}
