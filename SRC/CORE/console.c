/*
 * console.c
 *
 *  Created on: 4 sty 2022
 *      Author: zaquadnik
 */

#include "91x_uart.h"
#include "91x_dma.h"
#include "CommonTypes.h"
#include "Config.h"

#define SEND_TASK_PRIORITY  (tskIDLE_PRIORITY + 1)
#define RECEIVE_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define SEND_TASK_STACK_SIZE (configMINIMAL_STACK_SIZE + 128)
#define RECEIVE_TASK_STACK_SIZE (configMINIMAL_STACK_SIZE + 128)

#define SEND_TASK_NAME "SendTask"
#define RECEIVE_TASK_NAME "ReceiveTask"

typedef struct{
	xTaskHandle SendTaskHandle;
	xTaskHandle ReceiveTaskHandle;
}ConsoleCtx;

typedef struct{

}SendCtx;

typedef struct{

}ReceiveCtx;

ConsoleCtx ConsoleData;

void SendTask(void* pvParameters)
{
	while(1)
	{

	}
}

void ReceiveTask(void* pvParameters)
{
	while(1)
	{

	}
}

status_t InitInterface(void)
{
	UART_InitTypeDef UartData;

	UartData.UART_BaudRate = 115200;
	UartData.UART_FIFO = UART_FIFO_Enable;
	UartData.UART_HardwareFlowControl = UART_HardwareFlowControl_None;
	UartData.UART_Mode = UART_Mode_Tx_Rx;
	UartData.UART_Parity = UART_Parity_No;
	UartData.UART_StopBits = UART_StopBits_1;
	UartData.UART_WordLength = UART_WordLength_8D;
	UartData.UART_RxFIFOLevel = UART_FIFOLevel_7_8;
	UartData.UART_TxFIFOLevel = UART_FIFOLevel_7_8;

	UART_Init(
			UART0,
			&UartData);

	UART_ITConfig(
			UART0,
			UART_IT_Transmit | UART_IT_Receive,
			ENABLE);

	UART_DMAConfig(
			UART0,
			UART_DMAOnError_Enable);

	UART_DMACmd(
			UART0,
			UART_DMAReq_Tx | UART_DMAReq_Rx,
			ENABLE);

	UART_Cmd(
			UART0,
			ENABLE);

	return OK;
}

status_t InitConsole(void)
{
	InitInterface();

	xTaskCreate(SendTask,
				(signed portCHAR *) SEND_TASK_NAME,
				SEND_TASK_STACK_SIZE,
				NULL,
				SEND_TASK_PRIORITY,
				&ConsoleData.SendTaskHandle);

	xTaskCreate(ReceiveTask,
				(signed portCHAR *) RECEIVE_TASK_NAME,
				RECEIVE_TASK_STACK_SIZE,
				NULL,
				RECEIVE_TASK_PRIORITY,
				&ConsoleData.ReceiveTaskHandle);

	return OK;
}
