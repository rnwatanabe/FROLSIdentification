function [NOFRF, f] = computeSystemNOFRF(GFRF, u, Fs, fres, degree, fmin, fmax)

    U = computeSignalFFT(u, Fs, fres);
    [NOFRF, f] = computeNOFRF(GFRF, U, degree, Fs, fres, fmin, fmax);       
    
end