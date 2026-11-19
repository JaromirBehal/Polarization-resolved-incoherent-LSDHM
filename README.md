# Polarization-resolved-incoherent-LSDHM - Data and Function Structure

The repository is organized as follows:

## Main MATLAB files
These are the main MATLAB scripts used for loading and processing the data for the final presentation.

- **`Polar_Diatoms_github.m`** — processes camera images acquired during the experiments with diatoms.
- **`Coherence_github.ipynb`** — contains interference fringe contrast values calculated from a sequence of images using a fixed region of interest of 200 × 200 pixels.
- **`Polar_Polarizer_Jones_github.m`** — loads experimentally obtained Jones matrix parameters of a linear polarizer, fits the data, and compares the results with the theory.
- **`Polar_Starch_Jones_github.m`** — loads and presents the Jones matrices of potato starch granules.
- **`Polar_Shaun_Jones_github.m`** — loads and presents the Jones matrix, fibre shape, and eigenpolarization orientations of a wool fibre.

## `data/`

Contains the raw camera images acquired during the experiments with diatoms, as well as an example image of a linear polarizer.

## `functions/`

Contains the MATLAB functions used by the main scripts:

- **`apodiz_SG.m`** — higher-order Gaussian function used for apodization of the input data.
- **`apodization_for_propag.m`** — function for applying apodization prior to the Fourier transform of an image.
- **`off_axis_reconstruction_general.m`** — function for holographic reconstruction.

## `variables/`

Contains the following MATLAB data files:

- **`Polarizer.mat`**
- **`Shaun.mat`**
- **`Starch_1.mat`**
- **`Starch_2.mat`**
