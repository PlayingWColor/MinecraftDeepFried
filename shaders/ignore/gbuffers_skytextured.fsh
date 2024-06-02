//Copyright © 2024 David Draper Jr

#version 120

noperspective varying vec2 texcoord;
noperspective varying vec2 lightcoord;

uniform sampler2D texture;

uniform vec3 skyColor;
uniform vec3 fogColor;

varying vec4 vertexColor;

void main()
{
    gl_FragData[0] = texture2D(texture, texcoord);
    gl_FragData[2] = vec4(lightcoord, 0.0, 1.0);
}