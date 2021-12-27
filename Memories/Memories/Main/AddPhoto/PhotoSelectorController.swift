import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController {
    
    let page = 10
    
    var selectedImage: UIImage?
    var header: PhotoSelectorHeader?
    var images = [UIImage]()
    var assets = [PHAsset]()
    var beginIndex = 0
    var endIndex = 9
    var loading = false
    var hasNextPage = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    //TODO: - Resizing photos
    
    // MARK: - Actions
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    // MARK: - Functions
    
    private func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = true
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    private func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        if allPhotos.count == self.images.count {
            self.hasNextPage = false
            self.loading = false
            return
        }
        
        endIndex = beginIndex + (page - 1)
        
        if endIndex > allPhotos.count {
            endIndex = allPhotos.count - 1
        }
        
        let arr = Array(beginIndex...endIndex)
        
        let indexSet = IndexSet(arr)
        
        self.loading = true
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return}
            allPhotos.enumerateObjects(
                at: indexSet,
                options: NSEnumerationOptions.concurrent,
                using: { (asset, count, stop) in
                    
                    let imageManager = PHImageManager.default()
                    let targetSize = CGSize(width: 200, height: 200)
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                   
                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                               if let image = image {
                                   self.images.append(image)
                                   self.assets.append(asset)
                               }
                               
                               if self.selectedImage == nil {
                                   self.selectedImage = image
                               }
                               
                           })
                    if self.images.count - 1 == indexSet.last! {
                        self.loading = false
                        self.hasNextPage = self.images.count != allPhotos.count
                        self.beginIndex = self.images.count
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
        }
    }
    
    // MARK: - Configure
    
    private func configure() {
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: PhotoSelectorCell.cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoSelectorHeader.headerId)
    }
    
    private func configureUI() {
        configureNavButtons()
    }
    
    private func configureNavButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    // MARK: - Header settings
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoSelectorHeader.headerId, for: indexPath) as? PhotoSelectorHeader else { return UICollectionReusableView() }
        
        self.header = header
        header.photoImageView.image = selectedImage
        
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { image, info in
                           header.photoImageView.image = image
                       }
            }
        }
        return header
    }
    
    // MARK: - Grid cell settings
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectorCell.cellId, for: indexPath) as? PhotoSelectorCell else { return UICollectionViewCell() }
        cell.photoImageView.image = images[indexPath.item]
        
        if self.hasNextPage && !loading && indexPath.row == self.images.count - 1 {
            fetchPhotos()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView.reloadData()
        
        //Scroll up when you have selected an image
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
}

extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Header sizing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    // MARK: - Grid cell sizing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
}
