/*
 * File: arduinomega2560_servocontrol_sweep.h
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

#ifndef RTW_HEADER_arduinomega2560_servocontrol_sweep_h_
#define RTW_HEADER_arduinomega2560_servocontrol_sweep_h_
#include <float.h>
#include <string.h>
#include <stddef.h>
#ifndef arduinomega2560_servocontrol_sweep_COMMON_INCLUDES_
# define arduinomega2560_servocontrol_sweep_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "dt_info.h"
#include "ext_work.h"
#include "arduino_servowrite_lct.h"
#endif                                 /* arduinomega2560_servocontrol_sweep_COMMON_INCLUDES_ */

#include "arduinomega2560_servocontrol_sweep_types.h"

/* Shared type includes */
#include "multiword_types.h"
#include "MW_target_hardware_resources.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWExtModeInfo
# define rtmGetRTWExtModeInfo(rtm)     ((rtm)->extModeInfo)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

#define arduinomega2560_servocontrol_sweep_M (arduinomega2560_servocontrol_M)

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  uint8_T Output_DSTATE;               /* '<S3>/Output' */
} D_Work_arduinomega2560_servocon;

/* Parameters (auto storage) */
struct Parameters_arduinomega2560_serv_ {
  uint32_T ServoWrite_pinNumber;       /* Mask Parameter: ServoWrite_pinNumber
                                        * Referenced by: '<S2>/Servo Write'
                                        */
  uint8_T DesiredShaftAngle_OutValues[180];/* Mask Parameter: DesiredShaftAngle_OutValues
                                            * Referenced by: '<S1>/Vector'
                                            */
  uint8_T LimitedCounter_uplimit;      /* Mask Parameter: LimitedCounter_uplimit
                                        * Referenced by: '<S5>/FixPt Switch'
                                        */
  uint8_T Constant_Value;              /* Computed Parameter: Constant_Value
                                        * Referenced by: '<S5>/Constant'
                                        */
  uint8_T Output_InitialCondition;     /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S3>/Output'
                                        */
  uint8_T ServoWrite_p1;               /* Computed Parameter: ServoWrite_p1
                                        * Referenced by: '<S2>/Servo Write'
                                        */
  uint8_T FixPtConstant_Value;         /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S4>/FixPt Constant'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_arduinomega2560_servoco {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (auto storage) */
extern Parameters_arduinomega2560_serv arduinomega2560_servocontrol__P;

/* Block states (auto storage) */
extern D_Work_arduinomega2560_servocon arduinomega2560_servocont_DWork;

/* Model entry point functions */
extern void arduinomega2560_servocontrol_sweep_initialize(void);
extern void arduinomega2560_servocontrol_sweep_step(void);
extern void arduinomega2560_servocontrol_sweep_terminate(void);

/* Real-time Model object */
extern RT_MODEL_arduinomega2560_servoc *const arduinomega2560_servocontrol_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'arduinomega2560_servocontrol_sweep'
 * '<S1>'   : 'arduinomega2560_servocontrol_sweep/Desired Shaft  Angle'
 * '<S2>'   : 'arduinomega2560_servocontrol_sweep/Standard Servo Write'
 * '<S3>'   : 'arduinomega2560_servocontrol_sweep/Desired Shaft  Angle/LimitedCounter'
 * '<S4>'   : 'arduinomega2560_servocontrol_sweep/Desired Shaft  Angle/LimitedCounter/Increment Real World'
 * '<S5>'   : 'arduinomega2560_servocontrol_sweep/Desired Shaft  Angle/LimitedCounter/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_arduinomega2560_servocontrol_sweep_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
