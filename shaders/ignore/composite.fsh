//Copyright © 2024 David Draper Jr

#version 120

varying vec2 texcoord;

uniform vec3 sunPosition;

uniform float viewWidth;
uniform float viewHeight;
uniform float sunAngle;

uniform vec3 fogColor;
uniform vec3 skyColor;

uniform ivec2 eyeBrightness;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

uniform sampler2D depthtex0;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float limit_range(float dither, float value, float limit_by)
{
    return round(value * limit_by + (dither-0.5)*0.25)/limit_by;
}

void main()
{
    float lowResX = round(texcoord.x * 320.0)/320.0;
    float lowResY = round(texcoord.y * 240.0)/240.0;
    vec2 lowResTexCoord = vec2(lowResX,lowResY);

    //fix pixel blur offset
    lowResX = round(lowResX * viewWidth)/viewWidth + 0.5/viewWidth;
    lowResY = round(lowResY * viewHeight)/viewHeight + 0.5/viewHeight;
    
    vec3 albedo = texture2D(colortex0, lowResTexCoord).rgb;
    float depth = texture2D(depthtex0, lowResTexCoord).r;

    if(depth == 1.0f){
        gl_FragData[0] = vec4(albedo, 1.0f);
        return;
    }
    

    vec3 lightmap = texture2D(colortex2, lowResTexCoord).rgb;
    
    float dither = mod(lowResY*120.0,1.0)*2.0-mod(lowResX*160.0,1.0);

    vec3 skylight = round(lightmap.y * 10.0 + (dither-0.5)*0.25)*0.1 * skyColor * 1.5 + vec3(0.4);
    vec3 torchlight = round(lightmap.x * 10.0 + (dither-0.5)*0.25)*0.1 * vec3(0.95,0.6,0.45) * mix(3,1,skyColor.b+0.2);

    vec3 color = albedo * (skylight + torchlight);

    //color effects
    
    vec3 hsvCol = rgb2hsv(color);

    //float dither = mod(lowResY*120.0,1.0)*2.0-mod(lowResX*160.0,1.0);

    hsvCol.x = clamp(limit_range(dither,hsvCol.x+0.01,16),0.0,1.0);
    hsvCol.y = clamp(limit_range(dither,hsvCol.y*0.85,16),0.0,1.0);
    hsvCol.z = clamp(limit_range(dither,hsvCol.z*0.8,16),0.0,1.0);

    color = hsv2rgb(hsvCol);

    /* DRAWBUFFERS:0 */
    // Finally write the diffuse color
    gl_FragData[0] = vec4(color, 1.0);
}