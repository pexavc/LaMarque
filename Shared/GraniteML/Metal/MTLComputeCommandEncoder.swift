//
//  MTLComputeCommandEncoder.swift
//
//
//  Created by 0xKala on 2/26/21.
//

import Foundation
import Metal
import GraniteUI

extension MTLComputeCommandEncoder {
    /**
     Dispatches a compute kernel on a 1-dimensional grid.
     
     - Parameters:
     - count: the number of elements to process
     */
    public func dispatch(pipeline: MTLComputePipelineState, count: Int) {
        // Round off count to the nearest multiple of threadExecutionWidth.
        let width = pipeline.threadExecutionWidth
        let rounded = ((count + width - 1) / width) * width
        
        let blockSize = min(rounded, pipeline.maxTotalThreadsPerThreadgroup)
        let numBlocks = (count + blockSize - 1) / blockSize
        
        let threadGroupSize = MTLSizeMake(blockSize, 1, 1)
        let threadGroups = MTLSizeMake(numBlocks, 1, 1)
        
        setComputePipelineState(pipeline)
        dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
    }
    
    /**
     Dispatches a compute kernel on a 2-dimensional grid.
     
     - Parameters:
     - width: the first dimension
     - height: the second dimension
     */
    public func dispatch(pipeline: MTLComputePipelineState, width: Int, height: Int) {
        let w = pipeline.threadExecutionWidth
        let h = pipeline.maxTotalThreadsPerThreadgroup / w
        
        let threadGroupSize = MTLSizeMake(w, h, 1)
        
        let threadGroups = MTLSizeMake(
            (width  + threadGroupSize.width  - 1) / threadGroupSize.width,
            (height + threadGroupSize.height - 1) / threadGroupSize.height, 1)
        
        setComputePipelineState(pipeline)
        dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
    }
    
    /**
     Dispatches a compute kernel on a 3-dimensional image grid.
     
     - Parameters:
     - width: the width of the image in pixels
     - height: the height of the image in pixels
     - featureChannels: the number of channels in the image
     - numberOfImages: the number of images in the batch (default is 1)
     */
    public func dispatch(pipeline: MTLComputePipelineState,
                         width: Int,
                         height: Int,
                         featureChannels: Int,
                         numberOfImages: Int = 1) {
        let slices = ((featureChannels + 3)/4) * numberOfImages
        
        let w = pipeline.threadExecutionWidth
        let h = pipeline.maxTotalThreadsPerThreadgroup / w
        let d = 1
        let threadGroupSize = MTLSizeMake(w, h, d)
        
        let threadGroups = MTLSizeMake(
            (width  + threadGroupSize.width  - 1) / threadGroupSize.width,
            (height + threadGroupSize.height - 1) / threadGroupSize.height,
            (slices + threadGroupSize.depth  - 1) / threadGroupSize.depth)
        
        setComputePipelineState(pipeline)
        dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
    }
    
    /**
     For debugging the threadgroup sizes.
     */
    public func printGrid(threadGroups: MTLSize, threadsPerThreadgroup: MTLSize) {
        let groups = threadGroups
        let threads = threadsPerThreadgroup
        let grid = MTLSizeMake(groups.width  * threads.width,
                               groups.height * threads.height,
                               groups.depth  * threads.depth)
        
        
        GraniteLogger.info("threadGroups: \(groups.width)x\(groups.height)x\(groups.depth)"
                                + ", threadsPerThreadgroup: \(threads.width)x\(threads.height)x\(threads.depth)"
                                + ", grid: \(grid.width)x\(grid.height)x\(grid.depth)", .metal)
    }
    
}
