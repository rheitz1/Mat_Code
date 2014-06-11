// RVS5a_initialize// From MATLAB, call like this to get 4 taskHandle addresses that will be sent to RVS5a_protocol:// [rf sf lb hb] = RVS5a_initialize#include <NIDAQmxBase.h>#include <stdio.h>#include <mex.h>#define DAQmxErrChk(functionCall) { if( DAQmxFailed(error=(functionCall)) ) { goto Error; } }void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){    // Error parameters.    int32       error = 0;    char        errBuff[2048];        // DAQmxCreateTask parameters.    char        taskNameReceiverFlag[] = "";    char        taskNameSenderFlag[]   = "";    char        taskNameLowByte[]      = "";    char        taskNameHighByte[]     = "";    TaskHandle  taskHandleReceiverFlag = 0; // TaskHandle is an unsigned long *, declared in two parts in NIDAQmxBase.h: TaskHandle and uInt32.    TaskHandle  taskHandleSenderFlag   = 0; // TaskHandle is an unsigned long *, declared in two parts in NIDAQmxBase.h: TaskHandle and uInt32.    TaskHandle  taskHandleLowByte      = 0; // TaskHandle is an unsigned long *, declared in two parts in NIDAQmxBase.h: TaskHandle and uInt32.    TaskHandle  taskHandleHighByte     = 0; // TaskHandle is an unsigned long *, declared in two parts in NIDAQmxBase.h: TaskHandle and uInt32.        // DAQmxCreateDOChan parameters.    char        *channelReceiverFlag  = "Dev1/port2/line0:3";    char        *channelSenderFlag    = "Dev1/port2/line4:7";    char        *channelLowByte       = "Dev1/port0/line0:7";    char        *channelHighByte      = "Dev1/port1/line0:7";    char        nameToAssignToLines[] = "";        // Parameters for returning addresses of task handles.    int         num_of_dims = 1;    int         output_dims[2] = {1, 1};    unsigned long *addressReceiverFlag;    unsigned long *addressSenderFlag;    unsigned long *addressLowByte;    unsigned long *addressHighByte;        // Return the four addresses of task handles as output.    plhs[0] = mxCreateNumericArray(num_of_dims, output_dims, mxINT32_CLASS, mxREAL);    plhs[1] = mxCreateNumericArray(num_of_dims, output_dims, mxINT32_CLASS, mxREAL);    plhs[2] = mxCreateNumericArray(num_of_dims, output_dims, mxINT32_CLASS, mxREAL);    plhs[3] = mxCreateNumericArray(num_of_dims, output_dims, mxINT32_CLASS, mxREAL);    addressReceiverFlag = (unsigned long *) mxGetPr(plhs[0]);    addressSenderFlag   = (unsigned long *) mxGetPr(plhs[1]);    addressLowByte      = (unsigned long *) mxGetPr(plhs[2]);    addressHighByte     = (unsigned long *) mxGetPr(plhs[3]);        // Create tasks.    DAQmxErrChk (DAQmxBaseCreateTask (taskNameReceiverFlag, &taskHandleReceiverFlag));    DAQmxErrChk (DAQmxBaseCreateTask (taskNameSenderFlag,   &taskHandleSenderFlag));    DAQmxErrChk (DAQmxBaseCreateTask (taskNameLowByte,      &taskHandleLowByte));    DAQmxErrChk (DAQmxBaseCreateTask (taskNameHighByte,     &taskHandleHighByte));    mexPrintf("write Receiver Flag address %d\n",taskHandleReceiverFlag);    mexPrintf("read  Sender Flag   address %d\n",taskHandleSenderFlag);    mexPrintf("read  Low Byte      address %d\n",taskHandleLowByte);    mexPrintf("read  High Byte     address %d\n",taskHandleHighByte);    *addressReceiverFlag = (unsigned long) taskHandleReceiverFlag;    *addressSenderFlag   = (unsigned long) taskHandleSenderFlag;    *addressLowByte      = (unsigned long) taskHandleLowByte;    *addressHighByte     = (unsigned long) taskHandleHighByte;        // Create digital output (DO) channel.    DAQmxErrChk (DAQmxBaseCreateDOChan (taskHandleReceiverFlag, channelReceiverFlag, nameToAssignToLines, DAQmx_Val_ChanForAllLines));        // Create digital input (DI) channels.    DAQmxErrChk (DAQmxBaseCreateDIChan (taskHandleSenderFlag,   channelSenderFlag,   nameToAssignToLines, DAQmx_Val_ChanForAllLines));    DAQmxErrChk (DAQmxBaseCreateDIChan (taskHandleLowByte,      channelLowByte,      nameToAssignToLines, DAQmx_Val_ChanForAllLines));    DAQmxErrChk (DAQmxBaseCreateDIChan (taskHandleHighByte,     channelHighByte,     nameToAssignToLines, DAQmx_Val_ChanForAllLines));        // Start tasks    DAQmxErrChk (DAQmxBaseStartTask (taskHandleReceiverFlag));    DAQmxErrChk (DAQmxBaseStartTask (taskHandleSenderFlag));    DAQmxErrChk (DAQmxBaseStartTask (taskHandleLowByte));    DAQmxErrChk (DAQmxBaseStartTask (taskHandleHighByte));    mexPrintf("Testing!\n");        Error:                if (DAQmxFailed (error))            DAQmxBaseGetExtendedErrorInfo (errBuff, 2048);                // Do not stop or clear the task in initialize program.        // Do not do this in protocol program either.        // Just use same 4 handles after initilizing them once after MATLAB start.        // They get cleared when MATLAB is quit.        /*        if (taskHandleReceiverFlag != 0)        {            // mexPrintf("Task stopped and cleared.\n");            DAQmxBaseStopTask (taskHandleReceiverFlag);            DAQmxBaseClearTask (taskHandleReceiverFlag);        }        if (taskHandleSenderFlag != 0)        {            // mexPrintf("Task stopped and cleared.\n");            DAQmxBaseStopTask (taskHandleSenderFlag);            DAQmxBaseClearTask (taskHandleSenderFlag);        }        if (taskHandleLowByte != 0)        {            // mexPrintf("Task stopped and cleared.\n");            DAQmxBaseStopTask (taskHandleLowByte);            DAQmxBaseClearTask (taskHandleLowByte);        }        if (taskHandleHighByte != 0)        {            // mexPrintf("Task stopped and cleared.\n");            DAQmxBaseStopTask (taskHandleHighByte);            DAQmxBaseClearTask (taskHandleHighByte);        }         */        if (error)            mexPrintf("DAQmxBase Error %d: %s\n", error, errBuff);        }