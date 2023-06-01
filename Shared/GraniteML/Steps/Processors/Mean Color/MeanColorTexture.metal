#include <metal_stdlib>
using namespace metal;

kernel void MeanColorTexture(texture2d<half, access::read> inTexture [[texture(0)]],
                             texture2d<half, access::write> outTexture [[texture(1)]],
                             constant int4 &color [[buffer(0)]],
                             uint2 gid [[thread_position_in_grid]])
{
    if (gid.x >= outTexture.get_width() ||
        gid.y >= outTexture.get_height()) {
        return;
    }
    
    const auto inColor = float4(inTexture.read(gid));
    
    outTexture.write(half4(inColor.x*255-color.r, inColor.y*255-color.g, inColor.z*255-color.b, color.a / 255.0), gid);
}
