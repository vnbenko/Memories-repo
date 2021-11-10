import UIKit

class CommentCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    var comment: Comment? {
        didSet {
            textLabel.text = comment?.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, paddingTop: 4, left: leftAnchor, paddingLeft: 4, right: rightAnchor, paddingRight: 4, bottom: bottomAnchor, paddingBottom: 4, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
