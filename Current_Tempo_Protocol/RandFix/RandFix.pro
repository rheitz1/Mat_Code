/*                                          */ 							  
/* TEMPO Protocol File for General Search   */
/* TEMPONET Version							*/
/* Version 1.5                              */

// Min-Suk Kang        																				
// Geoffrey Woodman
// Psychology, Vandy    

/* 
   ** TEMPO DOS IMPROVEMENT REPORT **
   Version 0.3
   - random luminisity scale & hold time
   - update function
   - buffer check with com_get() to avoid racing problem
   
   Version 0.4
   - target position frequency balancing
   - colormap encoding correction
   - target position index printf correction
   - summary dialog addition test version
   
   Version 0.5
   - photodiode signal utilization
   - working on a new color lookup table
   
   Version 0.6
   - color lookup table fixing
   - catch trial inhibition when detection
   - idle mode with blank screen
   - more than on target condition check
   - search array duration mode activation
   
   Version 0.7
   - every reward +1 bug correction
   - separate frequency controlling option 
   - target grouping option
   - cPFail debugging   
   
   Version 0.8
   - behavior result dialog
   - trial information display
   - key mapping 
   - punish time addition
   - eccentricity information in dialogue
   - fixation spot size info in dialogue
   
   Version 0.9
   - Intertrial interval blank screen bug fix
   - catch trial timing bug fixing
   - 2 item trial condition
   
   Version 0.95
   - Set size summary section 
   - Event code register & update process fixing
	
*/

/* 
   ** TEMPO WIN IMPROVEMENT REPORT **
   
   Version 1.1
   - Dialog settup in progress
   - Analog table access configuration change

   Version 1.2
   - Dialog *.dcf file is done

   Version 1.3
   - Eye movement signal correction 
   - Update process to the plexon 
   - Window singal to the plexon implementation
   - Saccade latency & other counter signal correction
   - Temporal delay measurement
   
   Version 1.5
   - Tempo2Plx optimization & variable changes
   - Marker function simplification due to sync signal readout change
   - Implement target position signal to plx right after the onset 
   - Accuracy & response time computation check
   

*/ 

#pragma declare = 1;

/*********************/
/* declare processes */
/*********************/

// DECLARE PROCESS NAMES

/* initialization part */
 declare MAIN();                                              
 declare INIT_VAR();                                          
 declare INIT_EYE();                                          
                                                            
 declare WATCH_EYE();  /* on memory all the time       */     
                                                            
 declare TRIAL_CONF(); /* configuration of the trial   */     
 declare TRIAL();      /* execute the trial with matlab*/     
 declare TRIAL_POST(); /* update all parameters  */  
 declare TRIAL_STOP();   
                                                            
 declare SUCCESS();    /* sub of trial                 */     
 declare ABORT();      /* sub of trial                 */     
 declare IDLE();       /* on memory with high priority */     
                                                               
 declare MARKER(int);  /* photo diode signal reader    */
                                                           
 declare CNT_RESET();  /* key map function             */
 declare CNT_RESET_NEW();  /* clears only SAT variable counts to avoid buffer overflow             */          
 declare RWD_JUICE();  /* key map function             */     
 declare RWD_BELL();   /* sub of trial post            */   
// declare PUN_BELL();

 declare UPDATE();     /* sub of trial post            */     
 declare mSTIM();		/* microStimulation				*/
 declare MEANRT(); 		/* calculates mean RTs for each condition     */
 declare SORTRT();		/* sorts RT arrays so can get percentiles */
 declare RE_CLUT();		/* resets the color lookup table */
                                                           
 declare FIX(int);     /* sub of trial                 */    
 declare SHOW_STIM();  /* sub of trial                 */     
                                                            
 declare CAL_FIX();    /* key map function             */     
 declare CLC_WIN();    /* key map function             */     
 declare DRAW_WIN();   /* parallel to watch eye        */	  

 /* tempo 2 plexon event transfer functions            */
 // developed by Pierre
 declare queueEvent();
 declare xmitEvents();
 declare SendTTLToRemoteSystem (int value);
 declare Delay(int uSeconds);

//Calibration testing//
declare CALIB();
declare CALIB_INCR();
declare CALIB_DECR();
declare CALIB_EXE();
declare CALIB_EXE_LONG();

//macro to control color of background//
declare SET_BLACK();

// CONSECUTIVE ABORT PENALTY
declare ABORTPEN();

/* include files */
#include PARAMSAT.PIN
#include EVENT.PIN
#include object.pro
#include DIO.PRO

/* This is how we switch between Psychphys Toolbox and VideoSYNC for display */
#include ptbcmds\ptbcmd.pro
//#include vdocmds\vdocmd.pro

declare int DEBUG_DISP_FRAME = 0;

/*************/
/* processes */
/*************/
process MAIN enabled
{
	// set the CLUT values
    spawn RE_CLUT;
	
	spawn   INIT_EYE;
	waitforprocess  INIT_EYE;
	spawn   INIT_VAR;
	waitforprocess  INIT_VAR; 

	spawn   WATCH_EYE;
	
	/* initialize cable code */
	system("warning = 3");      /* allow level 3 warning disp   */
	nexttick;	   
	
	spawnwait ERASE_ALL();      // frame 0: erase all           				
	nexttick;

	spawn   IDLE;
}
	
process INIT_VAR
{
	spawn CNT_RESET;

	/* randomization */
	seed1(day());
	seed2(time());
	nexttick;
	
	// reset DB & wait command 
	// but practically obsolete
	system("HZERO *");
	while(system()) nexttick;
}

process CNT_RESET
{
	hide declare    i, j;
	
	printf("Clearing Variables \n");

	totTrls = 0;
	setTrls = 0;
	ccSL = 0;
	cFixBrk = 0;
	cNotFix = 0;
	cASucc = 0;
	cAFail = 0;
	cAbort = 0;
	trlAborts = 0;
	cCatchErr = 0;
	cHoldErr = 0;
	cLatErr = 0;
	cTargHoldErr = 0;
	cSaccDirErr = 0;
	n_slow = 0;
	n_med = 0;
	n_fast = 0;
	n_err_slo = 0;
	n_err_med = 0;
	n_err_fst = 0;
	n_miss_slo = 0;
	n_miss_fst = 0;
	
	nBellOnly = 0;
    nJuice = 0;
    nBigJuice = 0;


	RT_slow = 0;
	RT_med = 0;
	RT_fast = 0;
	ACC_fast = 0;
	ACC_med = 0;
	ACC_slow = 0;
	prc_miss_slo = 0;
	prc_miss_fst = 0;
	prct_s = 0;
	prct_m = 0;
	prct_f = 0;

	//i = 0;
   //	while (i <= n_cor_slo){
	//	corRTs_s[i] = 0;
	//	i = i + 1;
	//}
	//i = 0;
	n_cor_slo = 0;

	//while (i <= n_cor_med){
	//	corRTs_m[i] = 0;
   	//	i = i + 1;
	//}
	//i = 0;
	n_cor_med = 0;

	//while (i <= n_cor_fst){
	//	corRTs_f[i] = 0;
	//	i = i + 1;
	//}
	//i = 0;
 	n_cor_fst = 0;

	while( i < MAXPAIR ){
		j = 0;
		while( j < mMAXPOS+1 ){
			cSL[i,j] = 0;
			cSucc[i,j] = 0;
			cFail[i,j] = 0;
			j = j + 1;
		}
		cTSucc[i] = 0;
		cTFail[i] = 0;
		cTSL[i] = 0;
		
		i = i + 1;
		nexttick;
	}
	
	i = 0;
	while ( i < mMAXPOS+1 ){
		bFM_TgtP[i] = 0;
		cPSucc[i] = 0;        
		cPFail[i] = 0;
		cPSL[i] = 0;

		i = i + 1;
		nexttick;
		
	}

	i = 0;
	while ( i < 3 ){
		cSetSucc[i] = 0;
		cSetFail[i] = 0;
		cSetSL[i] = 0;
		cSetSumSL[i] = 0;
		cSetSumCnt[i] = 0;

		i = i + 1;
		nexttick;
	}

	
}
	
	
process CNT_RESET_NEW
{
	hide declare    i, j;
	
	printf("Clearing SAT Variables \n");

	n_slow = 0;
	n_med = 0;
	n_fast = 0;
	n_err_slo = 0;
	n_err_med = 0;
	n_err_fst = 0;
	n_miss_slo = 0;
	n_miss_fst = 0;
	RT_slow = 0;
	RT_med = 0;
	RT_fast = 0;
	ACC_fast = 0;
	ACC_med = 0;
	ACC_slow = 0;
	prc_miss_slo = 0;
	prc_miss_fst = 0;
	prct_s = 0;
	prct_m = 0;
	prct_f = 0;
	
	//i = 0;
   //	while (i <= n_cor_slo){
	//	corRTs_s[i] = 0;
	//	i = i + 1;
	//}
	//i = 0;
	n_cor_slo = 0;

	//while (i <= n_cor_med){
	//	corRTs_m[i] = 0;
   //		i = i + 1;
	//}
	//i = 0;
	n_cor_med = 0;

	//while (i <= n_cor_fst){
	//	corRTs_f[i] = 0;
	//	i = i + 1;
	//}
	//i = 0;
 	n_cor_fst = 0;

}
	
	
process INIT_EYE
{
	hide declare i;
	
	oSetGraph(gLEFT, aTITLE, "EYE MOVEMENT");
	oSetGraph(gLEFT, aRANGE, -360,360,-360,360); 
	
	oFIX = oCreate(tBOX, gLEFT, eFixW, eFixW);
	oSetAttribute(oFix, aINVISIBLE);
	oTGT = oCreate(tBOX, gLEFT, eStmW, eStmW);
	oSetAttribute(oTGT, aINVISIBLE);
	oFP = oCreate(tBOX, gLEFT, 10, 10);
	oSetAttribute(oFP, aINVISIBLE);
	nexttick;
	
	i = 0;
	while( i < NUM_SAMPLES ){
		oEYE[i] = oCreate(tBox, gLeft,4,4);
		oSetAttribute(oEYE[i], aFILLED);
		oSetAttribute(oEYE[i], aREPLACE);
		i = i + 1;
		nexttick;
	}
}

process WATCH_EYE
{
	hide declare i, j, tmp; 
	declare eyeH, eyeV;
	
	eyeX = 0; eyeY = 0;
	
	while(1){	
	
	if (mouseeye == 0) {	
		eyeH = atable(1) - eFixx;
		eyeV = -atable(2) - eFixy;
		}else{
		eyeH = mouGetX() - eFixx;
		eyeV = mouGetY() - eFixx;
		}

		eyeX = eyeH * XGAIN/100 + eyeV * XYF/100;
		eyeY = eyeV * YGAIN/100 + eyeH * YXF/100;

		oMove(oEYE[i], eyeX, eyeY);
		i = i + 1;
		if( i >= NUM_SAMPLES ) i = 0;
		
		// eInFix, eInTgt check
		   //eyeX and eyeY are read using the 'atable' command which reads input from an AD channel
		   //eFP is the fixation point coordinates (set to 0 in PARAM.pin???)
	   //	if ((abs(eyeX-eFP_x) < eHalfFix) &&
		//	(abs(eyeY-eFP_y) < eHalfFix))
		//	eInFix = 1;
		//else
		//	eInFix = 0;
			
		if ((eyeX > eWL) && (eyeX < eWR) &&
			(eyeY > eWU) && (eyeY < eWD)){
			eInTgt = 1;
			eInFix = 1;
		}else{
			eInTgt = 0;
			eInFix = 0;
		}		
		nexttick;

		//2008.2.29 RPH
		//code eye position location, regardless of target/distractor
 			
		if ((eyeX > eWL0) && (eyeX < eWR0) &&
			(eyeY > eWU0) && (eyeY < eWD0))
			saccLoc = 7000;
		if ((eyeX > eWL1) && (eyeX < eWR1) &&
			(eyeY > eWU1) && (eyeY < eWD1))
			saccLoc = 7001;
		if ((eyeX > eWL2) && (eyeX < eWR2) &&
			(eyeY > eWU2) && (eyeY < eWD2))
			saccLoc = 7002;
		if ((eyeX > eWL3) && (eyeX < eWR3) &&
			(eyeY > eWU3) && (eyeY < eWD3))
			saccLoc = 7003;
		if ((eyeX > eWL4) && (eyeX < eWR4) &&
			(eyeY > eWU4) && (eyeY < eWD4))
			saccLoc = 7004;
		if ((eyeX > eWL5) && (eyeX < eWR5) &&
			(eyeY > eWU5) && (eyeY < eWD5))
			saccLoc = 7005;
		if ((eyeX > eWL6) && (eyeX < eWR6) &&
			(eyeY > eWU6) && (eyeY < eWD6))
			saccLoc = 7006;
		if ((eyeX > eWL7) && (eyeX < eWR7) &&
			(eyeY > eWU7) && (eyeY < eWD7))
			saccLoc = 7007;

		nexttick; 		

	}
}

process CAL_FIX
{
// This gets the 1st and 2st values from the analog channel
	eFixx = atable(1);
	eFixy = -atable(2);
}

process CLC_WIN
{
	oSetAttribute(oTGT, aINVISIBLE);
	oSetGraph(gLEFT, aCLEAR);
}


process DRAW_WIN
{
  //	printf("pos: %d\n",point_num);
	 //if (point_num == 0) lTgtP = -1;
	//eFixW is a menu value in pixels (is fixation window size)
	eHalfFix = eFixW/2;
	
  	if (point_num == 0){

  		oSetAttribute(oTGT, aSIZE, eStmW, eStmW);
  		oSetAttribute(oTGT, aVISIBLE);
  		oMove(oTGT, eFP_x, eFP_y);
		
		oSetAttribute(oFIX, aSIZE, eFixW, eFixW);
		oSetAttribute(oFIX, aVISIBLE);
		oMove(oFIX, eFP_x, eFP_y);
	}else{

	//draw fixation, stimulus windows in eye trace window
	oSetAttribute(oFIX, aSIZE, eFixW, eFixW);
	oSetAttribute(oFIX, aVISIBLE);
	oMove(oFIX, ePosX[posUserSet], ePosY[posUserSet]);

	oSetAttribute(oTGT, aSIZE, eStmW, eStmW);
	oSetAttribute(oTGT, aVISIBLE);
	oMove(oTGT, ePosX[posUserSet],ePosY[posUserSet]);
	}	
		nexttick;

		
		eWL = ePosX[posUserSet]-eStmW/2;
		eWR = ePosX[posUserSet]+eStmW/2;
		eWU = ePosY[posUserSet]-eStmW/2;
		eWD = ePosY[posUserSet]+eStmW/2;

		//2008.2.29 RPH
		// attempt to code positions of each stimulus location
		// so we can mark which stim location eyes went to
		// easy to determine error location, then.
	   //		eWL0 = ePosX[0] - eStmW/2;
		//	eWR0 = ePosX[0] + eStmW/2;
	   //		eWU0 = ePosY[0] - eStmW/2;
		//	eWD0 = ePosY[0] + eStmW/2;

		//	eWL1 = ePosX[1] - eStmW/2;
	   //		eWR1 = ePosX[1] + eStmW/2;
	   //		eWU1 = ePosY[1] - eStmW/2;
	   //		eWD1 = ePosY[1] + eStmW/2;

		//	eWL2 = ePosX[2] - eStmW/2;
		//	eWR2 = ePosX[2] + eStmW/2;
		//	eWU2 = ePosY[2] - eStmW/2;
		//	eWD2 = ePosY[2] + eStmW/2;

		//	eWL3 = ePosX[3] - eStmW/2;
		//	eWR3 = ePosX[3] + eStmW/2;
	   //		eWU3 = ePosY[3] - eStmW/2;
	   //		eWD3 = ePosY[3] + eStmW/2;

		//	eWL4 = ePosX[4] - eStmW/2;
		//	eWR4 = ePosX[4] + eStmW/2;
		//	eWU4 = ePosY[4] - eStmW/2;
		//	eWD4 = ePosY[4] + eStmW/2;

		//	eWL5 = ePosX[5] - eStmW/2;
		 //	eWR5 = ePosX[5] + eStmW/2;
		//	eWU5 = ePosY[5] - eStmW/2;
		//	eWD5 = ePosY[5] + eStmW/2;

		//	eWL6 = ePosX[6] - eStmW/2;
		//	eWR6 = ePosX[6] + eStmW/2;
		//	eWU6 = ePosY[6] - eStmW/2;
		//	eWD6 = ePosY[6] + eStmW/2;

		//	eWL7 = ePosX[7] - eStmW/2;
		//	eWR7 = ePosX[7] + eStmW/2;
		//	eWU7 = ePosY[7] - eStmW/2;
		//	eWD7 = ePosY[7] + eStmW/2;
	   //	}
	nexttick;
}//end DRAW_WIN

// process MARKER(hide declare event)  
// this will get TTL input from photodiode 
// to synchronize the monitor and computer
// 2005.5.21
// photo diode signal will be read from plexon
// duration will be monitored in the plexon offline
// Marker function will not be used any more in TEMPO part
// Marker behaves more like an complex of TEMPO2PLX function
 
process MARKER(declare event)
{
	//hide declare markerOn;
	//hide declare i;

	eventCode = event;
	spawn queueEvent();
	
	//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING
	//print("1666 sent");
	
	//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING
	
	
	
	
	// commented out
	/*
	markerOn = 0;
	while( !markerOn ){
		i = 0;
		while( i < 100 ){
			if (mio_dig_get(0)== 0){
				
				if (!markerOn){
					t_2 = time();
					printf("TTL SIGNAL @ %d\n",i);
					markerOn = 1;
					
					eventCode = event;			   
    				spawn queueEvent();	

				}
			}
			i = i + 1; nexttick;
		}
		nexttick;
	}
	*/
}


/* reward, bell process using high TTL frequency output channel */
process RWD_BELL
{
	declare i;

	eventCode=2726;			   
    spawn queueEvent();	

  	i = 600;
	sound(i);
	mio_fout(10000000/i);
	wait 250;
	sound(0);
	mio_fout(0);

}

//process PUN_BELL
//{
  //	declare i;

  //	i = 2000;
  //	sound(i);
  //	mio_fout(1000000000/i);
  //	wait 2000;
  //	sound(0);
  //	mio_fout(0);
//}

/* process TRIG(hide declare start) */
/* in TEMPO2Plexon, no longer in use
process TRIG(declare start)
{
	if ( lTgtP > -1 ){
		if ( start ) trigger lTgtP + 2;
		else harvest lTgtP + 2;
	}
	event_set(1,0,EV_TRIGGER); nexttick;
}
*/

/* process FIX(hide declare on) */
process FIX(declare on)
{
	if ( on ){
		
		spawnwait DISP_FRAME_1();
		if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_1\n");
	  	event_set(1,0,EV_FIXON); nexttick;
 	  	spawn MARKER(EV_FIXON); nexttick;

	}else{
		spawnwait DISP_FRAME_5();
		if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_5\n");
		event_set(1,0,EV_FIXOFF); nexttick;
	}
}

process TRIAL_CONF
{
	/* frequency coding scheme change from version 0.7     */
	/* instead of having exact 100 count, this code uses   */
	/* while loop as a flooring function                   */
	/* unfilled freq[i] will be set with the lastfreq      */
	/* detailed procedure will be in the document          */

	/* variable declaration */
	declare i, j, k, tmp1, tmp2;   /* index variables      */
	declare freq[100];             /* frequency string     */
	declare iifreq[MAXPAIR];       /* temp frequency coding*/
	declare tfreqSum;              /* temp freq sum        */
	declare ctgt, cdst;            /* current tgt, dist    */
	declare cmax, cmin;            /* max, min counter     */
	declare imax, imin;            /* max, min index       */
	declare lastfreq;              /* last frequency       */
	
	
	
	  point_num = random(10);

	 if (point_num == 1) posUserSet = 2;
	 if (point_num == 2) posUserSet = 6;
	 if (point_num == 3) posUserSet = 4;
	 if (point_num == 4) posUserSet = 0;
	 if (point_num == 5) posUserSet = 3;
	 if (point_num == 6) posUserSet = 1;
	 if (point_num == 7) posUserSet = 5;
	 if (point_num == 8) posUserSet = 7;

	
	
	
	
	iFreqSum = 100;

		
	// SAT Condition manipulation
	if (SAT_condSet == 0){
		//SAT_cond = random(3)+1;  RPH: Turning off so RANDOM only selects SLOW or FAST
		if (random(99)+1 < 50){
			SAT_cond = 1;
		}else{
			SAT_cond = 3;
		}
	}else{
		SAT_cond = SAT_condSet;
	}

	// seed function print to check the proper 
	// seeding of random number
	//printf("seed1 = %d\n",seed1());
	//printf("seed2 = %d\n",seed2());
	/* randomization */


	/* selected grouped targets 							 */
	/* current version 0.7 only supports two group condition */
	/* on group on condition, frequency of the assigned group*/
	/* of 1 and 0 will alternate as many as group repetition */
	/* experimenter assign freqeuncy other than 0            */
	/* if frequency coding can't find any number, default    */
	/* target pair goes to 5    							 */
	
	if ( lGrpOn ){
		if ( lGrpPrv < 0 ){
			lGrpCur = random(2);	// assign new group either 0 or 1 at the beginning of the group on	
			lGrpPrv = lGrpCur;	   
			lGrpCnt = lGrpRep;
		} 
		
		if ( lGrpPrv == 0 && lGrpCnt == 0 ){
			//if previous group is 0 and group counter (lGrpCnt) is down to 0, then switch to group 1
			//and reset group counter to block amount (lGrpRep)
			lGrpCur = 1;
			lGrpPrv = lGrpCur;
			if (lRndRep == 0){
			//if lRndRep set to 0, just use lGrpRep repeitions.
			lGrpCnt = lGrpRep;
			}
			if (lRndRep == 1){
			//if lRndRep set to 1, take a random sample [lGrpMin lGrpRep];
			lGrpCnt = random(lGrpRep-lGrpMin)+lGrpMin;
			}
					//Debug random lGrpRep
					print("New block length: %d\n",lGrpCnt);
					//debug random lGrpRep
		} 
		
		if ( lGrpPrv == 1 && lGrpCnt == 0 ){
			//if previous group is 1 and group counter (lGrpCnt) is down to 0, then switch to group 0
			//and reset group counter to block amount (lGrpRep)
				lGrpCur = 0;
				lGrpPrv = lGrpCur;
			if (lRndRep == 0){
			//if lRndRep set to 0, just use lGrpRep repeitions.
			lGrpCnt = lGrpRep;
			}
			if (lRndRep == 1){
			//if lRndRep set to 1, take a random sample [lGrpMin lGrpRep];
			lGrpCnt = random(lGrpRep-lGrpMin)+lGrpMin;
			}
					//Debug random lGrpRep
					print("New block length: %d\n",lGrpCnt);
					//debug random lGrpRep
		}
		
		//lGrpCnt is current number of trials run in a block counting down from
		//lGrpRep (defined in grouping menu to 0).  When lGrpRep==0, switch to new
		//block.  If trial is aborted, then will add 1 back to lGrpCnt.
		lGrpCnt = lGrpCnt - 1;

	}else {
		lGrpCnt = -1;	// set every trial variable to negative
		lGrpPrv = -1;
		lGrpCur = -1;
	}
	nexttick;

	if ( lGrpOn ){
		i = 0;
		tfreqSum = 0;
		while( i < MAXPAIR ){
			if ( iGrpTgt[i] == lGrpCur ){
				tfreqSum = tfreqSum + iFreq[i];
			}
			i = i + 1;
		} nexttick;
	} else {
		i = 0;
		tfreqSum = 0;
		while( i < MAXPAIR ) {
			tfreqSum = tfreqSum + iFreq[i];
			i = i + 1;
		} nexttick;
	   
	}

	/* frequency normalization */
	if ( tfreqSum != 0 ){
		if ( lGrpOn ){
			i = 0;
			while ( i < MAXPAIR ){
				if ( iGrpTgt[i] == lGrpCur ){
					iifreq[i] = iFreq[i]*iFreqSum;	// lPair assignment
					iifreq[i] = iifreq[i]/tfreqSum;
				} else {
					iifreq[i] = 0;
				}
				i = i + 1;
			} nexttick;
		} else {
			i = 0;
			while ( i < MAXPAIR ){
				iifreq[i] = iFreq[i]*iFreqSum;
				iifreq[i] = iifreq[i]/tfreqSum;
				i = i + 1;
			} nexttick;
		}
	} else {   
		iifreq[0] = 0;
		iifreq[1] = 0;
		iifreq[2] = 0;
		iifreq[3] = 0;
		iifreq[4] = 0;
		iifreq[5] = 100;
	}

	/* frequency information coding              */
	/* j < iifreq[k] acts as a flooring function */
	i = 0; k = 0;
	while( k < MAXPAIR ){
		j = 0;																	
		while( j < iifreq[k] ){
			freq[i] = k;
			i = i + 1; 
			j = j + 1;
			lastfreq = k;
		}
		k = k + 1;
		nexttick;
	}
	
	while ( i < iFreqSum ){
		freq[i] = lastfreq;
		i = i + 1;
	} nexttick;
		

	/* frequency coding setting end */  


	/* if error correct on && fail at previous trial    */
	if ( rErrCPair == 1 && rPrvPair == 0 ){
		lPair = lPair;                  /* the same pair    */
	}else{
		lPair = freq[random(iFreqSum)]; /* random returns integer  */
	}
	
	/* if error correct on && fail at previous position */
	if ( rErrCPos == 1 && rPrvPos == 0 && tIsCatch == 0 ){
		lTgtP = lTgtP;                  /* the same position    */
	}else{
		// manually set target location if desired
		if (posUserSet != -1){
			lTgtP = posUserSet;

	   //		if (random(99)+1 < 50){
	   //			if (posUserSet <= 3){
	   //				lTgtP = posUserSet + 4;
	   //			}else{
	   //				lTgtP = posUserSet - 4;
	   //			}
	   //		}else{
	   //		lTgtP = posUserSet;
	   //		}

		}else{
			lTgtP = random(mMAXPOS);
		}

	}
		
	/* set size configuration */
	/* set size 2 is in   
	if ( lSetSFlg == 0 ) lSetS = 4;
	if ( lSetSFlg == 1 ) lSetS = 8;
	if ( lSetSFlg == 2 ) lSetS = 4*random(2); // this returns 0 or 4 
	*/
	
	if ( lSetSFlg == 0 ) lSetS = 0; // set size 2
	if ( lSetSFlg == 1 ) lSetS = 1; // set size 4
	if ( lSetSFlg == 2 ) lSetS = 2; // set size 8
	if ( lSetSFlg == 3 ) lSetS = random(3); // set size random
	
	/* target/distractor configuration           */
	/* lObjt[mMAXPOS]                            */
	/* catch trial configuration                 */
	
	/* when tgt/dst set itself declared at catch */
	i = 0; tmp1 = 0;
	/* only catch trial target setting condition */
	while( i < MAXTGT ){
		tmp1 = tmp1 + iTgt[lPair,i];
		i = i + 1;
	}/* if tmp1 == 0, catch trial    */
	
	/* target/distractors mixed condition        */
	if ( (iCFreq[lPair] > random(100)) && lTask == 2){
		tmp2 = 0;
	}else{
		tmp2 = 1;
	}
		
	/* catch trial configuration    */
	if ( tmp1 == 0 || tmp2 == 0 ){
		tIsCatch = 1;    /* yes, it's catch */
		lTgtP = -1;      /* null target pos */
	}else{
		tIsCatch = 0;    /* no, it's not    */
	}
	
	/*nogo trial configuration*/
	if ( iNGFreq[lPair] > random(100)){
			tIsNoGo = 1; /*yes, it's nogo*/
		}else{
			tIsNoGo = 0; /* no, it's not nogo*/
		}
	
	
	
	/***** added 2004.07.06 ******/
	/* target position balancing */
	
	/* if max position - min position counter reaches 5 */
	cmax = 0; cmin = 1000;
	i = 0;
	while( i < mMAXPOS ){
		
		if ( bFM_TgtP[i] >= cmax ){
			cmax = bFM_TgtP[i];
			imax = i;
		}
		nexttick;

		if ( bFM_TgtP[i] <= cmin ){
			cmin = bFM_TgtP[i];
			imin = i;
		}
		i = i + 1;
		nexttick;
	}
	
	if ( !tIsCatch ){
		bFM_TgtP[lTgtP] = bFM_TgtP[lTgtP] + 1;
			if ( ( cmax - cmin ) > 3 ){
				bFM_TgtP[lTgtP] = bFM_TgtP[lTgtP] - 1;
				bFM_TgtP[imin] = bFM_TgtP[imin] + 1;
				
				// manually set target position if desired
				if (posUserSet != -1){
					lTgtP = posUserSet;
				}else{
					lTgtP = imin;
				}
				       // target position changed
			}
	}
	nexttick;

	/* distractor assignment    */
	cdst = iDist[lPair,random(MAXDIST)];
	//if TASK is set to 2 or 3, then put distractor stimuli at all locations
	if ( lTask == 2){
		i = 0;
			while( i < mMAXPOS ){
				if ( iDFlag[lPair] == 1 ){   /* hetero   */
					lObjt[i] = iDist[lPair,random(MAXDIST)];
				}else{ 
					lObjt[i] = cdst;
				}
				i = i + 1;
				nexttick;
			}
	//if TASK is set to another other than 2, then put blanks at all locations
	} else {
		i = 0;
		while( i < mMAXPOS ){
				
			lObjt[i] = 0;
			i = i + 1;
			nexttick;
		}
	}
	
	/* target replacement in the target position so long as it is not a catch trial*/
	if ( tIsCatch == 0){
		ctgt = iTgt[lPair,random(MAXTGT)];
		lObjt[lTgtP] = ctgt;
	}
	
	/* target & distractors are placed in every 8 position initially */
	/* after then, by the set size option, irrevent items are        */
	/* discarded                                                     */
	
	/* set size configuration 2 */
	if ( lSetS == 0 ){
		if ( !tIsCatch ){
			i = 0;
			while( i < 7 ){
				if ( i != 3 ){
					k = ( lTgtP + i + 1 )%mMAXPOS;
					lObjt[k] = 0;
				}
				i = i + 1;
			}
		} else {
			i = 0;
			tmp1 = random(7);
			while  ( i < 7 ){
				if ( i != 3 ){
					k = ( tmp1 + i + 1)%mMAXPOS;
					lObjt[k] = 0;
				}
				i = i + 1;
			}
		}
	}
	
	/* set size configuration 4  */
	if ( lSetS == 1 ){
		if ( !tIsCatch ){
			i = 0;
			while( i < 4 ){
				k = ( lTgtP + 2*i + 1 )%mMAXPOS;
				lObjt[k] = 0;
				i = i + 1;
			}
		} else {
			i = 0;
			tmp1 = random(7);
			while ( i < 4 ){
				k = (tmp1 + 2*i + 1)%mMAXPOS;
				lObjt[k] = 0;
				i = i + 1;
			}
		}
	}



	
   	spawn   DRAW_STIM;
   	spawn   DRAW_WIN;
}//end TRIAL_CONF

process IDLE
{
	spawnwait ERASE_ALL();
	waitforprocess  TRIAL;
	waitforprocess  TRIAL_POST;
	waitforprocess  SUCCESS;
	waitforprocess  ABORT;
	
	// only display this when stop button pressed
	if ( !tGoOn ) printf("IDLE MODE\n");
	spawnwait DISP_FRAME_5();
	if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_5\n");
	
	while( !tGoOn ) nexttick;
	spawn TRIAL;
}

process TRIAL
{
   //initialize timing variables
	ccSL = 0;			// saccade latency initialization
	JUICE_TIME = 0;  	// reward latency initialization
	BELL_TIME = 0;		// bell latency initialization

	
	//only executed if tGoON==1 (controlled by f3)
	while( tGoOn ){
	
	   	tIsAbort = 1;   

		//execute TRIAL_CONF
		spawn   TRIAL_CONF;
		waitforprocess  TRIAL_CONF;
		nexttick;

		// Punish Time Handling
		if (wasResp == 1) {
			wait(tITI + tPunishTime); nexttick;
			eventCode=6019;			   
 			spawn queueEvent();
			nexttick;
			eventCode = tPunish;
			spawn queueEvent();
			nexttick;
		}

		
		//Conditional NoRespPun handling based on SAT condition
		if (SAT_cond == 1){
			NoRespPun = NoRespPun_slow;
		}
		
		if (SAT_cond == 3){
			NoRespPun = NoRespPun_fast;
		}
		
		if (wasResp == 0) {
			eventCode=6020;			   
			spawn queueEvent();
			nexttick;
			wait(tITI + NoRespPun);
		}

   
		wasResp = 1; /*assume some response has been made.  If target present and No response
					this will be later set to 0, and the NoRespPun variable will be enacted */

   	// fix on
		// in PARAMSAT.pin, tFix2Stm == 1000
		
		tFt = tFix2Stm+random((2*tFix2Stm*tJitFixx/100)-(tFix2Stm*tJitFixx/100));
	  	tHt = tMaxHold+random((2*tMaxHold*tJitHold/100)-(tMaxHold*tJitHold/100));
	    nexttick;

		spawn FIX(1);					// FIX(1) filled fixation
 		
		
		//oMove(oFP,eFP_x,eFP_y);			// draw in the target window
		//oSetAttribute(oFP,aVISIBLE);	// make it visible

		
	   

		//Two while loops (I think) because trial has already been spawned.  By doing it this way,
		//The same trial will be shown so long as the eye never falls within the fixation window.
		while( !eInFix && tGoOn ){


		//if current time is less than start time + acquire time, nexttick (wait until condition is 
		//true and eye is in fixation window). tFixAcqT == 1000 in paramSAT.pin
		   	tDead = time() + tFixAcqT; 
		   	while( time() < tDead && !eInFix ) nexttick;

		//if the condition never becomes true in given trial, re-do (fix off, then on). Trial
		//parameters unchanged
			if ( !eInFix ){
				trlAborts = trlAborts + 1;

				if (trlAborts >= NtrlAbts){
				spawn ABORTPEN;
				}
				
				//printf("TrialAborts: %d \n",trlAborts);

				spawn   FIX(0);					// blank screen
				oSetAttribute(oFP,aINVISIBLE);
				cNotFix = cNotFix + 1;
				no_fix_counter=no_fix_counter + 1;
				printf("NO FIX\n");

				spawn ERASE_ALL;
				spawnwait TRIAL_CONF; //in this fixation task, we don't want to repeat trials.
				
				wait(tITI);
			   	nexttick;
				
  	   	   		spawn   FIX(1);
		      	oSetAttribute(oFP,aVISIBLE);
			   
			   				   						   
			} nexttick;
			
			if ( eInFix )
			{
				no_fix_counter=0;
			}
			
			
			
		} 
		
		// fix is achieved
 		//If eye was in fixation area, but left fixation area before target appeared, ABORT
		//Note: tFt controls the amount of time needed to fixate at center before array
		//appears.  This prevents anticipating when trial starts.
		tDead = time() + tFt;
		trlStimP = random(99)+1; // probability draw for uStim
	 	
		didStim = 0; // did we stimulate yet? necessary to stop stim in while-loop below
		
		while( time() < tDead ){
  			 // STIMULATE FOR ALL TASKS WITH uStim DELAY < 0 (i.e. before target onset)
			 // ONLY Stimulate around saccade target if StimAfterJuice==0.
			 /* last argument counts backwards from time 0, where 
			 time 0 is the point at which fixation parameters have 
			 been met (e.g., have held for 1000 ms). */
  			 if (  (didStim == 0) && (trlStimP <= mStimProb) && (mStimDelay <= 0) && (time() >= mStimDelay + tDead) && StimAfterJuice==0 ){ 
  				spawn mSTIM;
				didStim = 1;
			 }
			
			// if was in fixation window but then left, ABORT
			if ( !eInFix ){
				errorcode = 1;						  
				printf("ABORT\n");
				trlAborts = trlAborts + 1;

				if (trlAborts >= NtrlAbts){
				spawn ABORTPEN;
				}


			   //	printf("TrialAborts: %d \n",trlAborts);
				lGrpCnt=lGrpCnt + 1;//if trial is aborted, do not count this trial in block.
				wasResp = 0;
				cAbort = cAbort + 1;
				spawn   ABORT;
				 }
			nexttick;
		}
  		
		if ( lTask ){	 
		//if lTask==0, will skip next part and run only fixation.  
		//If 1, 2, will show some type of search array, detection, MG, or search.
		//Eye has now 1) acquired fixation are before fixAcquireTime ended, and has
		//remained in fixation area for designated amount of time (maxTgtW)
				spawn SHOW_STIM; nexttick;
				
				trlAborts = 0; //since fix was achieved, reset our count of conecutive ABORTS

				StartTime = time();
				
				//if is catch trial OR GONOGO activated, error if fixation is not maintained
				if ( tIsCatch || tIsNoGo ){
					// catch trial
					// tWaitCat comes from MAX.CATCH
					tDead = time() + tWaitCat;
					while( time() < tDead ){

			   		// STIMULATE: FOR CATCH TRIALS WITH DELAY >= 0 (i.e. after target onset)
					// Only if StimAfterJuice==0
			 		if (  (didStim == 0) && (trlStimP <= mStimProb) && (mStimDelay >= 0) && (time() >= mStimDelay + StartTime) && StimAfterJuice==0){
   					spawn mSTIM;
				 	didStim = 1;
				 	}

					//for catch trials if eInFix==0 (eye not in fixation) and
					//tIsRun==0 (
						if ( !eInFix && !tIsRun ){
							errorcode = 2;
							printf("Catch Error\n");
							cCatchErr = cCatchErr + 1;
							spawn   ABORT; 
							}
						nexttick;
					}
				}else{

					// non-catch condition
					// This is for hold time, as in memory guided search.  if eye is not
					// in fixation area (while target visible) for designated amount of time
					// (tHt == target hold time), then Abort
					
					totTrls = totTrls + 1; // Display is on so count trial
					setTrls = setTrls + 1;
				
					tDead = time() + tHt;
	  				
	  				while( time() < tDead ){ //condition will fail if tHt == 0 and won't run
					 
		   				// STIMULATION: FOR MEMORY GUIDED TASK WITH DELAY >= 0 (i.e. after target onset)
				  		StartTime = time();
				  		if (  (didStim == 0) && (trlStimP <= mStimProb) && (mStimDelay >= 0) && (time() >= mStimDelay + StartTime) && StimAfterJuice==0){
				   			spawn mSTIM;
			 	   			didStim = 1;
			 	   		}
												 				
						if ( !eInFix ){
				   			errorcode = 3;
							printf("Hold Error\n");
							cHoldErr = cHoldErr + 1;
							spawn   ABORT; 
						}
							nexttick;
					}
					
					//By now, fixation point is off for both SEARCH and MG.  Monkey must
					//now make a saccade within allotted time (tMaxSacL)
					
					tDead = time() + tMaxSacL;
					
					// set invisible response window deadline. 
					if (SAT_cond == 1 || SAT_cond == 4) respWin = SAT_slow;
					if (SAT_cond == 2) respWin = SAT_med;
					if (SAT_cond == 3) respWin = SAT_fast;
					
					
					while( time() < tDead && eInFix ) {
				 		// STIMULATION: FOR NON-CATCH TRIAL SEARCH & DETECTION W/ DELAY >= 0 (i.e. after target onset)
						if (  (didStim == 0) && (trlStimP <= mStimProb) && (mStimDelay >= 0) && (time() >= mStimDelay + StartTime) && StimAfterJuice==0){
   				   			spawn mSTIM;
				   			didStim = 1;
				 		}
					nexttick;
					 }


					//if eye is still in fixation area after the tMaxSacL is up (max
					//saccade latency, then spawn an ABORT
					
					if ( eInFix ) {
						errorcode = 4;
						printf("Latency Error\n");
						cLatErr = cLatErr + 1;
						
						// if target present and NO response made, PUNISH
						wasResp = 0;
						spawn ABORT;
					}
				   		 
				   	// send codes right away to align on Response in NeuroExplorer
					if (lTgtP == 0 & errorcode == 0){
						eventCode=8000;		
 						spawn queueEvent();
						nexttick;
 					}
  					if (lTgtP == 1 & errorcode == 0){
						eventCode=8001;			   
 						spawn queueEvent();
						nexttick;
 					}
					if (lTgtP == 2 & errorcode == 0){
						eventCode=8002;			   
 						spawn queueEvent();
						nexttick;
 					}
					if (lTgtP == 3 & errorcode == 0) {
 						eventCode=8003;			   
 						spawn queueEvent();	
						nexttick;
					}
					if (lTgtP == 4 & errorcode == 0) {
						eventCode=8004;			   
				 		spawn queueEvent();	
						nexttick;
					}
					if (lTgtP == 5 & errorcode == 0) {
						eventCode=8005;			   
				 		spawn queueEvent();	
						nexttick;
					}
				    if (lTgtP == 6 & errorcode == 0) {
						eventCode=8006;			   
				 		spawn queueEvent();	
						nexttick;
					}
					if (lTgtP == 7 & errorcode == 0) {
						eventCode=8007;			   
				 		spawn queueEvent();	
						nexttick;
					}
 							//debug neuroexp
						  //	printf("lTgtP: %d \n",lTgtP);
						   //	printf("errorcode: %d \n",errorcode);
						   //	printf("eventCode: %d '\n",eventCode);
							//debug neuroexp
							
							
					// Calculate current saccade latency. Time set in SHOW_STIM just before array appears
					ccSL = ( time() - ccSL );
					printf("Saccade Latency: %d \n",ccSL);

					
					/* eye shouldn't stay too long in between */
					tDead = time() + tMaxInBt;
					while( time() < tDead && !eInTgt ) nexttick;
	
					/* if reappear flag is on */
					if ( iAgain[lPair] == 1 && tIsNoGo == 0 && eInTgt ==1 ){
						spawnwait DISP_FRAME_8(); 
						if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_8\n");
						nexttick;
						wait(tAgain);
						nexttick;
					}


					if ( !eInTgt ){ 
					//	saccade direction error
						eventCode = saccLoc;
						spawn queueEvent();	
						nexttick;

						errorcode = 6;
						printf("Saccade Direction Error\n");
						cSaccDirErr = cSaccDirErr + 1;
						
						// trick Tempo into thinking there was no response if a direction error
						// was made but the deadline was not missed.
						if (SAT_cond == 3 && ccSL > respWin){
							wasResp = 0;
						}
						//spawn PUN_BELL;
						spawn ABORT;
					}


					//Make sure that eye stays in target window for designated amount of time;
					//set by tWaitTgt == Max.TGT.W
					//
					tDead = time() + tWaitTgt;
					while( time() < tDead ){
						if ( !eInTgt ){ 
							//Target Hold error (saccade to correct location, but eye did not stay
							//there long enough
						  	errorcode = 5;
						   	printf("Target Hold Error\n");
							cTargHoldErr = cTargHoldErr + 1;
							
						// trick Tempo into thinking there was no response if a target hold error
						// was made but the deadline was not missed.
						if (SAT_cond == 3 && ccSL > respWin){
							wasResp = 0;
						}
						
						   	spawn  ABORT;
						}
  						nexttick;
					}
					
				}
			}//if(lTask)
			
			// Employ deadlines if NOT memory guided.
			// To check for MG, see if frequency of target 0 is > 0.  If it is, it is NOT MG, and
			// we SHOULD employ deadlines.
			if (iFreq[0] == 0){
			//If Missed invisible deadline but correct in FAST condition
				if (SAT_cond == 3 && ccSL > respWin){
					errorcode = 8;
					printf("Missed Deadline\n");
					wasResp = 0; //employ punishment for missing deadline
					spawn ABORT;
				}
			
				if (SAT_cond == 1 && ccSL  < respWin){
					errorcode = 7;
					printf("Too Fast\n");
					spawn ABORT;
				}else{
					spawn   SUCCESS;
					waitforprocess  SUCCESS;
					nexttick;
				}
			}else{
				spawn SUCCESS;
				waitforprocess SUCCESS;
				nexttick;
			}
	
				
		}
		spawn   IDLE;
		
}//end process TRIAL
		  
process SHOW_STIM
{
	declare tArray, tMask, i, tmp_tgtP; 
	
	//tArray sets the amount of time to show the stimuli.
	//tArray is set by SEARCH.DUR in the dialog box
  	tArray = iTArray[lPair];
	tMask = iMask[lPair];

	
		//Send codes to align to target in NeuroExplorer				
		if(lTgtP == 0){
		eventCode=9000;			   
 		spawn queueEvent();
		nexttick;
 		}
  		if(lTgtP == 1){
		eventCode=9001;			   
 		spawn queueEvent();
		nexttick;
 		}
		if (lTgtP == 2){
		eventCode=9002;			   
 		spawn queueEvent();
		nexttick;
 		}
 		if (lTgtP == 3) {
 		eventCode=9003;			   
 		spawn queueEvent();	
		nexttick;
		}
		if (lTgtP == 4) {
		eventCode=9004;			   
 		spawn queueEvent();	
		nexttick;
		}
		if (lTgtP == 5) {
		eventCode=9005;			   
 		spawn queueEvent();	
		nexttick;
		}
	    if (lTgtP == 6) {
		eventCode=9006;			   
 		spawn queueEvent();	
		nexttick;
		}
		if (lTgtP == 7) {
		eventCode=9007;			   
 		spawn queueEvent();	
		nexttick;
		}
		
			//debug neuroexp
			//printf("lTgtP: %d \n",lTgtP);
			//printf("errorcode: %d \n",errorcode);
			//printf("eventCode: %d '\n",eventCode);
			//debug neuroexp
			
			

	if (lTgtP == -1){
		tmp_tgtP = 8;
	} else {
		tmp_tgtP = lTgtP;
	}

	if ( tHt == 0 ){
		//if hold time (tHt==0)
			spawnwait DISP_FRAME_4(); 
			if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_4\n");
			nexttick;
			//dsend("screen('copyWindow',srcWindow(4),CUR_WINDOW);");nexttick;
			//dsend("f4; screen(CUR_WINDOW,'WaitBlanking',10);f5;");

			/* wait until frame on */
			spawn MARKER(EV_BOT); nexttick;
			waitforprocess MARKER; nexttick;
 
			// target position encoding
			eventCode=4000 + tmp_tgtP;	// target position 9: catch	   
   			spawn queueEvent();	

			// Mark time just before search array appears.  Use during TRIAL process to calculate SRT
			ccSL = time();
			JUICE_TIME = time();
			BELL_TIME = time();
			 
			// no more trigger after tempo2plexon
			//if ( lTrig == 2 ) spawn TRIG(1);
			//spawn RP_MARKER; 
			//nexttick;

			if ( tArray ){
				if (SAT_cond == 3 && ClearAtDead == 1){
					if (random(99) + 1 < prc_Clear){
						wait(SAT_fast); nexttick;
						eventCode=6022;	//send marker indicating display was cleared		   
						spawn queueEvent();	
						nexttick;
						}else{
						wait(tArray); nexttick;
						}
				}else{
					wait(tArray); nexttick;
				}
				//event_set(1,0,EV_TARG_OFF); nexttick;
			}   
			
			if ( tMask ){
				spawnwait DISP_FRAME_6();
				if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_6\n");
				//spawn MARKER(EV_TARG_OFF); nexttick;
				//wait(tMask);
				nexttick;
			}else{
			   	spawnwait DISP_FRAME_5();
				if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_5\n");
				nexttick;

			}
		//if hold time (tHt) is greater than 0
		} else {
			spawnwait DISP_FRAME_9(); //display fix outline + fix fill + array + photodiode
			if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_9\n");
			nexttick;
			//dsend("f9; screen(CUR_WINDOW,'WaitBlanking',4); f1;");

			spawn MARKER(EV_BOT); nexttick;
			waitforprocess MARKER; nexttick;
			
			// target position encoding
			eventCode=4000 + tmp_tgtP;	// target position 9:catch	   
   			spawn queueEvent();	

			//mark time before array appears
			ccSL = time();                  
			JUICE_TIME = time();
			BELL_TIME = time();
			  
			// no more in use after tempo2plexon
			//if ( lTrig == 2 ) spawn TRIG(1);
			//spawn RP_MARKER; 
			nexttick;
			
			//if the length of time that array is displayed is greater than the hold time
			if ( tArray - tHt > 0 ){
				wait(tHt); nexttick;

				spawnwait DISP_FRAME_4(); //display search array with changed fixation
				if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_4\n");
				nexttick;
				wait( tArray - tHt ); nexttick;
				
			
				if ( tMask ){
					spawnwait DISP_FRAME_6();
					if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_6\n");
					wait(tMask);
					nexttick;
				}else{
				spawnwait DISP_FRAME_2(); 
				if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_2\n");
				nexttick;	// empty fixation

				}
			// if the length of time that the array is displayed is less than the hold time
			} else {
				//wait while the array is displayed
				wait(tArray); nexttick;         

				spawnwait DISP_FRAME_1(); 
				if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_1\n");
				nexttick;	 // filled fixation
				wait(tHt - tArray); nexttick;
				spawnwait DISP_FRAME_2(); 
				if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_2\n");
				nexttick;	// empty fixation
				
			   if ( tMask ){
					spawnwait DISP_FRAME_3();
					if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_3\n");
					wait(tMask);
					nexttick;
				}else{
					spawnwait DISP_FRAME_2(); 
					if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_2\n");
					nexttick;	// empty fixation

				}

			}
	  }
}
	
process SUCCESS
{
	declare i, j; 
	declare tmp1, tmp2;	
	ccSF = 1;
	printf("Success\n");

	/* if reappear flag is on */
	if ( iAgain[lPair] == 1 && tIsNoGo ==0 && eInTgt ==1){
		spawnwait DISP_FRAME_8(); 
		if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_8\n");
		nexttick;
		wait(tAgain);
		nexttick;
	}
    
	/*bell */
	if ( rBell )   spawn   RWD_BELL;
	if ( rBell )   BELL_TIME = (time() - BELL_TIME);
	
	/*StimAfterJuice*/
	
	
	//delay between bell and juice
	wait(JuiceDelay);

	/*juice*/
	if ( rEveryRwd != 0 ){
		rWaitRwd = rWaitRwd - 1;
		if ( rWaitRwd <= 0 ){  
			// juice spawned, event code will be sent in that process

			if (random(99) + 1 < rRwdProb){
			spawn   RWD_JUICE; rJuiceGo = 1;JUICE_TIME = (time() - JUICE_TIME);
			rWaitRwd = rEveryRwd;
			}
		}else{
			 eventCode=2723;	// success but no juice			   
   			 spawn queueEvent();	
			nBellOnly = nBellOnly + 1;
			rJuiceGo = 0;

		}
	}
	

	/* counter  */
	if ( lTgtP == -1 || tIsCatch == 1 ){ /* catch trial */
		cSucc[lPair,8] = cSucc[lPair,8] + 1;
	} else {
		cSucc[lPair,lTgtP] = cSucc[lPair,lTgtP] + 1;

		/* discard this algorithm 
		   tempo doesn't have floating point variable
		   so this algorithm monotonically decrease the mean
		*/

		cSL[lPair,lTgtP] = ccSL + cSL[lPair,lTgtP];
		rPrvPos = 1;
		rPrvPair = 1;
	
	} nexttick;
	cASucc = cASucc + 1;
	
	// Keep track of # of successes for each SAT condition but do not include catch trials
	if (SAT_cond == 1 && !tIsCatch){
		n_cor_slo = n_cor_slo + 1;
		n_slow = n_slow + 1;
		ACC_slow = n_cor_slo / n_slow;
		prc_miss_slo = n_miss_slo / n_cor_slo;
		//corRTs_m[n_cor_med-1] = ccSL; //store current correct saccade latency. -1 because 0 based arrays
    	currRT = ccSL;
		//SPAWN SORTRT;
		SPAWN MEANRT;
	} 

	if (SAT_cond == 2 && !tIsCatch){
		n_cor_med = n_cor_med + 1;
		n_med = n_med + 1;
		ACC_med = n_cor_med / n_med;
		//corRTs_s[n_cor_slo-1] = ccSL;
		currRT = ccSL;
		//SPAWN SORTRT;
		SPAWN MEANRT;
	}

	if (SAT_cond == 3 && !tIsCatch){
		n_cor_fst = n_cor_fst + 1;
		n_fast = n_fast + 1;
		ACC_fast = n_cor_fst / n_fast;
		prc_miss_fst = n_miss_fst / n_cor_fst;
		//corRTs_f[n_cor_fst-1] = ccSL;
		currRT = ccSL;
		//SPAWN SORTRT;
		SPAWN MEANRT;
	}

	// set size summation
	if ( lTask == 2 ) {
		cSetSucc[lSetS] = cSetSucc[lSetS] + 1;
		if ( tIsCatch == 0 ){
			cSetSumCnt[lSetS] = cSetSumCnt[lSetS] + 1;
			cSetSumSL[lSetS] = cSetSumSL[lSetS] + ccSL;
			cSetSL[lSetS] = cSetSumSL[lSetS]/cSetSumCnt[lSetS];
		}
	}

	// position summation
	i = 0;
	while ( i < mMAXPOS + 1 ){
		tmp1 = 0; tmp2 = 0; j = 0;
		while ( j < MAXPAIR ) {
			tmp1 = tmp1 + cSucc[j,i];
			j = j + 1;
			nexttick;
		}
		
		cPSucc[i] = tmp1;
		i = i + 1;
		nexttick;
	}
	
	i = 0;
	while ( i < mMAXPOS ){
		tmp1 = 0; tmp2 = 0; j = 0;
		while ( j < MAXPAIR ) {
			tmp1 = tmp1 + cSucc[j,i];
			tmp2 = tmp2 + cSL[j,i];
			j = j + 1;
			nexttick;
		}
		
		cPSL[i] = tmp2/tmp1;
		i = i + 1;
		nexttick;
	}
	
	// target pair summation
	i = 0;
	while ( i < MAXPAIR ){
		tmp1 = 0; tmp2 = 0; j = 0;
		while ( j < mMAXPOS + 1 ) {
			tmp1 = tmp1 + cSucc[i,j];
			j = j + 1;
			nexttick;
		}
		
		cTSucc[i] = tmp1;
		i = i + 1;
		nexttick;
	}
	
	i = 0;
	while ( i < MAXPAIR ){
		tmp1 = 0; tmp2 = 0; j = 0;
		while ( j < mMAXPOS ) {
			tmp1 = tmp1 + cSucc[i,j];
			tmp2 = tmp2 + cSL[i,j];
			j = j + 1;
			nexttick;
		}
		
		cTSL[i] = tmp2/tmp1;
		i = i + 1;
		nexttick;
	}
	
	/* text display */
	printf("Success: %d    Err: %d          Total: %d\n",cASucc,cAFail,cASucc+cAFail);
	printf("Abort: %d      CatchErr: %d     HoldErr: %d\n",cAbort,cCatchErr,cHoldErr);
	printf("LatErr: %d     TargHoldErr: %d  DirectErr: %d\n",cLatErr,cTargHoldErr,cSaccDirErr);
	printf("nJuice: %d     nBellOnly: %d    nBigJuice: %d\n",nJuice,nBellOnly,nBigJuice);
	printf("-----------------------\n");
   	nexttick;
	
	/* *********************************************************** */
	/*BAP: TEMPORARY CODE TO PREVENT BUFFER OVERLOAD*/
	/*If total number of trials exceeds 100, then reset the trial count*/
	//if (cASucc+cAFail > 100)
	//	{
	//	spawn CNT_RESET_NEW;
	//	printf("*********************************\n");
	//	printf(">100 trials, automatically resetting SAT variables\n");
	//	printf("*********************************\n");
	//	}
	/* ********************************************************** */
	
	// punish time setting
	tPunishTime = 0;
	
	spawn   TRIAL_POST;
	waitforprocess  TRIAL_POST;

	spawn IDLE;
	nexttick;
}


process ABORT
{   
	   declare i, j, tmp;

	   // ERROR in the current trial  
		
		// Code error type

		// 0 = correct [not used]
		// 1 = Abort (fixation acquired, but not maintained)
		// 2 = Catch error (eye fell outside fixation on a catch trial)
		// 3 = Hold error (when hold time used [MG], if eyes fall out of fixation before hold time up)
		// 4 = Latency error (eyes remain in fixation for too long [i.e., saccade not made in time])
		//					note on latencies - default value is to quit the trial after  2000 ms)
		// 5 = Target Hold error (eyes moved to correct location, but did not stay in target window long enough
		//					default value = 500 ms [max.TGT.W]
		// 6 = Saccade Direction error (eyes out of fixation window but not found in target window for any amount of time)
		// 7 = Correct saccade but too fast in SLOW condition
		// 8 = Correct saccade but too slow in FAST condition
		if (errorcode == 1) eventCode = 2621;
		if (errorcode == 2) eventCode = 2622;
		if (errorcode == 3) eventCode = 2623;
		if (errorcode == 4) eventCode = 2624;
		if (errorcode == 5) eventCode = 2625;
		if (errorcode == 6) eventCode = 2626;
		if (errorcode == 7) eventCode = 2627;
		if (errorcode == 8) eventCode = 2628;


		// for SAT task, if eye still in fixation region when cutoff time is up, present
		// immediate blanking of screen
		//if (errorcode == 4){
	   //	if (errorcode == 6){
			/* present blank */
   	   	//dsend("f5;"); nexttick;
	   	//}
		if (errorcode == 7) {
			n_slow = n_slow + 1;
			n_cor_slo = n_cor_slo + 1;  //technically correct, so add to made + missed distribution
			n_miss_slo = n_miss_slo + 1;
			prc_miss_slo = (n_miss_slo / n_cor_slo);
			ACC_slow = (n_cor_slo / n_slow);
			currRT = ccSL; // technically correct, so add RT to made + missed distribution
			spawn MEANRT;
		}
		
		if (errorcode == 8) {
			n_fast = n_fast + 1;
			n_cor_fst = n_cor_fst + 1; //technically correct, so add to made + missed distribution
			n_miss_fst = n_miss_fst + 1;
			prc_miss_fst = (n_miss_fst / n_cor_fst);
			ACC_fast = (n_cor_fst / n_fast);
			currRT = ccSL;  // technically correct, so add RT to made + missed distribution
			spawn MEANRT;
		}
		
		// keep track of number of total VALID trials run in each SAT condition
		// we consider only Target Hold Errors and Saccade Direction Errors.  We do not take
		// into account catch trials errors because we do not take into account catch trial
		// successes either.
		if (errorcode == 5 || errorcode == 6) { //note: this disregards catch trials
		   if (SAT_cond == 1){
		   		n_slow = n_slow + 1;
				n_err_slo = n_err_slo + 1;
				ACC_slow = (n_cor_slo / n_slow);
				prc_miss_slo = n_miss_slo / n_cor_slo;
			}

		   if (SAT_cond == 2){
		   		n_med = n_med + 1;
				n_err_med = n_err_med + 1;
				ACC_med = (n_cor_med / n_med);
			}

		   if (SAT_cond == 3){
		   		n_fast = n_fast + 1;
				n_err_fst = n_err_fst + 1;
				ACC_fast = (n_cor_fst / n_fast);
				prc_miss_fst = n_miss_fst / n_cor_fst;
			}
		 }
		 

		
		//eventCode	= 2620;			   	  // ABORT 

		spawn queueEvent();	
	
	   ccSF = 0;
	   suspend TRIAL;
	   if ( !tIsRun ) suspend SHOW_STIM;
	   
	   if ( tIsAbort ){
			
			event_set(1,0,EV_ABORT); nexttick;
			
			cAFail = cAFail + 1;
			if ( lTgtP == -1 ){
				cFail[lPair,8] = cFail[lPair,8] + 1;
				nexttick;    
			} else {
				cFail[lPair,lTgtP] = cFail[lPair,lTgtP] + 1;
			}
			rPrvPos = 0;
			rPrvPair = 0;
		 //	printf("FAILED\n"); nexttick;

	   }else{
			event_set(1,0,EV_ABORT+1); nexttick;
			cFixBrk = cFixBrk + 1;
		  //	printf("ABORTED\n"); nexttick;
	   }
	   nexttick; 
	
	// set size summation
	if ( lTask == 2 ){
		cSetFail[lSetS] = cSetFail[lSetS] + 1;
	}

	// target position summation
	i = 0;
	while ( i < mMAXPOS + 1 ){
		tmp = 0; j = 0;
		while ( j < MAXPAIR ) {
			tmp = tmp + cFail[j,i];
			j = j + 1;
			nexttick;
		}
		cPFail[i] = tmp;
		i = i + 1;
		nexttick;
	}
	
	// target pair summation
	i = 0;
	while ( i < MAXPAIR ){
		tmp = 0; j = 0;
		while ( j < mMAXPOS + 1 ) {
			tmp = tmp + cFail[i,j];
			j = j + 1;
			nexttick;
		}
		cTFail[i] = tmp;
		i = i + 1;
		nexttick;
	}
		
	/* text display */
	printf("Success: %d    Err: %d          Total: %d\n",cASucc,cAFail,cASucc+cAFail);
	printf("Abort: %d      CatchErr: %d     HoldErr: %d\n",cAbort,cCatchErr,cHoldErr);
	printf("LatErr: %d     TargHoldErr: %d  DirectErr: %d\n",cLatErr,cTargHoldErr,cSaccDirErr);
	printf("-----------------------\n");
	nexttick;           
		
	// punish time setting for response errors
	if (errorcode > 1) { //do not punish if just an abort (errorcode = 1)
		if (SAT_cond == 1){
			tPunishTime = tPunish_slow;
		}
		
		if (SAT_cond == 2){
			tPunishTime = tPunish;
		}
		
		if (SAT_cond == 3){
			tPunishTime = tPunish_fast;
		}
		
		if (SAT_cond == 4){
			tPunishTime = tPunish;
		}
	}else{
		//tPunishTime = -1*(tITI-tITIabort);//if it is just an abort, then subtract difference between tITI and tITIabort for shorter ITI
		//NOTE: RPH found the above line to cause problems with fixation point markers.  Changed to the below
		tPunishTime = tITIabort;
		wasResp = 1;
	}
   	
   	//reset error code back to 0
	errorcode = 0;

	spawn   TRIAL_POST;
	waitforprocess  TRIAL_POST;
	spawn IDLE;

	nexttick;
}

process TRIAL_POST
{
	
	
	// END of the Trial (EOT) code  
 	eventCode=1667;			   
 	spawn queueEvent();

	//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING
	//print("1667 sent");
	//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING//DEBUGGING

	// Wait 500 ms before blanking screen after error so that there is no EEG offset response
	// NOTE: this will only occur if an eye movement has ocurred before the SAT cutoff time. Otherwise,
	// the display shuts off immediately when time is up
	wait(500);

	/* present blank */
   	spawnwait DISP_FRAME_5(); 
	if (DEBUG_DISP_FRAME==1) printf("DISP_FRAME_5\n");
	nexttick;
   
	event_set(1,0,EV_SCREENOFF); nexttick;
	oSetAttribute(oFP,aINVISIBLE);

	spawn   CLC_WIN; nexttick;

	spawn   UPDATE;

	waitforprocess  UPDATE;
	wait(tExtrRec);
	event_set(1,0,EV_EOT); nexttick;
	
 	spawn IDLE;		

}

process TRIAL_STOP
{   
	   declare i, j, tmp;

	   suspend TRIAL;
	   if ( !tIsRun ) suspend SHOW_STIM; 
	   
	   	// END of the Trial (SOT) code for the parsing purpose 
	 	eventCode=1668;			   
 		spawn queueEvent();
	   	
	   // event_set(1,0,EV_SCREENOFF); nexttick;
	   spawn   CLC_WIN; nexttick;
	   spawn IDLE;

       nexttick;
}


// queueEvent send in 15 bit interger
process UPDATE
{
		declare i;
		declare tmp;	



	/* send codes to keep track of actual stimuli presented by screen location */
	
		i = 0;
		while( i < mMaxPos ){
			eventCode=6000 + i; /* position x */
 			spawn queueEvent();
			nexttick;
		
			eventCode= lObjt[i]; /* stimulus code for position x */
			spawn queueEvent();
			nexttick;

			i = i + 1;
		}




	
   	    // 1: initial angle 0~360, but 180 symmetry with 2 tgt
	 	eventCode=3000;			   
 		spawn queueEvent();	
 		eventCode=mAngl;			   
 		spawn queueEvent();
		nexttick;	

        // 2:  eccentricity max is around 12, 		           
        eventCode = 3001;			   
 		spawn queueEvent();	
 		eventCode=mEccy;			   
 		spawn queueEvent();
		nexttick;

	    // 3: place holder flag        						   
		eventCode=3002;			   
 		spawn queueEvent();	
 		eventCode=mHolder;			   
 		spawn queueEvent();
		nexttick;

	    // 4: 0: fix, 1: det, 2: search    						
		eventCode=3003;			   
 		spawn queueEvent();	
 		eventCode=lTask;			   
 		spawn queueEvent();
		nexttick;

	    // 5: set size 0:2, 1:4, 2:8, 3:random     				
		eventCode=3004;			   
 		spawn queueEvent();	
 		eventCode=lSetSFlg;			   
 		spawn queueEvent();
		nexttick;

	    // 6: set size                     						
		eventCode=3005;			   
 		spawn queueEvent();	
 		eventCode=lSetS;			   
 		spawn queueEvent();
		nexttick;

	    // 7: raster plot trigger -> obsolete
	    // 7: microdrive1 depth         						
		eventCode=3006;			   
 		spawn queueEvent();	
 		eventCode=depthM1;			   
 		spawn queueEvent();
		nexttick;


	i = 0;									  
	while (i < mMAXPOS ){		// all target/distractor set    
		nexttick;  				// 8~15
		eventCode=3007;			   
 		spawn queueEvent();
		eventCode=lObjt[i];			   
 		spawn queueEvent();
		i = i + 1;
	}

	    // 16: color of the item : 255 clut correspond to int	
		eventCode=3008;			   
 		spawn queueEvent();	
 		eventCode=iColor;			   
 		spawn queueEvent();
		nexttick;

	    // 17: max lum in color look up table 			
		eventCode=3009;			   
 		spawn queueEvent();	
 		eventCode=iColMax;			   
 		spawn queueEvent();
		nexttick;

	    // 18: min lum in color look up table 			
		eventCode=3010;			   
 		spawn queueEvent();	
 		eventCode=iColMin;			   
 		spawn queueEvent();
		nexttick;

 	    // 19: number of bin between max and min 		
		eventCode=3011;			   
 		spawn queueEvent();	
 		eventCode=iColBin;			   
 		spawn queueEvent();
		nexttick;

	    // 20: selected pair, 6 pairs, int is enough to code	
		eventCode=3012;			   
 		spawn queueEvent();	
 		eventCode=lPair;			   
 		spawn queueEvent();
		nexttick;

		// 21: target position -1: catch converted to 255 @ plx	
		eventCode=3013;			   
 		spawn queueEvent();
		if (lTgtP < 0){
 			eventCode=255;	// catch trial
 		} else {
 			eventCode=lTgtP;
 		}			   
 		spawn queueEvent();
		nexttick;

	 	// 22: grouping of the target on = 1, off = 0		
		eventCode=3014;			   
 		spawn queueEvent();	
 		eventCode=lGrpOn;			   
 		spawn queueEvent();
		nexttick;

		// 23: num of group repitition, which over 255 unlikely	
  //		eventCode=3015;			   
  //		spawn queueEvent();	
   //		eventCode=lGrpRep;			   
   //		spawn queueEvent();
  //		nexttick;

	    // 24: current group selected      			
		eventCode=3016;			   
 		spawn queueEvent();	
 		if (lGrpCur < 0){
 			eventCode=255;
 		} else {
 			eventCode=lGrpCur;
 		}				   
 		spawn queueEvent();
		nexttick;

	    // 25: group repetition counter
		eventCode=3017;			   
 		spawn queueEvent();	
 		eventCode=lGrpCnt;			   
 		spawn queueEvent();
		nexttick;

		// 26: inter trial interval     
		eventCode=3018;			   
 		spawn queueEvent();	
 		eventCode=tITI;			   
 		spawn queueEvent();

		// 27: fixation acqusition time
		eventCode=3019;			   
 		spawn queueEvent();	
 		eventCode=tFixAcqT;			   
 		spawn queueEvent();
		nexttick;

		// 28: from fixation to target on
		eventCode=3020;			   
 		spawn queueEvent();	
 		eventCode=tFix2Stm;			   
 		spawn queueEvent();
		nexttick;

		// 29: maxium hold time          
		eventCode=3021;			   
 		spawn queueEvent();	
 		eventCode=tMaxHold;			   
 		spawn queueEvent();
		nexttick;

		// 30: allowed max saccade latency
  //		eventCode=3022;			   			
  //		spawn queueEvent();	
  //		eventCode=tMaxSacL;			   
   //		spawn queueEvent();
   //		nexttick;

		// 31: min waiting time in tgt window
		eventCode=3023;			   
 		spawn queueEvent();	
 		eventCode=tWaitTgt;			   
 		spawn queueEvent();
		nexttick;

		// 32: min time in catch window   
		eventCode=3024;			   
 		spawn queueEvent();	
 		eventCode=tWaitCat;			   
 		spawn queueEvent();
		nexttick;

   		// 33: extra recording time	-> obsolete
		// 33: microdrive2 depth
  //		eventCode=3025;			   
  //		spawn queueEvent();	
  //		eventCode=depthM2;			   
  //		spawn queueEvent();
  //		nexttick;

   		// 34: fixation time with jitter  
		eventCode=3026;			   
 		spawn queueEvent();	
 		eventCode=tFt;			   
 		spawn queueEvent();
		nexttick;

		// 35: hold time with jitter       
		eventCode=3027;			   
 		spawn queueEvent();	
 		eventCode=tHt;			   
 		spawn queueEvent();
		nexttick;

		// 36: catch trial flag 
		eventCode=3028;			   
 		spawn queueEvent();	
 		eventCode=tIsCatch;			   
 		spawn queueEvent();
		nexttick;
	
		// 37: 1:On, 0:Off                  
		eventCode=3029;			   
 		spawn queueEvent();	
 		eventCode=rBell;			   
 		spawn queueEvent();
		nexttick;

		// 38: amount of juice
		eventCode=3030;			   
 		spawn queueEvent();	
 		eventCode=rJuice_save;			   
 		spawn queueEvent();
		nexttick;

   		// 39:  fixation window size
		eventCode=3031;			   
 		spawn queueEvent();	
 		eventCode=eFixW;			   
 		spawn queueEvent();
		nexttick;
		
		// 40: distractor option
		eventCode=3032;			   
 		spawn queueEvent();	
 		eventCode=iDFlag[lPair];			   
 		spawn queueEvent();
		nexttick;

   		// 41: stimulus window size         
		eventCode=3033;			   
 		spawn queueEvent();	
 		eventCode=eStmW;			   
 		spawn queueEvent();
		nexttick;

		// 42: current success/fail         
		eventCode=3034;			   
 		spawn queueEvent();	
 		eventCode=ccSF;			   
 		spawn queueEvent();
		nexttick;

	if ( ccSF == 1 ) 
		{
		//43 current saccade latency
		eventCode=3035;			   
 		spawn queueEvent();	
 		eventCode=ccSL;			   
 		spawn queueEvent();
		}
	else 
	{
		eventCode=3035;			   
 		spawn queueEvent();	
 		eventCode=0;			   
 		spawn queueEvent();

	}	                 
	nexttick;                               
	
		/* 44: x direction gain       */
		/* assume: smaller than 1000  */
		eventCode=3036;			   
 		spawn queueEvent();
 		if (XGAIN < 0){	
 			eventCode=30000 + abs(XGAIN);
 		} else {
 			eventCode=20000 + abs(XGAIN);
 		} 			   
 		spawn queueEvent();
		nexttick;

  		/* 45: y direction gain       */
		/* assume: smaller than 1000  */
		eventCode=3037;			   
 		spawn queueEvent();	
 		if (YGAIN < 0){	
 			eventCode=30000 + abs(YGAIN);
 		} else {
 			eventCode=20000 + abs(YGAIN);
 		} 			   
 		spawn queueEvent();
		nexttick;
  		
		/*assume: smaller than 1000   */
  		/* 46: direction ratio        */
		eventCode=3038;			   
 		spawn queueEvent();	
 		 if (XYF < 0){	
 			eventCode=30000 + abs(XYF);
 		} else {
 			eventCode=20000 + abs(XYF);
 		} 			   
 	    spawn queueEvent();
		nexttick;
		
		/* assume: smaller than 1000  */
	 	/* 47: direction ratio        */
	 	eventCode=3039;			   
 		spawn queueEvent();	
 		if (YXF < 0){	
 			eventCode=30000 + abs(YXF);
 		} else {
 			eventCode=20000 + abs(YXF);
 		} 		   
 		spawn queueEvent();
	 	nexttick;

		/* 48: the same convention with old TEMPO */
		eventCode=3040;			   		  
 		spawn queueEvent();	
 		eventCode=eCIRsize;			   
 		spawn queueEvent();
		nexttick;

	 	/* 49 & 50: initialized eye position of x      */ 
	 	/* we need to code the sign separately	 	 	*/
   //	 	eventCode=3041;		   
   //		spawn queueEvent();
 	//	if (eFixx < 0){	
   //			eventCode = 1;
   //		} else {
 	//		eventCode = 0;
 	//	}			   
 	//	spawn queueEvent();
	//    nexttick;
 
		eventCode=3041;		   
 		spawn queueEvent();	
 		eventCode= abs(eFixx);			   
 		spawn queueEvent();
	    nexttick;
	         
		/* 51 & 52: initialized eye position of y      */
		/* we need to code the sign separately	  */ 	
		eventCode=3042;			   
 		spawn queueEvent();	
 		 if (eFixy < 0){	
 			eventCode = 1;	// (-1)^1
 		} else {
 			eventCode = 0;  // (-1)^0
 		}				   
 		spawn queueEvent();
		nexttick;

		eventCode=3041;		   
 		spawn queueEvent();	
 		eventCode= abs(eFixy);			   
 		spawn queueEvent();
	    nexttick;

		/* 53: every reward option     */
		eventCode=3043;			   
 		spawn queueEvent();	
 		eventCode=rEveryRwd;			   
 		spawn queueEvent();
		nexttick;

		/* 54: current reward counter      */
		eventCode=3044;			   
 		spawn queueEvent();	
 		eventCode=rWaitRwd;			   
 		spawn queueEvent();
		nexttick;

		/* 55: whether juice was given or not      */
		eventCode=3045;			   
 		spawn queueEvent();	
 		eventCode=rJuiceGo;			   
 		spawn queueEvent();
		nexttick;

		 /* 56: search array duration      */
	 	eventCode=3046;			   
 	 	spawn queueEvent();	
 	 	eventCode=iTArray[lPair];			   
 	 	spawn queueEvent();
	 	nexttick;

		/* 57: catch ratio of the selected pair      */
		eventCode=3047;			   
 		spawn queueEvent();	
 		eventCode=iCFreq[lPair];			   
 		spawn queueEvent();
		nexttick;





	/* 58~63 pair type ratio   0~5 */

	i = 0;									  
	while (i < MAXPAIR ){					 	
		eventCode=3048;			   
 		spawn queueEvent();
		eventCode=iFreq[i];			   
 		spawn queueEvent();
		nexttick;
		i = i + 1;
	}

	/* 64~65: signal of the horizontal window */
	eventCode = 3049;							// horizontal fix window voltage value
	spawn queueEvent(); 
	if (eHalfFix*100/(XGAIN + XYF) + eFixx < 0){
		eventCode = 1;
	} else {
		eventCode = 0;
	}	
	spawn queueEvent(); nexttick;

	eventCode = 3049;							// horizontal fix window voltage value
	spawn queueEvent(); 
	eventCode = abs(eHalfFix*100/(XGAIN + XYF) + eFixx);
	spawn queueEvent(); nexttick;


	/* 66~67: signal of the vertical window */
	eventCode = 3050;
	spawn queueEvent();
   	if ( -eHalfFix*100/(YGAIN + YXF) - eFixy < 0 ){
		eventCode = 1;
	} else {
		eventCode = 0;
	}
	spawn queueEvent(); nexttick;

	eventCode = 3050;
	spawn queueEvent();
	eventCode = abs(-eHalfFix*100/(YGAIN + YXF) - eFixy);
	spawn queueEvent(); nexttick;

	// SAT parameters
	
	// blocking condition
	eventCode = 5000;
	spawn queueEvent();
	eventCode = SAT_condSet;
	spawn queueEvent();
	nexttick; 

	// condition
	eventCode = 5001;
	spawn queueEvent();
	eventCode = SAT_cond;
	spawn queueEvent();
	nexttick;

	// Cutoff Time
	eventCode = 5002;
	spawn queueEvent();
	
	if (SAT_cond == 1) eventCode = SAT_slow;
	if (SAT_cond == 2) eventCode = SAT_med;
	if (SAT_cond == 3) eventCode = SAT_fast;
	if (SAT_cond == 4) eventCode = 9999;
	spawn queueEvent();
	nexttick;

	// What percentile were we using to set cutoff times?
	eventCode = 5003;
	spawn queueEvent();
	eventCode = prct;
	spawn queueEvent();

	// Reward Amount (duration solenoid open)
	eventCode = 5004;
	spawn queueEvent();

	if (SAT_cond == 1 || SAT_cond == 4) eventCode = rwd_slow;
	if (SAT_cond == 2) eventCode = rwd_med;
	if (SAT_cond == 3) eventCode = rwd_fast;

	spawn queueEvent();
	nexttick;
	
	// Reward probability
	eventCode = 5005;
	spawn queueEvent();
	eventCode = rRwdProb;
	spawn queueEvent();
	nexttick;
	
	// Juice time
	eventCode = 5006;
	spawn queueEvent();
	eventCode = JUICE_TIME;
	spawn queueEvent();
	nexttick;
	
	// Bell time
	eventCode = 5007;
	spawn queueEvent();
	eventCode = BELL_TIME;
	spawn queueEvent();
	nexttick;
	
	//Go/Nogo
	eventCode = 5008;
	spawn queueEvent();
	eventCode = tIsNoGo;
	spawn queueEvent();
	nexttick;
	
	//Delay between tone and juice
	eventCode = 5009;
	spawn queueEvent();
	eventCode = JuiceDelay;
	spawn queueEvent();
	nexttick;
	

	// code mStim parameters; only code if stimulation was delivered.

	if (trlStimP <= mStimProb){
	eventCode=7010;
	spawn queueEvent();
	nexttick;

	eventCode=mStimProb;
	spawn queueEvent();
	nexttick;

	eventCode=mStimDur;
	spawn queueEvent();
	nexttick;

//Tempo does not code negative numbers correctly so we need to send two different event codes (one for pos and one for neg)
//and then add 256 in MatLab if the number was negative.
	if (mStimDelay < 0){
	eventCode = 7011;
	spawn queueEvent();
	nexttick;

	}else{
	eventCode = 7012;
	spawn queueEvent();
	nexttick;
}

// now send stimulation delay.
	eventCode=mStimDelay;
	spawn queueEvent();
	nexttick;
 	
 	}



}       

/***************************************************/
/* add one more process that can draw event timing */
/* on the right panel including the signal from    */
/* photodiode to check the transmission speed      */
/***************************************************/


// Call queueEvent() in your protocol when you want to send an event code to Plexon
// Call this to queue an event code	  
// enabled : here run in the background
// for transmission to Plexon
process queueEvent()   
{                                   
     	   
	int     nextPut;
  	
	nextPut = (put + 1) % nXMIT;        	// precompute the next put value
	if (nextPut == get)                 	// Are we full (nXmit-1 events in xmit[])?
    	printf("queueEvent - xmit[] buffer is full! - Can't send event %d to Plexon\n", eventCode);
	else
    {
    xmit[put] = eventCode;                  // store event code in transmit array
    put = nextPut;                  		// Advance put index to next location
    }
}


//-------------------------------------------------------------------------
process SendTTLToRemoteSystem(int value)	      
      {
      dioSetMode(REMOTE_TTL, PORTA|PORTB|PORTC);		       
	   			  	   	   
    	 dioSetA(REMOTE_TTL, (value & 0xFF )); 			// load the first 8 bits
         dioSetB(REMOTE_TTL, ((value / 256) & 0x7F)); 	// load the second 8 bits
         dioSetC(REMOTE_TTL, 0x01); 					// strobe


		   //dioSetB(REMOTE_TTL, ((14) & 0x7F)) //| 0x80);		
		     
           	   		
    	 spawn Delay(175);	   //changed from 150 to 200 5/17/06 GW
         waitforprocess Delay; 
             			 	 
		 dioSetA(REMOTE_TTL, (0x0 & 0xFF));
	     dioSetB(REMOTE_TTL, (0x0 & 0xFF));
	   	 dioSetC(REMOTE_TTL, 0x00); 	// reset the strobe	
		 //dioSetA(REMOTE_TTL,  0x00); 	// strobe
		 //dioSetB(REMOTE_TTL, 0x00); 	// strobe
		 //dioSetC(REMOTE_TTL, 0x00); 	// strobe
            
     }

   
process Delay(int uSeconds)	
        {
		int start, duration;
        int ticks;

        ticks = uSeconds * 1.193180;     // Convert uSec to 1193180 Hz ticks
        start = timeus();
        duration = 0;
        while (duration < ticks)
                {
                duration = (timeus() - start) & 0xFFFF;
                }
        }

//-------------------------------------------------------------------------
// Process xmitEvents() runs in the background and sends up to 5 event codes
// per process cycle to the remote system, drawing them from the xmit[] array.
// This process should be the last process in your protocol so that any
// preceeding process that adds an event code to the xmit[] will do so
// before xmitEvents() runs.

process xmitEvents() enabled        // This could also be spawned in your init() process
{
    int         i;                  // # of codes sent this process cycle
 

	while (1)                           // We loop indefinitely..
    {
    i = 0;
    while (i < nEventsPerProcessCycle && get != put)    // Up to nEventsPerProcessCycle are sent..
        {
        spawn SendTTLToRemoteSystem(xmit[get]);  		//toto // Send next code to Plexon
        waitforprocess SendTTLToRemoteSystem;     		// Prudent but not necessary
        get = (get + 1) % nXMIT;            			// Advance to next event code xmit[]        
        i = i + 1;                         				// Count one more code transmitted
        }
    
    nexttick;                       					// ..Wait one process cycle
    }
}


process mSTIM
{
printf("\n STIMULATION \n");

mio_ao_set(1,32760);
//mio_ao_set(1,6000);
//mio_dig_set(1,1);
wait(mStimDur);
mio_ao_set(1,-32760);
//mio_ao_set(1,-6000);
//mio_dig_set(1,0);
	eventCode=7013;
	spawn queueEvent();
	nexttick;
}


process MEANRT
{
  //	hide declare i = 0;
  //	hide declare RT_SUM = 0;

	// initialize again; for some reason declaration of local variables sometimes initializes only once	
  //	i = 0;
  //	RT_SUM = 0;

	// weighted mean.  -1 because newest RT has already been appended.

	if (SAT_cond == 1){
		RT_slow =( ((n_cor_slo-1)*RT_slow) + currRT) / (n_cor_slo);
	}

	if (SAT_cond == 2){
		RT_med = ( ((n_cor_med-1)*RT_med) + currRT) / (n_cor_med);
	}

	if (SAT_cond == 3){
		RT_fast =( ((n_cor_fst-1)*RT_fast) + currRT) / (n_cor_fst);
	}

 //	while (i < n_cor_med){ 
 //		 RT_SUM = RT_SUM + corRTs_m[i];
 //		 i = i + 1;
 //	}
 //	RT_med = round(RT_SUM / n_cor_med);


 //	i = 0;
 //	RT_SUM = 0;
  //	while (i < n_cor_slo){
  //		RT_SUM = RT_SUM + corRTs_s[i];
 //		i = i + 1;
  //	}
 //	RT_slow = round(RT_SUM / n_cor_slo);

  //	i = 0;
  //	RT_SUM = 0;
  //	while (i < n_cor_fst){
  //		RT_SUM = RT_SUM + corRTs_f[i];
  //		i = i + 1;
  //	}
 //	RT_fast = round(RT_SUM / n_cor_fst);
//

}

process SORTRT
{
	declare ijx = 0;
	declare array_ix = 0;
	declare move_ix = 0;
	declare placed = 0;
	declare keeplooking = 0;

	// initialize again; for some reason declaration of local variables sometimes initializes only once
	array_ix = 0;
	move_ix = 0;
	placed = 0;
	keeplooking = 0;
	
	//for med condition
	if (SAT_cond == 2){
		if (n_cor_med == 1){
		   corRTs_m[0] = currRT; /* if first value, set manually */
		}else{
			keeplooking = 1;
			array_ix = 0;

			while (keeplooking){
				if (array_ix == n_cor_med-2) keeplooking = 0; /* if reach last index of PREVIOUS RTs, stop */
				if (currRT < corRTs_m[array_ix]){ /* need to move everything down in reverse. Start at last index */
					move_ix = n_cor_med; /* index is 0 based so n_cor_med is actually + 1 */
					while (move_ix > array_ix){
						corRTs_m[move_ix] = corRTs_m[move_ix-1];
						move_ix = move_ix - 1;
					}
					// now set current value
					corRTs_m[array_ix] = currRT;
					placed = 1;		// mark current RT as having been placed
					keeplooking = 0;
				}
				array_ix = array_ix + 1;
			
			}
	  	/* if still haven't found lesser value after looping through all, then we know it should be last value */
	  		if (placed == 0){
	  			corRTs_m[array_ix] = currRT;
	  			//printf("Placing last value\n");
			}
		}
	}
	
  	//for fast condition
	if (SAT_cond == 3){
		if (n_cor_fst == 1){
		   corRTs_f[0] = currRT; /* if first value, set manually */
		}else{
			keeplooking = 1;
			array_ix = 0;

			while (keeplooking){
				if (array_ix == n_cor_fst-2) keeplooking = 0; /* if reach last index of PREVIOUS RTs, stop */
				if (currRT < corRTs_f[array_ix]){ /* need to move everything down in reverse. Start at last index */
					move_ix = n_cor_fst; /* index is 0 based so n_cor_med is actually + 1 */
					while (move_ix > array_ix){
						corRTs_f[move_ix] = corRTs_f[move_ix-1];
						move_ix = move_ix - 1;
					}
					// now set current value
					corRTs_f[array_ix] = currRT;
					placed = 1;		// mark current RT as having been placed
					keeplooking = 0;
				}
				array_ix = array_ix + 1;
			
			}
	  	/* if still haven't found lesser value after looping through all, then we know it should be last value */
	  		if (placed == 0){
	  			corRTs_f[array_ix] = currRT;
	  		   //	printf("Placing last value\n");
			}
		}
	}



//for slow condition
	if (SAT_cond == 1){
		if (n_cor_slo == 1){
		   corRTs_s[0] = currRT; /* if first value, set manually */
		}else{
			keeplooking = 1;
			array_ix = 0;

			while (keeplooking){
				if (array_ix == n_cor_slo-2) keeplooking = 0; /* if reach last index of PREVIOUS RTs, stop */
				if (currRT < corRTs_s[array_ix]){ /* need to move everything down in reverse. Start at last index */
					move_ix = n_cor_slo; /* index is 0 based so n_cor_med is actually + 1 */
					while (move_ix > array_ix){
						corRTs_s[move_ix] = corRTs_s[move_ix-1];
						move_ix = move_ix - 1;
					}
					// now set current value
					corRTs_s[array_ix] = currRT;
					placed = 1;		// mark current RT as having been placed
					keeplooking = 0;
				}
				array_ix = array_ix + 1;
			
			}
	  	/* if still haven't found lesser value after looping through all, then we know it should be last value */
	  		if (placed == 0){
	  			corRTs_s[array_ix] = currRT;
	  			//printf("Placing last value\n");
			}
		}
	}



	// Calculate percentiles (subtract 1 because 0 based arrays).  Only do if # of trials > 5
	if (n_cor_slo > 5) prct_s = corRTs_s[round(prct * n_cor_slo)-1];
	if (n_cor_med > 5) prct_m = corRTs_m[round(prct * n_cor_med)-1];
 	if (n_cor_fst > 5) prct_f = corRTs_f[round(prct * n_cor_fst)-1];

	//use to print RT distribution to screen
   //	ijx = 0;
  //	while (ijx < n_cor_med){
   //		printf("RT %d\n",corRTs_m[ijx]);
  //	 	ijx = ijx + 1;
   //	}


}

process ABORTPEN
{
printf("Pausing Task due to successive ABORTS...\n");
trlAborts = 0; //reset count
tGoOn = 0;
wait(tAbortPen);
tGoOn = 1;
}


process RE_CLUT
{
// resets the CLUT based on values input in the COLOR menu.  control + F12 invokes.
// Will not run automatically. Must be invoked with keystrokes
 waitforprocess TRIAL_POST; nexttick;

 print("RE-SETTING COLOR LOOKUP TABLE...");
 dsendf("RE_CLUT(%d,%d,%d,%d,%d,%d,",black[0],black[1],black[2],white[0],white[1],white[2]);
 dsendf("%d,%d,%d,%d,%d,%d,",red[0],red[1],red[2],green[0],green[1],green[2]);
 dsendf("%d,%d,%d);",blue[0],blue[1],blue[2]);
}
						

///////////////////in progress 

process CALIB_EXE
{
	//display point window, wait 1000ms, display blank screen, wait 500ms
	if(point_num>=0&&point_num<=9)
	{
	spawn DISP_FRAME_10;
	wait(3000);
	spawn DISP_FRAME_5;
	nexttick;
	}
}

process CALIB_EXE_LONG
{
	//display point window, wait 1000ms, display blank screen, wait 500ms
	if(point_num>=0&&point_num<=9)
	{
	spawn DISP_FRAME_10;
	wait(500);
	spawn DISP_FRAME_5;
	nexttick;
	}
}

process SET_BLACK
{

	declare toggle_flag;
	
	//toggles value of black between [0 0 0] and [90 90 90]
	//if black is set to other values nothing will change.
	toggle_flag=1;

	if(black[0]==0&&black[1]==0&&black[2]==0&&toggle_flag==1)
	{
		black[0]=90;
		black[1]=90;
		black[2]=90;
		
		spawn RE_CLUT;
		
		toggle_flag=0;
	}
	
	if(black[0]==90&&black[1]==90&&black[2]==90&&toggle_flag==1)
	{
		black[0]=0;
		black[1]=0;
		black[2]=0;
		
		spawn RE_CLUT;
		
		toggle_flag=0;
	}		

}
