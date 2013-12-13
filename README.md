# Ovation Matlab API


Ovation is the powerful data management service engineered specifically for scientists that liberates research through organization of multiple data formats and sources, the ability to link raw data with analysis and the freedom to safely share all of this with colleagues and collaborators.

The Ovation Matlab API wraps the Ovation Java API for use by Matlab. Through this API, Matlab users can access the full functionality of the Ovation ecosystem from within Matlab. 

## Requirements

* Matlab 2013a or later


## Installation

1. [Download](https://github.com/physion/ovation-matlab/releases) or clone the Ovation Matlab API
2. Add the folder containing `+ovation/` to the Matlab path.
3. Windows users must start Matlab as an Administrator the *first* time using Ovation. OS X and Linux users will be prompted for their system administrator password during first run.


## Usage

	>>> import ovation.*

### Connecting to the Ovation database

	>>> context = NewDataContext(<ovation.io user email>);




