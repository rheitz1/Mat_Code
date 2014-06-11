declare constant PTB_CMD_DEBUG = 0;
declare constant DSEND_DEBUG = 0;

declare constant int Psychtoolbox = 1;



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
		COMPLETE_DSEND();

		
/* have matlab prepare the search frame sets            */
/* each constant corresponds to the lab setting value   */
process DRAW_STIM
{
	declare i, j, k;

	/* position calcuation  */
	i = 0;
	while ( i < mMAXPOS ){
		ePosX[i] = eOrigX[i]*175*mEccy/1000;
		ePosY[i] = eOrigY[i]*175*mEccy/1000;
		i = i + 1;
	} nexttick;
	
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
	if (SAT_cond == 1){
		fixColor = 2; //make SLOW condition fixation point RED
		}
	
	if (SAT_cond == 2){
		fixColor = 1; //make MED condition fixation point WHITE
		}
	
	if (SAT_cond == 3){
		fixColor = 3; //make FAST condition fixation point GREEN
	}
	
	//when SAT condition = 4, use standard fixation point colors
	if (SAT_cond == 4){
		fixColor = 1;
	}

	//when tIsNoGo ==1 (is nogo trial), use BLUE & CLOSED FIXATION POINT
	if (tIsNoGo){
		fixColor2 = 4;
		iEFix = 1;
		}else{
		fixColor2 = fixColor;
		iEFix = 2;
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
			iColor = 1;
			// Removed 10/29/10 by RPH: uncomment to manipulate luminance of MG target
			//iColor = 100 + iColMin + (iColMax - iColMin)*random(iColBin+1)/iColBin;
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
	/*****************************/
	
	/* frame 1: fixation: fixation property 0 is fixed: dummy   */
	/* filled fixation */
	spawnwait DRAW_OBJECT(1,iFFix,eFP_r,eFP_a,iFixS,fixColor,mHolder,iMask[lPair]);
	//if (posUserSet == -1){
	//		spawnwait DRAW_OBJECT(1,iFFix,eFP_r,eFP_a,iFixS,fixColor,mHolder,iMask[lPair]);
	//	} else{
	//		spawnwait DRAW_OBJECT(1,iFFix,145*175*mEccy/1000,lTgtP,iFixS,fixColor,mHolder,iMask[lPair]);
	 //	}

	nexttick;

	/* frame 2: fixation: fixation property 0 is fixed: dummy   */
	/* empty fixation */
	spawnwait DRAW_OBJECT(2,iEFix,eFP_r,eFP_a,iFixS,fixColor2,mHolder,iMask[lPair]);
	nexttick;
	
	
	/* frame 3: search + go fixation + without photodiode input */
	i = 0;
	spawnwait DRAW_OBJECT(3,iEFix,eFP_r,eFP_a,iFixS,fixColor2,mHolder,iMask[lPair]);
	while( i < mMAXPOS ){
		spawnwait DRAW_OBJECT(3,lObjt[i],145*175*mEccy/1000,i,eCIRsize,iColCopy[lObjt[i]],mHolder,iMask[lPair]);
		i = i + 1;
		nexttick;
	}


	/* frame 5: blank screen */
	/* it's implemented automatically
	dsendf("nprepSrch(%d,%d,%d,%d,",5,iEFix,eFP_r,eFP_a);
	dsendf("%d,%d,%d,%d);",iFixS,iColCopy[iEFix],mHolder,iMask[lPair]); nexttick;
	initial process make 9 blank screens, so it's not necessary to make one on top of it
	*/
	
	/* frame 6: mask, not yet implemented */
	/*
	dsendf("nprepSrch(%d,%d,%d,%d,",6,0,0,0);
	dsendf("%d,%d,%d,%d);",0,0,mHolder,iMask[lPair]); nexttick;
	dsendf("nprepSrch(%d,%d,%d,%d,",6,iEFix,eFP_r,eFP_a);
	dsendf("%d,%d,%d,%d);",iFixS,iColCopy[iEFix],mHolder,iMask[lPair]); nexttick;
	*/
	
	
	/* frame 4: search + go fixation + photodiode input          */
	i = 0;
	spawnwait DRAW_OBJECT(4,iEFix,eFP_r,eFP_a,iFixS,fixColor2,mHolder,iMask[lPair]);
	while( i < mMAXPOS ){
		spawnwait DRAW_OBJECT(4,lObjt[i],145*175*mEccy/1000,i,eCIRsize,iColCopy[lObjt[i]],mHolder,iMask[lPair]);
		i = i + 1;
		nexttick;
	}
	
  	/* frame 9: search + hold fixation  + photodiode input        */
	i = 0;
	spawnwait DRAW_OBJECT(9,iFFix,eFP_r,eFP_a,iFixS,fixColor,mHolder,iMask[lPair]);
	while( i < mMAXPOS ){
		spawnwait DRAW_OBJECT(9,lObjt[i],145*175*mEccy/1000,i,eCIRsize,iColCopy[lObjt[i]],mHolder,iMask[lPair]);
		i = i + 1;
		nexttick;
	}
	
	/* frame 8: reappear                         */
	if ( tIsCatch == 0 ){
		spawnwait DRAW_OBJECT(8,iEFix,eFP_r,eFP_a,iFixS,iColCopy[iEFix],mHolder,iMask[lPair]);
		spawnwait DRAW_OBJECT(8,lObjt[lTgtP],145*175*mEccy/1000,lTgtP,eCIRsize,iColCopy[lObjt[lTgtP]],mHolder,iMask[lPair]); nexttick;
	}


	/* dummy string for complete transfer check up */
   	spawnwait COMPLETE_DSEND();       														 
}
		
process DRAW_OBJECT(int frame,
					int item,
					int eccentricity,
					int angle,
					int stimSize,
					int stimProp,
					int placeholderFlag,
					int onsetMaskFlag)
{
	dsendf("nprepSrch(%d,%d,%d,%d,%d,%d,%d,%d);",
			frame,
			item,
			eccentricity,
			angle,
			stimSize,
			stimProp,
			placeholderFlag,
			onsetMaskFlag);
	if (DSEND_DEBUG)
	{
		printf("nprepSrch(%d,%d,%d,%d,%d,%d,%d,%d);\n",
			frame,
			item,
			eccentricity,
			angle,
			stimSize,
			stimProp,
			placeholderFlag,
			onsetMaskFlag);
	}
}


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
	spawn DRAW_OBJECT(10,1,145*175*ecc_vector[point_num]/1000,angle_vector[point_num],15,1,0,0);
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
	spawn DRAW_OBJECT(10,1,145*175*ecc_vector[point_num]/1000,angle_vector[point_num],15,1,0,0);
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
	spawn DRAW_OBJECT(10,1,145*175*ecc_vector[point_num]/1000,angle_vector[point_num],15,1,0,0);
	//print point_num
	print("Point number ",point_num+1," (location ",angle_vector[point_num],")");
	}
}


process ERASE_ALL()
{
	dsend("eall2;");             // frame 0: erase all  
	if (DSEND_DEBUG) printf("eall2;\n");
}

process DISP_FRAME_1()
{
	dsend("f1;");
	if (DSEND_DEBUG) printf("f1;\n");
}

process DISP_FRAME_2()
{
	dsend("f2;");
 	if (DSEND_DEBUG) printf("f2;\n");
}

process DISP_FRAME_3()
{
	dsend("f3;");
	if (DSEND_DEBUG) printf("f3;\n");
}

process DISP_FRAME_4()
{
	dsend("f4;");
	if (DSEND_DEBUG) printf("f4;\n");
}

process DISP_FRAME_5()
{
	dsend("f5;");
	if (DSEND_DEBUG) printf("f5;");
}

process DISP_FRAME_6()
{
	dsend("f6;");
	if (DSEND_DEBUG) printf("f6;\n");
}

/* There are no calls to display frame 7 in SRCHStm.pro */

process DISP_FRAME_8()
{
	dsend("f8;");
	if (DSEND_DEBUG) printf("f8;\n");
}

process DISP_FRAME_9()
{
	dsend("f9;");
	if (DSEND_DEBUG) printf("f9;\n");
}

process DISP_FRAME_10()
{
	dsend("f10;");
	if (DSEND_DEBUG) printf("f10;\n");
}

process COMPLETE_DSEND()
{
	while(dsend()) nexttick;
}


process RWD_JUICE
{


	// allow differential rewards
	if (SAT_cond == 1 || SAT_cond == 4) rJuice = rwd_med;
	if (SAT_cond == 2) rJuice = rwd_med;
	if (SAT_cond == 3) rJuice = rwd_fast;

	wait(rwd_delay);
	
	if (rBigJuice > 0)
		if (random(99)+1 < rBigJuice){
			printf("\n BIG Juice Reward \n");

			eventCode=2727;			   
    		spawn queueEvent();	
    		
    		mio_ao_set(0,32768);
			wait(rJuice*5);
			mio_ao_set(0,-32767);
			
			//save value of juice given on this trial
			rJuice_save=rJuice*5;
			nBigJuice = nBigJuice + 1;

			 // STIMULATION: after Juice if set to 1 (when BigJuice > 0)
				 if (StimAfterJuice == 1 && trlStimP <= mStimProb){
				 printf("Stimulating after Juice\n");
				 wait(mStimDelay);
				 SPAWN mSTIM;
				 didStim = 1;
				 }
			
			 }else{
		     	eventCode=2727;			   
    			spawn queueEvent();	
    			
    			mio_ao_set(0,32768);
				wait(rJuice);
				mio_ao_set(0,-32767);

				
				//save value of juice given on this trial
				rJuice_save=rJuice;
				nJuice = nJuice + 1;
				}
				
				else{
				eventCode=2727;			   
    			spawn queueEvent();	
    				
				mio_ao_set(0,32768);
				wait(rJuice);
				mio_ao_set(0,-32767);

			 // STIMULATION: after Juice if set to 1
				 if (StimAfterJuice == 1 && trlStimP <= mStimProb){
				 printf("Stimulating after Juice\n");
				 wait(mStimDelay);
				 SPAWN mSTIM;
				 didStim = 1;
				 }
    }	
}