import Foundation
import Metal

public protocol GranitePipe: Executable {
    associatedtype Input
    associatedtype Output
    
    ///The debugging label of the handler.
    var label: String { get }

    ///Handling input and returning the appropriate output.
    func execute(input : Input, state : GranitePipelineState) throws -> Output?
}

extension GranitePipe {
    
    public var label: String {
        return String(describing: Self.self)
    }
    
    public func run(on anyInput: Any, state: GranitePipelineState) throws -> Any? {
        guard let input = anyInput as? Input else {
            throw PipelineRuntimeError.typeMismatch(self, type(of: anyInput), Input.self)
        }
        
        let output = try execute(input: input, state: state)
        
        return output
    }
    
    public func runBatch(on inputs: [Any], state: GranitePipelineState) throws -> [Any]? {
        var results = [Any]()
        
        for input in inputs {
            guard let result = try run(on: input, state: state) else {
                return nil
            }
            
            results.append(result)
        }
        
        return results
    }
    
}
