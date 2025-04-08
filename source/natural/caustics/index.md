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
Then it samples a light source from above.

To generate waves we use a fourier series (similar to FBM)

$$ f(x, y) = - \sum_{i=1}^N \sqrt{x^2 + y^2} \frac{F \cos{(A + 2^j S xy)}}{2^j} $$

By chain rule, we can calculate the normal vector of the surface at any point.

$$ \frac{\partial f}{\partial x} = - \sum_{i=1}^N \sqrt{x^2 + y^2} F \sin{(A + 2^j S xy)} S y - \frac{F \cos{(A + 2^j S xy)} x}{2^j \sqrt{x^2 + y^2} } $$

$$ \frac{\partial f}{\partial y} = - \sum_{i=1}^N \sqrt{x^2 + y^2} F \sin{(A + 2^j S xy)} S x - \frac{F \cos{(A + 2^j S xy)} y}{2^j \sqrt{x^2 + y^2} } $$

$$ \textbf{n} = \begin{bmatrix} -\frac{df}{dx} \\ -\frac{df}{dy} \\ 1 \end{bmatrix} $$

We use this to backtrace the refracted ray with snell's law.

$$ 
\begin{align*}
\eta_1 \sin{\theta_1} &= \eta_2 \sin{\theta_2}\\
N \times E &= |N| |E| \sin{\theta_1} \eta \\
T &= \sin{(\theta_2)}(N \times \eta) - N \cdot T \\
&= \text{Projection on plane of incidence} + \text{on Normal vector}\\
&= \frac{\eta_1}{\eta_2} \sin{(\theta_1)} (N \times \eta ) - N |N| |T| \cos{(\theta_2)}\\
&= \frac{\eta_1}{\eta_2} (N \times \sin{(\theta_1)} \eta ) - N \cos{(\theta_2)}\\
&= \frac{\eta_1}{\eta_2} (N \times (-N \times E)) - N \sqrt{1 - \sin^2(\theta_2)}\\
&= \frac{\eta_1}{\eta_2} (N \times (-N \times E)) - N \sqrt{1 - \left(\frac{\eta_1}{\eta_2} \sin(\theta_1) \right)^2}\\
&= \frac{\eta_1}{\eta_2} (N \times (-N \times E)) - N \sqrt{1 - \left(\frac{\eta_1}{\eta_2} (N \times E) \right)^2}
\end{align*}
$$


To convert this into vector form, we can use the following from Foley et al. 1996:


$$ T = N \left( \frac{\eta_1}{\eta_2} (E \cdot N) \pm \sqrt{1 + \left(\frac{\eta_1}{\eta_2}\right)^2 ((E \cdot N)^2 + 1)} \right) + \frac{\eta_1}{\eta_2} E $$



