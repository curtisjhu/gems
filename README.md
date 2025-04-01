# Graphics Gems

This repository consists of the implementations of the ideas found in the [Nvidia GPU Book Gems series](https://developer.nvidia.com/gpugems/gpugems/foreword), [Ray Tracing Gems](https://www.realtimerendering.com/raytracinggems/), or [PBRT](https://www.pbrt.org/). 

For a comprehensive list of Graphics resources, look at [realtimerendering.com](https://www.realtimerendering.com/books.html). That's enough reading for one lifetime. 

## Build the projects
#### MacOS/Unix
Using cmake to build subprojects
```
mkdir build && cd build
cmake ..
make [subproject executable]
```

#### Windows
Use Visual Studio 2022...TBD. (Just choose subtarget and run it.)

## Build website
The Jekyll website is interwoven with the directory structure. Just run
```
build exec jekyll serve
```
And to build the site:
```
bundle exec jekyll build
```
