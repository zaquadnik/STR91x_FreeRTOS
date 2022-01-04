/*
 * main.c
 *
 *  Created on: 2010-02-07
 *      Author: Zaquadnik_AJ
 */

#include "config.h"

#define mainFLASH_TASK_PRIORITY  (tskIDLE_PRIORITY + 1)
#define IDLE_STACK_SIZE (configMINIMAL_STACK_SIZE + 10)

void IdleTaskFunction (void * pvParameters)
{
	volatile long counter;
	counter++;
}

int main(void)
{
	xTaskHandle IdleTask;

	xTaskCreate(IdleTask, (signed portCHAR *) "IDLE", IDLE_STACK_SIZE, 0, mainFLASH_TASK_PRIORITY, &IdleTaskFunction);

	while(1){

	}
	return 0;
}
