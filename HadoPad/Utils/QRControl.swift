import AVFoundation
import UIKit

// 协议定义：二维码扫描器视图控制器的委托
protocol QRCodeScannerViewControllerDelegate: AnyObject {
    func didFindCode(_ code: String)
}

// QRCodeScannerViewController 类：用于扫描二维码的视图控制器
class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: QRCodeScannerViewControllerDelegate?
    var scanRectView: UIView!
    var overlayView: UIView!
    var isScanning: Bool = true
    
    // 视图加载时的设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        // 设置捕获会话
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        // 添加视频输入到捕获会话
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        // 添加元数据输出到捕获会话
        let metadataOutput = AVCaptureMetadataOutput()
        
        // 设置扫描区域
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        setupOverlay()
        setupScanRect()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    // 设置遮罩层
    func setupOverlay() {
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let path = UIBezierPath(rect: overlayView.bounds)
        let scanRectSize: CGFloat = 200
        let scanRect = CGRect(
            x: (view.frame.width - scanRectSize) / 2,
            y: (view.frame.height - scanRectSize) / 2,
            width: scanRectSize,
            height: scanRectSize
        )
        let scanRectPath = UIBezierPath(roundedRect: scanRect, cornerRadius: 20)
        path.append(scanRectPath.reversing())
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        overlayView.layer.mask = maskLayer
        
        view.addSubview(overlayView)
    }
    
    // 设置扫描区域视图
    func setupScanRect() {
        let scanRectSize: CGFloat = 220
        let scanRect = CGRect(
            x: (view.frame.width - scanRectSize) / 2,
            y: (view.frame.height - scanRectSize) / 2,
            width: scanRectSize,
            height: scanRectSize
        )
        
        scanRectView = UIView(frame: scanRect)
        
        // Adding corner indicators
        let cornerLength: CGFloat = 20
        let cornerThickness: CGFloat = 4
        let cornerColor = UIColor.green
                
        // Top-left corner
        addCorner(to: scanRectView, x: 0, y: 0, width: cornerLength, height: cornerThickness, color: cornerColor) // Horizontal
        addCorner(to: scanRectView, x: 0, y: 0, width: cornerThickness, height: cornerLength, color: cornerColor) // Vertical
                
        // Top-right corner
        addCorner(to: scanRectView, x: scanRectSize - cornerLength, y: 0, width: cornerLength, height: cornerThickness, color: cornerColor) // Horizontal
        addCorner(to: scanRectView, x: scanRectSize - cornerThickness, y: 0, width: cornerThickness, height: cornerLength, color: cornerColor) // Vertical
                
        // Bottom-left corner
        addCorner(to: scanRectView, x: 0, y: scanRectSize - cornerThickness, width: cornerLength, height: cornerThickness, color: cornerColor) // Horizontal
        addCorner(to: scanRectView, x: 0, y: scanRectSize - cornerLength, width: cornerThickness, height: cornerLength, color: cornerColor) // Vertical
                
        // Bottom-right corner
        addCorner(to: scanRectView, x: scanRectSize - cornerLength, y: scanRectSize - cornerThickness, width: cornerLength, height: cornerThickness, color: cornerColor) // Horizontal
        addCorner(to: scanRectView, x: scanRectSize - cornerThickness, y: scanRectSize - cornerLength, width: cornerThickness, height: cornerLength, color: cornerColor) // Vertical
                
        view.addSubview(scanRectView)
    }
    
    func addCorner(to view: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let corner = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        corner.backgroundColor = color
        view.addSubview(corner)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    // 处理捕获到的元数据对象
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()
        print("metadataOutput")
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print("metadataObject stringValue", stringValue)
            delegate?.didFindCode(stringValue)
        }
        
        dismiss(animated: true)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    // 开启扫描
    func startScanning() {
        dismiss(animated: true)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    // 关闭扫描
    func stopScanning() {
        captureSession.stopRunning()
        print("stopScanning")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
