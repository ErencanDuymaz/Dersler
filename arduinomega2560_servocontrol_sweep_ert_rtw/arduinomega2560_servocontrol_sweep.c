/*
 * File: arduinomega2560_servocontrol_sweep.c
 *
 * Code generated for Simulink model 'arduinomega2560_servocontrol_sweep'.
 *
 * Model version                  : 1.210
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Mon Jan 30 20:29:56 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "arduinomega2560_servocontrol_sweep.h"
#include "arduinomega2560_servocontrol_sweep_private.h"
#include "arduinomega2560_servocontrol_sweep_dt.h"

/* Block states (auto storage) */
D_Work_arduinomega2560_servocon arduinomega2560_servocont_DWork;

/* Real-time model */
RT_MODEL_arduinomega2560_servoc arduinomega2560_servocontrol_M_;
RT_MODEL_arduinomega2560_servoc *const arduinomega2560_servocontrol_M =
  &arduinomega2560_servocontrol_M_;

/* Model step function */
void arduinomega2560_servocontrol_sweep_step(void)
{
  uint8_T rtb_FixPtSum1;

  /* S-Function (arduinoservowrite_sfcn): '<S2>/Servo Write' incorporates:
   *  Constant: '<S1>/Vector'
   *  MultiPortSwitch: '<S1>/Output'
   *  UnitDelay: '<S3>/Output'
   */
  MW_servoWrite(arduinomega2560_servocontrol__P.ServoWrite_p1,
                arduinomega2560_servocontrol__P.DesiredShaftAngle_OutValues[arduinomega2560_servocont_DWork.Output_DSTATE]);

  /* Sum: '<S4>/FixPt Sum1' incorporates:
   *  Constant: '<S4>/FixPt Constant'
   *  UnitDelay: '<S3>/Output'
   */
  rtb_FixPtSum1 = (uint8_T)((uint16_T)
    arduinomega2560_servocont_DWork.Output_DSTATE +
    arduinomega2560_servocontrol__P.FixPtConstant_Value);

  /* Switch: '<S5>/FixPt Switch' */
  if (rtb_FixPtSum1 > arduinomega2560_servocontrol__P.LimitedCounter_uplimit) {
    /* Update for UnitDelay: '<S3>/Output' incorporates:
     *  Constant: '<S5>/Constant'
     */
    arduinomega2560_servocont_DWork.Output_DSTATE =
      arduinomega2560_servocontrol__P.Constant_Value;
  } else {
    /* Update for UnitDelay: '<S3>/Output' */
    arduinomega2560_servocont_DWork.Output_DSTATE = rtb_FixPtSum1;
  }

  /* End of Switch: '<S5>/FixPt Switch' */

  /* External mode */
  rtExtModeUploadCheckTrigger(1);

  {                                    /* Sample time: [0.01s, 0.0s] */
    rtExtModeUpload(0, arduinomega2560_servocontrol_M->Timing.taskTime0);
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.01s, 0.0s] */
    if ((rtmGetTFinal(arduinomega2560_servocontrol_M)!=-1) &&
        !((rtmGetTFinal(arduinomega2560_servocontrol_M)-
           arduinomega2560_servocontrol_M->Timing.taskTime0) >
          arduinomega2560_servocontrol_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(arduinomega2560_servocontrol_M, "Simulation finished");
    }

    if (rtmGetStopRequested(arduinomega2560_servocontrol_M)) {
      rtmSetErrorStatus(arduinomega2560_servocontrol_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++arduinomega2560_servocontrol_M->Timing.clockTick0)) {
    ++arduinomega2560_servocontrol_M->Timing.clockTickH0;
  }

  arduinomega2560_servocontrol_M->Timing.taskTime0 =
    arduinomega2560_servocontrol_M->Timing.clockTick0 *
    arduinomega2560_servocontrol_M->Timing.stepSize0 +
    arduinomega2560_servocontrol_M->Timing.clockTickH0 *
    arduinomega2560_servocontrol_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void arduinomega2560_servocontrol_sweep_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)arduinomega2560_servocontrol_M, 0,
                sizeof(RT_MODEL_arduinomega2560_servoc));
  rtmSetTFinal(arduinomega2560_servocontrol_M, -1);
  arduinomega2560_servocontrol_M->Timing.stepSize0 = 0.01;

  /* External mode info */
  arduinomega2560_servocontrol_M->Sizes.checksums[0] = (1733016594U);
  arduinomega2560_servocontrol_M->Sizes.checksums[1] = (2081818153U);
  arduinomega2560_servocontrol_M->Sizes.checksums[2] = (842007716U);
  arduinomega2560_servocontrol_M->Sizes.checksums[3] = (2642956451U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[2];
    arduinomega2560_servocontrol_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(arduinomega2560_servocontrol_M->extModeInfo,
      &arduinomega2560_servocontrol_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(arduinomega2560_servocontrol_M->extModeInfo,
                        arduinomega2560_servocontrol_M->Sizes.checksums);
    rteiSetTPtr(arduinomega2560_servocontrol_M->extModeInfo, rtmGetTPtr
                (arduinomega2560_servocontrol_M));
  }

  /* states (dwork) */
  (void) memset((void *)&arduinomega2560_servocont_DWork, 0,
                sizeof(D_Work_arduinomega2560_servocon));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    arduinomega2560_servocontrol_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Start for S-Function (arduinoservowrite_sfcn): '<S2>/Servo Write' */
  MW_servoAttach(arduinomega2560_servocontrol__P.ServoWrite_p1,
                 arduinomega2560_servocontrol__P.ServoWrite_pinNumber);

  /* InitializeConditions for UnitDelay: '<S3>/Output' */
  arduinomega2560_servocont_DWork.Output_DSTATE =
    arduinomega2560_servocontrol__P.Output_InitialCondition;
}

/* Model terminate function */
void arduinomega2560_servocontrol_sweep_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
