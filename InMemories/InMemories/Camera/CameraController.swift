import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
    }
    
    @objc func handleCapturePhoto() {
        print("Shooting camera")
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupHUD() {
        view.addSubview(photoButton)
        photoButton.anchor(
            top: nil, paddingTop: 0,
            left: nil, paddingLeft: 0,
            right: nil, paddingRight: 0,
            bottom: view.bottomAnchor, paddingBottom: 24,
            width: 80, height: 80)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(
            top: view.topAnchor, paddingTop: 24,
            left: nil, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 12,
            bottom: nil, paddingBottom: 0, width: 50, height: 50)
    }
    
    fileprivate func setupCaptureSession()  {
        let captureSession = AVCaptureSession()
        
        //setup input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Couldn't setup camera input: ", error)
        }
        
        //setup output
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        //start running
        captureSession.startRunning()
        
    }
    
}
