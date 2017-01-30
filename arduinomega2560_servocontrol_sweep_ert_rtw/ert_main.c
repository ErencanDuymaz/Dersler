/*
 * File: ert_main.c
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
#include "rtwtypes.h"
#include <ext_work.h>
#include <ext_svr.h>
#include <ext_share.h>
#include <updown.h>

volatile int IsrOverrun = 0;
static boolean_T OverrunFlag = 0;
void rt_OneStep(void)
{
  /* Check for overrun. Protect OverrunFlag against preemption */
  if (OverrunFlag++) {
    IsrOverrun = 1;
    OverrunFlag--;
    return;
  }

#ifndef _MW_ARDUINO_LOOP_

  sei();

#endif;

  arduinomega2560_servocontrol_sweep_step();

  /* Get model outputs here */
#ifndef _MW_ARDUINO_LOOP_

  cli();

#endif;

  OverrunFlag--;
  rtExtModeCheckEndTrigger();
}

int main(void)
{
  volatile boolean_T runModel = 1;
  float modelBaseRate = 0.01;
  float systemClock = 0;
  init();
  MW_Arduino_Init();
  rtmSetErrorStatus(arduinomega2560_servocontrol_M, 0);

  /* initialize external mode */
  rtParseArgsForExtMode(0, NULL);
  arduinomega2560_servocontrol_sweep_initialize();
  sei ();

  /* External mode */
  rtSetTFinalForExtMode(&rtmGetTFinal(arduinomega2560_servocontrol_M));
  rtExtModeCheckInit(1);

  {
    boolean_T rtmStopReq = false;
    rtExtModeWaitForStartPkt(arduinomega2560_servocontrol_M->extModeInfo, 1,
      &rtmStopReq);
    if (rtmStopReq) {
      rtmSetStopRequested(arduinomega2560_servocontrol_M, true);
    }
  }

  rtERTExtModeStartMsg();
  cli();
  configureArduinoAVRTimer();
  runModel =
    (rtmGetErrorStatus(arduinomega2560_servocontrol_M) == (NULL)) &&
    !rtmGetStopRequested(arduinomega2560_servocontrol_M);

#ifndef _MW_ARDUINO_LOOP_

  sei();

#endif;

  sei ();
  while (runModel) { 
    MW_Arduino_Loop();
    /* External mode */
    {
      boolean_T rtmStopReq = false;
      rtExtModeOneStep(arduinomega2560_servocontrol_M->extModeInfo, 1,
                       &rtmStopReq);
      if (rtmStopReq) {
        rtmSetStopRequested(arduinomega2560_servocontrol_M, true);
      }
    }

    runModel =
      (rtmGetErrorStatus(arduinomega2560_servocontrol_M) == (NULL)) &&
      !rtmGetStopRequested(arduinomega2560_servocontrol_M);
  }

  rtExtModeShutdown(1);

  /* Disable rt_OneStep() here */

  /* Terminate model */
  arduinomega2560_servocontrol_sweep_terminate();
  cli();
  return 0;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
