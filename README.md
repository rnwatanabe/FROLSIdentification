# FROLSIdentification


The files in this repository were written to perform the system identification of nonlinear systems. The method used is the algorithm known as Forward Regression with Orthogonal Least Squares (FROLS), developed by Stephen Billings and his group. All the files were written by me, except the v2struct.m file, used to deal with the structs from Matlab.

All the files were written in Matlab, but they work fine in Octave. To use the files from this repository in Octave you must have installed the symbolic package  (http://octave.sourceforge.net/symbolic/). To use the symbolic package from Octave you must have a Python installation with the SymPy library. I recommend the use of the Anaconda distribution of Python (https://www.continuum.io/downloads). The files were tested in the Octave 4.0 version on Ubuntu  (https://www.gnu.org/software/octave/download.html).

If you use the codes from this repository, please cite the following paper as the used implementation of the algorithm:

"WATANABE, R. N.; KOHN, A. F. System identification of a motor unit pool using a realistic
neuromusculoskeletal model. In: 5th IEEE RAS & EMBS International Conference on
Biomedical Robotics and Biomechatronics, 2014. p. 610–615."

and the following  book as the source of the algorithm: 

"S. A. Billings, Nonlinear System Identification: NARMAX Methods in the Time, Frequency and Spatio-temporal Domains. Chichester, UK: John Wiley & Sons, Ltd,, 2013."

To run an example, download all the files in the same directory and run the FROLSTest.m file.





