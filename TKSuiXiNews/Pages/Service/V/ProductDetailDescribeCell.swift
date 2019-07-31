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
            if let value = newValue {
                do{
                    let srtData = value.data(using: String.Encoding.unicode, allowLossyConversion: true)!
                    let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]//Tips:Supported four types.
                    let attrStr = try NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
                    contentLabel.attributedText = attrStr
                }catch let error as NSError {
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
