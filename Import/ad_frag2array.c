/* John Haitas, 2007 */
#include "math.h"
#include "mex.h"
#include "matrix.h"

/* This code replaces the following for loop in the file PlxAD2_mAD.m
 *
 *for curFrag = 1:length(tsad)
 *    % TIMESTAMPS IN MILISECONDS OF THE ADVALUES IN THE CURRENT FRAGMENT
 *    % curTS = ceil(tsad(curFrag)*1000):ceil(tsad(curFrag)*1000) + fnad(curFrag)-1;
 *    curTS = ceil(tsad(curFrag)*adfreq):ceil(tsad(curFrag)*adfreq) + fnad(curFrag)-1;
 *
 *    % this only is needed if the first analog sample happens less than 12ms after the start
 *    % of the recording and the eye tracker is used to collect the eye position data.
 *   if curTS(1)<0
 *        ADindex= ceil(tsad(curFrag+1)*adfreq);
 *        continue
 *    end
 *    % REAL TIMESTAMPS SAME SIZE AS THE CURRENT CONTINUOUS CHANNEL
 *    % temp( curTS) = AD01( ADindex:ADindex+fnad(curFrag)-1);
 *    eval( ['temp( curTS) = ',adID{ich+1},'( ADindex:ADindex+fnad(curFrag)-1);'])
 *    % INCREMENT THE CURRENT LOCATION BY THE SIZE OF THE FRAGMENT
 *    ADindex=ADindex+fnad(curFrag);
 *end
 *
 */

/* insert this line of code into PlxAD2_mAD.m in place of previous for loop */

/* eval( ['[temp] = ad_frag2array(tsad,' adID{ich+1} ', fnad, adfreq);']); */

void mexFunction(int nlhs, mxArray *plhs[],
                    int nrhs, const mxArray *prhs[])
{
    double *tsad, *adDATA, *fnad, adfreq;
    double *oArray;
    
    int numTS, oArrayLength, curTS, ADindex;
    int i, ii, first_i;
    
  /* Check for proper number of arguments. */
    if (nrhs != 4) {
        mexErrMsgTxt("Four inputs required.");
    }
    if (nlhs != 1) {
        mexErrMsgTxt("One output argument required");
    }
    
  /* Assign pointers to each input. */
    tsad = mxGetData(prhs[0]);
    adDATA = mxGetData(prhs[1]);
    fnad = mxGetData(prhs[2]);
    adfreq = mxGetScalar(prhs[3]);
    
 /* Calculate important metrics based up input data */
    numTS = mxGetM(prhs[2]);
    oArrayLength = tsad[mxGetM(prhs[0]) - 1] * adfreq
    + fnad[mxGetM(prhs[2]) - 1] + 1;
    
  /* Create output data */
    plhs[0] = mxCreateDoubleMatrix(1,oArrayLength,mxREAL);
    
  /* Assign pointer to output. */
    oArray = mxGetPr(plhs[0]);
    
  /* Do Work - the meat of the function */
    ADindex = 0;
  /* make curTS < so first for loop will start */
    curTS = -1;
  /* skip any chunks that begin with timestamp < 0 */
    for (first_i = 0; curTS < 0; first_i++) {
        curTS = ceil(tsad[first_i]*adfreq);
        if (curTS >= 1)
            break;
        ADindex += fnad[first_i];
    }
    /* move data from adDATA array into the output array
     * start at the first chunk that begins greater than zero */
    for (i = first_i; i < numTS; i++) {
        curTS = ceil(tsad[i]*adfreq);
        for ( ii = 0; ii < fnad[i]; ii++) {
            oArray[curTS - 1 + ii] = adDATA[ADindex++];
        }
    }
}
