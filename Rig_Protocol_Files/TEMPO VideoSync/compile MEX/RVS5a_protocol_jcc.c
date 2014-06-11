// Note: commented out all RVS3_DEBUG stuff and also time.h and clock declarations.// Note: commented out DAQmxErrChk definition and ERROR section at bottom./* *  RVS.c * *  RVS.� is a CodeWarrior Pro 2 project which compiles to a Matlab .mex file, RVS.mex * *  RVS.mex receives bytes from an NI PCI-DIO-96 board using the Tempo VideoSync communication *  protocol. It returns the number of characters received, n.  If a second return variable is supplied *  then RVS returns in that variable a row vector holding the received characters. * *  Call IntiVideoSync.m before using RVS.mex.  InitVideoSync detects and stores the slot number *  of the PCI-DIO-96 board in the variable GLOBAL_NI_DIO_SLOT_NUMBER, which RVS uses to find the board. *  InitVideoSync.m also sets the data direction registers of the 8255 ICs on the PCI-DIO-96 board. * *  For additional documentation see the RVS.m file. * *  The RVS read loop is derived from Sheldon Hoffman's DXRECV.C . * *  Future Changes: * *  - PC and Mac use different character codes for line termination.  Maybe RVS should replace *    the PC character codes with the Mac ?  The PC character codes are parsed innocuously by *    Mac Matlab, so the only benefit would be aesthetic.   Maybe pass an optional flag to *    tell RVS to strip and replace ? * *  - Rather than splitting an 8255's C port direction into input and output nibbles for the *    handshaking flags, the Mac devotes one 8-bit port to the sender's and one to the *    receiver's flags.   We could economize here and split the C port, as does Tempo. * *  Authors: *   Allen W. Ingling  | Allen.W.Ingling@vanderbilt.edu  |  Vanderbilt Vision Research Center *   Sheldon Hoffman   | Sheldon@ReflectiveComputing.com |  Reflective Computing Inc. * *  History: *  5/20/00   awi wrote it (derived from sh's DXRECV.C) *  5/26/00   awi completed revisions, internal release of version 1.00. * 11/17/04   dws changed S_DR2 from 4 to 3 per latest Tempo client DXRECV.C and DX.HP files. * 12/ 7/04   dws Removed double-slash comments from definition for RVS3_DEBUG_1 and RVS3_DEBUG_2. * 12/ 7/04   dws Commented out mexPrintf("Entering 'GetSenderFlag' function\n"). *  3/10/06   dws Extensive modifications to use NI DAQmxBase commands in Mac OS X and NI USB-6501 device configuration, but same RVS protocol preserved.  Started 3 March 2006. */#include "mex.h"    // include Matlab mex API headers#include "NIDAQmxBase.h" // (dws 3 March 2006) Include National Intruments DAQmxBase headers. #include "stdio.h" // (dws 13 March 2006) Commented out stdio.h.  (dws 3 March 2006) Include stdio.h as well, but not sure why. #include "time.h" // (dws 7 March 2006)// (dws 3 March 2006) Add definition for NI DAQmxBase error checking.// (dws 13 March 2006) Commented out DAQmxErrChk definition.// #define DAQmxErrChk(functionCall) { if( DAQmxFailed(error=(functionCall)) ) { goto ERROR; } }// (dws 7 December 2004) Removed double-slash comments from two definitions below for RVS3_DEBUG_1 and RVS3_DEBUG_2. #define RVS3_DEBUG_1   //debugging switch, prints debugging info during execution.// #define RVS3_DEBUG_2   //debuggin switch, prints some other debugging info during execution.// #define RVS3_DEBUG_3 // (dws 7 March 2006)#define BUFFER_NDIM 2        //number of dimensions of matlab array holding read buffer#define RVS_BUFF_LEN 4096    //the length of the return vector holding the strings read.#define TIMEOUT_PERIOD 1000  //number of C loops to wait for sender to respond to a flag change.//  Note: Making this number too small, like 10, caused RVS to exit// early.  RVS would duplicate characters surrounding exits,// the first character read on return would be a copy of the last// character writing before exit.// (dws 3 March 2006) Do not need defined identifiers for ports.  For NI USB-6501, which is Dev1,//                    port2/line0:3 is receiver flag port (4-bit output),//                    port2/line4:7 is sender flag port (4-bit input),//                    port0/line0:7 is low byte port (8-bit input),//                    port1/line0:7 is high byte port (8-bit input).// Previous definitions for NI PCI-DIO-96.// #define RECEIVER_FLAG_PORT 3// #define SENDER_FLAG_PORT 4// #define LOWBYTE_PORT 0// #define HIGHBYTE_PORT 1/*set constants holding sender's flag values.  Note that these are bit shifted down a nibblefrom Sheldon's values because the Tempo send flag port is the high nibble of port C on thetempo PC and the low nibble of a Port B on the Mac.  */#define S_RESET 0#define S_RTS 1#define S_DR1 2#define S_DR2 3  // (dws 17 November 2004) Changed S_DR2 from 4 to 3, see comments in history above.#define S_NOTHING 15  //ddx dos utility videosync sender seems to drop to this state on exit.//set constants holding receiver's flag values.  Same as Sheldon's values.#define R_RESET 0#define R_ACK 1#define R_CTS 2//define constants for states of the receiver state machine#define RSTATE_ENTER_RESET      0#define RSTATE_WAITFORRTS       1#define RSTATE_WAITFORDR        2#define RSTATE_WAITFOR1BYTE     3#define RSTATE_WAITFOR2BYTES    4// (dws 3 March 2006) Remove BoardSlot parameter, not needed.// static i32 BoardSlot;                          //global value which holds the slot number of the NI card.static int initialized = 0;                   //flag indicating whether read buffer space has been allocatedstatic mxArray *persistent_array_ptr = NULL;   //pointer to matlab array holding read buffer// (dws 3 March 2006) Declare static parameters for use in all DAQmxBase read and write commands below.static int32       error = 0;static int32       numSampsPerChan = 1;static float64     timeoutDAQmxBase = 10;static uInt32      arraySizeInSamps = 1;static bool32      autoStart = 0; // (dws 13 March 2006) Made autoStart zero since task already started in initialize code.// (dws 10 March 2006)static unsigned long *addressReceiverFlag;static unsigned long *addressSenderFlag;static unsigned long *addressLowByte;static unsigned long *addressHighByte;//function sets the receiver flag.void SetReceiverFlag(int theFlag){    // (dws 3 March 2006) Old error parameter not needed.    // i32 error;    // (dws 3 March 2006) Local DAQmxBase parameters for write command.    int32 sampsPerChanWritten;    uInt8 writeArray[1];     //#if defined(RVS3_DEBUG_1)     //mexPrintf("Entering 'SetReceiverFlag' function, %f\n", (double) clock()/CLOCKS_PER_SEC);     //#endif    // (dws 3 March 2006) Swapped old write command for new NI DAQmxBase one.    // error = DIG_Out_Port((u32)BoardSlot, (u32)RECEIVER_FLAG_PORT, (u32)theFlag);    writeArray[0] = (uInt8) theFlag;    // DAQmxErrChk (DAQmxBaseWriteDigitalU8 (taskHandleReceiverFlag, numSampsPerChan, autoStart, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, writeArray, &sampsPerChanWritten, NULL));    // Remove DAQmxErrChk from above for now.    DAQmxBaseWriteDigitalU8 ((TaskHandle) *addressReceiverFlag, numSampsPerChan, autoStart, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, writeArray, &sampsPerChanWritten, NULL);}//function reads and returns the sender flag.unsigned int GetSenderFlag(void){    // (dws 3 March 2006) Old pattern parameter not needed.    // u8 pattern;    // (dws 3 March 2006) Local DAQmxBase parameters for read command.    int32 sampsPerChanRead;    uInt8 readArray[1];    // #if defined(RVS3_DEBUG_1)    // (dws 7 December 2004) Comment out this mexPrintf line so that it does not mask where handshaking is.    // mexPrintf("Entering 'GetSenderFlag' function, %f\n", (double) clock()/CLOCKS_PER_SEC);    // #endif    // (dws 3 March 2006) Swapped old read command for new NI DAQmxBase one.    // DIG_In_Port((u32)BoardSlot, (u32)SENDER_FLAG_PORT, &pattern);    // return(15 & (unsigned int)pattern);     // DAQmxErrChk(DAQmxBaseReadDigitalU8 (taskHandleSenderFlag, numSampsPerChan, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, readArray, arraySizeInSamps, &sampsPerChanRead, NULL));    // Remove DAQmxErrChk from above for now.    DAQmxBaseReadDigitalU8 ((TaskHandle) *addressSenderFlag, numSampsPerChan, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, readArray, arraySizeInSamps, &sampsPerChanRead, NULL);    if (((unsigned int) readArray[0]) > 0) {       // mexPrintf("Got %d\n", (unsigned int) readArray[0]>>4);    }    return((unsigned int) readArray[0]>>4); // (dws 3 March 2006) Bitwise shift of 4 to right because read on Dev1/port2/line4:7.}//function reads and returns the low byte of the portchar GetLowByte(void){    // (dws 3 March 2006) Old pattern parameter not needed.    // u8 pattern;    // (dws 3 March 2006) Local DAQmxBase parameters for read command.    int32 sampsPerChanRead;    uInt8 readArray[1];     #if defined(RVS3_DEBUG_1)     mexPrintf("Entering 'GetLowbyte' function, %f\n", (double) clock()/CLOCKS_PER_SEC);     #endif    // (dws 3 March 2006) Swapped old read command for new NI DAQmxBase one.    // DIG_In_Port((u32)BoardSlot, (u32)LOWBYTE_PORT, &pattern);    // DAQmxErrChk (DAQmxBaseReadDigitalU8 (taskHandleLowByte, numSampsPerChan, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, readArray, arraySizeInSamps, &sampsPerChanRead, NULL));    // Remove DAQmxErrChk from above for now.    DAQmxBaseReadDigitalU8 ((TaskHandle) *addressLowByte, numSampsPerChan, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, readArray, arraySizeInSamps, &sampsPerChanRead, NULL);    // #if defined( RVS3_DEBUG_2)    // mexPrintf("%c\n", (int) readArray[0]); // (dws 3 March 2006) Replaced pattern with readArray[0].    // #endif    return((char) readArray[0]); // (dws 3 March 2006) Replaced pattern with readArray[0].}//function reads and returns the High byte of the port.  Jeff Schall's version of tempo always just// sends one byte at a time, the low byte.char GetHighByte(void){    // (dws 3 March 2006) Old pattern parameter not needed.    // u8 pattern;    // (dws 3 March 2006) Local DAQmxBase parameters for read command.    int32 sampsPerChanRead;    uInt8 readArray[1];     #if defined(RVS3_DEBUG_1)     mexPrintf("Entering 'GetHighByte' function, %f\n", (double) clock()/CLOCKS_PER_SEC);     #endif    // (dws 3 March 2006) Swapped old read command for new NI DAQmxBase one.    // DIG_In_Port((u32)BoardSlot, (u32)HIGHBYTE_PORT, &pattern);    // DAQmxErrChk (DAQmxBaseReadDigitalU8 (taskHandleHighByte, numSampsPerChan, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, readArray, arraySizeInSamps, &sampsPerChanRead, NULL));    // Remove DAQmxErrChk from above for now.    DAQmxBaseReadDigitalU8 ((TaskHandle) *addressHighByte, numSampsPerChan, timeoutDAQmxBase, DAQmx_Val_GroupByChannel, readArray, arraySizeInSamps, &sampsPerChanRead, NULL);    // #if defined( RVS3_DEBUG_2)    // mexPrintf("%c\n", (int) readArray[0]); // (dws 3 March 2006) Replaced pattern with readArray[0].    // #endif    return((char) readArray[0]); // (dws 3 March 2006) Replaced pattern with readArray[0].}/* function deallocates the persistent array which holds the read buffer */void cleanup(void){    mxDestroyArray(persistent_array_ptr);}/* mexFunction is the gateway routine for the MEX-file. */void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){        // int mrows,ncols; // (dws 3 March 2006) Parameters mrows and ncols not needed.    int numRead, state;    double *rsltPntr1;    // double *rsltPntr2; // (dws 3 March 2006) Parameter rsltPntr2 never needed.    // double inpt;  // (dws 3 March 2006) Parameter inpt never needed.    // i32  error; // (dws 3 March 2006) Different error parameter defined below.    // i16  brdType; // (dws 3 March 2006) Parameter brdType never needed.    char *inputString;    char status, prev;    unsigned int timeout;    // const mxArray *globalSlotNum; // (dws 3 March 2006) Commented out, not needed.    int bufferDims[2] = {1, RVS_BUFF_LEN};        // (dws 3 March 2006) Additional parameters necessary for new NI DAQmxBase commands.    int32  error = 0;    char   errBuff[2048];        // (dws 7 March 2006)    // char   *checkReturnCharacter = "\n";    // clock_t ticks1, ticks2, ticks3, ticks4, ticks5, ticks6;        // (dws 7 March 2006)    // #if defined(RVS3_DEBUG_3)    // ticks2 = clock();    // #endif        // #if defined(RVS3_DEBUG_1)    // mexPrintf("Entering RVS mex function, %f\n", (double) clock()/CLOCKS_PER_SEC);    // #endif        // check to be sure that no arguments were passed    // (dws 10 March 2006)    // if (nrhs !=0)    //     mexErrMsgTxt("Unecessary arguements passed to function RVS\n");        // (dws 13 March 2006) Take a chance and remove check of how many input arguements are passed, assume 4 of them.    // if (nrhs !=4)    //     mexErrMsgTxt("Need 4 arguements passed to function RVS5a\n");        // pluck from global Matlab workspace a pointer to the NI card slot number    // (dws 3 March 2006) Commented out all globalSlotNum code, not needed.    // globalSlotNum = mexGetArrayPtr("GLOBAL_NI_DIO_SLOT_NUMBER", "global");    // if (globalSlotNum == NULL)    //  mexErrMsgTxt("VideoSync interface not initialized.  Call InitVideoSync\n");    // mrows = mxGetM(globalSlotNum);    // ncols = mxGetN(globalSlotNum);    // if (!mxIsDouble(globalSlotNum) || mxIsComplex(globalSlotNum) || !(mrows == 1 && ncols == 1))    // {    //  mexErrMsgTxt("VideoSync interface not initialized correctly by InitVideoSync\n");    // }        // (dws 10 March 2006) Assign 4 input parameters to addresses of previously defined taskHandles.    addressReceiverFlag = (unsigned long *) mxGetPr(prhs[0]);    addressSenderFlag   = (unsigned long *) mxGetPr(prhs[1]);    addressLowByte      = (unsigned long *) mxGetPr(prhs[2]);    addressHighByte     = (unsigned long *) mxGetPr(prhs[3]);        // create matrices for the first return value holding the number of characters read.    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);    rsltPntr1 = mxGetPr(plhs[0]);        //allocate space to hold values read    if (!initialized) {        //check to make sure that we are allocating enough memory        persistent_array_ptr = mxCreateNumericArray((int)BUFFER_NDIM, bufferDims, mxUINT8_CLASS,mxREAL);        mexMakeArrayPersistent(persistent_array_ptr);        mexAtExit(cleanup);        initialized = 1;    }        //inputString = mxCalloc(RVS_BUFF_LEN, sizeof(char));    inputString = (char *)mxGetPr(persistent_array_ptr);        // (dws 3 March 2006) Remove BoardSlot parameter, not needed.    //the board slot number is the first argument    // BoardSlot = (i32)mxGetScalar(globalSlotNum);        //initialize and being the read loop    numRead = 0;  //initailize index into array holding string of read characters.    state = RSTATE_ENTER_RESET;        // (dws 7 March 2006)    // #if defined(RVS3_DEBUG_3)    // ticks3 = clock();    // mexPrintf("MEXMAC parameter definitions and setup took %f\n",(double) (ticks3 - ticks2)/CLOCKS_PER_SEC);    // #endif         //#if defined(RVS3_DEBUG_1)     //mexPrintf("Entering state machine switch, %f\n", (double) clock()/CLOCKS_PER_SEC);     //#endif    switch(state){        default:                case    RSTATE_ENTER_RESET: ENTER_RESET:{     //#if defined(RVS3_DEBUG_1)     //mexPrintf("Entering 'RSTATE_ENTER_RESET' state, %f\n", (double) clock()/CLOCKS_PER_SEC);     //#endif    SetReceiverFlag(R_RESET);   // Tell sender we've reset        //dx_kill_a_short_time(ph->short_time);        state = RSTATE_WAITFORRTS;    goto WAITFORRTS;        }                case    RSTATE_WAITFORRTS: WAITFORRTS:{     //#if defined(RVS3_DEBUG_1)     //mexPrintf("Entering 'RSTATE_WAITFORRTS' state, %f\n", (double) clock()/CLOCKS_PER_SEC);     //#endif    for (timeout = TIMEOUT_PERIOD; timeout > 0; timeout--)    {                prev = GetSenderFlag();        while (prev != (status = GetSenderFlag()))            prev = status;          // Wait for unlatched status to stabilize                if (status == S_RTS)            goto GOT_RTS;           // Sender wants to send something                if (status == S_RESET)            // mexPrintf("Exiting because sender in S_RESET state.\n");            // (dws 8 March 2006) Replace "goto RETURN" with "continue" so that it does not exit on S_RESET, just keep looping until timeout or S_RTS meaning more data.            goto RETURN;            // Sender says done, don't waste time                if (status == S_DR1 || status == S_DR2)            continue;               // Sender hasn't finished last transaction                // AT THIS POINT, EITHER THE SENDER SENT US SOMETHING BAD OR        // THE SENDER IS NOT THERE AND THE LINE IS FLOATING.  WE QUIETLY        // ACCEPT WHATEVER WAS SENT AND WAIT FOR RTS.    }        // mexPrintf("Exiting because TIMEOUT in RSTATE_WAITFORRTS state.\n");    goto RETURN;                    // Wait for RTS        GOT_RTS:        SetReceiverFlag(R_CTS);         // Tell sender we're ready to receive        state = RSTATE_WAITFORDR;        goto WAITFORDR;        }                case    RSTATE_WAITFORDR: WAITFORDR:{     //#if defined(RVS3_DEBUG_1)     //mexPrintf("Entering 'RSTATE_WAITFORDR' state, %f\n", (double) clock()/CLOCKS_PER_SEC);     //#endif    for (timeout = TIMEOUT_PERIOD; timeout >= 0; timeout--)    {        prev = GetSenderFlag();        mexPrintf("first flag call, received %02X\n", prev);        mexPrintf("first flag call, received %d\n", prev);        while (prev != (status = GetSenderFlag()))            prev = status;          // Wait for unlatched status to stabilize        //status = S_DR2;        if (status == S_RTS)        // Is sender still in RTS state?            continue;               // Sender hasn't yet sent data        if (status == S_DR1)            goto GOT_DR1;        if (status == S_DR2)            goto GOT_DR2;                               mexPrintf("DX - Expected RTS, DR1 or DR2, received %02X\n", status);                state = RSTATE_ENTER_RESET;        goto ENTER_RESET;           // Unexpected sender status    }    // mexPrintf("Exiting because TIMEOUT in RSTATE_WAITFORDR state.\n");    goto RETURN;                    // Wait for RTS,DR1 or DR2            GOT_DR1:{     #if defined(RVS3_DEBUG_1)     mexPrintf("Reading One Byte, %f\n", (double) clock()/CLOCKS_PER_SEC);     #endif    if(numRead >= (RVS_BUFF_LEN - 2))    {        mexPrintf("Read Buffer Overflow\n");        goto RETURN;    }    inputString[numRead++] = GetLowByte();    goto WAITFOR1BYTE;    }        GOT_DR2:{     #if defined(RVS3_DEBUG_1)     mexPrintf("Reading Two Bytes, %f\n", (double) clock()/CLOCKS_PER_SEC);     #endif    if(numRead >= (RVS_BUFF_LEN - 3))    {        mexPrintf("Read Buffer Overflow\n");        goto RETURN;    }    inputString[numRead++] = GetLowByte();    inputString[numRead++] = GetHighByte();    goto WAITFOR2BYTES;    }        }                case RSTATE_WAITFOR1BYTE: WAITFOR1BYTE:{     #if defined(RVS3_DEBUG_1)     mexPrintf("Entering RSTATE_WAITFOR1BYTE, %f\n", (double) clock()/CLOCKS_PER_SEC);     #endif    SetReceiverFlag(R_ACK);         // Tell sender we got the data!    state = RSTATE_WAITFORRTS;    // (dws 7 March 2006)    // *checkReturnCharacter = inputString[numRead];    // if (strstr(inputString,"\n"))    // (dws 8 March 2006)            /*            if ((int) inputString[numRead - 1] == 10) // The integer equivalent to a RETURN CHARACTER (i.e., "\n") is 10.            {                // mexPrintf("Exiting because RETURN CHARACTER detected in string at end of RSTATE_WAITFOR1BYTE, %c, %d --- %d\n",inputString[numRead - 1],(int) inputString[numRead - 1],(int) checkReturnCharacter);                // mexPrintf("Exiting because RETURN CHARACTER detected in string at end of RSTATE_WAITFOR1BYTE, %d\n",(int) inputString[numRead - 1]);                goto RETURN;            }             */    goto WAITFORRTS;        }                case RSTATE_WAITFOR2BYTES: WAITFOR2BYTES:{     #if defined(RVS3_DEBUG_1)     mexPrintf("Entering RSTATE_WAITFOR2BYTES, %f\n", (double) clock()/CLOCKS_PER_SEC);     #endif    SetReceiverFlag(R_ACK);         // Tell sender we got the data!    state = RSTATE_WAITFORRTS;    // (dws 7 March 2006)    // *checkReturnCharacter = inputString[numRead];    // if (strstr(inputString,"\n"))    // (dws 8 March 2006)            /*            if ((int) inputString[numRead - 1] == 10) // The integer equivalent to a RETURN CHARACTER (i.e., "\n") is 10.            {                // mexPrintf("Exiting because RETURN CHARACTER detected in string at end of RSTATE_WAITFOR2BYTES, %c, %d --- %d\n",inputString[numRead - 1],(int) inputString[numRead - 1],(int) checkReturnCharacter);                // mexPrintf("Exiting because RETURN CHARACTER detected in string at end of RSTATE_WAITFOR2BYTES, %d\n",(int) inputString[numRead - 1]);                goto RETURN;            }             */    goto WAITFORRTS;        }            } //close switch        RETURN:                // (dws 7 March 2006)        // #if defined(RVS3_DEBUG_3)        // ticks4 = clock();        // mexPrintf("State machine took %f\n",(double) (ticks4 - ticks3)/CLOCKS_PER_SEC);        // #endif                 //#if defined(RVS3_DEBUG_1)         //mexPrintf("Entering RETURN, %f\n", (double) clock()/CLOCKS_PER_SEC);         //#endif        *rsltPntr1 = (double)numRead; // Return # of bytes read                //append a \0 to the end of the string        inputString[numRead] = '\0';                //return the string read, if we have a place to put it.        if (nlhs == 2)        {            plhs[1] = mxCreateString(inputString);        }            /*    ERROR:             // (dws 7 March 2006)        // #if defined(RVS3_DEBUG_3)        // ticks5 = clock();        // mexPrintf("MEXMAC output return took %f\n",(double) (ticks5 - ticks4)/CLOCKS_PER_SEC);        // #endif             if (DAQmxFailed (error))            DAQmxBaseGetExtendedErrorInfo (errBuff, 2048);             if (error)            mexPrintf("DAQmxBase Error %d: %s\n", error, errBuff);    */        }