/*
 * interrupt.h
 *
 *  Created on: 9 sty 2022
 *      Author: zaquadnik
 */

#ifndef INC_CORE_INTERRUPT_H_
#define INC_CORE_INTERRUPT_H_

#include "91x_vic.h"
#include "CommonTypes.h"

#define MAX_PRIORITY 15
#define VIC_REGISTER_NUMBER 16

typedef enum{
	IRQ_WDG = 0,
	IRQ_SW,
	IRQ_CORE_DBG_RX,
	IRQ_CORE_DBG_TX,
	IRQ_TIMER0,
	IRQ_TIMER1,
	IRQ_TIMER2,
	IRQ_TIMER3,
	IRQ_USB_HI_PRIORITY,
	IRQ_SB_LO_PRIORITY,
	IRQ_SCU,
	IRQ_ETH_MAC,
	IRQ_DMA,
	IRQ_CAN,
	IRQ_MOTOR_CTRL,
	IRQ_ADC,
	IRQ_UART0,
	IRQ_UART1,
	IRQ_UART2,
	IRQ_I2C0,
	IRQ_I2C1,
	IRQ_SSP0,
	IRQ_SSP1,
	IRQ_LVD,
	IRQ_RTC,
	IRQ_WIU,
	IRQ_EXTINT0,
	IRQ_EXTINT1,
	IRQ_EXTINT2,
	IRQ_EXTINT3,
	IRQ_USB_WAKE_UP,
	IRQ_PFQ_BC,
	IRQ_LAST = IRQ_PFQ_BC
}IrqSource_t;

status_t IrqRegister(
		void* IrqHandler,
		u16 Priority,
		IrqSource_t Source);

#endif /* INC_CORE_INTERRUPT_H_ */
