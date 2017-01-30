/*
 * File: arduinomega2560_servocontrol_sweep_data.c
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

/* Block parameters (auto storage) */
Parameters_arduinomega2560_serv arduinomega2560_servocontrol__P = {
  4U,                                  /* Mask Parameter: ServoWrite_pinNumber
                                        * Referenced by: '<S2>/Servo Write'
                                        */

  /*  Mask Parameter: DesiredShaftAngle_OutValues
   * Referenced by: '<S1>/Vector'
   */
  { 0U, 1U, 2U, 3U, 4U, 5U, 6U, 7U, 8U, 9U, 10U, 11U, 12U, 13U, 14U, 15U, 16U,
    17U, 18U, 19U, 20U, 21U, 22U, 23U, 24U, 25U, 26U, 27U, 28U, 29U, 30U, 31U,
    32U, 33U, 34U, 35U, 36U, 37U, 38U, 39U, 40U, 41U, 42U, 43U, 44U, 45U, 46U,
    47U, 48U, 49U, 50U, 51U, 52U, 53U, 54U, 55U, 56U, 57U, 58U, 59U, 60U, 61U,
    62U, 63U, 64U, 65U, 66U, 67U, 68U, 69U, 70U, 71U, 72U, 73U, 74U, 75U, 76U,
    77U, 78U, 79U, 80U, 81U, 82U, 83U, 84U, 85U, 86U, 87U, 88U, 89U, 90U, 89U,
    88U, 87U, 86U, 85U, 84U, 83U, 82U, 81U, 80U, 79U, 78U, 77U, 76U, 75U, 74U,
    73U, 72U, 71U, 70U, 69U, 68U, 67U, 66U, 65U, 64U, 63U, 62U, 61U, 60U, 59U,
    58U, 57U, 56U, 55U, 54U, 53U, 52U, 51U, 50U, 49U, 48U, 47U, 46U, 45U, 44U,
    43U, 42U, 41U, 40U, 39U, 38U, 37U, 36U, 35U, 34U, 33U, 32U, 31U, 30U, 29U,
    28U, 27U, 26U, 25U, 24U, 23U, 22U, 21U, 20U, 19U, 18U, 17U, 16U, 15U, 14U,
    13U, 12U, 11U, 10U, 9U, 8U, 7U, 6U, 5U, 4U, 3U, 2U, 1U },
  179U,                                /* Mask Parameter: LimitedCounter_uplimit
                                        * Referenced by: '<S5>/FixPt Switch'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value
                                        * Referenced by: '<S5>/Constant'
                                        */
  0U,                                  /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S3>/Output'
                                        */
  0U,                                  /* Computed Parameter: ServoWrite_p1
                                        * Referenced by: '<S2>/Servo Write'
                                        */
  1U                                   /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S4>/FixPt Constant'
                                        */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
