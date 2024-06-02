//Copyright © 2024 David Draper Jr

#version 120

varying vec2 texcoord;

void main()
{
    gl_Position = ftransform();
    texcoord = gl_MultiTexCoord0.st;
}