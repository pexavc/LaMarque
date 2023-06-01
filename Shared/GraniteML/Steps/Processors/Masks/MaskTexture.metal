#include <metal_stdlib>
using namespace metal;

kernel void MaskTexture(texture2d<half, access::read> inTexture [[texture(0)]],
                        texture2d<half, access::write> outTexture [[texture(1)]],
                        texture2d<half, access::sample> maskTexture [[texture(2)]],
                        uint2 gid [[thread_position_in_grid]])
{
    if (gid.x >= outTexture.get_width() ||
        gid.y >= outTexture.get_height()) {
        return;
    }
    
    constexpr sampler s(address::clamp_to_edge, filter::linear, coord::normalized);
    
    float2 size = float2(inTexture.get_width(), inTexture.get_height());
    float2 coords = float2(gid) * float2(1.0 / size.x, 1.0 / size.y);
    
    half4 inColor = half4(inTexture.read(gid));
    half4 inMask = maskTexture.sample(s, coords);
    
    half4 result = mix(inColor, inMask, 1.0 - inMask.a);
    
    outTexture.write(result, gid);
}
