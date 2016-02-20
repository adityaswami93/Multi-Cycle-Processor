source=w450.v regfile.v mem.v w450_tb.v

.PHONY: run
run: fetch math ldst branch remainder addarray

# tb_fetch
.PHONY: fetch
fetch: tb_fetch.vvp
	vvp $<

.PHONY: fetch-debug
fetch-debug: tb_fetch.lx2
	gtkwave $< &

tb_fetch.vvp: $(source) fetch.data
	iverilog -s tb_fetch -o $@ $(source)

# tb_math
.PHONY: math
math: tb_math.vvp
	vvp $<

.PHONY: math-debug
math-debug: tb_math.lx2
	gtkwave $< &

tb_math.vvp: $(source) math.data
	iverilog -s tb_math -o $@ $(source)

# tb_ldst
.PHONY: ldst
ldst: tb_ldst.vvp
	vvp $<

.PHONY: ldst-debug
ldst-debug: tb_ldst.lx2
	gtkwave $< &

tb_ldst.vvp: $(source) ldst.data
	iverilog -s tb_ldst -o $@ $(source)

# tb_branch
.PHONY: branch
branch: tb_branch.vvp
	vvp $<

.PHONY: branch-debug
branch-debug: tb_branch.lx2
	gtkwave $< &

tb_branch.vvp: $(source) branch.data
	iverilog -s tb_branch -o $@ $(source)

# tb_remainder
.PHONY: remainder
remainder: tb_remainder.vvp
	vvp $<

.PHONY: remainder-debug
remainder-debug: tb_remainder.lx2
	gtkwave $< &

tb_remainder.vvp: $(source) remainder.data
	iverilog -s tb_remainder -o $@ $(source)

# tb_addArray
.PHONY: addarray
addarray: tb_addArray.vvp
	vvp $<

.PHONY: addarray-debug
addarray-debug: tb_addArray.lx2
	gtkwave $< &

tb_addArray.vvp: $(source) addArray.data
	iverilog -s tb_addArray -o $@ $(source)

%.lx2: %.vvp
	vvp $< -lxt2
	mv dump.lx2 $@

clean:
	rm -f *.vvp *.lx2 *.vcd
