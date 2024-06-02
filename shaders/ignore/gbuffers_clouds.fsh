//Copyright © 2024 David Draper Jr

#version 120

varying vec2 texcoord;
varying vec2 lightcoord;

uniform sampler2D texture;

varying vec4 vertexColor;

void main()
{
    vec4 color = texture2D(texture, texcoord) * vertexColor;
    
    gl_FragData[0] = vec4(color.rgb,color.a);
    gl_FragData[2] = vec4(lightcoord, 0.0f, 1.0f);
}