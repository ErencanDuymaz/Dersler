/*
 * File: LED2.c
 *
 * Code generated for Simulink model 'LED2'.
 *
 * Model version                  : 1.1
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Mon Jan 30 20:12:50 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "LED2.h"
#include "LED2_private.h"
#include "LED2_dt.h"

/* Block signals (auto storage) */
B_LED2_T LED2_B;

/* Real-time model */
RT_MODEL_LED2_T LED2_M_;
RT_MODEL_LED2_T *const LED2_M = &LED2_M_;

/* Model step function */
void LED2_step(void)
{
  real_T currentTime;

  /* Step: '<Root>/Step' incorporates:
   *  DataTypeConversion: '<S1>/Data Type Conversion'
   */
  currentTime = LED2_M->Timing.t[0];
  if (currentTime < LED2_P.Step_Time) {
    /* DataTypeConversion: '<S1>/Data Type Conversion' */
    if (LED2_P.Step_Y0 < 256.0) {
      if (LED2_P.Step_Y0 >= 0.0) {
        LED2_B.DataTypeConversion = (uint8_T)LED2_P.Step_Y0;
      } else {
        LED2_B.DataTypeConversion = 0U;
      }
    } else {
      LED2_B.DataTypeConversion = MAX_uint8_T;
    }
  } else if (LED2_P.Step_YFinal < 256.0) {
    /* DataTypeConversion: '<S1>/Data Type Conversion' */
    if (LED2_P.Step_YFinal >= 0.0) {
      LED2_B.DataTypeConversion = (uint8_T)LED2_P.Step_YFinal;
    } else {
      LED2_B.DataTypeConversion = 0U;
    }
  } else {
    /* DataTypeConversion: '<S1>/Data Type Conversion' */
    LED2_B.DataTypeConversion = MAX_uint8_T;
  }

  /* End of Step: '<Root>/Step' */

  /* S-Function (arduinodigitaloutput_sfcn): '<S1>/Digital Output' */
  MW_digitalWrite(LED2_P.DigitalOutput_pinNumber, LED2_B.DataTypeConversion);

  /* External mode */
  rtExtModeUploadCheckTrigger(2);

  {                                    /* Sample time: [0.0s, 0.0s] */
    rtExtModeUpload(0, LED2_M->Timing.t[0]);
  }

  {                                    /* Sample time: [0.2s, 0.0s] */
    rtExtModeUpload(1, ((LED2_M->Timing.clockTick1) * 0.2));
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.0s, 0.0s] */
    if ((rtmGetTFinal(LED2_M)!=-1) &&
        !((rtmGetTFinal(LED2_M)-LED2_M->Timing.t[0]) > LED2_M->Timing.t[0] *
          (DBL_EPSILON))) {
      rtmSetErrorStatus(LED2_M, "Simulation finished");
    }

    if (rtmGetStopRequested(LED2_M)) {
      rtmSetErrorStatus(LED2_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  LED2_M->Timing.t[0] =
    (++LED2_M->Timing.clockTick0) * LED2_M->Timing.stepSize0;

  {
    /* Update absolute timer for sample time: [0.2s, 0.0s] */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The resolution of this integer timer is 0.2, which is the step size
     * of the task. Size of "clockTick1" ensures timer will not overflow during the
     * application lifespan selected.
     */
    LED2_M->Timing.clockTick1++;
  }
}

/* Model initialize function */
void LED2_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)LED2_M, 0,
                sizeof(RT_MODEL_LED2_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&LED2_M->solverInfo, &LED2_M->Timing.simTimeStep);
    rtsiSetTPtr(&LED2_M->solverInfo, &rtmGetTPtr(LED2_M));
    rtsiSetStepSizePtr(&LED2_M->solverInfo, &LED2_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&LED2_M->solverInfo, (&rtmGetErrorStatus(LED2_M)));
    rtsiSetRTModelPtr(&LED2_M->solverInfo, LED2_M);
  }

  rtsiSetSimTimeStep(&LED2_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&LED2_M->solverInfo,"FixedStepDiscrete");
  rtmSetTPtr(LED2_M, &LED2_M->Timing.tArray[0]);
  rtmSetTFinal(LED2_M, 10.0);
  LED2_M->Timing.stepSize0 = 0.2;

  /* External mode info */
  LED2_M->Sizes.checksums[0] = (3606703615U);
  LED2_M->Sizes.checksums[1] = (3930090523U);
  LED2_M->Sizes.checksums[2] = (2543482189U);
  LED2_M->Sizes.checksums[3] = (3661583579U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    LED2_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(LED2_M->extModeInfo,
      &LED2_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(LED2_M->extModeInfo, LED2_M->Sizes.checksums);
    rteiSetTPtr(LED2_M->extModeInfo, rtmGetTPtr(LED2_M));
  }

  /* block I/O */
  (void) memset(((void *) &LED2_B), 0,
                sizeof(B_LED2_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    LED2_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Start for S-Function (arduinodigitaloutput_sfcn): '<S1>/Digital Output' */
  MW_pinModeOutput(LED2_P.DigitalOutput_pinNumber);
}

/* Model terminate function */
void LED2_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
