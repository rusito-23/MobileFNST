//
// TransferModel.swift
//

import CoreML


/// Model Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class TransferInput : MLFeatureProvider {

    /// input as color (kCVPixelFormatType_32BGRA) image buffer
    ///  224 pixels wide by 224 pixels high
    var imageInput: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["input1"]
        }
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input1") {
            return MLFeatureValue(pixelBuffer: imageInput)
        }
        return nil
    }

    init(with image: CVPixelBuffer) {
        self.imageInput = image
    }
}

/// Model Output Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class TransferOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// output as color (kCVPixelFormatType_32BGRA) image buffer
    ///  224 pixels wide by 224 pixels high
    lazy var imageOutput: CVPixelBuffer = {
        [unowned self] in return self.provider.featureValue(for: "output1")!.imageBufferValue
    }()!

    var featureNames: Set<String> {
        return self.provider.featureNames
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(output1: CVPixelBuffer) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["output1" : MLFeatureValue(pixelBuffer: output1)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class TransferModel {
    var model: MLModel

    /// URL of compiled model
    class func compiledURL(with name:String) -> URL? {
        let bundle = Bundle(for: TransferModel.self)
        return bundle.url(forResource: name, withExtension:"mlmodelc")
    }

    /**
        Construct a model with name
        - parameters:
           - name: the desired model name
    */
    convenience init?(with name:String) {
        guard let compiledURL = type(of:self).compiledURL(with: name) else {
            return nil
        }

        try? self.init(contentsOf: compiledURL)
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as TransferInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as TransferOutput
    */
    func prediction(input: TransferInput) throws -> TransferOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as TransferInput
           - options: prediction options
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as TransferOutput
    */
    func prediction(input: TransferInput, options: MLPredictionOptions) throws -> TransferOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return TransferOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - input1 as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as TransferOutput
    */
    func prediction(imageInput: CVPixelBuffer) throws -> TransferOutput {
        let input_ = TransferInput(with: imageInput)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [TransferInput]
           - options: prediction options
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [TransferOutput]
    */
    func predictions(inputs: [TransferInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [TransferOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [TransferOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  TransferOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}

