//Copyright © 2024 David Draper Jr

#version 120

noperspective varying vec2 texcoord;
noperspective varying vec2 lightcoord;

varying vec3 normal;
varying vec4 vertexColor;

uniform sampler2D texture;

void main()
{
    vec4 color = texture2D(texture, texcoord);

    gl_FragData[0] = color * vertexColor;

    if(vertexColor.a < 1.0)
        return;
    gl_FragData[2] = vec4(lightcoord.x, lightcoord.y, 0.0f, 1.0f);
}