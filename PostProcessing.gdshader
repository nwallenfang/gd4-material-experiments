/*
	Halftone Shader
	This shader is taken from
		https://weber.itn.liu.se/%7Estegu/webglshadertutorial/shadertutorial.html
	and adjusted to Godot.
*/
shader_type canvas_item;

const float aspect_h = 16.0;
const float aspect_v = 9.0;
const mat2 rotated_45 = mat2(vec2(0.707, -0.707), vec2(0.707, 0.707));
const mat2 scale_down = mat2(vec2(2.0, 0.0), vec2(0.0, 1.0));

uniform float radius_base = 0.5;
uniform float frequency = 70.0;


float aastep(float threshold, float value) {
  float afwidth = 0.7 * length(vec2(dFdx(value), dFdy(value)));
  return smoothstep(threshold-afwidth, threshold+afwidth, value);
}
 

// Description : Array- and textureless GLSL 2D simplex noise.
// Author : Ian McEwan, Ashima Arts. Version: 20110822
// Copyright (C) 2011 Ashima Arts. All rights reserved.
// Distributed under the MIT License. See LICENSE file.
// https://github.com/ashima/webgl-noise
 
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 mod289_3(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289_3((( x * 34.0) + 1.0) * x); }
 
float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
  // First corner
  vec2 i = floor(v + dot(v, C.yy) );
  vec2 x0 = v - i + dot(i, C.xx);
  // Other corners
  vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  // Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
                           + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
                          dot(x12.zw,x12.zw)), 0.0);
  m = m*m; m = m*m;
  // Gradients
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 a0 = x - floor(x + 0.5);
  // Normalise gradients implicitly by scaling m
  m *= 1.792843 - 0.853735 * ( a0*a0 + h*h );
  // Compute final noise value at P
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}


vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 color_dodge(vec4 base, vec4 blend){
	return base / (1.0 - blend);
}


void fragment() {
	// Distance to nearest point in a grid of
    // (frequency x frequency) points over the unit square
	vec2 rot_uv = rotated_45 * scale_down *  UV;//vec2(aspect_h, aspect_v) * UV;
    vec2 nearest = 2.0 * fract(frequency * rot_uv) - 1.0;
    float distance_nearest = length(nearest);
	
	float brightness = 0.21 * COLOR.r + 0.71 * COLOR.g + 0.07 * COLOR.b;
	// Fractal noise (think this means noise layered with different frequencies)
	float noise = 0.1*snoise(UV*200.0); 
    noise += 0.05*snoise(UV*400.0);
    noise += 0.025*snoise(UV*800.0);
	float radius = sqrt(1.0 - brightness);

	vec3 white = vec3(noise * 0.5 + 0.98);
	vec3 black = vec3(noise + 0.15);
    // Perform a rough RGB-to-CMYK conversion
    vec4 cmyk;
    cmyk.xyz = 1.0 - COLOR.rgb;
    cmyk.w = min(cmyk.x, min(cmyk.y, cmyk.z)); // Create K
    cmyk.xyz -= cmyk.w; // Subtract K equivalent from CMY
 
    float afwidth = 2.0 * frequency * max(length(dFdx(UV)), length(dFdy(UV)));
    float blend = smoothstep(0.7, 1.4, afwidth); 


    vec3 color = mix(black, white, aastep(radius, distance_nearest+noise));
	vec4 color_p = mix(COLOR, vec4(color, 1.0), cmyk.w+noise);
    COLOR = vec4(mix(color_p, COLOR, blend));
//	COLOR = vec4(color, 1.0);
//	COLOR = vec4(vec3(brightness), 1.0);
}
