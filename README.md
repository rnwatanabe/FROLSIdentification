# FROLSIdentification

##Files to perform discrete nonlinear system identification and analysis


The files in this repository were written to perform the system identification of nonlinear systems. The method used is the algorithm known as Forward Regression with Orthogonal Least Squares (FROLS), developed by Stephen Billings and his group. All the files were written by me, except the v2struct.m file, used to deal with the structs from Matlab.

How to use the files 
-------------------

Download all the files in the same directory. The files were written to run in the Matlab<sup>&reg;</sup> platform, so if you want to run them on Matlab<sup>&reg;</sup>, you will need a license of the Matlab<sup>&reg;</sup> software. To run the functions that compute the Generalized Frequency Response Function (GFRF) and Nonlinear Output Frequency Response Function (NOFRF), you will need a license of the Matlab<sup>&reg;</sup> Symbolic Math Toolbox<sup>&trade;</sup>. 

Once you have downloaded all the files in the same directory, run the FROLSTest.m file.

GNU Octave
---------

Although all the files were written in Matlab<sup>&reg;</sup>, they work equally well in the free software GNU Octave. To use the files from this repository in Octave you must have installed the symbolic package  (http://octave.sourceforge.net/symbolic/). To use the symbolic package from Octave you must have a Python installation with the SymPy library. I recommend the use of the Anaconda distribution of Python (https://www.continuum.io/downloads). The files were tested in the Octave 4.0 version on Ubuntu  (https://www.gnu.org/software/octave/download.html).

To execute an example on GNU Octave, download all the files in the same directory and run the FROLSTest.m file.

Notebook
---------

An explanation of the algorithm implementation is also available in the format of [notebook](http://nbviewer.ipython.org/github/rnwatanabe/FROLSIdentification/blob/master/FROLSExampleNotebook_Matlab.ipynb). You can also download the notebook file and execute in your own computer. In this case you will need to install the [Jupyter environment](http://jupyter.org/) and either the [Matlab or Octave kernel](https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages).

Citation
----------

If you use the codes from this repository, please cite the following paper as the used implementation of the algorithm:

"WATANABE, R. N.; KOHN, A. F. System identification of a motor unit pool using a realistic
neuromusculoskeletal model. In: 5th IEEE RAS & EMBS International Conference on
Biomedical Robotics and Biomechatronics, 2014. p. 610–615."

and the following  book as the source of the algorithm: 

"S. A. Billings, Nonlinear System Identification: NARMAX Methods in the Time, Frequency and Spatio-temporal Domains. Chichester, UK: John Wiley & Sons, Ltd,, 2013."







