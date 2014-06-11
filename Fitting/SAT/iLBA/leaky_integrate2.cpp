#include "mex.h"

// Matlab MEX function to compute leaky integration
// RPH


void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	//mexPrintf("Hello, world!\n");

int trl, t, nTrials, nTimes, index;
double *linear, *start, *cur_act, *act, leakage, *rate;


	// Find dimensions of input data
	//Get input data
	rate = mxGetPr(prhs[0]);
	nTimes = 1001;
	nTrials = mxGetN(prhs[0]);

	// create mxArray for output data
	plhs[0] = mxCreateDoubleMatrix(nTimes, nTrials, mxREAL);
	//plhs[0] = mxCreateDoubleMatrix(1,nTrials*nTimes,mxREAL);
	act = mxGetPr(plhs[0]);
	
	//Get start points
	start = mxGetPr(prhs[1]);
	
	//Get leakage
	leakage = mxGetScalar(prhs[2]);
	

	for (trl=0;trl<nTrials;trl++)
	{
		act[(trl*nTimes)] = start[trl];

		for (t=1;t<nTimes;t++)
		{
			act[(trl*nTimes)+t] = (rate[trl]*t + start[trl]) + act[(trl*nTimes)+t-1] - act[(trl*nTimes)+t-1]*leakage;
			
		}
	}


	//for (trl=0;trl<nTrials;trl++)
	//{
	//	for (t=0;t<nTimes;t++)
	//	{
	//		act[index] = linear[(trl*nTrials)+t];
	//		index++;
	//	}
	//}


	//index = 0;
	//for (trl=0;trl<rows;trl++)
	//{
	//	cur_act[0] = start[trl];
	//	

	//	for (t=1;t<columns;t++)
	//	{
	//		cur_act[t] = cur_act[t-1] + linear[(trl*columns)+t];
	//	}

	//	// Now set to act variable
	//	for (t=0;t<columns;t++)
	//	{
	//		act[(trl*columns)+t] = cur_act[t];
	//	}
	//}
	
}