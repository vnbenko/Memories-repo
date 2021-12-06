import UIKit
import AVFoundation

class CameraController: UIViewController  {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let captureView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let output = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    
    let customAnimationPresenter = CustomAnimationPresenter()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    var isCameraReady = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureUI()
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showButtons), name: PreviewPhoto.showButtonsNotificationName, object: nil)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        
#if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
#endif
        photoButton.isHidden = true
        dismissButton.isHidden = true
    }
    
    @objc func showButtons() {
        photoButton.isHidden = false
        dismissButton.isHidden = false
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    private func setupCaptureSession() {
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            self.alert(message: error.localizedDescription, title: "Could not setup camera input")
        }
        
        //2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        captureView.layoutIfNeeded()
        previewLayer.frame = captureView.layer.bounds
        
        captureView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    // MARK: - Configure
    
    private func configure() {
        configureDelegates()
    }
    
    private func configureUI() {
        configureCaptureView()
        configureButtons()
    }
    
    private func configureCaptureView() {
        view.addSubview(captureView)
        
        captureView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                           left: view.leftAnchor, paddingLeft: 0,
                           right: view.rightAnchor, paddingRight: 0,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           paddingBottom: 50, width: 0, height: 0)
        
        captureView.layer.cornerRadius = 20
        captureView.layer.masksToBounds = true
    }
    
    private func configureButtons() {
        view.addSubview(photoButton)
        view.addSubview(dismissButton)
        
        photoButton.anchor(top: nil, paddingTop: 0,
                           left: nil, paddingLeft: 0,
                           right: nil, paddingRight: 0,
                           bottom: captureView.bottomAnchor, paddingBottom: 12,
                           width: 80, height: 80)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dismissButton.anchor(top: captureView.topAnchor, paddingTop: 12,
                             left: nil, paddingLeft: 0,
                             right: captureView.rightAnchor, paddingRight: 12,
                             bottom: nil, paddingBottom: 0, width: 50, height: 50)
    }
    
    private func configureDelegates() {
        transitioningDelegate = self
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            self.alert(message: error.localizedDescription, title: "Failed")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let previewImage = UIImage(data: imageData) else { return }
        
        let previewPhotoView = PreviewPhoto()
        previewPhotoView.previewImageView.image = previewImage
        
        view.addSubview(previewPhotoView)
        
        previewPhotoView.anchor(top: view.topAnchor, paddingTop: 0,
                                left: view.leftAnchor, paddingLeft: 0,
                                right: view.rightAnchor, paddingRight: 0,
                                bottom: view.bottomAnchor, paddingBottom: 0,
                                width: 0, height: 0)
    }
}

extension CameraController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
}


