import UIKit
import RoomPlan

/// Drives Apple's RoomPlan capture session directly. No third-party
/// plugin involved — this is a thin wrapper around RoomCaptureView plus
/// a "Done" button, so we can see exactly what RoomPlan is doing at each
/// step instead of trusting an opaque dependency.
///
/// Flow: present this full-screen -> user walks around scanning -> taps
/// Done -> we build the final CapturedRoom from the raw session data
/// ourselves (bypassing Apple's built-in review screen for a simpler,
/// more predictable flow) -> export a .usdz -> call onFinish with its
/// path -> dismiss.
@available(iOS 16.0, *)
class RoomScanViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    private var roomCaptureView: RoomCaptureView!
    private let sessionConfig = RoomCaptureSession.Configuration()

    /// Called exactly once, either with a file path on success or an
    /// error. Not called if the user cancels (see onCancel).
    var onFinish: ((Result<URL, Error>) -> Void)?
    var onCancel: (() -> Void)?

    override func loadView() {
        roomCaptureView = RoomCaptureView(frame: .zero)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        view = roomCaptureView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        roomCaptureView.captureSession.run(configuration: sessionConfig)
    }

    private func setupButtons() {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done Scanning", for: .normal)
        doneButton.backgroundColor = .white
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.layer.cornerRadius = 22
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.addSubview(doneButton)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 180),
            doneButton.heightAnchor.constraint(equalToConstant: 44),

            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }

    @objc private func doneTapped() {
        roomCaptureView.captureSession.stop()
    }

    @objc private func cancelTapped() {
        roomCaptureView.captureSession.stop()
        onCancel?()
        dismiss(animated: true)
    }

    // We handle building + exporting the room ourselves, so we skip
    // RoomPlan's own built-in review screen here.
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: (any Error)?) -> Bool {
        return false
    }

    func captureView(didPresent processedResult: CapturedRoom, error: (any Error)?) {
        // Not used since shouldPresent returns false, but required by
        // the protocol.
    }

    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (any Error)?) {
        if let error = error {
            onFinish?(.failure(error))
            dismiss(animated: true)
            return
        }

        Task {
            do {
                let roomBuilder = RoomBuilder(options: [.beautifyObjects])
                let capturedRoom = try await roomBuilder.capturedRoom(from: data)
                let destination = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("usdz")
                try capturedRoom.export(to: destination)

                await MainActor.run {
                    self.onFinish?(.success(destination))
                    self.dismiss(animated: true)
                }
            } catch {
                await MainActor.run {
                    self.onFinish?(.failure(error))
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
