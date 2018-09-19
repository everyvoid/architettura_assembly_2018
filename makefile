EXE= controller
OBJS= ./controller.o ./asm_elaboratore.o
FLAG= -m32
FLAGS= -m32 -c 
GCC= gcc

$(EXE) : $(OBJS)
	$(GCC) $(FLAG) $(OBJS) -o $(EXE)

asm_elaboratore.o : *.s
	$(GCC) $(FLAGS) $< -o $@

controller.o : *.c
	$(GCC) $(FLAGS) $< -o $@ 

clean:
	@rm -f *.o

clean_all:
	@rm -f *.o
	@rm -f $(EXE)

.PHONY: clean clean_all
	
	
