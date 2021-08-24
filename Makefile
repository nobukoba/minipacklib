TARGETS   = libminipacklib.a libminipacklib.so

GCC_VER_GTEQ_6 = $(shell expr `gcc -dumpversion | cut -f1-2 -d.` \>= 6.0)
ifeq ($(GCC_VER_GTEQ_6),1)
PIEFLAGS  =  -O -no-pie
else
PIEFLAGS  =
endif

CC        = gcc $(PIEFLAGS)
AR        = ar clq
XARGS     = xargs
FC        = gfortran $(PIEFLAGS)
CFLAGS    = -fPIC
FFLAGS    = -std=legacy -Wno-argument-mismatch -fPIC

all:	$(TARGETS)
libminipacklib.a: hlimap.o hidall.o mzwork.o hcreatem.o hshm.o hmapm.o hrin2.o hcopyu.o hcopyn.o hcopyt.o zebra.o hbook.o cernlib.o kernlib.o
	echo $^ | $(XARGS) $(AR) $@
libminipacklib.so: libminipacklib.a
	gcc -shared -Wl,-soname,$@ $^ -o $@
%.o: %.c
	$(CC)      $(CFLAGS)   -c $<
%.o: %.f
	$(FC)      $(FFLAGS)   -c $<
.PHONY : clean
clean:
	rm -rf *.o *~ $(TARGETS)
