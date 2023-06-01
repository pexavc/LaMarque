#include <metal_stdlib>
using namespace metal;

kernel void FloatTexture(texture2d<float, access::sample> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         uint2 gid [[thread_position_in_grid]])
{
    if (gid.x >= outTexture.get_width() ||
        gid.y >= outTexture.get_height()) {
        return;
    }
    
    float4 out = inTexture.read(gid);
    outTexture.write(out, gid);
}
