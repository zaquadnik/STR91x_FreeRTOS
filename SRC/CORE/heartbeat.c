/*
 * heartbeat.c
 *
 *  Created on: 2 mar 2025
 *      Author: Lenovo
 */

#include "CommonTypes.h"
#include "Config.h"
#include "91x_gpio.h"
#include "91x_map.h"

#define HB_LED_PORT GPIO0
#define HB_LED_PIN GPIO_Pin_0

#define HB_TASK_PRIORITY  (tskIDLE_PRIORITY)
#define HB_TASK_STACK_SIZE (configMINIMAL_STACK_SIZE)

#define HB_TASK_NAME "HeartBeatTask"

typedef struct{
	xTaskHandle HbTaskHandle;
}HeartBeatCtx;

HeartBeatCtx HbData;

void HbInitLed(void)
{
	GPIO_InitTypeDef HbGpioPinCfg;

	HbGpioPinCfg.GPIO_Pin = HB_LED_PIN;
	HbGpioPinCfg.GPIO_Type = GPIO_Type_PushPull;
	HbGpioPinCfg.GPIO_Direction = GPIO_PinOutput;
	HbGpioPinCfg.GPIO_Alternate = GPIO_OutputAlt1;
	HbGpioPinCfg.GPIO_IPConnected = GPIO_IPConnected_Disable;

	GPIO_Init(HB_LED_PORT, &HbGpioPinCfg);
}

void HbTask(void* pvParameters)
{
	while(1)
	{
		GPIO_WriteBit(HB_LED_PORT, HB_LED_PIN, Bit_RESET);
		vTaskDelay(500);
		GPIO_WriteBit(HB_LED_PORT, HB_LED_PIN, Bit_SET);
		vTaskDelay(500);
	}
}

status_t HbInitHeartBeat(void)
{
	HbInitLed();
	GPIO_WriteBit(HB_LED_PORT, HB_LED_PIN, Bit_RESET);

	xTaskCreate(HbTask,
				(signed portCHAR *) HB_TASK_NAME,
				HB_TASK_STACK_SIZE,
				NULL,
				HB_TASK_PRIORITY,
				&HbData.HbTaskHandle);

	return OK;
}

