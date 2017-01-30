/*
 * File: LED.c
 *
 * Code generated for Simulink model 'LED'.
 *
 * Model version                  : 1.1
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Mon Jan 30 20:17:23 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "LED.h"
#include "LED_private.h"
#include "LED_dt.h"

/* Block signals (auto storage) */
B_LED_T LED_B;

/* Block states (auto storage) */
DW_LED_T LED_DW;

/* Real-time model */
RT_MODEL_LED_T LED_M_;
RT_MODEL_LED_T *const LED_M = &LED_M_;

/* Model step function */
void LED_step(void)
{
  real_T temp;

  /* SignalGenerator: '<Root>/Signal Generator' */
  temp = LED_P.SignalGenerator_Frequency * LED_M->Timing.t[0];
  if (temp - floor(temp) >= 0.5) {
    LED_B.SignalGenerator = LED_P.SignalGenerator_Amplitude;
  } else {
    LED_B.SignalGenerator = -LED_P.SignalGenerator_Amplitude;
  }

  /* End of SignalGenerator: '<Root>/Signal Generator' */

  /* DataTypeConversion: '<S1>/Data Type Conversion' */
  if (LED_B.SignalGenerator < 256.0) {
    if (LED_B.SignalGenerator >= 0.0) {
      LED_B.DataTypeConversion = (uint8_T)LED_B.SignalGenerator;
    } else {
      LED_B.DataTypeConversion = 0U;
    }
  } else {
    LED_B.DataTypeConversion = MAX_uint8_T;
  }

  /* End of DataTypeConversion: '<S1>/Data Type Conversion' */

  /* S-Function (arduinodigitaloutput_sfcn): '<S1>/Digital Output' */
  MW_digitalWrite(LED_P.DigitalOutput_pinNumber, LED_B.DataTypeConversion);

  /* External mode */
  rtExtModeUploadCheckTrigger(2);

  {                                    /* Sample time: [0.0s, 0.0s] */
    rtExtModeUpload(0, LED_M->Timing.t[0]);
  }

  {                                    /* Sample time: [0.3s, 0.0s] */
    rtExtModeUpload(1, ((LED_M->Timing.clockTick1) * 0.3));
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.0s, 0.0s] */
    if ((rtmGetTFinal(LED_M)!=-1) &&
        !((rtmGetTFinal(LED_M)-LED_M->Timing.t[0]) > LED_M->Timing.t[0] *
          (DBL_EPSILON))) {
      rtmSetErrorStatus(LED_M, "Simulation finished");
    }

    if (rtmGetStopRequested(LED_M)) {
      rtmSetErrorStatus(LED_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  LED_M->Timing.t[0] =
    (++LED_M->Timing.clockTick0) * LED_M->Timing.stepSize0;

  {
    /* Update absolute timer for sample time: [0.3s, 0.0s] */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The resolution of this integer timer is 0.3, which is the step size
     * of the task. Size of "clockTick1" ensures timer will not overflow during the
     * application lifespan selected.
     */
    LED_M->Timing.clockTick1++;
  }
}

/* Model initialize function */
void LED_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)LED_M, 0,
                sizeof(RT_MODEL_LED_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&LED_M->solverInfo, &LED_M->Timing.simTimeStep);
    rtsiSetTPtr(&LED_M->solverInfo, &rtmGetTPtr(LED_M));
    rtsiSetStepSizePtr(&LED_M->solverInfo, &LED_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&LED_M->solverInfo, (&rtmGetErrorStatus(LED_M)));
    rtsiSetRTModelPtr(&LED_M->solverInfo, LED_M);
  }

  rtsiSetSimTimeStep(&LED_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&LED_M->solverInfo,"FixedStepDiscrete");
  rtmSetTPtr(LED_M, &LED_M->Timing.tArray[0]);
  rtmSetTFinal(LED_M, 15.0);
  LED_M->Timing.stepSize0 = 0.3;

  /* External mode info */
  LED_M->Sizes.checksums[0] = (1395862914U);
  LED_M->Sizes.checksums[1] = (1097795845U);
  LED_M->Sizes.checksums[2] = (3296443821U);
  LED_M->Sizes.checksums[3] = (1421373598U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    LED_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(LED_M->extModeInfo,
      &LED_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(LED_M->extModeInfo, LED_M->Sizes.checksums);
    rteiSetTPtr(LED_M->extModeInfo, rtmGetTPtr(LED_M));
  }

  /* block I/O */
  (void) memset(((void *) &LED_B), 0,
                sizeof(B_LED_T));

  /* states (dwork) */
  (void) memset((void *)&LED_DW, 0,
                sizeof(DW_LED_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    LED_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Start for S-Function (arduinodigitaloutput_sfcn): '<S1>/Digital Output' */
  MW_pinModeOutput(LED_P.DigitalOutput_pinNumber);
}

/* Model terminate function */
void LED_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
