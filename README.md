# MAP
# Model-aied predictor for cancer immunotherapy response.

## Installation

By pip:
```
pip install git+git://github.com/guangxujin/MAP.git#egg=MAP
```


## Installation of Python Packages
Python 2.7 or 3.8

Numba

Numpy

Conda

## System: Linux.
GPU is required for analysis of CyTOF datasets or the datasets with single cell number large than 100,000.
### Example

### run MAP
cd py

python SPEA2_numba.py
### heatmap
cd Rcodes

R heatmap_MAP.R
### ROC curve
R ROC.MAP.R
