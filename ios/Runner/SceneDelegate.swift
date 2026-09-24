import Flutter
import QuickLook
import RoomPlan
import UIKit

/// Holds the .usdz URL for QLPreviewController's data source. QLPreviewController
/// doesn't retain its dataSource, so SceneDelegate keeps this instance alive
/// (see quickLookDataSource property below) for as long as the preview is open.
private class USDZPreviewDataSource: NSObject, QLPreviewControllerDataSource {
  let url: URL
  init(url: URL) { self.url = url }

  func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    return url as QLPreviewItem
  }
}

class SceneDelegate: FlutterSceneDelegate {
  // Retained here so it isn't deallocated out from under QLPreviewController
  // while the preview is on screen.
  private var quickLookDataSource: USDZPreviewDataSource?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // super creates the window and sets its rootViewController to the
    // real FlutterViewController — must run first, or window.rootViewController
    // below will still be nil.
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard let controller = window?.rootViewController as? FlutterViewController else { return }

    // Direct Flutter <-> native bridge for RoomPlan — no third-party
    // plugin involved. See RoomScanViewController.swift for the actual
    // scanning logic.
    let roomPlanChannel = FlutterMethodChannel(
      name: "roamlog/roomplan",
      binaryMessenger: controller.binaryMessenger
    )

    roomPlanChannel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "isSupported":
        if #available(iOS 16.0, *) {
          result(RoomCaptureSession.isSupported)
        } else {
          result(false)
        }

      case "startScan":
        guard #available(iOS 16.0, *) else {
          result(FlutterError(code: "UNSUPPORTED", message: "RoomPlan requires iOS 16+", details: nil))
          return
        }
        let scanVC = RoomScanViewController()
        scanVC.modalPresentationStyle = .fullScreen
        scanVC.onFinish = { scanResult in
          switch scanResult {
          case .success(let url):
            result(url.path)
          case .failure(let error):
            result(FlutterError(code: "SCAN_FAILED", message: error.localizedDescription, details: nil))
          }
        }
        scanVC.onCancel = {
          result(nil)
        }
        controller.present(scanVC, animated: true)

      case "viewScan":
        guard let path = call.arguments as? String else {
          result(FlutterError(code: "BAD_ARGS", message: "Expected a file path string", details: nil))
          return
        }
        // AR Quick Look — Apple's native 3D/AR viewer, the same one you
        // get tapping a .usdz from Messages or Safari. It has its own
        // built-in share button too, so "save/share elsewhere" still
        // works from inside this screen.
        let url = URL(fileURLWithPath: path)
        let dataSource = USDZPreviewDataSource(url: url)
        self?.quickLookDataSource = dataSource

        let preview = QLPreviewController()
        preview.dataSource = dataSource
        controller.present(preview, animated: true)
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}