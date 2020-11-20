import PopupDialog

final class ErrorDialog {

    // MARK: - Properties

    private var dialog: PopupDialog

    // MARK: - Initializers

    init(message: String = "DEFAULT_ERROR_MESSAGE".localized) {
        dialog = PopupDialog(
            title: "☹️",
            message: message,
            buttonAlignment: .horizontal,
            transitionStyle: .bounceDown
        )

        dialog.addButton(
            DefaultButton(
                title: "OH_OK".localized,
                dismissOnTap: true,
                action: nil
            )
        )
    }

    // MARK: - Methods

    func present(
        _ parent: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        parent.present(
            dialog,
            animated: true,
            completion: completion
        )
    }
}
