import Foundation

public protocol Executable {
    var label : String { get }
    
    func run(on input : Any, state : GranitePipelineState) throws -> Any?
    
    func runBatch(on inputs: [Any], state : GranitePipelineState) throws -> [Any]?
}
