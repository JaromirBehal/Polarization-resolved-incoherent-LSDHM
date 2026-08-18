# Polarization-resolved-incoherent-LSDHM - Data and Function Structure

The repository is organized as follows:

## Main MATLAB files

**`Polar_Cotton.m`**
**`Polar_Diatoms.m`**
**`Polar_Tape.m`**

The main MATLAB scripts used for loading and processing the camera images. They perform the reconstruction and analysis of the experimental data.

## `data/`

Contains the raw camera images acquired during the experiments with Diatoms, Cotton and plastic tape.

## `functions/`

Contains the MATLAB functions used by the main script:

- **`apodiz_SG.m`** — higher-order Gaussian function for apodization of the input data.
- **`apodization_for_propag.m`** — function for applying apodization prior to Fourier transform if the image.
- **`off_axis_reconstruction_general.m`** — general function for holographic reconstruction.
