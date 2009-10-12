#ifndef _ASSERT_H_
#define _ASSERT_H_

/* prints an error message and goes into an infinite loop. */
#define panic(format, ...) for(;;) \
{ \
	printf(format, ## __VA_ARGS__); \
	__asm__("cli"); \
	for(;;); \
}

/* if the expression is false, panics the kernel */
#define assert(expression)  for(;;) \
{ \
	if(!(expression)) { \
		panic("%s:%u: failed assertion `%s'", \
		      __FILE__, __LINE__, #expression); \
	} \
	break; \
} \

#endif

