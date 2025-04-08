---
layout: post
title: Water Caustics
---

# Introduction
> Based off the following [GPU Gem Chapter](https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects/chapter-2-rendering-water-caustics)


## Naive Approach
The naive approach is to shoot rays of light from a light source
onto the uneven water surface,
use snell's law to refract light ray, and calculate intersection
with the floor.

This is obviously highly inefficient and produces grainy results. 

## Less Naive Approach
Another approach is backtracing the rays.
We start with all pixels on the floor and
use Direct Hemisphere sampling to sample light rays for that pixel on the floor.
Each ray takes a path to the water surface, refracts into the sky and possibly hits a light source.
Again, the problem with this is that a lot of the rays will not hit the light source so its quite inefficient.

## Best Approach
Only using GPU and shader language.

We assume that each pixel on the floor only back traces up
(that is the only light contribution is the ray going straight down.
Light doesn't travel well in water anyways so this is a rough estimation).
Then it refracts through a water surface described by a fourier series.
Then it samples a texture of the sun or light source.




