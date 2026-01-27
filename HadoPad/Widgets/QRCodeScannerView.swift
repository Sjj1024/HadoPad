//
//  QRCodeScannerView.swift
//  HadoPad
//
//  Created by song on 2026/1/27.
//

import SwiftUI
import UIKit

// 二维码扫描视图
struct QRCodeScannerView: UIViewControllerRepresentable {
    // 扫描启用状态
    @Binding var isScanning: Bool

    // 创建视图控制器
    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let viewController = QRCodeScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    // 视图更新控制器
    func updateUIViewController(_ uiViewController: QRCodeScannerViewController, context: Context) {
        uiViewController.isScanning = isScanning
        print("更新视图控制器")
        if isScanning {
            print("开启扫描")
            uiViewController.startScanning()
        } else {
            print("停止扫描")
            uiViewController.stopScanning()
        }
    }

    // 创建协调器
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // 协调器类
    class Coordinator: NSObject, QRCodeScannerViewControllerDelegate {
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func didFindCode(_ code: String) {
            print("success code", code)
            if parent.isScanning {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("QRCodeScanned"), object: code)
                }
            }
        }
    }
}
