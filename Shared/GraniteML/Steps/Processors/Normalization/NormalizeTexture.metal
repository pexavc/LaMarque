#include <metal_stdlib>
using namespace metal;

kernel void NormalizeTexture(texture2d<half, access::sample> inTexture [[texture(0)]],
                             texture2d<half, access::write> outTexture [[texture(1)]],
                             constant float2 &normalization [[buffer(0)]],
                             uint2 gid [[thread_position_in_grid]])
{
    if (gid.x >= outTexture.get_width() ||
        gid.y >= outTexture.get_height()) {
        return;
    }

    half4 out = inTexture.read(gid) * (normalization.y * 2) - half4(abs(normalization.x));
    outTexture.write(out, gid);
}
