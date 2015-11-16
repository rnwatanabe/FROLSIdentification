%finds the number of terms in the matrizx p (see page 36 from Billings, SA (2013))
%mu is the maximal lag for the input signal
%my is the maximal lag for the output signal
function size = findPMatrixSize(mu, my, degree)
    n =mu+my;
    size = factorial(1+degree)/factorial(1)/factorial(degree);
    for i =2:n
        size = (i+degree)/i*size;
    end
end