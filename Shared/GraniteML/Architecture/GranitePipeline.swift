import Foundation

public class GranitePipeline<T>: GranitePipe {
    public typealias Input = Any
    public typealias Output = T
    
    public let executables: [Executable]
    public let scene: GraniteScene
    
    public init(executables: [Executable], scene: GraniteScene) {
        self.executables = executables
        self.scene = scene
        
        self.executables.forEach {
            ($0 as? (any GraniteStep))?.invalidate(context: scene)
        }
    }
    
    public func execute(input: Any, state: GranitePipelineState) throws -> T? {
        var output = input
        
        for exe in executables {
            guard let result = try exe.run(on: output, state: state) else {
                throw PipelineRuntimeError.emptyResult(exe)
            }
            
            output = result
        }
        
        state.insertCommandBufferExecutionBoundary()
        
        return output as? T
    }
    
    public func execute(inputs: [Any], state: GranitePipelineState) throws -> [T]? {
        var outputs = inputs
        
        for exe in executables {
            guard let result = try exe.runBatch(on: outputs, state: state) else {
                throw PipelineRuntimeError.emptyResult(exe)
            }
            
            outputs = result
        }
        
        state.insertCommandBufferExecutionBoundary()
        
        return outputs as? [T]
    }
    
    public func run(on input: Any) throws -> T? {
        guard let state = GranitePipelineState(context: scene) else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        return try execute(input: input, state: state)
    }
    
    public func runBatch(on inputs: [Any]) throws -> [T]? {
        guard let state = GranitePipelineState(context: scene) else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        return try execute(inputs: inputs, state: state)
    }
}

