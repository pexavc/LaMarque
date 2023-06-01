import Foundation

public struct PassthroughPipe: GraniteStep {
    public typealias Input = Any
    public typealias Output = Any
    
    public func execute(input: Any, state: GranitePipelineState) throws -> Any? {
        return input
    }
}
