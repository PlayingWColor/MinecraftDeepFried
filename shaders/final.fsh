//Copyright © 2024 David Draper Jr

#version 120

varying vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D gnormal;

uniform float viewWidth;
uniform float viewHeight;

float random(float seed)
{
	float first = mix(fract(seed*123.43),1-fract(seed*357.57),fract(seed*798.901));
	float second = mix(fract(first*431.27),1-fract(first*157.73),fract(first*977.715));
	return mix(fract(second*123.43),1-fract(second*357.57),fract(second*798.901));
}

vec3 sharpen(sampler2D tex, vec2 texCoord, vec2 resolution, float strength)
{
    vec4 result = texture2D(tex, texCoord) * (strength * 4.0 + 1.0);
    result += texture2D(tex, texCoord + vec2(0,1)/resolution) * -strength;
    result += texture2D(tex, texCoord + vec2(0,-1)/resolution) * -strength;
    result += texture2D(tex, texCoord + vec2(1,0)/resolution) * -strength;
    result += texture2D(tex, texCoord + vec2(-1,0)/resolution) * -strength;
    return result.rgb;
}

vec3 colorNoise(vec2 texCoord)
{
    float texCoord1D = texCoord.x + texCoord.y;

    float randomRed = random(texCoord1D);
    float randomGreen = random(texCoord1D * 157);
    float randomBlue = random(texCoord1D * 793);

    return vec3(randomRed, randomGreen, randomBlue);
}

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

void main()
{
    vec3 color = sharpen(colortex0, texcoord.xy, vec2(viewWidth, viewHeight), 10);

    color = mix(color, colorNoise(texcoord.xy),0.3);


    vec3 deepFriedHSV = rgb2hsv(color);
    deepFriedHSV.y = deepFriedHSV.y*4;
    deepFriedHSV.z = deepFriedHSV.z*3;
    vec3 deepFriedRGB = hsv2rgb(deepFriedHSV);

    gl_FragColor = vec4(deepFriedRGB,1.0);
}