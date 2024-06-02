#version 120
#include "ps_vertex_transform.glsl"

varying vec2 texcoord;

void main()
{
    gl_Position = psTransform();

    texcoord = gl_MultiTexCoord0.st;
}