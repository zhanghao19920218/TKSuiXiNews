//
//  ShowImageTextCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///图文的cell
class TKSXShowImageTextCell: BaseTableViewCell {
    var isShowDelete: Bool? {
        willSet(newValue) {
            _bottomView.isShowDelete = newValue
        }
    }
    
    var deleteBlock: () -> Void = { }
    
    //MARK: -设置参数
    var describe: String? {
        willSet(value) {
            _describeLabel.text = value ?? "";
        }
    }
    
    var avatar: String? {
        willSet(value) {
            if let url = value {
                _avatarImage.kf.setImage(with: URL(string: url), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    var nickname: String? {
        willSet(value) {
            _nicknameLabel.text = value ?? "";
        }
    }
    
    var comment: String? {
        willSet(value) {
            _bottomView.comment = value
        }
    }
    
    var like: String? {
        willSet(value) {
            _bottomView.like = value
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            _bottomView.isLike = value
        }
    }
    
    var beginTime:String? {
        willSet(value) {
            _bottomView.time = value ?? "0小时前"
        }
    }
    
    
    //获取的images
    var images:Array<String>? {
        willSet(value){
            rebuildImagePicker(value ?? []);
        }
    }
    
    //用户头像
    private lazy var _avatarImage:BaseAvatarImageView = {
        let imageView = BaseAvatarImageView(frame: .zero);
        return imageView;
    }();
    
    //用户昵称
    private lazy var _nicknameLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label;
    }();
    
    //用户的内容
    private lazy var _describeLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label;
    }();
    
    //用户下方的评论
    private lazy var _bottomView: SXBaseTimeCommentLikeView = {
        let view = SXBaseTimeCommentLikeView();
        return view;
    }()
    
    //显示照片的view
    private lazy var _imagesContentView: BaseWrapImagesView = {
        let view = BaseWrapImagesView.init();
        return view;
    }();

    override func setupUI() {
        super.setupUI();
        
        contentView.addSubview(_avatarImage);
        _avatarImage.snp.makeConstraints { (make) in
            make.top.equalTo(15 * iPHONE_AUTORATIO);
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 42 * iPHONE_AUTORATIO, height: 42 * iPHONE_AUTORATIO));
        };
        
        contentView.addSubview(_nicknameLabel);
        _nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self._avatarImage.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.top.equalTo(15 * iPHONE_AUTORATIO);
        }
        
        contentView.addSubview(_describeLabel);
        _describeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(44 * iPHONE_AUTORATIO);
            make.left.equalTo(65 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_bottomView);
        _bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO);
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.height.equalTo(40 * iPHONE_AUTORATIO)
        }
        
        _bottomView.block = { [weak self] () in
            self?.deleteBlock()
        }
        
        contentView.addSubview(_imagesContentView);
        _imagesContentView.snp.makeConstraints { (make) in
            make.top.equalTo(96 * iPHONE_AUTORATIO);
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.height.equalTo(108 * iPHONE_AUTORATIO);
        };
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    //初始化图片查看
    private func rebuildImagePicker(_ images: [String]){
        _imagesContentView.images = images;
        if images.count <= 3 {
            _imagesContentView.snp.remakeConstraints { (make) in
                make.top.equalTo(96 * iPHONE_AUTORATIO);
                make.left.equalTo(65 * iPHONE_AUTORATIO);
                make.right.equalTo(-13 * iPHONE_AUTORATIO);
                make.height.equalTo(108 * iPHONE_AUTORATIO);
            };
        } else if images.count <= 6 {
            _imagesContentView.snp.remakeConstraints { (make) in
                make.top.equalTo(96 * iPHONE_AUTORATIO);
                make.left.equalTo(65 * iPHONE_AUTORATIO);
                make.right.equalTo(-13 * iPHONE_AUTORATIO);
                make.height.equalTo(216 * iPHONE_AUTORATIO);
            };
        } else {
            _imagesContentView.snp.remakeConstraints { (make) in
                make.top.equalTo(96 * iPHONE_AUTORATIO);
                make.left.equalTo(65 * iPHONE_AUTORATIO);
                make.right.equalTo(-13 * iPHONE_AUTORATIO);
                make.height.equalTo(324 * iPHONE_AUTORATIO);
            };
        }
    }

}
