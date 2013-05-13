# Ovation Matlab API


Ovation is the powerful data management service engineered specifically for scientists that liberates research through organization of multiple data formats and sources, the ability to link raw data with analysis and the freedom to safely share all of this with colleagues and collaborators.

The Ovation Matlab API wraps the Ovation Java API for use by Matlab. Through this API, Matlab users can access the full functionality of the Ovation ecosystem from within Matlab. 

## Requirements

* Matlab 2012b or later


## Installation

Add the folder containing `+ovation/` to the Matlab path.

## Usage

::

	>>> import ovation.*

### Connecting to the Ovation database

	>>> context = NewDataContext(<ovation.io user email>);




