void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec4 aqua = vec4(0.3, 0.6, 0.8, 1.0);
    vec4 blue = vec4(0.4, 0.6, 1.0, 1.0);
    vec4 deepPurple = vec4(0.1, 0.2, 0.5, 1.0);
    
    vec4 water = mix(aqua, deepPurple, (1.0 - uv.y) * 2.0 - 1.5 + sin(iTime + uv.x * 8.0)/6.0);
    
    float waveHeight = sin(iTime + uv.x * 4.0)/8.0 +0.6 + (sin(-iTime * 2.0 + uv.x * 16.0)/64.0);
    
    if(uv.y < waveHeight)
		fragColor = water;
    else
        fragColor = blue;
}