declare constant VDO_CMD_DEBUG = 0;
declare constant FRAME_NUM_DEBUG = 0;
declare constant TIMING_DEBUG = 0;
declare constant DSEND_DEBUG = 0;

/* Fundamental data */
declare constant int VideoSYNC = 1;
/*
// dimensions of Dell E171FP monitor
// this monitor is used development
// will not be used for experiments
// specifications from
// http://support.dell.com/support/edocs/monitors/e171fp/en/specs.htm
// values in centimeters
declare constant float dispAreaHorizontal = 33.792;
declare constant float dispAreaVertical = 27.0336;
*/

// dimensions of Sony GDM-FW900 monitor
// this monitor is used in WH029
// specifications from
// http://www.firingsquad.com/hw/1756/Sony_GDM-FW900		
// approx 18.98 inches horizontal multiplied by 2.54 to convert to cm
// approx 12.13 inches vertical multiplied by 2.54 to convert to cm
declare constant float dispAreaHorizontal = 48.2092;
declare constant float dispAreaVertical = 30.8102;


// scale to micrometers
// VideoSYNC won't truncates float coords
declare constant float scalingFactor = 10000;

// scale stim size for PTB to suit VideoSYNC
declare constant float scaleStimSize = 0.0308;

// virtual coordinates available to all processes
declare float VIRT_WIDTH_X, VIRT_WIDTH_Y;
declare float VC_XMIN,VC_XMAX,VC_YMIN,VC_YMAX;

// typical subject distance is ~57cm ...
// ... convenient because each degree eccentricity is ~1cm
declare constant float subjectDistance = 57;
declare constant float degreesInCircle = 360;

// map color indices
declare constant int colorBG 				= 0;
declare constant int colorFixOutline		= 1;
declare constant int colorFixFill			= 2;
declare constant int colorGlyph 			= 3;
declare constant int colorCircleRed			= 4;
declare constant int colorCircleGreen		= 5;
declare constant int colorCircleBlue		= 6;
declare constant int colorPhotodiode		= 7;
declare constant int colorCalibStim			= 8;
declare constant int numColorIndices		= 9;


/* quick hack to be sure display is initialized */
declare int initializedDisplay = 0;

/* ---------- END DATA DEFINITIONS ---------- */

/* Processes called directly by protocol */
declare DRAW_STIM(),
		DRAW_OBJECT(int,int,int,int,int,int,int,int),
		ERASE_ALL(),
		DISP_FRAME_1(),
		DISP_FRAME_2(),
		DISP_FRAME_3(),
		DISP_FRAME_4(),
		DISP_FRAME_5(),
/* There are no calls to display frame 7 in SRCHStm.pro */
		DISP_FRAME_6(),
		DISP_FRAME_8(),
		DISP_FRAME_9(),
		DISP_FRAME_10(),
		COMPLETE_DSEND();
		
/* Underlying process called by above processes */
declare		SHOW_FIX_OUTLINE(),CHANGE_FIX_OUTLINE(),
			SHOW_FIX_FILL(),CHANGE_FIX_FILL(),
			SHOW_ARRAY(),HIDE_ARRAY(),
			SHOW_PHOTODIODE(),HIDE_PHOTODIODE(),
			SHOW_CALIB_STIM(),
			HIDE_ALL_OBJECTS();
			
/* Processes specific to objects */
declare DRAW_FIX_OUTLINE(int,int,float,int);
declare DRAW_FIX_FILLED(int,int,float,int);
declare DRAW_T(int,int,float,float,int);
declare DRAW_L(int,int,float,float,int);
declare DRAW_CIRCLE(int,int,float,int);
declare DRAW_PHOTODIODE();
declare DRAW_CALIB(int,int,float,int);

process DRAW_STIM
{
	declare i, j, k;
	declare startTime, endTime;
	if (TIMING_DEBUG)
	{
		startTime = time();
		printf("START DRAW_STIM\n");
	}
	/* position calcuation  */
	i = 0;
	while ( i < mMAXPOS ){
		ePosX[i] = eOrigX[i]*175*mEccy/1000;
		ePosY[i] = eOrigY[i]*175*mEccy/1000;
		i = i + 1;
	} 
	nexttick;
	
	eSTgt = mTRS*mEccy/10;
	if ( eSTgt%2 ) eSTgt = eSTgt + 1;   /* even & odd   */
	eSQRsize = eSTgt;
	eCIRsize = (eSQRsize*113+50)/100 + 2;
	if ( eCIRsize%2 ) eCIRsize = eCIRsize + 1;
	nexttick;
	
	/* send information to matlab using dsendf  */
	/* current setting for each screen          */
	/* 1: fixation  2: fixation                 */
	/* 3: search without photodiode input       */
	/* 4: search + photodiode input             */
	/* 5: blank without fixation                */
	/* 6: mask                                  */
	/* 7: blank 8: reappear                     */
	/*                                          */
	/* 9: search + hold fixation + photodiode   */
	/*10: calibration window					*/
	/* photodiode input is handled in eall.m    */    

	/* presentation does not correspond to      */
	/* numeric order of the frame number        */
	 
	/* prepSrch variables                       */
	/* prepSrch(1, frame number,
			2, item: fixation, L, T coded in #
			3, eccentricity
			4, angle coded in number
			5, stimulus size    
			6, stimulus property: color, texture    
			7, placeholder flag         
			8, common onset mask flag)          */

	com_flush(2);
  	  				  			// Flip conditions if condition is met
			
			if (FlipCond > 0){
				if (setTrls == FlipCond && SAT_condSet == 1 && includeMed == 1){
					setTrls = 0;
					SAT_cond = 2;
					SAT_condSet = 2;
				}
				
				if (setTrls == FlipCond && SAT_condSet == 1 && includeMed == 0){
					setTrls = 0;
					SAT_cond = 3;
					SAT_condSet = 3;
				}
				
				if (setTrls == FlipCond && SAT_condSet == 2){
					setTrls = 0;
					SAT_cond = 3;
					SAT_condSet = 3;
				}
			
				if (setTrls == FlipCond && SAT_condSet == 3){
					setTrls = 0;
					SAT_cond = 1;
					SAT_condSet = 1;
				}
			}
			
			//Send marker for FlipCond
			eventCode=6021;			   
 			spawn queueEvent();
			nexttick;
			eventCode = FlipCond;
			spawn queueEvent();
			nexttick;
	
	
	
	
	
	/***** added 2004.07.06 *****/
	// SET FIXATION POINT COLOR AS PART OF SAT MANIPULATION
	// BP: for vdo, need to change colorFixFill, not fixColor2

	if (SAT_cond == 1){
		fixColor = 2; //make SLOW condition fixation point RED
		}
	
	if (SAT_cond == 2){
		fixColor = 1; //make MED condition fixation point WHITE
		}
	
	if (SAT_cond == 3){
		fixColor = 3; //make FAST condition fixation point GREEN
		}
	if (SAT_cond ==4){
		fixColor = 1; //make fixColor white be default
		}

		
	// color for random color condition
	if ( tIsCatch == 0 ){
		if ( iCol[lObjt[lTgtP],1] == 1000 ){
			/* luminisity randomization protocol */
			/* value should be set by            */
			/* cell by cell                      */
			/* min 1 to max 156                  */
			
			// Is a MG trial, set fixation point color to white
			fixColor = 1;
			iColor = 100 + iColMin + (iColMax - iColMin)*random(iColBin+1)/iColBin;
			/* float number to integer in matlab */
		
		} else {
				iColor = iCol[lObjt[lTgtP],1];
				
				//set SAT_cond to 4 to use original colors (e.g., color pop-out)
				//set SAT_cond to 0-3 for color to indicate SAT condition
		//		if ( SAT_cond == 4)
		//		{
		//		fixColor = 1;
		//		} else {
		//		fixColor = SAT_cond;
		//   		}
			}
	 
		i = 0;
		while( i < MAXITEM ){
			iColCopy[i] = iCol[i,1];
					
		//	if ( SAT_cond == 4)
		//	{
		//		fixColor = iCol[i,1];
		//	} else {
		//		fixColor = SAT_cond;
		//	}	  
		   
			i = i + 1;
			nexttick;
		}
		iColCopy[lObjt[lTgtP]] = iColor; 
	
	} else {
		i = 0;        
		while( i < MAXITEM ){
			iColCopy[i] = iCol[i,1];
			
		//	if ( SAT_cond == 4)
		//	{
		//		fixColor = iCol[i,1];
		//	}else{
		//		fixColor = SAT_cond;
		//	}
		  			i = i + 1;
			nexttick;
		}
	}
   //	printf(" COLOR CODE    %d\n",iColor);
   
   
   
	/************BEGIN DRAWING*****************/
	/************BEGIN DRAWING*****************/
	/************BEGIN DRAWING*****************/
	/************BEGIN DRAWING*****************/
	
	// Draw Fixation filled 
	spawnwait DRAW_OBJECT(1,iFFix,eFP_r,eFP_a,iFixS,fixColor,mHolder,iMask[lPair]);

	
	// Draw Fixation outline 
	spawnwait DRAW_OBJECT(2,iEFix,eFP_r,eFP_a,iFixS,fixColor2,mHolder,iMask[lPair]);

	
	// Draw search array 
	i = 0;
	while( i < mMAXPOS ){
		spawnwait DRAW_OBJECT(3,lObjt[i],145*175*mEccy/1000,i,eCIRsize,iColCopy[lObjt[i]],mHolder,iMask[lPair]);
		i = i + 1;
		nexttick;
	}
	
	// draw photodiode marker (BP: coordinates hardcoded for 029, not sure if this is right???)
	spawnwait DRAW_PHOTODIODE();
	
	
	
  	spawnwait COMPLETE_DSEND();  nexttick;
	if (TIMING_DEBUG)
	{
		endTime = time();
		printf("FINISH DRAW_STIM in %d milliseconds\n",endTime-startTime);	
	}
}

process INIT_DISPLAY()
{
	
	if (VDO_CMD_DEBUG) printf("INIT_DISPLAY()\n");
	
	// Calculate virtual coordinate dimensions ...
	// ... derived from physical screen dimensions
	VIRT_WIDTH_X = scalingFactor * dispAreaHorizontal;
	VIRT_WIDTH_Y = scalingFactor * dispAreaVertical;
	
	// Set virtual coordinate limits ...
	// 0,0 centered
	VC_XMIN = - (VIRT_WIDTH_X / 2.0);
	VC_XMAX =   (VIRT_WIDTH_X / 2.0);
	VC_YMIN = - (VIRT_WIDTH_Y / 2.0);
	VC_YMAX =   (VIRT_WIDTH_Y / 2.0);
	
	// Set virtual coordinates
	dsendf("vc %d,%d,%d,%d\n", VC_XMIN, VC_XMAX, VC_YMIN, VC_YMAX);
	
	initializedDisplay = 1;
	
	if (VDO_CMD_DEBUG) printf("vc %d,%d,%d,%d\n", VC_XMIN, VC_XMAX, VC_YMIN, VC_YMAX);
}
			
			
process DRAW_OBJECT(int frame,
					int item,
					int eccentricity,
					int targPos,
					int stimSize,
					int stimProp,
					int placeholderFlag,
					int onsetMaskFlag)
{
	float newStimSize,newEccentricity;
	int angle;
	
	// be sure VideoSYNC is inititialized
	if (!initializedDisplay) spawnwait INIT_DISPLAY(); nexttick;
	
	/* ------ start transfomations ------ */
	// eccentricity being passed with the following expression ...
	// ... 145*175*mEccy/1000
	eccentricity = (((eccentricity * 1000) / 175) / 145);
	
	newStimSize = float(stimSize) * scaleStimSize;
	
	angle = 360-(360/8)*targPos;
	
	/* ------- end transfomations ------- */
	
	// item 0 is not an item
	if(item==0) suspend;
	
	if (item==1) 			// filled square
	{
		if (VDO_CMD_DEBUG) printf("filled square\n");
		spawnwait DRAW_FIX_FILLED(eccentricity,angle,newStimSize,colorFixFill);
	}
	else if (item==2)		// outlined square
	{
		if (VDO_CMD_DEBUG) printf("outlined square\n");
		spawnwait DRAW_FIX_OUTLINE(eccentricity,angle,newStimSize,colorFixFill);
	}
	else if (item==4)		// circle RED
	{
		if (VDO_CMD_DEBUG) printf("circle\n");
		spawnwait DRAW_CIRCLE(eccentricity,angle,newStimSize,colorCircleRed);
	}
	else if (item==5)		// circle GREEN
	{
		if (VDO_CMD_DEBUG) printf("circle\n");
		spawnwait DRAW_CIRCLE(eccentricity,angle,newStimSize,colorCircleGreen);
	}
	else if (item==3)		// circle BLUE
	{
		if (VDO_CMD_DEBUG) printf("circle\n");
		spawnwait DRAW_CIRCLE(eccentricity,angle,newStimSize,colorCircleBlue);
	}
	else if (item==11)		// T - 0 degrees
	{
		if (VDO_CMD_DEBUG) printf("T - 0 degrees\n");
		spawnwait DRAW_T(eccentricity,angle,newStimSize,0.0,colorGlyph);
	}
	else if (item==12)		// T - 90 degrees
	{
		if (VDO_CMD_DEBUG) printf("T - 90 degrees\n");
		spawnwait DRAW_T(eccentricity,angle,newStimSize,90.0,colorGlyph);
	}
	else if (item==13)		// T - 180 degrees
	{
		if (VDO_CMD_DEBUG) printf("T - 180 degrees\n");
		spawnwait DRAW_T(eccentricity,angle,newStimSize,180.0,colorGlyph);
	}
	else if (item==14)		// T - 270 degrees
	{
		if (VDO_CMD_DEBUG) printf("T - 270 degrees\n");
		spawnwait DRAW_T(eccentricity,angle,newStimSize,270.0,colorGlyph);
	}
	else if (item==21)		// L - 0 degrees
	{
		if (VDO_CMD_DEBUG) printf("L - 0 degrees\n");
		spawnwait DRAW_L(eccentricity,angle,newStimSize,0.0,colorGlyph);
	}
	else if (item==22)		// L - 90 degrees
	{
		if (VDO_CMD_DEBUG) printf("L - 90 degrees\n");
		spawnwait DRAW_L(eccentricity,angle,newStimSize,90.0,colorGlyph);
	}
	else if (item==23)		// L - 180 degrees
	{
		if (VDO_CMD_DEBUG) printf("L - 180 degrees\n");
		spawnwait DRAW_L(eccentricity,angle,newStimSize,180.0,colorGlyph);
	}
	else if (item==24)		// L - 270 degrees
	{
		if (VDO_CMD_DEBUG) printf("L - 270 degrees\n");
		spawnwait DRAW_L(eccentricity,angle,newStimSize,270.0,colorGlyph);
	}
	else if (item==99)
	{
		if (VDO_CMD_DEBUG) printf("calib_stimulus - square\n");
		spawnwait DRAW_CALIB(eccentricity,angle,newStimSize,colorCalibStim);

	}
	else
	{
		printf("ERROR: unknown item code - %d\n",item);
	}
}

/////////////////////////////////////////////////////in progress///////////////////////////////
process CALIB
{
	//display
	print("Begin calibration.");

	//get eccentricity values
	ecc_hv=mEccy+1;				//Eccentricity on horizontal and vertical meridian 
								//will be value selected in menu + 1 deg. to avoid
								//bounds issues.
	
	ecc_obl=sqrt(2)*(mEccy+1);	//Eccentricity on diagonal will be sqrt(2)*ecc_hv
								//so that it forms a right angle (isoceles right triangle).
								
	//put eccentricity values in vector in order of stimulus presentation
	ecc_vector[0] = 0;
	ecc_vector[1] = ecc_hv;
	ecc_vector[2] = ecc_hv;
	ecc_vector[3] = ecc_hv;
	ecc_vector[4] = ecc_hv;
	ecc_vector[5] = ecc_obl;
	ecc_vector[6] = ecc_obl;
	ecc_vector[7] = ecc_obl;
	ecc_vector[8] = ecc_obl;
	ecc_vector[9] = 0;
	
	//initialize first point, then enter loop and wait for CALIB_INCR/CALIB_DECR/CALIB_EXE to control
	point_num=0;
	spawn ERASE_ALL;
	spawnwait DRAW_OBJECT(10,99,145*175*ecc_vector[point_num]/1000,angle_vector[point_num],10,1,0,0);
	print("Point number ",point_num+1," (location ",angle_vector[point_num],")");
	
	//begin looping through calibration after pressing right, down, or left arrow
	while(point_num>=0&&point_num<=9)
	{
		nexttick;
	}
	//clear screen and set point_num to arbitrarily high value
	spawn ERASE_ALL;
		point_num = 9999;
	//display
		print("Exiting calibration.");
}

process CALIB_INCR
{
	//increment point_num
	point_num=point_num+1;
	if (point_num>=0&&point_num<=9)
	{
	//clear window
	spawn ERASE_ALL;
	//initialize point window
	spawnwait DRAW_OBJECT(10,99,145*175*ecc_vector[point_num]/1000,angle_vector[point_num],10,1,0,0);
	//print point_num
	print("Point number ",point_num+1," (location ",angle_vector[point_num],")");
	}
}		

process CALIB_DECR
{
	//increment point_num
	point_num=point_num-1;
	if (point_num>=0&&point_num<=9)
	{
	//clear window
	spawn ERASE_ALL;
	//initialize point window
	spawnwait DRAW_OBJECT(10,99,145*175*ecc_vector[point_num]/1000,angle_vector[point_num],10,1,0,0);
	//print point_num
	print("Point number ",point_num+1," (location ",angle_vector[point_num],")");
	}
}
/////////////////////////////////////////////////////in progress///////////////////////////////


process ERASE_ALL()
{
	if (VDO_CMD_DEBUG) printf("ERASE_ALL()\n");
	dsend("cl\n");             // frame 0: erase all 
	if (DSEND_DEBUG)printf("cl\n");	
	
}

/* send information to matlab using dsendf  */
	/* current setting for each screen          */
	/* 1: fixation+fixation fill*/
	/* 2:  hide fixation fill*/
	/* 3: search without photodiode input       */
	/* 4: search + photodiode input             */
	/* 5: blank without fixation                */
	/* 6: mask                                  */
	/* 7: blank 8: reappear                     */
	/*                                          */
	/* 9: search + hold fixation + photodiode   */
	/*10: calibration window					*/

process DISP_FRAME_1()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_1()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 1\n");
	spawnwait SHOW_FIX_OUTLINE();
	spawnwait SHOW_FIX_FILL();
//	spawnwait HIDE_ARRAY();
//	spawnwait HIDE_PHOTODIODE();
}

process DISP_FRAME_2()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_2()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 2:\n");
//	spawnwait SHOW_FIX_OUTLINE();
	spawnwait CHANGE_FIX_OUTLINE();
	spawnwait CHANGE_FIX_FILL();
//	spawnwait HIDE_ARRAY();
//	spawnwait HIDE_PHOTODIODE();
}

process DISP_FRAME_3()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_3()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 3:\n");
//	spawnwait SHOW_FIX_OUTLINE();
//	spawnwait CHANGE_FIX_FILL();
	spawnwait SHOW_ARRAY();
//	spawnwait HIDE_PHOTODIODE();
}

process DISP_FRAME_4()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_4()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 4:\n");
	spawnwait CHANGE_FIX_OUTLINE();
	spawnwait CHANGE_FIX_FILL();
	spawnwait SHOW_ARRAY();
	spawnwait SHOW_PHOTODIODE();
}

process DISP_FRAME_5()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_5()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 5:\n");
	spawn HIDE_ALL_OBJECTS();
}

process DISP_FRAME_6()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_6()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 6:\n");
	//dsend("f6;");
	
	//THIS CODE IS INCOMPLETE
	
	
	if (DSEND_DEBUG) printf("f6;");
}

/* There are no calls to display frame 7 in SRCHStm.pro */

process DISP_FRAME_8()
{
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_8()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 8:\n");
	//dsend("f8;");
	
	
	//THIS CODE IS INCOMPLETE
	
	
	if (DSEND_DEBUG) printf("f8;");
}

process DISP_FRAME_9()										
{
	//BP: in PTB this is a frame displaying fix outline + fix fill + array + photodiode
	//For VDO, fix outline + fix fill are already on screen, so only need array + photodiode
	spawnwait SHOW_ARRAY();
	spawnwait SHOW_PHOTODIODE();
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_9()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 9:\n");
	//dsend("f9;");

}


process DISP_FRAME_10()
{
	spawnwait SHOW_CALIB_STIM();
	if (VDO_CMD_DEBUG) printf("DISP_FRAME_10()\n");
	if (FRAME_NUM_DEBUG) printf("---------- Frame 10:\n");
}


process COMPLETE_DSEND()
{
	while(dsend()) nexttick;
}


/* Start definitions of underlying processes */

process SHOW_FIX_OUTLINE
{
	if (fixColor==1) dsendf("cm %d,63,63,63\n",colorFixOutline);	//set fixation outline color to white
	if (fixColor==2) dsendf("cm %d,63,0,0\n",colorFixOutline);		//set fixation outline color to red
	if (fixColor==3) dsendf("cm %d,0,63,0\n",colorFixOutline);		//set fixation outline color to green
	
	
	//if (DSEND_DEBUG) printf("cm %d,63,63,63\n",colorFixOutline);
}

process CHANGE_FIX_OUTLINE
{
	//set fixation color outline to black
	if (tIsNoGo==1) dsendf("cm %d,21,63,63\n",colorFixOutline);		//set fixation outline to cyan if nogo is flagged
	//if (DSEND_DEBUG) printf("cm %d,0,0,0\n",colorFixOutline);
}

process SHOW_FIX_FILL
{
	//set fixation fill to white
	if (fixColor==1) dsendf("cm %d,63,63,63\n",colorFixFill);		//set fixation fill to white
	if (fixColor==2) dsendf("cm %d,63,0,0\n",colorFixFill);			//set fixation fill to red
	if (fixColor==3) dsendf("cm %d,0,63,0\n",colorFixFill);			//set fixation fill to green
	
	//if (DSEND_DEBUG) printf("cm %d,63,63,63\n",colorFixFill);
}

process CHANGE_FIX_FILL
{
	if (tIsNoGo==0) dsendf("cm %d,0,0,0\n",colorFixFill);			//set fixation fill to black if nogo isn't flagged
	if (tIsNoGo==1) dsendf("cm %d,21,63,63\n",colorFixFill);		//set fixation fill to cyan if nogo is flagged
	//if (DSEND_DEBUG) printf("cm %d,0,0,0\n",colorFixFill);
}

process SHOW_ARRAY
{
	dsendf("cm %d,63,63,63\n",colorGlyph);
	dsendf("cm %d,63,0,0\n",colorCircleRed);
	dsendf("cm %d,0,63,0\n",colorCircleGreen);
	dsendf("cm %d,0,0,63\n",colorCircleBlue);
	if (DSEND_DEBUG)
	{
		printf("cm %d,63,63,63\n",colorGlyph);
		printf("cm %d,63,0,0\n",colorCircleRed);
		printf("cm %d,0,63,0\n",colorCircleGreen);
		printf("cm %d,0,0,63\n",colorCircleBlue);
	}
}

process HIDE_ARRAY
{
	dsendf("cm %d,0,0,0\n",colorGlyph);
	dsendf("cm %d,0,0,0\n",colorCircleRed);
	dsendf("cm %d,0,0,0\n",colorCircleGreen);
	dsendf("cm %d,0,0,0\n",colorCircleBlue);
	if (DSEND_DEBUG)
	{
		printf("cm %d,0,0,0\n",colorGlyph);
		printf("cm %d,0,0,0\n",colorCircleRed);
		printf("cm %d,0,0,0\n",colorCircleGreen);
		printf("cm %d,0,0,0\n",colorCircleBlue);
	}
}

process SHOW_PHOTODIODE
{
	dsendf("cm %d,63,63,63\n",colorPhotodiode);
	if (DSEND_DEBUG) printf("cm %d,63,63,63\n",colorPhotodiode);
}

process HIDE_PHOTODIODE
{
	dsendf("cm %d,0,0,0\n",colorPhotodiode);
	if (DSEND_DEBUG) printf("cm %d,0,0,0\n",colorPhotodiode);
}

process SHOW_CALIB_STIM()
{
	dsendf("cm %d,63,63,63\n",colorCalibStim);
	printf("cm %d,63,63,63\n",colorCalibStim);
}


process HIDE_ALL_OBJECTS()
{
	int i;
	if (VDO_CMD_DEBUG) printf("HIDE_ALL_OBJECTS()\n");
	i = 0;
	while (i < numColorIndices)
	{
		dsendf("cm %d,0,0,0\n",i);
		if (DSEND_DEBUG) printf("cm %d,0,0,0\n",i);
		i = i + 1;
	}
}

process DRAW_FIX_FILLED (	int		fpEccy,
							int		fpAngle,
							float	fpSize,
							int		fpColor)
{
	float fpOriginX,fpOriginY;
	float v1x1,v1y1,v2x2,v2y2;
	float tanEccy,distFromCenter;
	
	if (VDO_CMD_DEBUG) printf("DRAW_FIX_FILLED()\n");
	
	/* Compute X,Y coordinates from Eccentricity & Angle */
	// PCL does not have a tan function ...
	// ... use tangent identity (tan=sin/cos)
	tanEccy = sin(fpEccy)/cos(fpEccy);
	
	// calculate distance from center of the screen
	distFromCenter = tanEccy * subjectDistance;
	
	fpOriginX = cos(fpAngle) * distFromCenter;
	fpOriginY = sin(fpAngle) * distFromCenter;
	/* End compute X,Y coordinates */
	
	v1x1 = ((fpOriginX - (fpSize / 2.0)) * scalingFactor);
	v1y1 = ((fpOriginY - (fpSize / 2.0)) * scalingFactor);
	v2x2 = ((fpOriginX + (fpSize / 2.0)) * scalingFactor);
	v2y2 = ((fpOriginY + (fpSize / 2.0)) * scalingFactor);
	
	// Send draw commands to VideoSYNC
	// set fill color
	dsendf("co %d\n",colorFixFill);
	dsendf("rf %d,%d,%d,%d\n",v1x1,v1y1,v2x2,v2y2);
	
	if (DSEND_DEBUG) 
	{
		// Show user VideoSYNC commands
		// Send draw commands to VideoSYNC
		// set fill color
		printf("co %d\n",colorFixFill);
		printf("rf %d,%d,%d,%d\n",v1x1,v1y1,v2x2,v2y2);
   }
}

process DRAW_FIX_OUTLINE (	int		fpEccy,
							int		fpAngle,
							float	fpSize,
							int		fpColor)
{
	float fpOriginX,fpOriginY;
	float v1x1,v1y1,v1x2,v1y2;
	float v2x1,v2y1,v2x2,v2y2;
	float h1x1,h1y1,h1x2,h1y2;
	float h2x1,h2y1,h2x2,h2y2;
	float tanEccy,distFromCenter;
	
	if (VDO_CMD_DEBUG) printf("DRAW_FIX_OUTLINE()\n");
	
	/* Compute X,Y coordinates from Eccentricity & Angle */
	// PCL does not have a tan function ...
	// ... use tangent identity (tan=sin/cos)
	tanEccy = sin(fpEccy)/cos(fpEccy);
	
	// calculate distance from center of the screen
	distFromCenter = tanEccy * subjectDistance;
	
	fpOriginX = cos(fpAngle) * distFromCenter;
	fpOriginY = sin(fpAngle) * distFromCenter;
	/* End compute X,Y coordinates */
	
	v1x1 = ((fpOriginX - (fpSize / 2.0)) * scalingFactor);
	v1y1 = ((fpOriginY - (fpSize / 2.0)) * scalingFactor);
	v1x2 = ((fpOriginX - (fpSize / 2.0)) * scalingFactor);
	v1y2 = ((fpOriginY + (fpSize / 2.0)) * scalingFactor);
	
	v2x1 = ((fpOriginX + (fpSize / 2.0)) * scalingFactor);
	v2y1 = ((fpOriginY - (fpSize / 2.0)) * scalingFactor);
	v2x2 = ((fpOriginX + (fpSize / 2.0)) * scalingFactor);
	v2y2 = ((fpOriginY + (fpSize / 2.0)) * scalingFactor);
	
	h1x1 = ((fpOriginX - (fpSize / 2.0)) * scalingFactor);
	h1y1 = ((fpOriginY - (fpSize / 2.0)) * scalingFactor);
	h1x2 = ((fpOriginX + (fpSize / 2.0)) * scalingFactor);
	h1y2 = ((fpOriginY - (fpSize / 2.0)) * scalingFactor);
	
	h2x1 = ((fpOriginX + (fpSize / 2.0)) * scalingFactor);
	h2y1 = ((fpOriginY + (fpSize / 2.0)) * scalingFactor);
	h2x2 = ((fpOriginX - (fpSize / 2.0)) * scalingFactor);
	h2y2 = ((fpOriginY + (fpSize / 2.0)) * scalingFactor);
	
	// Send draw commands to VideoSYNC	
	// set outline color
	dsendf("co %d\n", colorFixOutline);
	// draw left vertical line
	dsendf("rf %d,%d,%d,%d\n",v1x1,v1y1,v1x2,v1y2);
	// draw right vertical line
	dsendf("rf %d,%d,%d,%d\n",v2x1,v2y1,v2x2,v2y2);
	// draw top horizontal line
	dsendf("rf %d,%d,%d,%d\n",h1x1,h1y1,h1x2,h1y2);
	// draw bottom horizontal line
	dsendf("rf %d,%d,%d,%d\n",h2x1,h2y1,h2x2,h2y2);
	
	if (DSEND_DEBUG) 
	{
		// Show user VideoSYNC commands		
		// set outline color
		printf("co %d\n", colorFixOutline);
		// draw left vertical line
		printf("rf %d,%d,%d,%d\n",v1x1,v1y1,v1x2,v1y2);
		// draw right vertical line
		printf("rf %d,%d,%d,%d\n",v2x1,v2y1,v2x2,v2y2);
		// draw top horizontal line
		printf("rf %d,%d,%d,%d\n",h1x1,h1y1,h1x2,h1y2);
		// draw bottom horizontal line
		printf("rf %d,%d,%d,%d\n",h2x1,h2y1,h2x2,h2y2);
   }
}

process DRAW_T(	int		tEccy,
				int		tAngle,
				float	tSize,
				float	tOrient,
				int		tColor)
{
	float tPosX,tPosY;
	float lineThickness;
	float vx1,vy1,vx2,vy2,hx1,hy1,hx2,hy2;
	float tanTheta,tanEccy,distFromCenter;
	
	if (VDO_CMD_DEBUG) printf("DRAW_T()\n");

	/* Compute X,Y coordinates from Eccentricity & Angle */
	// PCL does not have a tan function ...
	// ... use tangent identity (tan=sin/cos)
	tanEccy = sin(tEccy)/cos(tEccy);
	
	// calculate distance from center of the screen
	distFromCenter = tanEccy * subjectDistance;
	
	tPosX = cos(tAngle) * distFromCenter;
	tPosY = sin(tAngle) * distFromCenter;
	
	lineThickness = (tSize / 4.0);
	if (VDO_CMD_DEBUG) printf("T position = [%d, %d]\n",tPosX,tPosY);
	/* End compute X,Y coordinates */

	// handle different orientations
	// should rather do this with trigonometry
	if (tOrient == 0)
	{
		// vertical line
		vx1 = tPosX;
		vy1 = tPosY - (tSize / 2.0);
		vx2 = tPosX;
		vy2 = tPosY + (tSize / 2.0);

		// horizontal line
		hx1 = tPosX - (tSize / 2.0);
		hy1 = tPosY - (tSize / 2.0);
		hx2 = tPosX + (tSize / 2.0);
		hy2 = tPosY - (tSize / 2.0);
	}
	else if (tOrient == 90)
	{
		// vertical line (horizontal when rotated 90)
		vx1 = tPosX - (tSize / 2.0);
		vy1 = tPosY;
		vx2 = tPosX + (tSize / 2.0);
		vy2 = tPosY;

		// horizontal line (vertical when rotated 90)
		hx1 = tPosX + (tSize / 2.0);
		hy1 = tPosY - (tSize / 2.0);
		hx2 = tPosX + (tSize / 2.0);
		hy2 = tPosY + (tSize / 2.0);
	}
	else if (tOrient == 180)
	{
		// vertical line
		vx1 = tPosX;
		vy1 = tPosY - (tSize / 2.0);
		vx2 = tPosX;
		vy2 = tPosY + (tSize / 2.0);

		// horizontal line
		hx1 = tPosX - (tSize / 2.0);
		hy1 = tPosY + (tSize / 2.0);
		hx2 = tPosX + (tSize / 2.0);
		hy2 = tPosY + (tSize / 2.0);
	}
	else if (tOrient == 270)
	{
		// vertical line (horizontal when rotated 270)
		vx1 = tPosX - (tSize / 2.0);
		vy1 = tPosY;
		vx2 = tPosX + (tSize / 2.0);
		vy2 = tPosY;

		// horizontal line (vertical when rotated 270)
		hx1 = tPosX - (tSize / 2.0);
		hy1 = tPosY - (tSize / 2.0);
		hx2 = tPosX - (tSize / 2.0);
		hy2 = tPosY + (tSize / 2.0);
	}
	else
	{
		printf("DRAW_T() ERROR : Unknown orientation\n");
		suspend;
	}
	
	// scale coordinates
	vx1 = (vx1 - (LineThickness / 2.0)) * scalingFactor;
	vy1 = (vy1 - (LineThickness / 2.0)) * scalingFactor;
	vx2 = (vx2 + (LineThickness / 2.0)) * scalingFactor;
	vy2 = (vy2 + (LineThickness / 2.0)) * scalingFactor;
	
	hx1 = (hx1 - (LineThickness / 2.0)) * scalingFactor;
	hy1 = (hy1 - (LineThickness / 2.0)) * scalingFactor;
	hx2 = (hx2 + (LineThickness / 2.0)) * scalingFactor;
	hy2 = (hy2 + (LineThickness / 2.0)) * scalingFactor;
	
	if (VDO_CMD_DEBUG)
	{
		printf("T width = %.3d\n",(vx1 - hx2)/100000);
		printf("T height = %.3d\n",(vy1 - hy2)/100000);
	}
	
	// Send draw commands to VideoSYNC
	// set color
	dsendf("co %d\n",tColor);
	// vertical line
	dsendf("rf %d,%d,%d,%d\n",vx1,vy1,vx2,vy2);
	// horizontal line
	dsendf("rf %d,%d,%d,%d\n",hx1,hy1,hx2,hy2);
	
	
	if (DSEND_DEBUG)
	{
		// set color
		printf("co %d\n",tColor);
		// vertical line
		printf("rf %d,%d,%d,%d\n",vx1,vy1,vx2,vy2);
		// horizontal line
		printf("rf %d,%d,%d,%d\n",hx1,hy1,hx2,hy2);
	}
}

process DRAW_L(	int		lEccy,
				int		lAngle,
				float	lSize,
				float	lOrient,
				int		lColor)
{
	float lPosX,lPosY,lSizeX,lSizeY;
	float lineThickness;
	float vx1,vy1,vx2,vy2,hx1,hy1,hx2,hy2;
	float tanTheta,tanEccy,distFromCenter;
	
	if (VDO_CMD_DEBUG) printf("DRAW_L()\n");
	
	/* Compute X,Y coordinates from Eccentricity & Angle */
	// PCL does not have a tan function ...
	// ... use tangent identity (tan=sin/cos)
	tanEccy = sin(lEccy)/cos(lEccy);
	
	// calculate distance from center of the screen
	distFromCenter = tanEccy * subjectDistance;
		
	lPosX = cos(lAngle) * distFromCenter;
	lPosY = sin(lAngle) * distFromCenter;	
	
	lineThickness = (lSize / 4.0);
	if (VDO_CMD_DEBUG) printf("L position = [%d, %d]\n",lPosX,lPosY);
	/* End compute X,Y coordinates */
	
	// handle different orientations
	// should rather do this with trigonometry
	if (lOrient == 0)
	{
		// vertical line
		vx1 = lPosX - (lSize / 2.0);
		vy1 = lPosY - (lSize / 2.0);
		vx2 = lPosX - (lSize / 2.0);
		vy2 = lPosY + (lSize / 2.0);

		// horizontal line
		hx1 = lPosX - (lSize / 2.0);
		hy1 = lPosY + (lSize / 2.0);
		hx2 = lPosX + (lSize / 2.0);
		hy2 = lPosY + (lSize / 2.0);
	}
	else if (lOrient == 90)
	{
		// vertical line (horizontal when rotated 90)
		vx1 = lPosX - (lSize / 2.0);
		vy1 = lPosY - (lSize / 2.0);
		vx2 = lPosX + (lSize / 2.0);
		vy2 = lPosY - (lSize / 2.0);

		// horizontal line (vertical when rotated 90)
		hx1 = lPosX - (lSize / 2.0);
		hy1 = lPosY - (lSize / 2.0);
		hx2 = lPosX - (lSize / 2.0);
		hy2 = lPosY + (lSize / 2.0);
	}
	else if (lOrient == 180)
	{
		// vertical line
		vx1 = lPosX + (lSize / 2.0);
		vy1 = lPosY - (lSize / 2.0);
		vx2 = lPosX + (lSize / 2.0);
		vy2 = lPosY + (lSize / 2.0);

		// horizontal line
		hx1 = lPosX - (lSize / 2.0);
		hy1 = lPosY - (lSize / 2.0);
		hx2 = lPosX + (lSize / 2.0);
		hy2 = lPosY - (lSize / 2.0);
	}
	else if (lOrient == 270)
	{
		// vertical line (horizontal when rotated 270)
		vx1 = lPosX - (lSize / 2.0);
		vy1 = lPosY + (lSize / 2.0);
		vx2 = lPosX + (lSize / 2.0);
		vy2 = lPosY + (lSize / 2.0);

		// horizontal line (vertical when rotated 270)
		hx1 = lPosX + (lSize / 2.0);
		hy1 = lPosY - (lSize / 2.0);
		hx2 = lPosX + (lSize / 2.0);
		hy2 = lPosY + (lSize / 2.0);
	}
	else
	{
		printf("DRAW_L() ERROR : Unknown orientation\n");
		suspend;
	}
	
	// scale coordinates
	vx1 = (vx1 - (LineThickness / 2.0)) * scalingFactor;
	vy1 = (vy1 - (LineThickness / 2.0)) * scalingFactor;
	vx2 = (vx2 + (LineThickness / 2.0)) * scalingFactor;
	vy2 = (vy2 + (LineThickness / 2.0)) * scalingFactor;
	
	hx1 = (hx1 - (LineThickness / 2.0)) * scalingFactor;
	hy1 = (hy1 - (LineThickness / 2.0)) * scalingFactor;
	hx2 = (hx2 + (LineThickness / 2.0)) * scalingFactor;
	hy2 = (hy2 + (LineThickness / 2.0)) * scalingFactor;
	
	
	if (VDO_CMD_DEBUG)
	{
		printf("L width = %.3d\n",(vx1 - hx2)/100000);
		printf("L height = %.3d\n",(vy1 - hy2)/100000);
	}
	
	// Send draw commands to VideoSYNC
	// set color
	dsendf("co %d\n",lColor);
	// vertical line
	dsendf("rf %d,%d,%d,%d\n",vx1,vy1,vx2,vy2);
	// horizontal line
	dsendf("rf %d,%d,%d,%d\n",hx1,hy1,hx2,hy2);
	
	if (DSEND_DEBUG)
	{
		// set color
		printf("co %d\n",lColor);
		// vertical line
		printf("rf %d,%d,%d,%d\n",vx1,vy1,vx2,vy2);
		// horizontal line
		printf("rf %d,%d,%d,%d\n",hx1,hy1,hx2,hy2);
	}
}

process DRAW_CIRCLE(int		cEccy,
					int		cAngle,
					float	cSize,
					int		cColor)
{
	int cColor;
	float cPosX,cPosY,cRadX,cRadY;
	float tanEccy,distFromCenter;
	if (VDO_CMD_DEBUG) printf("DRAW_CIRCLE()\n");
	
	
	/* Compute X,Y coordinates from Eccentricity & Angle */
	// PCL does not have a tan function ...
	// ... use tangent identity (tan=sin/cos)
	tanEccy = sin(cEccy)/cos(cEccy);
	
	// calculate distance from center of the screen
	distFromCenter = tanEccy * subjectDistance;
	
	cPosX = (cos(cAngle) * distFromCenter) * scalingFactor;
	cPosY = (sin(cAngle) * distFromCenter) * scalingFactor;
	cRadX = (cSize / 2.0) * scalingFactor;
	cRadY = (cSize / 2.0) * scalingFactor;
	
	nexttick;
	
	/* End compute X,Y coordinates */
	
	dsendf("co %d\n",cColor);
	dsendf("ef %d,%d,%d,%d\n",cPosX,cPosY,cRadX,cRadY);
	
	if (DSEND_DEBUG)
	{
		printf("co %d\n",cColor);
		printf("ef %d,%d,%d,%d\n",cPosX,cPosY,cRadX,cRadY);
	}
	
}
	
process DRAW_PHOTODIODE
	{
		dsendf("co %d\n",colorPhotodiode);
		dsendf("rf -250000,126000,-220000,150000\n");
	}
	
process DRAW_CALIB (	int		fpEccy,
						int		fpAngle,
						float	fpSize,
						int		fpColor)
{
	float fpOriginX,fpOriginY;
	float v1x1,v1y1,v2x2,v2y2;
	float tanEccy,distFromCenter;
	
	if (VDO_CMD_DEBUG) printf("DRAW_CALIB()\n");
	
	/* Compute X,Y coordinates from Eccentricity & Angle */
	// PCL does not have a tan function ...
	// ... use tangent identity (tan=sin/cos)
	tanEccy = sin(fpEccy)/cos(fpEccy);
	
	// calculate distance from center of the screen
	distFromCenter = tanEccy * subjectDistance;
	
	fpOriginX = cos(fpAngle) * distFromCenter;
	fpOriginY = sin(fpAngle) * distFromCenter;
	/* End compute X,Y coordinates */
	
	v1x1 = ((fpOriginX - (fpSize / 2.0)) * scalingFactor);
	v1y1 = ((fpOriginY - (fpSize / 2.0)) * scalingFactor);
	v2x2 = ((fpOriginX + (fpSize / 2.0)) * scalingFactor);
	v2y2 = ((fpOriginY + (fpSize / 2.0)) * scalingFactor);
	
	// Send draw commands to VideoSYNC
	// set fill color
	dsendf("co %d\n",colorCalibStim);
	dsendf("rf %d,%d,%d,%d\n",v1x1,v1y1,v2x2,v2y2);
	
	if (DSEND_DEBUG) 
	{
		// Show user VideoSYNC commands
		// Send draw commands to VideoSYNC
		// set fill color
		printf("co %d\n",colorCalibStim);
		printf("rf %d,%d,%d,%d\n",v1x1,v1y1,v2x2,v2y2);
   }
}

process RWD_JUICE
{

	// allow differential rewards
	if (SAT_cond == 1 || SAT_cond == 4) rJuice = rwd_slow;
	if (SAT_cond == 2) rJuice = rwd_med;
	if (SAT_cond == 3) rJuice = rwd_fast;

	if (rBigJuice > 0)
		if (random(99)+1 < rBigJuice){
			printf("\n BIG Juice Reward \n");

			mio_dig_set(0,1);
			wait(rJuice*5);
			mio_dig_set(0,0);
			
			//save value of juice given on this trial
			rJuice_save=rJuice*5;
			nBigJuice = nBigJuice + 1;

	  //		nexttick;
			 // STIMULATION: after Juice if set to 1 (when BigJuiceReward > 0)
	   //		 if (StimAfterJuice == 1){
	   //		 printf("Stimulating after Juice\n");
	   //		 SPAWN mSTIM;
	   //		 }
			

    		eventCode=2727;			   
    		spawn queueEvent();	
			 }else{
				mio_dig_set(0,1);
				wait(rJuice);
				mio_dig_set(0,0);
    			eventCode=2727;			   
    			spawn queueEvent();	
				
				//save value of juice given on this trial
				rJuice_save=rJuice;
				nJuice = nJuice + 1;
				}
				
				else{	
			mio_dig_set(0,1);
			wait(rJuice);
			mio_dig_set(0,0);

			 // STIMULATION: after Juice if set to 1
			 if (StimAfterJuice == 1){
			 printf("Stimulating after Juice\n");
			 wait(100);
			 SPAWN mSTIM;
			 }

    eventCode=2727;			   
    spawn queueEvent();
    }	
}

