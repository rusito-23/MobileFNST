import CoreML

// MARK: - Style Transfer Model Input

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class TransferInput : MLFeatureProvider {

    // MARK: - Constants

    private struct Constants {
        static let inputName = "input1"
    }

    // MARK: - Properties

    /// Pixel Buffer with size 224 x 224 and 32ARGB pixel format
    var inputBuffer: CVPixelBuffer

    var featureNames: Set<String> { [Constants.inputName] }

    // MARK: - Initializer

    init(with buffer: CVPixelBuffer) {
        self.inputBuffer = buffer
    }

    // MARK: - Methods

    func featureValue(for featureName: String) -> MLFeatureValue? {
        guard featureName == Constants.inputName else { return nil }
        return MLFeatureValue(pixelBuffer: inputBuffer)
    }
}

// MARK: - Style Transfer Model Output

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class TransferOutput : MLFeatureProvider {

    // MARK: - Constants

    private struct Constants {
        static let outputName = "output1"
    }

    // MARK: - Properties

    /// Pixel Buffer with size 224 x 224 and 32ARGB pixel format
    lazy var outputBuffer: CVPixelBuffer? = { [weak self] in
        self?.provider.featureValue(for: Constants.outputName)?.imageBufferValue
    }()

    var featureNames: Set<String> { self.provider.featureNames }

    // MARK: - Private properties

    private let provider : MLFeatureProvider

    // MARK: - Initializer

    init?(pixelBuffer: CVPixelBuffer) {
        guard let provider = try? MLDictionaryFeatureProvider(
            dictionary: [Constants.outputName : MLFeatureValue(pixelBuffer: pixelBuffer)]
        ) else { return nil }

        self.provider = provider
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }

    // MARK: - Methods

    func featureValue(for featureName: String) -> MLFeatureValue? {
        guard featureName == Constants.outputName else { return nil }
        return self.provider.featureValue(for: featureName)
    }
}

// MARK: - Style Transfer Model


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class TransferModel {

    // MARK: - Constants

    private struct Constants {
        static let fileType = "mlmodelc"
    }

    // MARK: - Properties

    private var model: MLModel

    // MARK: - Initializers

    init?(name: String) {
        guard
            let compiledURL = Bundle.main.url(
                forResource: name,
                withExtension: Constants.fileType
            ),
            let model = try? MLModel(contentsOf: compiledURL)
        else { return nil }

        self.model = model
    }

    // MARK: - Predict Methods

    func prediction(input: TransferInput) throws -> TransferOutput {
        try self.prediction(input: input, options: MLPredictionOptions())
    }

    func prediction(input: TransferInput, options: MLPredictionOptions) throws -> TransferOutput {
        TransferOutput(features: try model.prediction(from: input, options:options))
    }
}
