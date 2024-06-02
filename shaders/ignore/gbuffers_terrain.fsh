#version 120

noperspective varying vec2 texcoord;
noperspective varying vec2 lightcoord;

varying vec3 normal;
varying vec4 vertexColor;

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D normals;

uniform int worldTime;

void main()
{
    float lowResX = round(texcoord.x * 1024.0)/1024.0 + 0.5/1024.0;
    float lowResY = round(texcoord.y * 1024.0)/1024.0 - 0.5/1024.0;
    
    vec4 color = texture2D(gtexture, texcoord);
    vec4 light = texture2D(lightmap, lightcoord);

    float vertlight = dot(vertexColor.rgb, vec3(0.333));

    gl_FragData[0] = color * vertexColor;
    gl_FragData[2] = vec4(lightcoord, dot(vertexColor, vec4(0.333)), 1.0f);
}