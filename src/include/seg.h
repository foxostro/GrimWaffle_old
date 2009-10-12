#ifndef _SEG_H_
#define _SEG_H_

#define SEGSEL_TSS       (0x08)
#define SEGSEL_KERNEL_CS (0x10)
#define SEGSEL_KERNEL_DS (0x18)
#define SEGSEL_USER_CS   (0x23)
#define SEGSEL_USER_DS   (0x2B)



#ifndef ASSEMBLER

#include <stdint.h>


#define SEGSEL_NIL_IDX       (0)
#define SEGSEL_TSS_IDX       (1)
#define SEGSEL_KERNEL_CS_IDX (2)
#define SEGSEL_KERNEL_DS_IDX (3)
#define SEGSEL_USER_CS_IDX   (4)
#define SEGSEL_USER_DS_IDX   (5)
#define NUM_GDT_SEGS         (6)



typedef struct
{
	uint32_t dl, dh;
} segment_descriptor_t;

typedef struct
{
	segment_descriptor_t segs[NUM_GDT_SEGS];
} gdt_t;



void segment_descriptor_init(segment_descriptor_t * out,
                             uint32_t base_addr,
							 uint32_t limit,
							 unsigned int granularity_flag,
							 unsigned int dpl_field,
							 unsigned int type_field,
							 unsigned int system_flag,
							 unsigned int db_flag,
							 unsigned int p_flag,
							 unsigned int avl_flag);



void gdt_init(void);


void dump_gdt(void);


#endif /* ASSEMBLER */

#endif /* _SEG_H_ */
