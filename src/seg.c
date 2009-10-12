#include <seg.h>
#include <asm.h>
#include <assert.h>

extern void printf(const char *format, ...);

extern void * tss; /* Defined in kernel.c. We just want the base address. */

static gdt_t gdt;


/* The segment descriptor format is disgusting, but it just has to be dealt
 * with to deal with x86 segmented memory. This function can be used to fill
 * out the bitfields for a segment descriptor in the GDT.
 * See the Intel Manual, Volume 3, Chapter 2, Section 4 for details on each
 * parameter. I'm using the same notation that the manual uses.
 */
void segment_descriptor_init(segment_descriptor_t * out,
                             uint32_t base_addr,
							 uint32_t limit,
							 unsigned int granularity_flag,
							 unsigned int dpl_field,
							 unsigned int type_field,
							 unsigned int system_flag,
							 unsigned int db_flag,
							 unsigned int present_flag,
							 unsigned int avl_flag)
{
	assert(out);
	assert(limit <= 0xFFFFF);
	assert(granularity_flag == 1 || granularity_flag == 0);
	assert(dpl_field <= 3);
	assert(type_field <= 0xF);
	assert(system_flag == 0 || system_flag == 1);
	assert(db_flag == 0 || db_flag == 1);
	assert(present_flag == 0 || present_flag == 1);
	assert(avl_flag == 0 || avl_flag == 1);

	/* This format is defined by the Intel Programming manuals. Specifically,
	 * in Volume 3, Chapter 2, Section 4
	 * Yes, it is ugly.
	 */
	out->dl = ((base_addr & 0x0000FFFF) << 16) | (limit & 0xFFFF);
	out->dh = (base_addr & 0xFF000000) 
	        | (granularity_flag << 23)
			| (db_flag << 22)
			| (avl_flag << 20)
			| (limit & 0x000F0000)
			| (present_flag << 15)
			| (dpl_field << 13)
			| (system_flag << 12)
			| (type_field << 8)
			| ((base_addr & 0x00FF0000) >> 16);
}


/* Prints the contents of the GDT and other debugging informtation */
void dump_gdt(void)
{
	int i;

	/* dump the GDT for our inspection */
	for(i=0; i<6; ++i)
	{
		printf("gdt[%d] = { dl=0x%x, dh=0x%x }\n",
		       i,
			   gdt.segs[i].dl,
			   gdt.segs[i].dh);
	}

	printf("gdt limit = %x\n", sizeof(gdt)-1);
}


/* Initializes and install the GDT. */
void gdt_init(void)
{
	/* initialize the system segment we will use for the TSS structure */

	segment_descriptor_init(&gdt.segs[SEGSEL_TSS_IDX],
	                        (uint32_t)&tss, /* base */
							sizeof(tss)-1,  /* limit */
							0,
							0,
							0x9,
							0,
							0,
							1,
							0);

	/* Now intialize the 4 segments we want to be able to use */

	segment_descriptor_init(&gdt.segs[SEGSEL_KERNEL_CS_IDX],
	                        0x00000000, /* base */
							0x000FFFFF, /* limit */
							1,          /* G*/
							0,          /* DPL */
							0xB,        /* Type = Execute/Read, Accessed */
							1,          /* S */
							1,          /* D/B */
							1,          /* P */
							0);         /* AVL */
	
	segment_descriptor_init(&gdt.segs[SEGSEL_KERNEL_DS_IDX],
	                        0x00000000, /* base */
							0x000FFFFF, /* limit */
							1,          /* G*/
							0,          /* DPL */
							0x3,        /* Type = Read/Write, Accessed */
							1,          /* S */
							1,          /* D/B */
							1,          /* P */
							0);         /* AVL */
	
	segment_descriptor_init(&gdt.segs[SEGSEL_USER_CS_IDX],
	                        0x00000000, /* base */
							0x000FFFFF, /* limit */
							1,          /* G*/
							3,          /* DPL */
							0xB,        /* Type = Execute/Read, Accessed */
							1,          /* S */
							1,          /* D/B */
							1,          /* P */
							0);         /* AVL */
	
	segment_descriptor_init(&gdt.segs[SEGSEL_USER_DS_IDX],
	                        0x00000000, /* base */
							0x000FFFFF, /* limit */
							1,          /* G*/
							3,          /* DPL */
							0x2,        /* Type = Read/Write */
							1,          /* S */
							1,          /* D/B */
							1,          /* P */
							0);         /* AVL */

# if 0
	dump_gdt();
#endif

	/* Actually install the GDT here */
	lgdt(&gdt, sizeof(gdt)-1);
}

