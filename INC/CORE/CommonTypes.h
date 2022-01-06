/*
 * CommonTypes.h
 *
 *  Created on: 6 sty 2022
 *      Author: zaquadnik
 */

#ifndef INC_CORE_COMMONTYPES_H_
#define INC_CORE_COMMONTYPES_H_

#include "91x_type.h"

typedef enum{
	OK = 0,
	FAILURE = 1,
	NOT_FOUND = 2,
	INVALID_DATA = 3,
	NULL_POINTER = 4,
	NOT_ALLOWED = 5,
	OUT_OF_MEMORY = 6,
	UNKNOWN = 0xFF
}status_t;


#endif /* INC_CORE_COMMONTYPES_H_ */
