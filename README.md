
# WaveMask: Computational Phase Mask Optimization
## Overview
WaveMask is a MATLAB-based computational imaging toolkit that optimizes phase mask designs for extended depth-of-field (EDOF) imaging systems. It implements and analyzes various phase mask designs including binary, cubic, and exponential patterns to enhance image quality across different focusing conditions.

## Key Features

### Phase Mask Analysis
- Binary annular phase mask optimization
- Cubic phase mask implementation (α(x³ + y³))
- Exponential phase mask patterns
- Comparative analysis between different mask types

### Image Processing
- Point Spread Function (PSF) calculation
- Noise-aware image restoration
- Mean Square Error (MSE) optimization
- Wiener filtering implementation

### Performance Metrics
- MSE analysis across defocus range
- Signal-to-Noise Ratio (SNR) impact assessment
- Depth-dependent image quality evaluation
- Optimization for various optical parameters

### Visualization Tools
- PSF visualization
- Phase mask pattern display
- MSE distribution plots
- Defocus analysis curves

## Technical Parameters
- Default SNR: 34dB
- Pupil radius: 2cm
- Wavelength: 10µm
- Image size: 256x256 pixels
- Defocus range analysis: -5 to +5 waves

## Applications
- Extended depth-of-field imaging
- Computational photography
- Optical system design
- Wavefront coding

## Requirements
- MATLAB 
- Image Processing Toolbox
- Signal Processing Toolbox

This project provides a comprehensive framework for designing and optimizing phase masks in computational imaging systems, with particular focus on extending the depth of field while maintaining image quality.
