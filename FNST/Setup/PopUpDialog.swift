import PopupDialog

extension PopupDialog {

    // MARK: - Constants

    private struct Constants {
        static let borderWidth: CGFloat = 3
        static let cornerRadius: Float = 32
    }

    // MARK: - Methods

    static func setup() {
        PopupDialogContainerView.appearance().cornerRadius = Constants.cornerRadius
        PopupDialogDefaultView.appearance().backgroundColor = .darkGray
        PopupDialogDefaultView.appearance().titleFont = Font.subtitle
        PopupDialogDefaultView.appearance().titleColor = .white
        PopupDialogDefaultView.appearance().messageFont = Font.bodySmall
        PopupDialogDefaultView.appearance().messageColor = .white
        DefaultButton.appearance().titleFont = Font.bodySmall
        DefaultButton.appearance().buttonColor = .darkGray
        DefaultButton.appearance().titleColor = .white
    }
}
