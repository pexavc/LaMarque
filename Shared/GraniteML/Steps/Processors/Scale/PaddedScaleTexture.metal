#include <metal_stdlib>
using namespace metal;

kernel void PaddedScaleTexture(texture2d<float, access::read> inTexture [[texture(0)]],
                               texture2d<float, access::write> outTexture [[texture(1)]],
                               uint2 gid [[thread_position_in_grid]])
{
    if (gid.x >= outTexture.get_width() ||
        gid.y >= outTexture.get_height()) {
        return;
    }
    
    const float in_width = inTexture.get_width();
    const float in_height = inTexture.get_height();
    
    const float in_width_diff = (outTexture.get_width() - in_width)/2.0;
    const float in_height_diff = (outTexture.get_height() - in_height)/2.0;
    
   
    if (gid.x >= in_width + in_width_diff ||
        gid.y >= in_height + in_height_diff ||
        gid.x <= in_width_diff ||
        gid.y <= in_height_diff ) {
        outTexture.write(float4(0.5, 0.5, 0.5, 1.0), gid);
    }
    else {
        
        outTexture.write(inTexture.read(uint2(gid.x - in_width_diff, gid.y - in_height_diff)), gid);
    }
    
}
